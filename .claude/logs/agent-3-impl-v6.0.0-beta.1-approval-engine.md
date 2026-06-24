# Agent-3 Implementation Log — v6.0.0-beta.1 Approval Engine (23 Jun 2026)

Scope: Approval Engine `edges[]` unification only. Agent-tooling features were CHANGELOG-ONLY per human orchestrator decision — NO new agents page, NO `docs.json` changes, NO documentation of `rest-api`/`mcp-tools`/`docs-code-comparison`/custom-agent validation.

## Files changed (8)

### A. `release-notes/version-6/upgrade-guide.mdx` — HIGHEST PRIORITY
- BEFORE: `## Breaking Changes` said "None — fully backward compatible."
- AFTER: Two bracket-prefixed bullets — `[**Modular SDK**]` (None) and `[**Approval Engine — unified edges[] contract**]` (breaking). Added an `### Approval Engine: migrate to edges[]` subsection under How to Upgrade with: the 4-row old→new migration mapping table, the new `EdgeSchema` field table (`from`/`to`/`on`/`when`/`loop`), and the 10-row `APPROVAL_*` compile-error-key table. Renamed the existing modular-SDK how-to heading to `## How to Upgrade the Modular SDK` to disambiguate. Migration detail lives here, NOT in the changelog.

### B. `…/definitions/create-definition.mdx`
- `edges` ParamField rewritten to unified `EdgeSchema` (field table: `from`/`to` EdgeEndpoint, `on` enum default `always`, `when` only on `custom`, `loop` only on reject back-edge). Added the `APPROVAL_HUMAN_NODE_REQUIRES_REJECT_PATH` rule note.
- REMOVED the `loops` ParamField.
- `nodes` ParamField: added optional cosmetic `name` (1–200) / `description` (≤2000).
- `groups` ParamField: added group-as-edge-source note (`waitAll` unanimity, `cancelOnQuorum` quorum, forward reject = dead edge, group-to-node fan-out).
- Node example: added `name`/`description`. Edge example: replaced single `when` example with 5 examples (approve/reject/reject+loop/exhausted/custom). Request example edges: split human→publish into `on:"approve"` + `on:"reject"`+`loop`.
- Success response + ResponseExample: added read-only `compiled` block (`forwardEdges`/`loops`) and a prose note that authored `edges` echo `sourceEdges` byte-for-byte.

### C. `…/definitions/update-definition.mdx`
- Mirrored B: `edges` rewritten to EdgeSchema summary, `loops` ParamField REMOVED, `nodes` gained name/description, `groups` gained edge-source note, both response blocks gained `compiled`.

### D. `…/definitions/get-definition.mdx`
- Success response JSON: added populated `compiled.forwardEdges` + `compiled.loops` examples; `edges` annotated as byte-for-byte `sourceEdges`.
- Added a `#### The compiled block` section with `<ResponseField name="compiled">` documenting `forwardEdges` (`from`/`to`/`role`/`when`/`fromGroupId?`/`toGroupId?`) and `loops` (`loopId`/`entryNodeId`/`bodyNodeIds`/`maxIterations`/`onExhausted`) — translated from the raw note's `CompiledGraph` TS interface into the page's ResponseField/table style.
- ResponseExample: added empty `compiled` block.

### E. `…/definitions/list-definitions.mdx`
- Annotated `items` as carrying the read-only `compiled` block per row + prose note linking to get-definition `#the-compiled-block`.

### F. `ai/approval-engine/customize-behavior.mdx` (largest)
- Node-configuration intro: added node `name`/`description` paragraph.
- REPLACED the entire `### Per-human-node onReject shorthand`, `### Strict-mode validation`, `### What desugaring rejects`, `### onReject.routeToNodeId on a joinOnQuorum group member is dead code`, `### Canonical form after desugaring`, and `## Edge gating expressions` block with:
  - `### Rejection paths are edges` (short)
  - `## Edge model` (field table + `### Reject, loop-back, and exhausted` + `### Custom predicates` [absorbs old edge-gating content] + `### Groups as edge sources` + `### The compiled view`).
- `## Loop regions`: rewrote intro + field table to describe SERVER-DERIVED loops (`compiled.loops[]` shape) instead of authored top-level `loops[]`. Removed the authored-`loops[]` JSON example, the authored field table, and the `### When to use a loop vs. the onReject shorthand` subsection. Kept `### Body-shape constraint`, `previousAttempts`, iteration-scoped groups, loop events (still accurate runtime behavior).
- `## Linter rules`: pruned obsolete authored-loop rows (`loop-duplicate-id`, `loop-entry-must-be-in-body`, `loop-body-member-missing`, `loop-body-unreachable-from-entry`, `loop-node-in-multiple-loops`, `loop-on-exhausted-route-to-not-found`, `loop-on-exhausted-route-to-in-body`). Kept `loop-body-must-have-single-terminal` + `loop-group-bounded-quorum-must-equal-expected` (reworded "derived"). Added `### Edge model validation errors` table with all 10 `APPROVAL_*` keys.

