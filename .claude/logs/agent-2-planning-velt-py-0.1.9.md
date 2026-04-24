# Release Update Plan for velt-py v0.1.9

## Overview
- Release Type: Minor (new feature, no breaking changes to existing APIs)
- Key Changes: 17 new `sdk.api.*` REST services + typed request dataclasses + new error classes + env var support
- Breaking Changes: No — existing `sdk.selfHosting.*` is unchanged

## Areas Requiring Updates

### 1. Data Models — SKIP
Python dataclasses (`velt_py.models.*`) must NOT be added to `/api-reference/sdk/models/data-models.mdx`. Document them inline on the Python SDK page only.

### 2. API Methods — SKIP
`/api-reference/sdk/` covers the Web/React SDK. Python-only services must NOT be added there.

### 3. Primary Documentation: `/Users/yoenzhang/Downloads/docs/backend-sdks/python.mdx`
- File: `/Users/yoenzhang/Downloads/docs/backend-sdks/python.mdx`
- Changes: Add a new top-level `# REST API Backend` section after the existing self-hosting content (before the `# Request Types` section at line 715). Sub-sections:
  - `## Overview` — brief intro: `sdk.api.*` namespace, REST-only init (no MongoDB required), `apiKey`/`authToken` config, env vars
  - `## Initialization` — code block showing REST-only init (database key omitted; `apiKey` + `authToken` from env or config)
  - `## Error Handling` — `VeltSDKError`, `VeltValidationError`, `VeltTokenError`, `VeltApiError` from `velt_py.exceptions`; import snippet + try/except example
  - `## Services` — one `###` per service (17 total), each containing: service name, method table (method name + description), one representative Python code snippet with `@dataclass` import + call + response handling
  - `## Request Dataclasses` — import reference table mapping each service to its `velt_py.models.*` module
- Priority: High

### 4. Navigation: `/Users/yoenzhang/Downloads/docs/docs.json`
- File: `/Users/yoenzhang/Downloads/docs/docs.json`
- Recommendation: **Option B** — split into two pages.
  - Rename existing page label to `"backend-sdks/python-self-hosting"` (file move needed)
  - Create new page `"backend-sdks/python-rest-api"`
  - Update `"group": "Backend SDKs"` pages array to list both:
    ```json
    "pages": [
      "backend-sdks/python-self-hosting",
      "backend-sdks/python-rest-api"
    ]
    ```
  - Reasoning: the current file is already 743 lines covering self-hosting only. Adding 17 services with code examples will push it past ~2,000 lines. Two focused pages (self-hosting vs REST API) are easier to navigate and link to from the REST API reference.
- Priority: High

### 5. Cross-references: REST API reference docs
- Files: all `api-reference/rest-apis/v2/` service overview pages (organizations, folders, documents, users, user-groups, comments-feature, activities, auth, crdt, gdpr, livestate, notifications, presence, recordings, rewriter, workspace)
- Changes: add a callout or footer note on each service's overview page pointing to the Python SDK REST API equivalent: "Use the [Velt Python SDK](/backend-sdks/python-rest-api) to call this endpoint from a Python backend."
- Priority: Medium (cross-link; non-blocking for the Python page itself)

### 6. Self-host-data overview cross-reference
- File: `/Users/yoenzhang/Downloads/docs/self-host-data/overview.mdx` (verify path exists)
- Changes: add a note that `velt-py` now also supports a REST API backend (not just self-hosting) with a link to the new page.
- Priority: Low

### 7. UI Customization / Wireframes / Primitives — N/A
This is a backend-only Python SDK release. No frontend components, wireframes, or primitives are affected.

### 8. Upgrade Guide — N/A
No breaking changes. The existing `sdk.selfHosting.*` API is unchanged.

## Implementation Sequence
1. **Split python.mdx into two files** — create `python-self-hosting.mdx` (move existing content) and `python-rest-api.mdx` (new REST API content). Update `docs.json` navigation to reference both.
2. **Write `python-rest-api.mdx`** — REST-only init section, env vars, error classes, 17 service sections with method tables and code snippets, request dataclass reference.
3. **Add cross-links to REST API v2 service pages** — one callout per service pointing to `python-rest-api.mdx`.
4. **Update self-host-data overview** — brief mention with link.

## Quality Checklist
- [ ] Python dataclasses documented inline on `python-rest-api.mdx`, not in `data-models.mdx`
- [ ] All 17 services have method tables and at least one code snippet
- [ ] REST-only init (no `database` key) is shown separately from the self-hosting init
- [ ] Error classes documented with import snippet and try/except pattern
- [ ] Env vars (`VELT_API_KEY`, `VELT_AUTH_TOKEN`, `VELT_WORKSPACE_ID`, `VELT_WORKSPACE_AUTH_TOKEN`) listed in the init/config section
- [ ] `docs.json` updated with both `python-self-hosting` and `python-rest-api` pages
- [ ] `token` service notes that it takes positional args, not a dataclass
- [ ] No breaking changes added to upgrade guide
- [ ] Log file written to `.claude/logs/agent-2-planning-velt-py-0.1.9.md`
