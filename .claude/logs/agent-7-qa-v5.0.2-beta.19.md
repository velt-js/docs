## QA Summary for v5.0.2-beta.19

### Issues Found: 3

1. **comment-dialog-structure.mdx** — Agent-6 placed `Download` under `Composer.Attachments.Selected.Image` and `Composer.Attachments.Selected.Other` (the pre-existing hierarchy). The correct paths per the release note and wireframes.mdx (Agent-4) are `VeltCommentDialogWireframe.Composer.Attachments.Image.Download` and `VeltCommentDialogWireframe.Composer.Attachments.Other.Download` — direct children of `Attachments`, siblings to `Selected` and `Invalid`, not nested inside `Selected`.
   - Fix: Removed `.Download` from `.Selected.Image` and `.Selected.Other` bullet lists. Added `Composer.Attachments.Image.Download` and `Composer.Attachments.Other.Download` as direct children of `Composer.Attachments` in the React section.

2. **comment-dialog-structure.mdx (HTML section)** — The two new HTML wireframe tags `velt-comment-dialog-composer-attachments-image-download-wireframe` and `velt-comment-dialog-composer-attachments-other-download-wireframe` were entirely absent from the HTML component tree under `velt-comment-dialog-composer-attachments-wireframe`.
   - Fix: Added both as direct children of `velt-comment-dialog-composer-attachments-wireframe` (leaf nodes), mirroring the React section and the wireframes.mdx code examples.

3. **confirm-dialog.mdx** — The `type` prop and CSS modifier class documentation mentioned `type` in prose without linking to `ConfirmDialogComponentConfig` in data-models.mdx.
   - Fix: Added inline link `[ConfirmDialogComponentConfig](/api-reference/sdk/models/data-models#confirmdialogcomponentconfig)` on the `type` prop reference line.

### Structural Concern Resolution

**Verdict: Agent-6 used the wrong parent path. Agent-4 (wireframes.mdx) is correct.**

Evidence:
- `git show HEAD~1` confirms `.Selected.Image` and `.Selected.Other` never contained a `.Download` child before this release.
- The release note primitive names (`VeltCommentDialogComposerAttachmentsImageDownload`, `velt-comment-dialog-composer-attachments-image-download`) contain no "selected" segment.
- wireframes.mdx places `Image.Download` and `Other.Download` as siblings to `Selected` inside the `Attachments` block — consistent with them being top-level slots that live outside the selected-item container.
- Both fixes applied to comment-dialog-structure.mdx bring it into alignment with wireframes.mdx.

### Scan Results — No Additional Issues Found

- No missing-plural forms (`VeltCommentDialogComposerAttachmentImage` without `s`): clean
- No underscore forms (`edit_placeholder`): clean
- No kebab-case in React tabs or camelCase in HTML tabs for edit placeholder props: clean
- `ConfirmDialogComponentConfig` definition present and correct in data-models.mdx
- `velt-confirm-dialog--comment` / `velt-confirm-dialog--reply` / `velt-confirm-dialog--{type}` consistent across confirm-dialog.mdx and styling.mdx
- `@veltdev/react` import module name: no crossover issues found
- `inline-comments.mdx` uses `edit-placeholder` (kebab) in an HTML-only context: correct

### Summary

- Files corrected: 2
- Issues fixed: 3 (1 wrong React path placement, 1 missing HTML tags, 1 missing prose link)
- Critical issues: 2 (structural mismatch between Agent-4 and Agent-6; missing HTML entries)
- Terminology inconsistencies: 0
- Outstanding issues for user review: 0
