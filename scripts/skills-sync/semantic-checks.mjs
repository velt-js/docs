#!/usr/bin/env node
/*
 * Deterministic post-build semantic checks for the skills-sync pipeline.
 *
 * These checks are intentionally narrow. They block high-confidence regressions
 * that the format validator cannot see, while leaving prose quality review to
 * humans.
 */

import { existsSync, readFileSync, readdirSync, writeFileSync } from "node:fs";
import { join, relative } from "node:path";

const cwd = process.cwd();
const outDir = process.env.OUT_DIR || join(cwd, "outputs");
const docsDir = process.env.DOCS_DIR || join(cwd, "docs");
const agentSkillsDir =
  process.env.AGENT_SKILLS_DIR || join(cwd, "agent-skills");

const planPath = join(outDir, "plan.json");
const diffPath = join(outDir, "diff.json");
const outOfScopePath = join(outDir, "out-of-scope.json");
const semanticPath = join(outDir, "semantic-checks.json");

function readJson(path, fallback) {
  if (!existsSync(path)) return fallback;
  return JSON.parse(readFileSync(path, "utf8"));
}

function readText(path) {
  if (!existsSync(path)) return "";
  return readFileSync(path, "utf8");
}

function walkFiles(dir) {
  if (!existsSync(dir)) return [];
  const entries = readdirSync(dir, { withFileTypes: true });
  const files = [];
  for (const entry of entries) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) {
      if (entry.name === "node_modules" || entry.name === ".git") continue;
      if (entry.name === "evals" || entry.name.endsWith("-workspace")) continue;
      files.push(...walkFiles(full));
    } else if (entry.isFile()) {
      files.push(full);
    }
  }
  return files;
}

function skillFiles(skill) {
  const dir = join(agentSkillsDir, "skills", skill);
  return walkFiles(dir)
    .filter((file) => /\.(md|json)$/.test(file))
    .map((file) => ({
      path: relative(agentSkillsDir, file),
      text: readText(file),
    }));
}

function skillText(skill) {
  return skillFiles(skill)
    .map((file) => `\n\n--- ${file.path} ---\n${file.text}`)
    .join("");
}

function hunkPathFor(docsPath) {
  return join(outDir, "hunks", `${docsPath}.patch`);
}

function hunkText(docsPath) {
  return readText(hunkPathFor(docsPath));
}

function includesAny(text, patterns) {
  return patterns.some((pattern) => pattern.test(text));
}

function changedSignal(paths, patterns) {
  const corpus = paths
    .map((docsPath) => `${docsPath}\n${hunkText(docsPath)}`)
    .join("\n\n");
  return includesAny(corpus, patterns);
}

function contexts(text, pattern, radius = 320) {
  const matches = [];
  for (const match of text.matchAll(pattern)) {
    const start = Math.max(0, match.index - radius);
    const end = Math.min(text.length, match.index + match[0].length + radius);
    matches.push(text.slice(start, end));
  }
  return matches;
}

function hasRecommendedUsage(text, pattern) {
  return contexts(text, pattern, 450).some(
    (context) =>
      !/incorrect|wrong|bad|avoid|do not|don't|never|obsolete|removed|stale|deprecated|not recommended|instead/i.test(
        context,
      ),
  );
}

function liveNamespaceViolations(files, namespace) {
  const pattern = new RegExp(namespace.replaceAll(".", "\\."), "g");
  const safeContext =
    /do not|don't|hidden|commented|draft|until .*visible|until .*published|not .*published|not .*visible|intentionally hide|intentionally hidden/i;
  const violations = [];
  for (const file of files) {
    for (const context of contexts(file.text, pattern, 360)) {
      if (!safeContext.test(context)) {
        violations.push({ path: file.path, context: context.trim() });
      }
    }
  }
  return violations;
}

function addResult(results, id, status, summary, details = {}) {
  results.push({ id, status, summary, ...details });
}

function runTriggeredCheck(results, id, triggered, callback) {
  if (!triggered) {
    addResult(results, id, "skipped", "No matching docs signal in this run.");
    return;
  }
  callback();
}

