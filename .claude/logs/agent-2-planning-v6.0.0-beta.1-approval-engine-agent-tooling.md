# Release Update Plan for v6.0.0-beta.1 — Approval Engine & Agent Tooling (23 Jun 2026)

> Scope note: This is the SECOND release note appended to the existing `<Update label="6.0.0-beta.1">` block. The base modular-SDK plan is in `agent-2-planning-v6.0.0-beta.1.md` — do NOT touch that work. This log covers ONLY the Approval Engine + Agent Tooling items.

## Overview
- Release Type: Minor + one Breaking Change (within an existing beta version).
- Key Changes: Approval Engine unified `edges[]` contract (removes `onReject`/`loops[]`); read-only `compiled` block on DefinitionView; `waitAll`/`cancelOnQuorum` groups as edge sources; node cosmetic `name`/`description`; three new agent capabilities (`rest-api` context strategy, `mcp-tools` execution strategy, `docs-code-comparison` built-in agent); custom-agent config validation changes.
- Breaking Changes: YES — Approval Engine `edges[]` migration. Upgrade guide currently says "None — fully backward compatible," which is now WRONG and is the highest-priority gap.

## Areas Requiring Updates

### 1. Data Models
- Not applicable. Approval Engine + agent config schemas live in REST reference and conceptual pages, not `data-models.mdx` (SDK frontend types). No new SDK-facing types. SKIP.

### 2. API Methods
- Not applicable. No new SDK hooks/facade methods. All surface is REST + conceptual. SKIP.

### 3. Documentation / REST Reference

**3a. Upgrade Guide — HIGHEST PRIORITY (breaking change)**
- File: `/Users/yoenzhang/Downloads/docs/release-notes/version-6/upgrade-guide.mdx`
- Changes: Replace "## Breaking Changes → None" (line 11-13) with an Approval Engine entry: the four-row `onReject`/`loops[]` → `edges[]` migration mapping (from raw input lines 14-22), the new `EdgeSchema` fields (`from`/`to`/`on`/`when`/`loop`), and the new `INVALID_ARGUMENT` error keys (raw input lines 31-41). Migration table belongs HERE, never in the changelog.
- Priority: High.

**3b. Approval Engine REST — Create Definition**
- File: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/approval-engine/definitions/create-definition.mdx`
- Changes: Rewrite `edges` ParamField to the unified EdgeSchema (`from`/`to`/`on`/`when`/`loop`); REMOVE the `loops` ParamField (lines 62-64); add node `name`/`description` to node config; note group-as-edge-source (`waitAll`/`cancelOnQuorum`); update edge example + success response to show `compiled` block. Edge `when` is now valid only on `on:"custom"`.
- Priority: High.

**3c. Approval Engine REST — Update Definition**
- File: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/approval-engine/definitions/update-definition.mdx`
- Changes: Mirror 3b edge/loops/node changes; remove `onReject`/`loops[]` references.
- Priority: High.

**3d. Approval Engine REST — Get Definition**
- File: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/approval-engine/definitions/get-definition.mdx`
- Changes: Document read-only `compiled` block (`compiled.forwardEdges` + `compiled.loops`, schema from raw input lines 51-67) in the response; note authored `edges` echo `sourceEdges` byte-for-byte; remove `onReject`/`loops[]` echo references.
- Priority: High.

**3e. Approval Engine REST — List Definitions**
- File: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/approval-engine/definitions/list-definitions.mdx`
- Changes: Note each row carries the `compiled` block; remove `onReject`/`loops[]` references.
- Priority: Medium.

**3f. Approval Engine Conceptual — Customize Behavior (largest revision, 44KB)**
- File: `/Users/yoenzhang/Downloads/docs/ai/approval-engine/customize-behavior.mdx`
- Changes: Remove/rewrite the "Per-human-node `onReject` shorthand" section (lines 59-131), the `loops[]` region model, and "When to use a loop vs. the `onReject` shorthand" (line 259). Replace with unified `edges[]`: reject path = outgoing `on:"reject"` edge; loop-back = `on:"reject"` edge with `loop`; exhausted = sibling `on:"exhausted"` edge. Add group-as-edge-source semantics (waitAll unanimity, cancelOnQuorum quorum) and node `name`/`description`. Add the new `APPROVAL_EDGE_*` error keys.
- Priority: High.

