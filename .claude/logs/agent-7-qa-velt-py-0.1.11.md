## QA Summary for velt-py v0.1.11

### Issues Found: 0

No corrective changes were required. Both touched files are internally consistent, correctly structured, and link-clean.

### Verification Coverage

**release-notes/version-5/velt-py-changelog.mdx**
- `<Update label="Python SDK (velt-py) v0.1.11" description="June 16, 2026">` — exact match; placed above v0.1.10 (line 9 vs 37)
- `<Update>` tags balanced (3 open / 3 close); no JSX mismatch
- Section order: New Features → Improvements → Bug Fixes (no Breaking Changes section)
- 9 distinct bullets: 7 New Features + 1 Improvement + 1 Bug Fix — none combined
- Method-count phrases present: agents `(24 methods)`, memory `(24 methods)`, workflow `(14 methods)`
- 7 `[Learn more →](/backend-sdks/python)` links — one per New Feature bullet; Improvement & Bug Fix bullets correctly have none; all resolve
- `getApiKeyMetadata` bug fix: canonical `/v2/workspace/apikeyconfig/get`, legacy alias `/v2/workspace/apikeymetadata/get`, "signature unchanged" note present

**backend-sdks/python.mdx**
- Code fences balanced (594 — even); no unterminated `python` blocks
- New service counts re-counted from `####` headings: Agents = 24, Memory = 24, Workflow = 14 — match section intros
- Heading levels correct: `###` for services, `####` for methods
- New services Agents/Memory/Workflow inserted before `### Token` (4824) and `### Data Isolation` (4855)
- "20 services" consistent in REST API Backend intro (759), Overview (21), and code comment (771); no stale "17"
- Every new `####` method has description + `Params:` + `Returns:` + opened/closed `python` fence
- `getDocumentsCount` (documents), `deleteCrdtData` (crdt), `getUsersCount`/`getDocUsers`/`addUserInvite`/`respondToInvite`/`getInvitedUsers`/`getUserInvitations`/`getInvitedPendingUsersCount` (users) all present; `getUsers` updated with `includeInvolvedDocuments`/`searchKey`
- `getApiKeyMetadata` endpoint (3431) matches changelog; signature-unchanged note present

**`filter_unknown_fields` (python.mdx)**
- Documented once at `### Filtering unknown fields` (778); subsection slug `#filtering-unknown-fields` valid
- Cross-referenced by exactly the 7 affected methods: updateNotifications, addCommentAnnotations, updateCommentAnnotations, addComments, updateComments, addActivities, updateActivities
- `addNotifications` correctly has NO cross-reference (explicitly not affected) — confirmed by isolating its block (1866–1952)
- Default `False`, top-level-only, fail-open semantics documented; `field_allowlists` module named

**Link integrity**
- All 118 unique `data-models#…` anchors referenced in python.mdx resolve to real headings (0 missing; checked against 929 heading candidates)
- New Python-only request types (CreateAgentRequest, MemorySearchRequest, CreateWorkflowDefinitionRequest, etc.) rendered as plain inline code — NOT linked to non-existent data-models anchors (correct)
- All 62 `/api-reference` links in the new Agents/Memory/Workflow sections target only `#veltapiresponse` (valid)

**Type-leakage / camelCase consistency**
- No Python-only request types or `velt_py`/`field_allowlists` leaked into `api-reference/sdk/*` from this release
- All method names in changelog prose match `####` headings in python.mdx (camelCase 1:1)

### Note (no action taken)
- QA prompt expected "grand total = 90", but python.mdx contains 170 REST-API `####` methods. Docs are internally self-consistent (20 services everywhere; 24/24/14 confirmed against both headings and intros), so "90" is a stale figure in the QA prompt, not a documentation defect. No change fabricated.
- Pre-existing working-tree edits to `api-reference/sdk/api/api-methods.mdx`, `api-reference/sdk/models/data-models.mdx`, `ui-customization/.../comment-sidebar*`, `async-collaboration/...`, and `self-host-data/overview.mdx` are from a prior unrelated beta — contain no velt-py 0.1.11 content; left untouched.

### Summary
- Files corrected: 0
- Critical issues: 0
- Terminology alignments: 0
- Agent-6 alignment confirmed clean; no propagation needed
- Result: PASS — Agent-1 clear to process the next release note