const plan = readJson(planPath, { tickets: [], unmapped: [], noops: [] });
const diff = readJson(diffPath, []);
const outOfScope = readJson(outOfScopePath, []);

const planFiles = new Set();
const fileToSkills = new Map();
for (const ticket of plan.tickets || []) {
  for (const file of ticket.files || []) {
    planFiles.add(file);
    const skills = fileToSkills.get(file) || new Set();
    skills.add(ticket.skill);
    fileToSkills.set(file, skills);
  }
}
const noopFiles = new Set(plan.noops || []);
const unmappedFiles = new Set(
  (plan.unmapped || []).flatMap((entry) => entry.paths || []),
);
const diffFiles = new Set((diff || []).map((entry) => entry.path));
const outOfScopeFiles = new Set((outOfScope || []).map((entry) => entry.path));
const allChangedFiles = [
  ...new Set([
    ...diffFiles,
    ...planFiles,
    ...noopFiles,
    ...unmappedFiles,
    ...outOfScopeFiles,
  ]),
].sort();

const coverageMatrix = [];
for (const file of allChangedFiles) {
  if (fileToSkills.has(file)) {
    coverageMatrix.push({
      path: file,
      classification: "mapped-skill-update",
      skills: [...fileToSkills.get(file)].sort(),
    });
  } else if (noopFiles.has(file)) {
    coverageMatrix.push({ path: file, classification: "no-op/prose-only" });
  } else if (unmappedFiles.has(file)) {
    coverageMatrix.push({ path: file, classification: "unmapped" });
  } else if (outOfScopeFiles.has(file)) {
    const item = (outOfScope || []).find((entry) => entry.path === file);
    coverageMatrix.push({
      path: file,
      classification: "out-of-scope",
      reason: item?.reason || "explicitly out-of-scope",
    });
  } else {
    coverageMatrix.push({ path: file, classification: "unclassified" });
  }
}

const results = [];

const unclassified = coverageMatrix.filter(
  (entry) => entry.classification === "unclassified",
);
if (unclassified.length > 0) {
  addResult(
    results,
    "coverage-matrix",
    "fail",
    "Some changed docs paths were not classified by the planner.",
    { paths: unclassified.map((entry) => entry.path) },
  );
} else {
  addResult(
    results,
    "coverage-matrix",
    "ok",
    "Every changed docs path is classified as mapped, no-op, unmapped, or out-of-scope.",
    { count: coverageMatrix.length },
  );
}

runTriggeredCheck(
  results,
  "apryse-comments-coverage",
  changedSignal(allChangedFiles, [
    /async-collaboration\/comments\/setup\/apryse\.mdx/i,
    /Apryse|WebViewer|ApryseVeltComments|AddCommentArgs|RenderCommentsArgs/i,
  ]),
  () => {
    const text = skillText("velt-comments-best-practices");
    const missing = ["Apryse", "WebViewer"].filter((term) => !text.includes(term));
    if (!/async-collaboration\/comments\/setup\/apryse/i.test(text)) {
      missing.push("Source Pointer to async-collaboration/comments/setup/apryse");
    }
    addResult(
      results,
      "apryse-comments-coverage",
      missing.length === 0 ? "ok" : "fail",
      missing.length === 0
        ? "Apryse WebViewer comments coverage is present in the comments skill."
        : "Apryse WebViewer docs changed but comments skill coverage is incomplete.",
      { missing },
    );
  },
);

