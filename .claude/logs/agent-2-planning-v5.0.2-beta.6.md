# Release Update Plan for v5.0.2-beta.6

## Overview
- Release Type: Patch
- Key Changes: 7 Comments bug fixes (sidebar filter session restore, DOM filter sync, mergeClientFilters null handling, autocomplete hotkey dedup, autocomplete Shadow DOM cursor tracking, @mention prefix replacement, multi-thread DOM filtering)
- Breaking Changes: No

## Decision: No Documentation Updates Required

All 7 items are internal implementation fixes with no new public API surfaces. Specifically:

- `commentSidebarFilters$` — internal RxJS stream, not a public API
- `effectiveSidebarFilters$` — new internal stream in `CommentService`, not exposed publicly
- `mergeClientFilters` — internal utility function, not a public API
- `getSelectionFromElement()` — new private helper in `AutocompleteToolComponent`, not exported
- `addFilterCommentsOnDomCheck: true` — internal parameter change inside `CommentsContainerComponent`, not a public prop
- `getAllMultiThreadCommentAnnotations` — internal method call, no change to its public signature
- `isHotkeyAlreadyAtCursor()` — internal guard method, not a public API

**Grep check result**: None of these symbols appear in any `.mdx` documentation file outside of the release note itself.

## Areas Requiring Updates

None. Criteria for flagging updates:
- New types/interfaces/parameters added to public API: No
- Existing API signatures changed: No
- New feature without existing documentation: No
- Breaking changes requiring migration guidance: No

## Implementation Sequence

No tasks required for Agent-3, Agent-4, or Agent-5.

## Quality Checklist
- [x] Analyzed release note from Agent-1
- [x] Confirmed all 7 items are internal bug fixes with no public API surface
- [x] Grep verified: no documentation files reference any of the internal symbols
- [x] No updates needed to `data-models.mdx`
- [x] No updates needed to `api-methods.mdx`
- [x] No new documentation pages needed
- [x] No UI customization wireframe updates needed
- [x] No migration guide entries needed (no breaking changes)
- [x] Log file written to `.claude/logs/agent-2-planning-v5.0.2-beta.6.md`
