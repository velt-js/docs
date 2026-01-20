# Release Update Plan for 4.7.2-beta.1

## Overview
- Release Type: Minor (Beta)
- Key Changes: New CRDT Get API REST endpoint for retrieving CRDT editor data on demand from backend
- Breaking Changes: No

## Areas Requiring Updates

### 1. REST API Documentation - NEW ENDPOINT
- Files:
  - `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/crdt/get-crdt-data.mdx` (NEW FILE)
  - `/Users/yoenzhang/Downloads/docs/docs.json` (add navigation entry)
- Changes:
  - Create new REST API documentation page for `POST https://api.velt.dev/v2/crdt/get`
  - Document headers: `x-velt-api-key`, `x-velt-auth-token`
  - Document request body schema: organizationId (required), documentId (required), editorId (optional)
  - Document success response format with data array containing: data (text/xml/array/object), id, lastUpdate, lastUpdatedBy, sessionId
  - Document error response format
  - Add to docs.json navigation under "REST APIs" > "v2" with new group "CRDT"
- Priority: High

### 2. CRDT Feature Documentation - REFERENCE TO REST API
- Files: `/Users/yoenzhang/Downloads/docs/realtime-collaboration/crdt/setup/core.mdx`
- Changes:
  - Add section referencing the new REST API for backend data retrieval
  - Link to REST API documentation from CRDT setup guide
  - Add note that this complements the SDK methods for frontend usage
- Priority: Medium

### 3. Navigation Configuration
- Files: `/Users/yoenzhang/Downloads/docs/docs.json`
- Changes:
  - Add new "CRDT" group under "REST APIs" > "v2" (after "Live State" group, before "Workspace")
  - Add entry: `"api-reference/rest-apis/v2/crdt/get-crdt-data"`
- Priority: High

## Implementation Sequence

1. **Create directory structure** (Low effort)
   - Create `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/crdt/` directory

2. **Create REST API documentation file** (Medium effort)
   - Write `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/crdt/get-crdt-data.mdx`
   - Follow existing REST API pattern from `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/livestate/broadcast-event.mdx`
   - Include endpoint, headers, body parameters, success/error responses with examples

3. **Update navigation configuration** (Low effort)
   - Edit `/Users/yoenzhang/Downloads/docs/docs.json`
   - Add CRDT group with get-crdt-data page reference

4. **Update CRDT feature documentation** (Low effort)
   - Edit `/Users/yoenzhang/Downloads/docs/realtime-collaboration/crdt/setup/core.mdx`
   - Add REST API reference section with link to new documentation

## Quality Checklist
- [ ] REST API documentation created at correct path
- [ ] Documentation follows existing REST API pattern (headers, body params, responses)
- [ ] Request/response examples are accurate and complete
- [ ] Navigation entry added to docs.json in correct location
- [ ] CRDT setup guide references the new REST API
- [ ] All internal links are valid and follow Velt URL patterns
- [ ] No new data models needed (response uses existing structure similar to CrdtUpdateDataPayload)
- [ ] No SDK API methods changes (backend-only REST API)
- [ ] Log file written to `/Users/yoenzhang/Downloads/docs/.claude/logs/agent-2-planning-4.7.2-beta.1.md`
