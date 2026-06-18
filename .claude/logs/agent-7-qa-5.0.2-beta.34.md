# QA Summary for v5.0.2-beta.34

## Scope
Repo-wide rename of 26 React sub-component exports `VeltCommentsSidebarV2*` → `VeltCommentSidebarV2*`. Source of truth: Before/After table in release-notes/version-5/upgrade-guide.mdx (beta.34 entry). Release-notes files excluded (historical + Before column preserved).

## Files Changed: 1

1. **ui-customization/features/async/comments/comment-sidebar/comment-sidebar-v2-primitives.mdx** — 133 replacements across all 26 sub-component names (exact word-boundary match, longest-first). Per-name counts: MinimalActionsDropdownContentMarkAllResolved 5, MinimalActionsDropdownContentMarkAllRead 5, FilterDropdownContentListCategoryContent 5, FilterDropdownContentListItemIndicator 5, FilterDropdownContentListItemLabel 5, FilterDropdownContentListCategory 7, MinimalActionsDropdownContent 6, MinimalActionsDropdownTrigger 4, FilterDropdownContentListItem 7, FocusedThreadDialogContainer 4, FilterDropdownContentList 7, FocusedThreadBackButton 4, MinimalActionsDropdown 5, FilterDropdownContent 6, FilterDropdownTrigger 4, PageModeComposer 5, ResetFilterButton 4, EmptyPlaceholder 6, FilterDropdown 5, FocusedThread 6, CloseButton 4, Skeleton 4, ListItem 3, Header 6, Panel 6, List 5.

## Files Reviewed, No Changes Needed (Agent-2 over-scope correction)

- **comment-sidebar-v2-wireframes.mdx** (~76 occ.) — all tokens are `VeltCommentsSidebarV2Wireframe` (Wireframe-suffixed, out of release-note scope). FLAGGED, not renamed.
- **comment-sidebar-structure-v2.mdx** (~27 occ.) — same: only `VeltCommentsSidebarV2Wireframe`. FLAGGED, not renamed.
- **async-collaboration/comments-sidebar/setup.mdx** — 3 root + 1 `VeltCommentsSidebarV2Props`; root/Props keep the 's'.
- **async-collaboration/comments-sidebar/customize-behavior.mdx** — 1 `VeltCommentsSidebarV2Props` only.
- **api-reference/sdk/models/data-models.mdx** — 1 `VeltCommentsSidebarV2Props` only.

## Verification (exact name-string diff, not counts)

- New-name set in primitives file vs upgrade-guide After column: 26 vs 26, sets identical (diff clean).
- Old sub-component names remaining repo-wide (excl. release-notes, .claude, .pipeline-scratch): **0** for all 26 names. Only survivors of the `VeltCommentsSidebarV2` prefix are `...Props` (4, correct) and `...Wireframe` (flagged, correct).
- Root `VeltCommentsSidebarV2` exact occurrences: primitives.mdx 7 before / 7 after; setup.mdx 3 before / 3 after (file untouched). Equal — root preserved.
- Kebab-case HTML element names (`velt-comments-sidebar-v2-*`): token multiset identical across diff minus/plus sides — unchanged.
- Changed diff lines not containing the rename: 0 (no collateral edits).
- No stragglers found outside the allowed paths.

## Summary
- Files corrected: 1 (133 exact-name replacements)
- Flagged (out of scope): `VeltCommentsSidebarV2Wireframe` in wireframes + structure-v2 pages (103 occ.)
- Root component, Props type, kebab-case elements, release-notes: all untouched
- Ready for Plugin Agent 1 / next release note (Agent-1)