runTriggeredCheck(
  results,
  "comments-sidebar-v2-removal",
  changedSignal(allChangedFiles, [
    /comments-sidebar/i,
    /VeltCommentsSidebar\s+version=["']2["']/i,
    /<velt-comments-sidebar[^>]*\sversion=["']2["']/i,
  ]),
  () => {
    const text = skillText("velt-comments-best-practices");
    const stalePattern =
      /VeltCommentsSidebar\s+version=["']2["']|<velt-comments-sidebar[^>]*\sversion=["']2["']/gi;
    const stale = hasRecommendedUsage(text, stalePattern);
    addResult(
      results,
      "comments-sidebar-v2-removal",
      stale ? "fail" : "ok",
      stale
        ? 'Stale `VeltCommentsSidebar version="2"` usage still appears recommended.'
        : "No recommended Sidebar V2 `version=\"2\"` setup remains.",
    );
  },
);

runTriggeredCheck(
  results,
  "collapsed-replies-primitives",
  changedSignal(allChangedFiles, [
    /collapsedRepliesPreview/i,
    /MoreReply/i,
    /comment-dialog\/primitives/i,
    /wireframe/i,
  ]),
  () => {
    const files = skillFiles("velt-comments-best-practices");
    const text = files.map((file) => file.text).join("\n");
    const missing = [];
    if (!text.includes("collapsedRepliesPreview")) {
      missing.push("collapsedRepliesPreview");
    }
    if (
      !text.includes("VeltCommentDialogMoreReply.Count") &&
      !text.includes("VeltCommentDialogMoreReplyCount")
    ) {
      missing.push("VeltCommentDialogMoreReply.Count");
    }
    if (
      !text.includes("VeltCommentDialogMoreReply.Text") &&
      !/VeltCommentDialogMoreReply\.Count[\s\S]{0,80}\.Text/.test(text) &&
      !text.includes("VeltCommentDialogMoreReplyText")
    ) {
      missing.push("VeltCommentDialogMoreReply.Text");
    }
    const misplacedWireframeNames = files
      .filter((file) => !/wireframe/i.test(file.path))
      .filter((file) => /VeltCommentDialogWireframe\.MoreReply\.(Count|Text)/.test(file.text))
      .map((file) => file.path);
    addResult(
      results,
      "collapsed-replies-primitives",
      missing.length === 0 && misplacedWireframeNames.length === 0 ? "ok" : "fail",
      missing.length === 0 && misplacedWireframeNames.length === 0
        ? "Collapsed replies preview uses the public MoreReply primitive names outside wireframe rules."
        : "Collapsed replies preview primitive coverage is missing or uses wireframe names in public primitive rules.",
      { missing, misplacedWireframeNames },
    );
  },
);

runTriggeredCheck(
  results,
  "page-info-document-id-reserved",
  changedSignal(allChangedFiles, [
    /setPageInfo|clearPageInfo|useSetPageInfo|useClearPageInfo|PageInfo|documentId/i,
  ]),
  () => {
    const text = skillText("velt-setup-best-practices");
    const missing = ["setPageInfo", "clearPageInfo"].filter(
      (term) => !text.includes(term),
    );
    const badDocumentIdContexts = contexts(text, /documentId/g, 420)
      .filter((context) => /setPageInfo|clearPageInfo|PageInfo/i.test(context))
      .filter((context) => !/reserved|future|not .*current|does not .*scope|global/i.test(context));
    addResult(
      results,
      "page-info-document-id-reserved",
      missing.length === 0 && badDocumentIdContexts.length === 0 ? "ok" : "fail",
      missing.length === 0 && badDocumentIdContexts.length === 0
        ? "`documentId` page-info scope is documented as reserved/future, not shipped behavior."
        : "Setup skill page-info guidance is missing or treats `documentId` as live scoped behavior.",
      {
        missing,
        badContexts: badDocumentIdContexts.map((context) => context.trim()),
      },
    );
  },
);

runTriggeredCheck(
  results,
  "node-field-filter-options",
  changedSignal(allChangedFiles, [
    /FieldFilterOptions|filterUnknownFields|pickKnownFields|filterRequest|FilterSpec|Field Allowlist/i,
  ]),
  () => {
    const text = skillText("velt-node-sdk-best-practices");
    const missing = [
      "FieldFilterOptions",
      "filterUnknownFields",
      "pickKnownFields",
      "filterRequest",
      "FilterSpec",
    ].filter((term) => !text.includes(term));
    addResult(
      results,
      "node-field-filter-options",
      missing.length === 0 ? "ok" : "fail",
      missing.length === 0
        ? "Node SDK field filtering terms are covered."
        : "Node SDK field filtering docs changed but skill coverage is incomplete.",
      { missing },
    );
  },
);

runTriggeredCheck(
  results,
  "approval-inbound-webhook",
  changedSignal(allChangedFiles, [
    /ai\/approval-engine/i,
    /inbound webhook|raw JSON ingress|Authorization:\s*Bearer|SSRF|signed callback/i,
  ]),
  () => {
    const text = skillText("velt-approval-engine-best-practices");
    const missing = [
      "Inbound webhook handler",
      "Authorization: Bearer",
      "SSRF",
      "signed callback",
    ].filter((term) => !text.includes(term));
    addResult(
      results,
      "approval-inbound-webhook",
      missing.length === 0 ? "ok" : "fail",
      missing.length === 0
        ? "Approval Engine inbound webhook security coverage is present."
        : "Approval Engine inbound webhook docs changed but skill security coverage is incomplete.",
      { missing },
    );
  },
);

runTriggeredCheck(
  results,
  "rest-agents-memory-and-hidden-sdk",
  changedSignal(allChangedFiles, [
    /\/v2\/agents|\/v2\/memory|sdk\.api\.agents|sdk\.api\.memory|Agents and Memory/i,
  ]),
  () => {
    const restText = skillText("velt-rest-apis-best-practices");
    const requiredRestTerms = [];
    const corpus = allChangedFiles.map((file) => hunkText(file)).join("\n");
    if (/\/v2\/agents|sdk\.api\.agents|Agents/i.test(corpus)) {
      requiredRestTerms.push("/v2/agents");
    }
    if (/\/v2\/memory|sdk\.api\.memory|Memory/i.test(corpus)) {
      requiredRestTerms.push("/v2/memory");
    }
    const missingRestTerms = requiredRestTerms.filter((term) => !restText.includes(term));
    const sdkFiles = [
      ...skillFiles("velt-node-sdk-best-practices"),
      ...skillFiles("velt-self-hosting-data-best-practices"),
    ];
    const liveNamespaceProblems = [
      ...liveNamespaceViolations(sdkFiles, "sdk.api.agents"),
      ...liveNamespaceViolations(sdkFiles, "sdk.api.memory"),
    ];
    addResult(
      results,
      "rest-agents-memory-and-hidden-sdk",
      missingRestTerms.length === 0 && liveNamespaceProblems.length === 0
        ? "ok"
        : "fail",
      missingRestTerms.length === 0 && liveNamespaceProblems.length === 0
        ? "Agents/Memory REST coverage is present and hidden SDK namespaces are not documented as live."
        : "Agents/Memory coverage is missing or hidden SDK namespaces appear live.",
      { missingRestTerms, liveNamespaceProblems },
    );
  },
);

runTriggeredCheck(
  results,
  "python-field-filter-options",
  changedSignal(allChangedFiles, [/filter_unknown_fields|field_allowlists/i]),
  () => {
    const text = skillText("velt-self-hosting-data-best-practices");
    const missing = ["filter_unknown_fields", "field_allowlists"].filter(
      (term) => !text.includes(term),
    );
    addResult(
      results,
      "python-field-filter-options",
      missing.length === 0 ? "ok" : "fail",
      missing.length === 0
        ? "Python SDK field filtering terms are covered in the self-hosting data skill."
        : "Python SDK field filtering docs changed but skill coverage is incomplete.",
      { missing },
    );
  },
);

const failures = results.filter((result) => result.status === "fail");
const warnings = results.filter((result) => result.status === "warn");
const output = {
  status: failures.length > 0 ? "fail" : "ok",
  summary: {
    checks: results.length,
    failures: failures.length,
    warnings: warnings.length,
    coverage_entries: coverageMatrix.length,
  },
  coverage_matrix: coverageMatrix,
  checks: results,
  inputs: {
    outDir,
    docsDir,
    agentSkillsDir,
  },
};

writeFileSync(semanticPath, `${JSON.stringify(output, null, 2)}\n`);

if (failures.length > 0) {
  console.error(
    `[semantic-checks] FAILED: ${failures.length} high-confidence issue(s). See ${semanticPath}`,
  );
  for (const failure of failures) {
    console.error(`- ${failure.id}: ${failure.summary}`);
  }
  process.exit(1);
}

console.log(
  `[semantic-checks] OK: ${results.length} checks, ${coverageMatrix.length} coverage entr${
    coverageMatrix.length === 1 ? "y" : "ies"
  }. Wrote ${semanticPath}`,
);
