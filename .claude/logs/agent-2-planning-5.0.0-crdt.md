# Release Update Plan for 5.0.0 (CRDT REST APIs)

## Overview
- Release Type: Minor (new REST API endpoints)
- Key Changes: Two new CRDT REST API endpoints: Add CRDT Data and Update CRDT Data
- Breaking Changes: No

## Source Material
- Release note: `/Users/yoenzhang/Downloads/docs/release-notes/version-5/sdk-changelog.mdx` lines 13-25
- Bug fix (Comments edit mode) requires no documentation updates

## Areas Requiring Updates

### 1. New REST API Documentation Pages (HIGH PRIORITY)

Two new MDX files must be created modeled on the existing pattern in:
`/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/crdt/get-crdt-data.mdx`

**File to create: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/crdt/add-crdt-data.mdx`**

Structure to follow from `get-crdt-data.mdx`:
- Frontmatter: `title: "Add CRDT Data"`, `api: "POST https://api.velt.dev/v2/crdt/add"`
- Intro sentence: explain this creates new CRDT editor data; link to `/realtime-collaboration/crdt/setup/core`
- `# Endpoint` section with URL
- `# Headers` section: `x-velt-api-key` (required, string), `x-velt-auth-token` (required, string, links to `/security/auth-tokens`)
- `# Body Parameters` section: nested `data` object (required) containing:
  - `organizationId` (string, required)
  - `documentId` (string, required)
  - `editorId` (string, required)
  - `data` (string, required) — the CRDT content to store
  - `type` (string, required) — one of `text`, `map`, `array`, `xml`
  - `contentKey` (string, optional) — sub-key within the CRDT document
- `## Example Request` JSON block
- `# Response` section with `## Success Response` and `## Error Response` JSON blocks
- `<ResponseExample>` block mirroring the success response

**File to create: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/crdt/update-crdt-data.mdx`**

Structure identical to `add-crdt-data.mdx` except:
- Frontmatter: `title: "Update CRDT Data"`, `api: "POST https://api.velt.dev/v2/crdt/update"`
- Intro sentence: explain this replaces existing CRDT editor data and generates CRDT operations so connected clients pick up the change
- All headers and body parameters are identical to Add CRDT Data
- Success response message should reflect "updated" not "added"

### 2. Navigation Config (HIGH PRIORITY)

**File: `/Users/yoenzhang/Downloads/docs/docs.json`**

Current CRDT group (lines 501-506):
```json
{
  "group": "CRDT",
  "pages": [
    "api-reference/rest-apis/v2/crdt/get-crdt-data"
  ]
}
```

Required update — add two new pages in logical order (get, add, update):
```json
{
  "group": "CRDT",
  "pages": [
    "api-reference/rest-apis/v2/crdt/get-crdt-data",
    "api-reference/rest-apis/v2/crdt/add-crdt-data",
    "api-reference/rest-apis/v2/crdt/update-crdt-data"
  ]
}
```

## Areas NOT Requiring Updates

- **Data Models** (`data-models.mdx`): These are REST endpoints with no new SDK types or TypeScript interfaces.
- **API Methods** (`api-methods.mdx`): These are REST endpoints, not SDK hooks or methods.
- **UI Customization**: No wireframe or component changes.
- **Migration Guide**: No breaking changes.
- **CRDT feature setup docs** (`realtime-collaboration/crdt/setup/`): No changes to SDK-level usage.

## Implementation Sequence

1. Create `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/crdt/add-crdt-data.mdx` — model on `get-crdt-data.mdx` (High priority, no dependencies)
2. Create `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/crdt/update-crdt-data.mdx` — model on `add-crdt-data.mdx`, adjust intro and endpoint URL (High priority, no dependencies)
3. Update `docs.json` CRDT group to include both new pages in order: get, add, update (High priority, depends on files existing to validate paths)

## Key Patterns from `get-crdt-data.mdx` to Replicate

- Use `<ParamField header="...">` for header params
- Use `<ParamField body="data" type="object" required>` wrapping `<Expandable title="properties">` for nested body params
- Auth token param links to `/security/auth-tokens`
- Feature context links to `/realtime-collaboration/crdt/setup/core`
- `## Example Request` uses fenced `JSON` code block
- `## Success Response` and `## Error Response` subsections under `# Response`
- Closing `<ResponseExample>` block with JSON repeating success response
- No `<Tabs>` blocks — REST API docs do not use React/Other Frameworks tabs

## Quality Checklist

- [ ] `add-crdt-data.mdx` created at correct path
- [ ] `update-crdt-data.mdx` created at correct path
- [ ] Both files use same header params as `get-crdt-data.mdx`
- [ ] Both files document all 6 body params (organizationId, documentId, editorId, data, type, contentKey)
- [ ] `contentKey` marked as optional in both files
- [ ] `type` enum values listed: `text`, `map`, `array`, `xml`
- [ ] `docs.json` CRDT group updated with both new page paths
- [ ] Page order in `docs.json` is: get, add, update
- [ ] Release note links (`/api-reference/rest-apis/v2/crdt/add-crdt-data` and `/api-reference/rest-apis/v2/crdt/update-crdt-data`) resolve to the new files
- [ ] No SDK data models or API methods pages modified
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.0-crdt.md`
