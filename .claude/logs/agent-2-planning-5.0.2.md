# Release Update Plan for 5.0.2 (core SDK, stable)

## Overview
- Release Type: Patch (stable promotion of `5.0.2-beta.38` → `5.0.2`).
- Key Changes: One user-facing bug fix — "Hide replies" now fully collapses an inline thread back to its first-comment teaser (was leaving first + last + divider). Plus version-bump-only changes (`@veltdev/types` dep + internal version constant; no functional React-only changes).
- Breaking Changes: No. Backward compatible.

## Areas Requiring Updates

### 1. Data Models (`api-reference/sdk/models/data-models.mdx`)
- Decision: SKIP.
- Reason: No new/changed types, interfaces, or enums. Bug fix only adjusts internal runtime behavior.
- Verified: No diff at HEAD; nothing in the changelog entry introduces a type.

### 2. API Methods (`api-reference/sdk/api/api-methods.mdx`)
- Decision: SKIP.
- Reason: No new/changed public SDK methods. `toggleHideReply()` / `toggleShowReplies()` / `toggleAnnotationSelection()` are internal component methods, not public SDK API.
- Verified: No diff at HEAD.

### 3. Wireframe Variables (`ui-customization/.../comment-dialog/wireframe-variables.mdx`)
- Decision: SKIP.
- Reason: Pages document the CORRECT teaser behavior, not the buggy partial-expanded state. Checked:
  - `collapsedRepliesPreview` (line 149, 180-188): describes teaser = first comment + "Show N replies…" divider + last comment. Consistent with fix.
  - `comment-dialog-hide-reply` (lines 1465-1476): documents the link's `shouldShow` visibility (`!collapsedComments AND isDialogSelected AND annotation.comments.length > 1`) — visibility only, says nothing about post-click collapse outcome. Bug fix changes the click *handler*, not this visibility formula.
  - `comment-dialog-more-reply` `shouldShow` (lines 1480-1491): `(isDialogSelected OR collapsedRepliesPreview) AND !showAllComments AND annotation.comments.length > 2`. Unchanged by the fix — the fix makes the runtime correctly re-reach this already-documented teaser state by deselecting the annotation.
- No documented formula or wording describes the buggy behavior; no edit required.

### 4. Comments customize-behavior (`async-collaboration/comments/customize-behavior.mdx`)
- Decision: SKIP.
- Reason: `collapsedRepliesPreview` section (line 7827) describes the non-selected *preview* teaser, not "Hide replies" collapse behavior. No buggy behavior documented; nothing to correct.

### 4a. UI Customization — Wireframes (`comment-dialog/wireframes.mdx`)
- Decision: N/A.
- Reason: No new wireframes. Existing "Hide Reply (Body)" entry (line 3278) is a generic component description ("button to hide replies"); no buggy behavior text.

### 4b. UI Customization — Primitives (`comment-dialog/primitives.mdx`)
- Decision: N/A.
- Reason: No new primitives or props. Existing `VeltCommentDialogHideReply` (line 4147) is generic; no behavioral claim to amend.

### 5. Upgrade Guide (`release-notes/version-5/upgrade-guide.mdx`)
- Decision: N/A.
- Reason: Backward-compatible bug fix + version bump. No breaking changes, no migration steps.

### docs.json
- Decision: N/A. No nav/structure change.

## Real Edits Found
- None beyond the changelog (already done by Agent-1). This is a "changelog only" release.

## Implementation Sequence
1. None. No downstream doc edits required.
2. Agent-3/4/5/6 may verify-and-pass; no file changes expected.

## Quality Checklist
- [x] Analyzed Agent-1 changelog entry for v5.0.2 stable.
- [x] data-models.mdx: no new types — SKIP (verified, no diff).
- [x] api-methods.mdx: no new/changed public methods — SKIP (verified, no diff).
- [x] wireframe-variables.mdx: read teaser / hide-reply / more-reply sections — document correct behavior, not the bug — SKIP.
- [x] customize-behavior.mdx: `collapsedRepliesPreview` describes preview teaser, not buggy collapse — SKIP.
- [x] Wireframes / Primitives: no new components or props — N/A.
- [x] Breaking changes: none — upgrade-guide N/A (no breaking change added to changelog).
- [x] Log file written to `.claude/logs/agent-2-planning-5.0.2.md`.
