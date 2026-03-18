## QA Summary for v5.0.2-beta.7

### Issues Found: 1

1. **`displayMessageTemplate` syntax inconsistency** — REST API files used `{variable}` (single brace) while the SDK data models, customize-behavior docs, and changelog SDK code all use `{{variable}}` (double brace).
   - Files affected: `add-activities.mdx`, `update-activities.mdx`, `get-activities.mdx`, `sdk-changelog.mdx`
   - Fix: Updated param descriptions and all example JSON values from `{variable}` → `{{variable}}` to match the canonical syntax defined in `data-models.mdx`.

### Files Corrected: 4

- `/api-reference/rest-apis/v2/activities/add-activities.mdx` — param description + 2 example values
- `/api-reference/rest-apis/v2/activities/update-activities.mdx` — param description + 2 example values
- `/api-reference/rest-apis/v2/activities/get-activities.mdx` — 2 response example values
- `/release-notes/version-5/sdk-changelog.mdx` — 1 REST API example value

### Items Verified (No Changes Needed)

- `activityServiceConfig` note: correctly scoped to `add-activities.mdx` and `setup.mdx` only (not get/update/delete)
- `triggerActivities` field: present in `add-comment-annotations.mdx` param definition and example; consistent with changelog
- `docs.json` navigation: Activities group at correct location under v2 REST APIs with all 4 endpoints
- Cross-reference links: `overview.mdx` → `/api-reference/rest-apis/v2/activities/get-activities` resolves; `setup.mdx` → `/api-reference/rest-apis/v2/activities/add-activities` resolves
- `[Activity Service API Reference →]` link in changelog resolves to get-activities
- `#activity` anchor in `api-methods.mdx` resolves (created by `# Activity` heading at line 1728)
- SDK changelog code block: `apiKey` at body top-level is an acceptable simplification for release notes context
- `commentData` field name in changelog code block: correct (not `comments`)
- `removeCommentTextTrigger` and `removeCommentTextSdktestTrigger`: documented as disabled in Bug Fixes section, no cross-references to update
- "Activity Service" capitalization: consistent across all files
- `activityServiceConfig` camelCase: consistent across all files
- `triggerActivities` camelCase: consistent across all files
- No remaining TODO comments or placeholder links in activity-related files

### Summary

- Files corrected: 4
- Critical issues: 1 (`{{variable}}` vs `{variable}` syntax mismatch across REST API files)
- Terminology alignments: 0 (all other terms consistent)
- Broken links: 0
