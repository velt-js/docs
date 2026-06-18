# Release Update Plan for velt-py v0.1.11

## Overview
- Release Type: Minor (large additive REST API parity expansion; no breaking changes)
- Key Changes: 3 new `sdk.api.*` services (agents/memory/workflow), new methods on 4 existing services (users/documents/crdt/workspace), opt-in `filter_unknown_fields` keyword, `getApiKeyMetadata` endpoint repoint
- Breaking Changes: No — all additive; `sdk.selfHosting.*` unchanged; `getApiKeyMetadata` signature unchanged

## Areas Requiring Updates

### 1. Data Models — SKIP
Per v0.1.9/v0.1.10 precedent, Python dataclasses (`velt_py.models.*`) must NOT be added to `/api-reference/sdk/models/data-models.mdx` (that file is the Web/React SDK reference). New models (`velt_py.models.agents`, `.memory`, `.workflow`, `.field_allowlists`) are documented inline on python.mdx only.

### 2. API Methods — SKIP
`/api-reference/sdk/api/api-methods.mdx` is Web/React SDK only. Python services must NOT be added there.

### 3. Primary Documentation: `/Users/yoenzhang/Downloads/docs/backend-sdks/python.mdx`
- File: `/Users/yoenzhang/Downloads/docs/backend-sdks/python.mdx`
- Priority: High
- All edits land inside the `## REST API Backend` section (line 757) and before `## Error Handling` (line 3642). Follow the existing per-method pattern exactly: `####` heading, bullet description, `Params:` line, `Returns:` line, Python code block (with `from velt_py.models.* import ...`), then `**Response**` example.

**3a. Update the "17 services" intro count to 20**
- Line 759: change "17 services are available" to "20 services are available".
- Line 771 comment: change "All 17 services are accessible under sdk.api.*" to "All 20 services are accessible under sdk.api.*".

**3b. New methods on existing services (insert as new `####` blocks at end of each service section, before the next `###`)**
- `users` — insert after `deleteUsers` (ends line 1604, before `### User Groups` at 1606): add `getUsersCount`, `getDocUsers`, `addUserInvite`, `respondToInvite`, `getInvitedUsers`, `getUserInvitations`, `getInvitedPendingUsersCount` (7 methods). Also note `getUsers` (line 1501) gains `includeInvolvedDocuments` and `searchKey` params — add them to the existing `getUsers` example. Models: `velt_py.models.user_api`.
- `documents` — insert `getDocumentsCount` after `migrateDocumentsStatus` (ends line 1462, before `### Users` at 1463). Model: `velt_py.models.document`.
- `crdt` — insert `deleteCrdtData` after `updateCrdtData` (ends line 2751, before `### Presence` at 2753). Model: `velt_py.models.crdt`.
- `workspace` — insert 19 new methods after `updateWebhookConfig` (ends line 3605, before `### Token` at 3607). Models: `velt_py.models.workspace`. Agent-3: enumerate the 19 method names from PyPI 0.1.11 source before writing.

**3c. New `### service` sections (insert all 3 before `### Token` at line 3607, after the new workspace methods, keeping `Token` and `Data Isolation` last)**
- `### Agents` (`sdk.api.agents`) — 23 methods: create/get/update/delete agents; agent versions; executions run/get/list/count; prompt tooling (enhancePrompt, validatePrompt, refinePrompt, resolveConfig, extractAgents); analytics; agent groups create/get/list/update/delete + add/remove agents. Model: `velt_py.models.agents`.
- `### Memory` (`sdk.api.memory`) — 25 methods: search, queryJudgments, suggest, ask, getReviewerProfile, getPatterns, getStats, ingestKnowledge, getUploadUrl, getIngestStatus, updateKnowledge, deleteKnowledge, searchKnowledge, listKnowledgeSources, downloadCanonicalMarkdown, listExtractedRules, listAlerts, dismissAlert, markAlertActioned, updateAlertConfig, getAlertConfig, triggerConsolidation, seedActiveApiKeys, backfillJudgments. Model: `velt_py.models.memory`.
- `### Workflow` (`sdk.api.workflow`) — 14 methods: createDefinition, updateDefinition, deleteDefinition, getDefinition, listDefinitions, dispatchExecution, cancelExecution, getExecution, getExecutionEvents, listExecutions, cancelStep, resolveStep, recordAgentResolution, recordReviewerDecision. Model: `velt_py.models.workflow`.

