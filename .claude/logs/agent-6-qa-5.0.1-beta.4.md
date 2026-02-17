## QA Summary for v5.0.1-beta.4

### Issues Found: 1

1. **release-notes/version-4/sdk-changelog.mdx** — The entire `5.0.1-beta.4` `<Update>` block (lines 12–133) was duplicated into the v4 changelog file instead of being exclusive to the v5 changelog. This would cause the v5 breaking change and new feature entries to appear under the v4 SDK changelog, misleading users on version scope.
   - Fix: Removed the `<Update label="5.0.1-beta.4" ...>` block (122 lines) from `version-4/sdk-changelog.mdx`. The entry already exists correctly in `version-5/sdk-changelog.mdx`.

### Verified Clean (no changes needed)

- **api-reference/sdk/models/data-models.mdx** — `CommentVisibilityType` updated to `'public' | 'organizationPrivate' | 'restricted'`; `CommentVisibilityConfig` table rows updated; `PrivateModeConfig` type alias present; `CommentSavedEvent` table present with correct anchor `#commentsavedevent`.
- **api-reference/sdk/api/api-methods.mdx** — `enablePrivateMode()` and `disablePrivateMode()` entries present with correct format (brief description, params linked to data models, returns, hook, full doc link). `updateVisibility()` description uses new value names.
- **async-collaboration/comments/customize-behavior.mdx** — `updateVisibility` section uses `'organizationPrivate'` and `'restricted'` in all 6 call sites and prose; `enablePrivateMode` and `disablePrivateMode` subsections present with React/Other Frameworks tabs; `commentSaved` row in event table linked to `CommentSavedEvent`; `commentSaved` subsection with code tabs present.
- **release-notes/version-5/upgrade-guide.mdx** — Breaking change entry for `CommentVisibilityType` rename present; Before/After tabs use old values in Before and new values in After (correct).
- **release-notes/version-5/sdk-changelog.mdx** — `5.0.1-beta.4` block present and correct; historical `5.0.0-beta.8` entry uses `organizationPrivate` and `restricted` (correctly updated by prior agents).
- **key-concepts/overview.mdx** — `type: 'organization'` at line 1384 is a resource permission type (not `CommentVisibilityType`); no change needed.
- **get-started/advanced.mdx** — `type: 'organization'` at line 236 is a resource permission type; no change needed.
- **snippets/comments-methods-json.mdx** — `enablePrivateMode` / `disablePrivateMode` absent (not yet registered); `enablePrivateCommentMode` present as V4 method — correct.
- **All other doc sections** — Zero occurrences of new terms (`CommentVisibilityType`, `PrivateModeConfig`, `CommentSavedEvent`, `enablePrivateMode`, `disablePrivateMode`, `commentSaved`, `organizationPrivate`) found outside the 5 expected files plus key-concepts/overview.mdx (resource type context).

### Search/Replace Performed

- None beyond the removal of the duplicated `<Update>` block. No repo-wide renames were needed — terminology was already consistent across all in-scope files.

### Summary

- Files corrected: 1 (`release-notes/version-4/sdk-changelog.mdx`)
- Critical issues: 1 (v5 entry duplicated into v4 changelog)
- Terminology alignments: 0 (prior agents completed all renames correctly)
- Exclusions respected: `type: 'organization'` and `type: 'self'` preserved in all Before-migration examples and all non-`CommentVisibilityType` resource permission contexts
