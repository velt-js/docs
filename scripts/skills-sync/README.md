# skills-sync — Docs → Agent-Skills Auto-Sync Pipeline

> **Status:** Phase 4 (production-hardened). The `push` trigger is ENABLED — every merge to `main` touching a watched path runs the pipeline and opens a PR against `velt-js/agent-skills`. Only enable in production once the Phase 3 test matrix below is green.

This pipeline detects docs changes on `main` and opens a PR against [`velt-js/agent-skills`](https://github.com/velt-js/agent-skills) updating the affected skills. It's parallel to the existing `docs-sync.yml` / release-note pipelines and does not modify them.

## Architecture

Five stages (one deterministic + four Claude agents), wired as three GitHub Actions jobs:

```
push to docs/main
   ↓
Stage 0 (script)          compute-diff.sh
Agent 1                   docs-diff-planner          → plan.json
   ↓
Agent 2 (matrix-parallel) one of 6 variants per skill → patch + changes.json
   ↓
Agent 3                   skill-format-validator     → npm validate + build
Deterministic check       semantic-checks.mjs        → coverage + stale API assertions
Agent 4                   skill-pr-composer          → PR + issues on agent-skills
```

See `/Users/yoenzhang/.claude/plans/i-need-you-to-abundant-starlight.md` for the full design rationale.

## What's in this directory

| File | Purpose |
|---|---|
| `compute-diff.sh` | Stage 0 — emits `diff.json` + per-file hunks |
| `prepare-agent-1-inputs.sh` | Stages inputs for Agent 1 (planner) + builds `skill-inventory.json` |
| `prepare-agent-2-inputs.sh` | Stages inputs for one Agent 2 matrix instance |
| `dispatch-updater-variant.sh` | Maps skill name → updater variant (one of 6) |
| `run-claude-agent.sh` | Thin wrapper around `claude-code` CLI; resolves agent name to file via glob |
| `apply-patches.sh` | Merges per-skill patches from the matrix into one working tree |
| `smoke-test.sh` | Local Agent 1 sanity check against a synthetic diff |
| `semantic-checks.mjs` | Deterministic post-build semantic assertions for high-confidence coverage gaps |
| `semantic-checks-fixture-test.sh` | Offline regression fixture for recent skills-sync semantic misses |
| `reference-artifacts/` | Frozen ground truth (format guide, mapping, sample files) loaded by agents |

Agent definitions live in `../../.claude/agents/skills-sync/`:

```
Agent-1-docs-diff-planner.md
Agent-2a-frontend-async-skill-updater.md       (comments, notifications, activity, recorder)
Agent-2b-frontend-realtime-skill-updater.md    (presence, cursors, huddle, single-editor-mode, crdt)
Agent-2c-setup-skill-updater.md                (setup)
Agent-2d-backend-skill-updater.md              (rest-apis, self-hosting-data)
Agent-2e-infra-skill-updater.md                (proxy-server, yjs)
Agent-2f-ai-skill-updater.md                   (rewriter, approval-engine — and future AI features)
Agent-3-skill-format-validator.md
Agent-4-skill-pr-composer.md
```

The workflow lives at `../../.github/workflows/docs-sync-skills.yml`.

## Required secrets

Set both in `velt-js/docs` → Settings → Secrets and variables → Actions:

| Secret | Scope | Used by |
|---|---|---|
| `ANTHROPIC_API_KEY` | Claude API access | All 4 agents |
| `AGENT_SKILLS_PAT` | Fine-grained PAT with `contents:write`, `pull-requests:write`, `issues:write` on `velt-js/agent-skills` | Checkout + push + PR/issue creation |

The default `GITHUB_TOKEN` can't push to a different repo, so the PAT is required.

## Running the workflow

### Phase 3 — manual test runs only

Go to **Actions → docs-sync-skills → Run workflow** and provide:

- **before_sha** — the commit to diff FROM (default: `HEAD~1` of the target ref)
- **target_sha** — the commit to diff TO (default: the workflow's checkout SHA)

Or via CLI:

```bash
gh workflow run docs-sync-skills.yml -R velt-js/docs \
  -f before_sha=<parent-sha> \
  -f target_sha=<commit-sha>
```

### Suggested Phase 3 test matrix

Pick one historical docs commit per category and dispatch the workflow against each. Inspect the resulting PR/issues; tune agent prompts as needed.

| Category | What to look for | Test commit type |
|---|---|---|
| **frontend-async** | Comments/notifications skill PR with new rule or example | A commit touching `async-collaboration/comments/**` |
| **frontend-realtime** | Presence/cursors/huddle/single-editor-mode/crdt PR | A commit touching `realtime-collaboration/**` |
| **setup** | velt-setup PR with multi-framework example update | A commit touching `get-started/**` or `security/auth-tokens.mdx` |
| **backend** | rest-apis or self-hosting-data PR | A commit touching `api-reference/rest-apis/**` |
| **infra** | proxy-server or yjs PR | A commit touching `security/proxy-server.mdx` |
| **unmapped feature** | Issue only, no PR | A commit touching `realtime-collaboration/flock-mode/**` or other unmapped path |
| **prose-only** | No PR, no issue — workflow exits at gate | A commit fixing only typos |
| **cross-variant** | Two matrix jobs in parallel | A commit touching both `async-collaboration/comments/**` and `realtime-collaboration/crdt/**` |

### Local smoke test (no workflow needed)

```bash
ANTHROPIC_API_KEY=sk-ant-... \
AGENT_SKILLS_DIR=~/Downloads/agent-skills \
DOCS_DIR=~/Downloads/docs \
  bash docs/scripts/skills-sync/smoke-test.sh
```

This runs Agent 1 only, against a synthetic "add darkMode prop" diff. Verifies the planner produces a single comments ticket with the right shape. Useful for prompt iteration without burning a full workflow run.

### Local semantic regression fixture

```bash
DOCS_DIR=~/Downloads/docs \
AGENT_SKILLS_DIR=~/Downloads/agent-skills \
  bash docs/scripts/skills-sync/semantic-checks-fixture-test.sh
```

This does not call Claude. It simulates recent high-confidence misses — Apryse comments, Sidebar V2 removal, collapsed replies primitives, reserved page-info `documentId`, Node field filtering, Approval Engine inbound webhooks, and REST Agents/Memory vs hidden SDK namespaces — and verifies the deterministic checker passes against the current skill tree.

## Phase 4 production hardening (already wired)

The following are in place as of Phase 4 — verify each before relying on the pipeline:

1. **Push trigger enabled** in `docs-sync-skills.yml`. The pipeline runs on every merge to `main` touching watched paths.
2. **Reviewer assignment.** The PR-composer agent assigns `@yoen-velt` as the reviewer on every PR via `--reviewer yoen-velt`. The `CODEOWNERS` file at `velt-js/agent-skills/.github/CODEOWNERS` is retained for ownership documentation only — it is **not** the review-routing mechanism, so the placeholder team handles there do not need to resolve to real teams for the pipeline to notify a reviewer.
3. **CI guardrails** at `velt-js/agent-skills/.github/workflows/skills-sync-guardrails.yml` — runs on every PR labeled `skills-sync`:
   - Rejects edits inside `*-workspace/**` or `**/evals/**`
   - Rejects `metadata.json.abstract` or `.author` rewrites unless labeled `manual-skill-rewrite`
   - Requires `metadata.json.version` to bump when rule files change (skipped if labeled `docs-prose-only`)
   - Rejects `AGENTS.md` changes without a sibling rule change
   - Runs `npm run validate`, `npm run build`, and fails if generated `AGENTS.md` / `AGENTS.full.md` are stale
   - Warns when >5 skills or >30 rule files are touched
4. **Weekly drift check** at `docs/.github/workflows/skills-sync-drift-check.yml` (Mondays 14:00 UTC) — files (or updates) a `skills-sync-drift` issue in `agent-skills` if any docs feature dir isn't mapped or any skill has no docs counterpart. Closes the issue automatically when drift clears.
5. **Documentation:** `agent-skills/CONTRIBUTING.md` has a new "Auto-sync from docs" section pointing contributors at the right authoring surface.

## Troubleshooting

### `claude-code: command not found`

The workflow installs it via `npm install -g @anthropic-ai/claude-code`. If your team uses a different distribution method (custom action, pre-installed runner image, etc.), edit the **Install claude-code CLI** step in the workflow YAML to match.

### Agent 1 misclassifies a change

Edit `../.claude/agents/skills-sync/Agent-1-docs-diff-planner.md` and re-run. The change-type taxonomy table is the primary lever. For new path patterns, update `reference-artifacts/mapping.md` (Agent 1 loads it as authoritative input).

### Agent 2 produces too-aggressive edits

The variant-specific guidance bullets at the bottom of each `Agent-2X-*.md` are the main lever. Make the rules tighter and more specific. The **Hard rules** section is for absolute prohibitions; the variant guidance is for domain conventions.

### Validator (Agent 3) keeps aborting

Read `outputs/abort.json` from the failed run's artifacts. Most likely causes:
- A rule got malformed frontmatter the validator can't auto-fix
- A new category was added but `_sections.md` wasn't updated
- An impact level was set to something not in the enum

Fix the underlying issue in Agent 2's prompt, not in Agent 3 — the validator is intentionally conservative.

### Semantic checks fail

Read `outputs/semantic-checks.json` from the failed run's artifacts. These failures are deterministic; fix the relevant Agent 1 mapping, Agent 2 variant prompt, or skill rule source. Do not bypass them with prose-only labels. The checks catch stale APIs, missing known coverage terms, hidden SDK namespaces documented as live APIs, and public-vs-wireframe primitive name mixups.

### PR not opening

Check `outputs/pr-composer-result.json` and the validator status. If the validator aborted, Agent 4 files an issue instead of a PR (this is intentional). If validator succeeded but PR creation failed, check that `AGENT_SKILLS_PAT` has the right scopes.

## Out-of-scope decisions (won't fix)

These are deliberate:

- **No auto-creation of new skills.** Unmapped features file issues; humans decide. See plan §4.1.
- **No retries on Claude API errors.** A failed Agent run aborts the matrix job; re-dispatch the workflow.
- **No PR auto-merge.** Every PR requires human review (assigned to `@yoen-velt`).
- **One open `skills-sync` PR at a time.** When the workflow runs, it first looks for an already-open PR labeled `skills-sync` in `agent-skills`. If one exists, the new changes are added as **a fresh commit on that PR's branch** and the PR body is refreshed via `gh pr edit` (no parallel PR is opened). If no open `skills-sync` PR is found, a new per-SHA branch is created and `gh pr create` opens a new PR. See the "Resolve branch" step in `.github/workflows/docs-sync-skills.yml` and the matching logic in `Agent-4-skill-pr-composer.md`.
- **No editing of `AGENTS.md` or `AGENTS.full.md` by hand.** These are regenerated by `npm run build`.

## Reference

- Plan: `/Users/yoenzhang/.claude/plans/i-need-you-to-abundant-starlight.md`
- Format guide: `reference-artifacts/format-guide.md`
- Mapping table: `reference-artifacts/mapping.md`
- Existing release-note pipeline (parallel system): `../.claude/agents/Agent-{1..7}-*.md`
- Existing skills→plugins sync (downstream): `velt-js/agent-skills/.github/workflows/sync-to-plugins.yml`