### G. `ai/approval-engine/setup.mdx`
- Step 1 walkthrough: removed `onReject.routeToNodeId` from node config; reject path is now an `on:"reject"` edge. Removed redundant JSON-AST reject `when` edge. Added `APPROVAL_HUMAN_NODE_REQUIRES_REJECT_PATH` note. Relinked from removed `#per-human-node-onreject-shorthand` → `#edge-model`.
- Mermaid diagram labels updated to `on: approve` / `on: reject`.
- "Going further": rewrote conditional-routing bullet (`on:"custom"`, `#custom-predicates`), parallel-groups bullet (added waitAll edge-source), and rejection-handling bullet ("reject edges & loop-backs", relinked to `#edge-model`/`#loop-regions`, removed `#when-to-use…` and `#edge-gating-expressions` dead anchors).
- Troubleshooting: "Human node missing a reject path" → `APPROVAL_HUMAN_NODE_REQUIRES_REJECT_PATH` + add an `on:"reject"` edge.

### H. `ai/approval-engine/overview.mdx`
- Grep found no `onReject`/`loops`/`compiled` hits. Edited the `### Edges` mental-model paragraph (was old `when`-only model) to describe the unified `on`-role model, reject edges, loop-back marking, group-as-edge-source, and the read-only `compiled` block; linked to `#edge-model`.

### Out-of-plan fix
- `…/steps/resolve-step.mdx` line 75 referenced the now-removed authored `onIterationReject.when` field. Rewrote to the unified model: model the reject back-edge as `on:"custom"` with a `when` filtering on `decision` alone. Relinked `#loop-regions` → `#edge-model`. (Actively-wrong stale reference; same class as the in-scope removals.)

## Broken anchors fixed (setup/resolve-step → customize-behavior)
- `#per-human-node-onreject-shorthand` (removed) → `#edge-model`
- `#edge-gating-expressions` (renamed) → `#custom-predicates`
- `#when-to-use-a-loop-vs-the-onreject-shorthand` (removed) → dropped, folded into `#edge-model`/`#loop-regions`
All referenced anchors verified to resolve to live headings (incl. new `#edge-model`, `#custom-predicates`, get-definition `#the-compiled-block`).

## Verification
- Final grep: NO `onReject` / `loopBack` / `onIterationReject` / authored-`loops[]` references remain in any approval-engine page. Only surviving occurrences: the upgrade-guide migration table (intentional old→new mapping) and unrelated "loopback" in SSRF webhook text. All `"loops"` JSON literals are the read-only `compiled.loops` field.
- `compiled` block documented on create (4) + get (6, full field schema) + update (3); noted on list (2).
- Group-as-edge-source (waitAll unanimity / cancelOnQuorum quorum / group-to-node fan-out) documented in customize-behavior (dedicated section) + create + update + overview.
- Node `name`/`description` documented in customize-behavior + create + update.
- Code-fence parity even and all `<Expandable>`/`<ResponseField>` tags paired in every edited file.

## Confirmations
- Did NOT document any agent-tooling feature (`rest-api`, `mcp-tools`, `docs-code-comparison`, custom-agent validation).
- Did NOT create any new page.
- Did NOT touch `docs.json`.
- Did NOT touch the changelog (`sdk-changelog.mdx`); migration detail lives only in the upgrade guide.
- Did NOT expose internal-only identifiers (`compileGraph`/linter split, `ApiKeySecretCipher`, service class names, `INV-005`, `DEPLOY_ALL`, etc.). Public REST contract names (`compiled`, `forwardEdges`, `loops`, `edges`, EdgeSchema fields, `on` roles, `APPROVAL_*` error keys) ARE documented.

## Needs human review / ambiguous
1. `resolve-step.mdx` edit was outside Agent-2's explicit file list but contained an actively-wrong authored-loop field reference. Fixed minimally; flag if it should be reverted or expanded.
2. Get/Create `compiled` examples use illustrative placeholder values for `forwardEdges`/`loops` (the raw note gives the TS interface, not a concrete JSON instance). Field shapes match the `CompiledGraph` interface; concrete example values are representative.
3. `compiled.loops[].onExhausted` documented as `{ routeToNodeId } | null` per the raw `CompiledGraph` interface — consistent across get-definition and the customize-behavior Loop regions table.

---

## FOLLOW-UP (coordinator-relayed): backend SDK reference — old model still documented

