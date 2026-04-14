# Release Update Plan for April 8, 2026

## Overview
- Release Type: Minor (new REST endpoints + internal agent improvements)
- Key Changes: 4 new V2 REST workspace endpoints; Stagehand agent enhancements; defaultValue for userContextFields
- Breaking Changes: No

## Areas Requiring Updates

### 1. REST API Reference — New Workspace Endpoint Pages (HIGH PRIORITY)

Four new MDX files must be created under the existing REST API workspace directory:

- `api-reference/rest-apis/v2/workspace/create.mdx` — `POST /v2/workspace/create`
- `api-reference/rest-apis/v2/workspace/get.mdx` — `POST /v2/workspace/get`
- `api-reference/rest-apis/v2/workspace/email-status.mdx` — `POST /v2/workspace/email/status`
- `api-reference/rest-apis/v2/workspace/send-login-link.mdx` — `POST /v2/workspace/email/send-login-link`

Pattern to follow: `api-reference/rest-apis/v2/workspace/add-domain.mdx` (frontmatter `api:` field, Headers section with `x-velt-api-key` + `x-velt-auth-token`, Body Params section, Example Request/Response, `<ResponseExample>` block).

Security notes to include on public endpoints:
- IP-based rate limiting applied
- Disposable email domain blocking applied

**Do NOT add these to `api-methods.mdx`** — that file covers client SDK methods only.

Priority: High

### 2. Changelog Link Fix

The release note at `release-notes/version-5/sdk-changelog.mdx` contains a placeholder link:

```
[Learn more →](<!-- TODO: confirm link target for this doc -->#TODO-confirm-doc-link)
```

Once the four endpoint pages are created, replace this with the correct path. Suggested link target: `/api-reference/rest-apis/v2/workspace/create` (or a workspace overview page if one is created).

Priority: High — must be resolved after endpoint pages exist.

### 3. Data Models — No Update Needed

No new client-side types or interfaces introduced. Internal agent config changes (Firestore-driven aiConfig, deep merge for metadata) are backend-only and not exposed via the SDK.

### 4. API Methods — No Update Needed

No new SDK client methods or changed method signatures. Changes are REST endpoints and internal agent runtime behavior.

### 5. UI Customization — No Update Needed

No new components, primitives, or wireframes.

### 6. Upgrade Guide — No Update Needed

No breaking changes.

## Implementation Sequence

1. Create `api-reference/rest-apis/v2/workspace/create.mdx` following add-domain.mdx pattern.
2. Create `api-reference/rest-apis/v2/workspace/get.mdx`.
3. Create `api-reference/rest-apis/v2/workspace/email-status.mdx`.
4. Create `api-reference/rest-apis/v2/workspace/send-login-link.mdx`.
5. Fix the placeholder link in `release-notes/version-5/sdk-changelog.mdx` to point to the new create endpoint page.
6. Verify the new pages appear in the docs nav (check mint.json or docs.json for REST API workspace section entries).

## Quality Checklist
- [ ] 4 new REST endpoint pages created under `api-reference/rest-apis/v2/workspace/`
- [ ] Each page has correct `api:` frontmatter, Headers, Body, Example Request, Example Response, and `<ResponseExample>`
- [ ] Public endpoint pages note IP-based rate limiting and disposable email blocking
- [ ] Placeholder link in sdk-changelog.mdx resolved
- [ ] Nav config updated if required for new pages
- [ ] No changes made to `api-methods.mdx` or `data-models.mdx`
- [ ] Log file written to `.claude/logs/agent-2-planning-april-8-2026.md`
