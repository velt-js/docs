## QA Summary for v5.0.2-beta.25

### Issues Found: 3

1. **ui-customization/features/async/comments/comment-bubble/wireframe-variables.mdx** (line 51) — `annotation.iam.accessMode` row described as the sole privacy check with no mention that `visibilityConfig` (`restricted`, `organizationPrivate`) also represents private state; usage example `velt-if="{annotation.iam.accessMode} === 'private'"` would silently miss V2-style private annotations.
   - Fix: Added note to Description column that `isAnnotationPrivate` should be used for a complete check covering both legacy and `visibilityConfig` privacy.

2. **ui-customization/features/async/comments/comment-bubble/wireframe-variables.mdx** (line 250) — `<velt-comment-pin-private-comment-indicator-wireframe>` usage example similarly only shows `iam.accessMode` check, no mention of `visibilityConfig` alternative.
   - Fix: Added note to Description column pointing to `velt-if="{isAnnotationPrivate}"` for V2 privacy annotations.

3. **async-collaboration/comments-sidebar/customize-behavior.mdx** (line 226) — `setCommentSidebarData()` dual-gate bullet stated draft annotations "bypass both gates" — contradicts the spec (planning doc items 4 and 5) and the matching note in `comments/customize-behavior.mdx` which correctly says drafts bypass only "the id-list gate."
   - Fix: Corrected to "bypass the id-list gate."

### Verified Consistent (no changes needed)

- `CommentAccessMode` type + `accessModes` field added to `data-models.mdx` — present and correctly linked.
- `setCommentSidebarFilters()` params in `api-methods.mdx` — links to `CommentSidebarFilters` data model; no inline expansion.
- `getCustomSidebarDataAnnotationIds()` and `getCustomSidebarDataAnnotationIds$()` added to `api-methods.mdx` with `<Note>Advanced / internal</Note>` — present.
- `accessModes` code examples in `comments-sidebar/customize-behavior.mdx` — both React and Other Frameworks tabs present with correct note and `CommentAccessMode` link.
- `setCommentSidebarData()` dedup + filter-count + dual-gate notes in sidebar customize-behavior — present.
- `filterCommentsOnDom` dual-gate AND note in `comments/customize-behavior.mdx` line 6308 — present and consistent with spec.
- Smooth-scroll note in `comments/customize-behavior.mdx` — present (Divi auto-detection + Lenis/GSAP/Locomotive contact-support note).
- `isDefault` per-iteration alias in notifications-panel wireframe-variables — present.
- `reaction` alias in reactions wireframe-variables — present at line 78.
- `filteredComments` / `sortedComments` in inline-comments-section wireframe-variables — present with data-model links.
- `globalConfigSignal.*` V1/V2 availability note in comment-bubble wireframe-variables — present at line 78.
- `VeltCommentDialogPrivateBanner` suppression note in primitives — present at line 2962.
- Make Private / Make Public `visibilityConfig` + suppression notes in primitives — present at lines 1712, 1739, 1766.
- All `iam.accessMode` prose references outside usage-example columns include `visibilityConfig` context — confirmed.
- No `CommentAccessMode` or `accessModes` stale references found in other docs paths.

### Summary

- Files corrected: 1 (`comment-bubble/wireframe-variables.mdx` — 2 rows, `comments-sidebar/customize-behavior.mdx` — 1 bullet)
- Critical issues: 0
- Correctness fixes: 1 (draft-gate scope contradiction)
- Terminology/coverage alignments: 2 (legacy-only privacy check in wireframe variable table)
