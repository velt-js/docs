# Release Update Plan for v5.0.2-beta.8 (Document Migration API Addendum)

## Overview
- Release Type: Minor (addendum to existing 5.0.2-beta.8 entry)
- Key Changes: Two new V2 REST API endpoints for asynchronous document migration; one bug fix reducing Firestore batch size
- Breaking Changes: No

## Context

The prior `agent-2-planning-5.0.2-beta.8.md` covered the Recorder self-host and CRDT message stream features from the same release. This plan covers only the Document Migration API content appended by Agent-1 to the same changelog entry.

The bug fix (batch size 500 → 100) is internal implementation detail only; it is already documented in the changelog bug fix section and requires no documentation page changes.

---

## Areas Requiring Updates

### 1. New REST API Pages (new feature — no existing pages)

Two new MDX files must be created under the v2 documents directory.

**a. Migrate Document (initiate)**
- File: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/documents/migrate-documents.mdx`
- Endpoint: `POST https://api.velt.dev/v2/organizations/documents/migrate`
- Request body fields inside `data` object:
  - `organizationId` (string, required)
  - `documentId` (string, required) — the current document ID to re-key
  - `newDocumentId` (string, required) — the target document ID
- Success response: returns `migrationId` (string) used to poll status
- Failure response: standard `{ "error": { "message": "...", "status": "..." } }`
- Follow exact structure of `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/documents/move-documents.mdx` (headers, ParamField, example request/response, ResponseExample blocks)
- Priority: High

**b. Migration Status (poll)**
- File: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/documents/migrate-documents-status.mdx`
- Endpoint: `POST https://api.velt.dev/v2/organizations/documents/migrate/status`
- Request body fields inside `data` object:
  - `organizationId` (string, required)
  - `migrationId` (string, required) — returned by the initiate call
- Success response: returns migration status (e.g., `pending`, `in_progress`, `completed`, `failed`) and progress metadata
- Failure response: standard error shape
- Same structural pattern as migrate-documents.mdx
- Priority: High

### 2. docs.json Navigation (new pages must be registered)

- File: `/Users/yoenzhang/Downloads/docs/docs.json`
- Location: the v2 documents group currently at lines 441–447 (entries: `add-documents`, `get-documents-v2`, `update-documents`, `delete-documents`, `move-documents`, `update-document-access`, `update-document-disable-state`)
- Add after `move-documents`:
  - `"api-reference/rest-apis/v2/documents/migrate-documents"`
  - `"api-reference/rest-apis/v2/documents/migrate-documents-status"`
- Priority: High

---

## Areas NOT Requiring Updates

- **Data Models** (`data-models.mdx`): No new SDK types or interfaces. The migration endpoints use plain request/response JSON fields (`organizationId`, `documentId`, `newDocumentId`, `migrationId`) — no typed models are exposed in the SDK.
- **API Methods** (`api-methods.mdx`): REST-only endpoints; no new SDK client methods or hooks.
- **UI Customization**: No UI changes.
- **Migration Guides**: No breaking changes.
- **Self-Host Data**: No new self-host data patterns.

---

## Implementation Sequence

1. Create `migrate-documents.mdx` — no prerequisites.
2. Create `migrate-documents-status.mdx` — no prerequisites, but logically references the `migrationId` produced by step 1.
3. Update `docs.json` — prerequisite: both files must exist before registering nav entries.

---

## Quality Checklist
- [ ] `migrate-documents.mdx` created with correct endpoint URL, all three required body params, curl example matching the changelog snippet, and `migrationId` in success response
- [ ] `migrate-documents-status.mdx` created with correct endpoint URL, `organizationId` and `migrationId` body params, curl example, and status field in success response
- [ ] Both pages follow the same `ParamField` / `ResponseExample` structure as `move-documents.mdx`
- [ ] Headers section in both pages includes `x-velt-api-key` and `x-velt-auth-token`
- [ ] `docs.json` updated: two new entries added after `move-documents` in the v2 documents group
- [ ] No new data-model types added (endpoints use plain JSON, not SDK typed objects)
- [ ] No api-methods.mdx changes needed (REST-only, no SDK client methods)
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.8-document-migration.md`