A repo-wide grep found the OLD edges/loops model still in the backend SDK reference (these files were not in Agent-2's plan). Updated to the unified `edges[]` model. Same constraints held: no agent-tooling docs, no `docs.json`, surgical edits.

### node.mdx — `#### Node & Graph Types` inline TS block
- BEFORE: documented `ApprovalHumanNodeOnRejectLoopBack`, `ApprovalHumanNodeOnReject`, `ApprovalLoopRejectTrigger`, `ApprovalLoopExhaustionPolicy`, `ApprovalLoop`; `ApprovalHumanNodeConfig` carried `onReject?`; `ApprovalEdge` was `{ from: string; to: string; when?: string }`; node interfaces had no `name`/`description`.
- AFTER: removed all 5 now-deleted interfaces. `ApprovalHumanNodeConfig` keeps reviewerIds/reviewers/reviewerEmails/commentBody only (added inline comment: reject path is an outgoing `on:'reject'` edge). Added `type ApprovalEdgeEndpoint = string | { kind:'node'; nodeId } | { kind:'group'; groupId }` and rewrote `ApprovalEdge` to `{ from: ApprovalEdgeEndpoint; to: ApprovalEdgeEndpoint; on?: approve|reject|always|exhausted|custom (default always); when? (JSON-AST, only on custom); loop? { maxIterations 1..20 } (only on on:'reject' back-edge) }`. Added optional cosmetic `name?: string /* 1..200 */` + `description?: string /* max 2000 */` to `ApprovalAgentNode`, `ApprovalHumanNode`, `ApprovalWebhookNode`. Left `ApprovalQuorumPolicy`/`ApprovalGroup` as-is (waitAll/cancelOnQuorum/joinOnQuorum unchanged; groups-as-edge-sources is an edge concern, covered by `ApprovalEdgeEndpoint`).
- Also fixed the `createDefinition` method blurb "(nodes, edges, groups, loops, triggers)" → "(nodes, edges, groups, triggers)".
- Did NOT add compiled/CompiledGraph here (response types are not documented in this block — see data-models finding below).

### data-models.mdx — `ApprovalCreateDefinitionRequest` (Node)
- BEFORE: had `| loops | ApprovalLoop[] | No | Loop definitions. |` row; `edges` description was generic.
- AFTER: removed the `loops` row. Updated `edges` description to note the unified `EdgeSchema` (`from`/`to`/`on`/`when`/`loop`) and that reject paths and loop-backs are `on:'reject'` edges. `ApprovalUpdateDefinitionRequest` (Node) extends create and added no separate edges/loops rows, so removing the create row covers update too.
- **compiled SKIPPED in data-models.mdx (with reason):** there is NO documented approval definition response-shape type in data-models.mdx. All approval definition methods (`createDefinition`/`updateDefinition`/`getDefinition`/`listDefinitions`) document `Returns: VeltApiResponse` (the generic Node response type) — there is no `ApprovalDefinitionView` / `ApprovalGetDefinitionResponse` entry with nodes/edges/groups to attach `compiled` to. Per the coordinator's explicit instruction, I did NOT invent a new anchor. The `compiled` block IS already documented on the REST reference pages (get/create/update/list) from the first pass.

### python.mdx — verify only (NO edit)
- Confirmed: the Workflow examples (createDefinition/updateDefinition/etc., ~lines 4684-4752) use `edges=[]` and inline node dicts. Full-file grep for `onReject`/`loopBack`/`loops=`/`"loops"`/`ApprovalLoop`/`onIterationReject` → zero hits. The `edges=[]` examples are illustrative empty-edge examples (runnable); left as-is per instruction.

### Final grep (backend-sdks/ + data-models.mdx)
Word-boundary grep for `onReject|loopBack|ApprovalLoop|ApprovalLoopRejectTrigger|ApprovalLoopExhaustionPolicy|ApprovalHumanNodeOnReject|ApprovalHumanNodeOnRejectLoopBack|onIterationReject` → **zero matches** (exit 1). The only `*reject*` substrings remaining are the unrelated AI-suggestion events (`SUGGESTION_REJECTED`/`suggestionRejected`). node.mdx code fences balanced; the Node & Graph Types ```ts block opens/closes correctly.

### IMPORTANT ASSUMPTION FLAG (for human)
These backend SDK reference edits assume the `@veltdev/node` and `velt_py` SDK request types track the backend Cloud Functions contract for this release. If those SDKs have NOT yet shipped the `edges[]` migration (i.e. their published types still accept `onReject`/`loops[]`), then node.mdx / data-models.mdx now describe the new model AHEAD of the actual SDK surface, which would mislead SDK callers. Verify the shipped `@veltdev/node` / `velt_py` versions expose the unified `ApprovalEdge` (with `on`/`loop`) and reject `onReject`/`loops[]` before publishing. python.mdx was left unedited, so no python-side drift was introduced.
