# Agent-6 Alignment Log — v6.0.0-beta.1 Approval Engine & Agent Tooling (23 Jun 2026)

Scope: alignment-only verification of Agent-3's `edges[]` unification + `compiled` block work across the full docs tree. Agents 4 & 5 were no-ops (backend/REST release, no wireframes/primitives).

## Result: ZERO edits required

Agent-3's implementation was fully consistent. No genuine drift, broken anchors, banned identifiers, or error-key typos found. All findings below are PASS confirmations.

## Files scanned

- `release-notes/version-6/sdk-changelog.mdx`, `upgrade-guide.mdx`
- `api-reference/rest-apis/v2/approval-engine/definitions/{create,update,get,list}-definition.mdx`
- `api-reference/rest-apis/v2/approval-engine/steps/resolve-step.mdx`, `executions/{dispatch-execution,get-execution-events}.mdx`
- `ai/approval-engine/{overview,setup,customize-behavior}.mdx`
- `backend-sdks/node.mdx`, `backend-sdks/python.mdx`, `api-reference/sdk/models/data-models.mdx`
- Adjacent flagged files: `webhooks/advanced.mdx`, `get-started/agentic-overview.mdx`, `ai/agent-comments.mdx`
- `docs.json` (verify-only, not modified)

## Verification results

### 1. Old-model references — CLEAN
Case-sensitive word-boundary grep for `onReject` / `loopBack` / `onIterationReject` / `ApprovalLoop` / `ApprovalHumanNodeOnReject` across `ai/`, `api-reference/`, `backend-sdks/`:
- **Zero hits** in approval-engine REST pages, conceptual pages, and backend SDK pages.
- Surviving mentions are all intentional:
  - `upgrade-guide.mdx` migration table (old→new mapping — required).
  - `sdk-changelog.mdx` line 18 — prose naming the removed concepts to explain the breaking change (required).
- False-positive substrings correctly left alone: `loopback` (SSRF network term in webhook validation, setup/customize-behavior/dispatch-execution), `compiled.loops[]` (new read-only field), `SUGGESTION_REJECTED`/`suggestionRejected` (unrelated comment-suggestion feature).

### 2. APPROVAL_* error keys — EXACT MATCH (10/10)
Every key in the docs matches the raw note's set byte-for-byte. No typo'd or invented constants:
```
APPROVAL_EDGE_CUSTOM_REQUIRES_WHEN
APPROVAL_EDGE_WHEN_ONLY_FOR_CUSTOM
APPROVAL_EDGE_LOOP_REQUIRES_REJECT
APPROVAL_EDGE_LOOP_TARGET_NOT_ANCESTOR
APPROVAL_EDGE_REJECT_CYCLE_REQUIRES_LOOP
APPROVAL_EDGE_EXHAUSTED_REQUIRES_LOOP_SIBLING
APPROVAL_HUMAN_NODE_REQUIRES_REJECT_PATH
APPROVAL_EDGE_GROUP_TO_GROUP_FORBIDDEN
APPROVAL_GROUP_FROM_REJECT_REQUIRES_LOOP
APPROVAL_GROUP_FROM_LOOP_REQUIRES_JOINONQUORUM
```
(The bare `APPROVAL_EDGE_*` glob token exists only in the raw note, not in docs.)

### 3. Banned internal identifiers — ABSENT
`compileGraph`, `ApprovalDefinitionService`, `CustomAgentFirestoreService`, `ApiKeySecretCipher`, `ProviderApiKeyService`, `CryptoUtil`, `ILlmProvider`, `askAIWithTools`, `McpClientService`, `INV-005`, `INV-022`, `DEPLOY_ALL`: **zero hits** in any docs page (only in raw note + pipeline logs).

`linter` (13 occurrences) is NOT banned — the ban targets the internal "compileGraph-vs-linter split mechanics". The user-facing "linter rules / linter code / linter validation" concept predates this release (present since v5.0.2-beta.31) and is consistent. Kept.

### 4. Canonical terminology — CONSISTENT
- `on` role values: only `approve` / `reject` / `always` / `exhausted` / `custom` appear. No stray roles.
- Compiled-vs-authored distinction maintained correctly: authored edges use `on`; `compiled.forwardEdges` entries use `role` (per the `CompiledGraph` interface). get-definition's field table even labels it "The authored `on` role."
- EdgeEndpoint `kind:"node"` / `kind:"group"` spelling consistent (node.mdx uses single quotes per its TS-block style — acceptable).
- Group policies: `waitAll` / `cancelOnQuorum` / `joinOnQuorum` — exact casing everywhere in prose. Lowercase forms appear only inside pre-existing linter-rule slug names (`group-cancelonquorum-requires-quorum-lt-expected`, `group-joinonquorum-members-must-share-successors`) and the `..._REQUIRES_JOINONQUORUM` error-key constant — all correct by convention.
- `routeToNodeId` appears only in `compiled.loops[].onExhausted` and the upgrade-guide migration table — never as an authored edge field.