**3g. Approval Engine Conceptual — Setup**
- File: `/Users/yoenzhang/Downloads/docs/ai/approval-engine/setup.mdx`
- Changes: Rewrite `onReject.routeToNodeId` walkthrough (lines 62-105), the "Rejection handling: shorthand vs. loops" guidance (line 323), and the "Human node missing a reject path" troubleshooting (line 365) to the `edges[]` model. Fix anchor links pointing to removed customize-behavior sections.
- Priority: High.

**3h. Approval Engine Conceptual — Overview**
- File: `/Users/yoenzhang/Downloads/docs/ai/approval-engine/overview.mdx`
- Changes: Verify no `onReject`/`loops[]` mentions remain; add `compiled` block and group-as-edge-source to feature list if applicable. Agent-3: grep first, edit only if hits.
- Priority: Low.

### 4a. UI Customization — Wireframes
- Not applicable. Backend/REST release, no wireframes. SKIP.

### 4b. UI Customization — Primitives
- Not applicable. No primitive components. SKIP.

### 5. Upgrade Guide (breaking changes)
- Covered in 3a. Breaking changes go ONLY in upgrade-guide.mdx, never the changelog.

## NO DOC TARGET — HUMAN DECISION REQUIRED (flag for Agent-3)

The three new agent capabilities and the custom-agent config validation changes have NO existing public doc surface. Existing agent pages: `ai/agent-comments.mdx` (agents leaving comments, unrelated) and `api-reference/rest-apis/v2/agents/` (only `list-agent-executions.mdx`). Agent-1 deliberately omitted "Learn more" links for all 7 agent items.

Items with no home:
- `rest-api` context-gathering strategy (raw input lines 83-97: `strategyOptions["rest-api"]`, `RestApiEndpoint` shape, SSRF guard, `{{restApiData}}`).
- `mcp-tools` execution strategy (raw input lines 99-110: `execution.mcpServers[]` shape, allowlists, max-turn cap).
- `docs-code-comparison` built-in agent (raw input lines 112-115).
- Custom-agent config validation: deep-merge partial updates; reject server-managed fields (`managedBy`, `metadata.*`) with per-key 400; `instructions` required for `ai`/`service+ai`/`stagehand-agent`; `listVersions` fail-closed secret redaction.

Recommendation: warrants ONE new custom-agent configuration reference page (execution strategies + context-gathering strategies + built-in agents + config validation), e.g. `ai/agents/configuration.mdx` or `api-reference/rest-apis/v2/agents/`. DECISION DEFERRED to human — do NOT invent a page or fabricate URL paths this pass. If approved, Agent-3 also adds nav entries to `docs.json` (agents section near line 311 / 827).

## DO NOT DOCUMENT (confirmed internal refactors)
ApiKeySecretCipher extraction; ProviderApiKeyService extraction; CryptoUtil/CRDT barrel-import migration; compileGraph-vs-linter validation split; ILlmProvider.askAIWithTools adapter internals; McpClientService internal plumbing. Email-digest determinism bug fix = changelog only, no reference doc.

## Implementation Sequence
1. Upgrade guide breaking-change entry + migration table (High; blocks correctness of changelog link).
2. Approval Engine REST: create + update (edges/loops/node) (High).
3. Approval Engine REST: get + list (`compiled` block) (High/Medium).
4. Conceptual: customize-behavior rewrite, then setup (depends on customize-behavior anchors) (High).
5. Conceptual: overview grep-and-fix (Low).
6. Agent tooling: PAUSE — await human decision on new page before any agent-config docs.

## Quality Checklist
- [ ] Breaking change moved to upgrade-guide.mdx ONLY (not changelog).
- [ ] Migration table (onReject/loops[] → edges[]) + new error keys in upgrade guide.
- [ ] All `onReject`/`loops[]`/`loopBack` references removed from REST + conceptual pages.
- [ ] `compiled` block documented on get/list/create responses.
- [ ] Group-as-edge-source (waitAll/cancelOnQuorum) + node name/description documented.
- [ ] No broken anchors after customize-behavior section removals (setup.mdx links).
- [ ] Code examples keep `React/Next.js` first, `Other Frameworks` second where tabs apply (REST pages are framework-agnostic JSON).
- [ ] Agent-tooling new-page decision surfaced to human; no invented URLs.
- [ ] Internal refactors NOT documented.
- [ ] Log written to `.claude/logs/agent-2-planning-v6.0.0-beta.1-approval-engine-agent-tooling.md`.