**3d. Params/Returns link rule for new Python-only request types (decided)**
- Verified: agents/memory/workflow/field_allowlists request types have NO anchors in data-models.mdx (only an unrelated `CommentDialogAgentSuggestionProps` UI entry exists).
- Rule: name the dataclass in plain inline code WITHOUT a link, and show the real import path in the code block. Example: `Params: \`RunExecutionRequest\` (from \`velt_py.models.agents\`)`. Do NOT link to non-existent `data-models.mdx` anchors and do NOT add these types to data-models.mdx.
- Returns: continue linking to `[VeltApiResponse](/api-reference/sdk/models/data-models#veltapiresponse)` (that anchor exists and applies to all REST responses).
- Existing services (users/documents/crdt/workspace) keep their current data-models.mdx links since those request anchors already exist for the shared Web/React types.

**3e. `filter_unknown_fields` opt-in keyword**
- Add a short note on the add/update methods of `commentAnnotations` (lines 1952, 2087), `activities` (lines 2323, 2406), and `notifications` (lines 1719, 1806): these accept an optional `filter_unknown_fields=True` keyword that drops keys not in the allowlist, backed by `velt_py.models.field_allowlists`.
- Document once in detail (preferred: a brief bullet under the `## REST API Backend` intro or a small `#### Filtering unknown fields` note) and cross-reference from each method to avoid repetition. Import: `from velt_py.models.field_allowlists import ...` (Agent-3: confirm exported symbol names from PyPI 0.1.11).

**3f. `getApiKeyMetadata` bug fix**
- At `getApiKeyMetadata` (line 3254): add one bullet noting it now targets the canonical `/v2/workspace/apikeyconfig/get` endpoint; signature and usage unchanged. No code/example change needed.

### 4. Navigation: `/Users/yoenzhang/Downloads/docs/docs.json` — SKIP
`backend-sdks/python` already exists in the "Backend SDKs" pages array (line 320). No nav change.

### 5. UI Customization / Wireframes / Primitives — N/A
Backend-only release. No frontend components, wireframes, or primitives affected.

### 6. Upgrade Guide — N/A
Fully additive and backward compatible. No breaking changes; no upgrade-guide.mdx entry.

## Implementation Sequence
1. Update intro counts: 17 → 20 (lines 759, 771). Effort: trivial.
2. Add `getDocumentsCount` to documents (before line 1463). Effort: low.
3. Add 7 invite/count methods to users + 2 new params on `getUsers` (before line 1606). Effort: medium.
4. Add `deleteCrdtData` to crdt (before line 2753). Effort: low.
5. Add 19 new workspace methods (before line 3607). Effort: medium-high.
6. Add `### Agents`, `### Memory`, `### Workflow` sections (before line 3607, after workspace, before Token). Effort: high (62 methods total).
7. Add `filter_unknown_fields` note + cross-references on commentAnnotations/activities/notifications add/update. Effort: low.
8. Add `getApiKeyMetadata` endpoint-repoint bullet (line 3254). Effort: trivial.
9. Verify all new method names, param names, and model exports against PyPI velt-py 0.1.11 source before publishing. Effort: medium.

## Quality Checklist
- [ ] Intro count updated 17 → 20 in both the prose (759) and the comment (771)
- [ ] `### Agents` (23), `### Memory` (25), `### Workflow` (14) sections added before `### Token`
- [ ] New methods added to users (7 + 2 params), documents (1), crdt (1), workspace (19)
- [ ] New Python-only request types named in plain code (no data-models.mdx link); Returns still links to VeltApiResponse
- [ ] No Python types added to `/api-reference/sdk/models/data-models.mdx` or `/api-reference/sdk/api/api-methods.mdx`
- [ ] Each new method follows the pattern: description bullet, Params, Returns, Python code block, `**Response**` example
- [ ] `filter_unknown_fields` documented once + cross-referenced on commentAnnotations/activities/notifications add+update
- [ ] `getApiKeyMetadata` endpoint-repoint noted; signature unchanged
- [ ] docs.json unchanged (python page already in nav)
- [ ] No wireframe/primitive/upgrade-guide edits
- [ ] Method/param/model names verified against PyPI velt-py 0.1.11
- [ ] Log written to `.claude/logs/agent-2-planning-velt-py-0.1.11.md`