### 5. `compiled` block schema — MATCHES CompiledGraph interface
get-definition `#### The compiled block` field tables match the raw note field-for-field:
- `forwardEdges`: `from`, `to`, `role`, `when` (`JsonAst | null`), `fromGroupId?`, `toGroupId?`
- `loops`: `loopId`, `entryNodeId`, `bodyNodeIds` (string[]), `maxIterations`, `onExhausted` (`{ routeToNodeId } | null`)

`sourceEdges` used only as the documented echo contract concept ("authored `edges` echo `sourceEdges` byte-for-byte") in caller-facing phrasing — permitted usage.

### 6. Cross-reference links / anchors — ALL RESOLVE
`Learn more →` target files all exist:
- `/release-notes/version-6/upgrade-guide` ✓
- `/api-reference/rest-apis/v2/approval-engine/definitions/get-definition` ✓
- `/ai/approval-engine/customize-behavior` ✓
- `/api-reference/rest-apis/v2/approval-engine/definitions/create-definition` ✓

In-page anchors to customize-behavior NEW heading slugs — all resolve to live headings:
- `#edge-model` → `## Edge model` ✓
- `#custom-predicates` → `### Custom predicates` ✓
- `#loop-regions` → `## Loop regions` ✓
- `#node-configuration`, `#parallel-groups-and-quorum-policies`, `#linter-rules`, `#event-reference`, `#webhook-retry-policy`, `#sla-and-breach-handling`, `#agent-nodes`, `#onquorummet-policies`, `#specific-must-approve-quorum`, `#canonical-codes` ✓
- get-definition `#the-compiled-block` → `#### The compiled block` (referenced from list-definitions + customize-behavior) ✓
- No dead anchors to removed sections (`#per-human-node-onreject-shorthand`, `#edge-gating-expressions`, `#when-to-use-a-loop...`) anywhere. ✓
- data-models `#approvalcreatedefinitionrequest-node` refs from node.mdx — N/A (Agent-3 confirmed no separate response-shape anchor; not introduced).

### 7. Agent-tooling — NO DOC SURFACE (as mandated)
- All 6 `[**Agents**]` changelog bullets (lines 38, 40, 42, 56, 66, 68) are **link-less**. Confirmed: zero `[...](...)` links in any Agents bullet.
- No `ai/agents/` directory exists. `api-reference/rest-apis/v2/agents/` contains only the pre-existing `list-agent-executions.mdx`.
- `docs.json` has no agent-tooling nav entries and is NOT in the modified-files set (untouched).
- No `restApiData` / `mcp-tools` / `docs-code-comparison` / `mcpServers` references leaked into any prose doc page.

### 8. Modified-files set — matches Agent-3 exactly
`git status` shows exactly the 12 files Agent-3 reported as changed. No stray/new doc files. The 3 untracked files are pipeline inputs/logs.

## Canonical term list for Agent-7 final QA pass

Enforce EXACT forms; flag drift:
- Edges: `edges[]`, `EdgeSchema`; fields `from`, `to`, `on`, `when`, `loop`.
- `on` roles (quoted): `"approve"`, `"reject"`, `"always"` (default), `"exhausted"`, `"custom"`.
- EdgeEndpoint kinds: `{ kind: "node", nodeId }`, `{ kind: "group", groupId }` (single quotes acceptable only inside node.mdx TS block).
- Compiled view: `compiled`, `compiled.forwardEdges`, `compiled.loops`. forwardEdges entry fields: `from`, `to`, `role`, `when`, `fromGroupId?`, `toGroupId?`. loop fields: `loopId`, `entryNodeId`, `bodyNodeIds`, `maxIterations`, `onExhausted`.
- Group policies: `waitAll`, `cancelOnQuorum`, `joinOnQuorum`.
- Echo contract term: `sourceEdges` (caller-facing echo phrasing only).
- Error keys: the 10 `APPROVAL_*` constants listed in §2 — spell EXACTLY.
- Node cosmetic fields: `name` (1–200), `description` (max 2000).
- LEAVE ALONE (unrelated): `suggestionRejected` / `SuggestionRejectEvent` / `ActionReject` / `SUGGESTION_REJECTED` (comment-suggestion feature); `loopback` (SSRF network term).
- DO NOT introduce: banned internal identifiers in §3; agent-tooling pages/links/nav.

## Needs human review

1. **SDK contract assumption (carried from Agent-3, unresolved):** `backend-sdks/node.mdx` + `data-models.mdx` now describe the unified `ApprovalEdge` (`on`/`loop`, no `onReject`/`loops[]`). This assumes the published `@veltdev/node` SDK has shipped the `edges[]` migration in lockstep with the Cloud Functions contract. If the SDK still accepts `onReject`/`loops[]`, these pages describe the model ahead of the shipped SDK surface. Verify before publish. (`python.mdx` left unedited — no python-side drift.)
2. **`compiled` example values are illustrative** (carried from Agent-3): get/create `compiled.forwardEdges`/`loops` examples use representative placeholder values (raw note gives the TS interface, not concrete JSON). Field shapes are correct; concrete values are representative.

## Handoff to Agent-7
Aligned docs verified clean. Change map above is the source of truth for Agent-7's repo-wide QA terminology pass. No corrective edits were needed this pass.
