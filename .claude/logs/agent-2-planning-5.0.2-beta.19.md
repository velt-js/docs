# Release Update Plan for v5.0.2-beta.19

## Overview
- Release Type: Minor (beta patch)
- Key Changes: Edit-mode placeholder props (3 new props on 4 components), attachment download primitives (2 new primitives + wireframes), confirm dialog CSS type modifier
- Breaking Changes: No

---

## Areas Requiring Updates

### 1. Data Models
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes: Add `ConfirmDialogComponentConfig` interface (or add `type` field to existing confirm dialog config if present). New optional field: `type?: 'comment' | 'reply'`. SDK passes `'comment'` for delete-comment and `'reply'` for delete-reply flows.
- Priority: Medium
- Note: Grep confirms no existing `ConfirmDialog` or `ComponentConfig` entry in data-models.mdx — this is a net-new interface entry.

### 2. API Methods — Props on Comment Components
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Changes: Add three new props to the sections for `VeltComments`, `VeltCommentDialog`, `VeltCommentsSidebar`, `VeltInlineCommentsSection`:
  - `editPlaceholder` / `edit-placeholder` — generic fallback text when editing any comment
  - `editCommentPlaceholder` / `edit-comment-placeholder` — placeholder when editing the first comment in a thread
  - `editReplyPlaceholder` / `edit-reply-placeholder` — placeholder when editing a reply (index > 0)
  - Priority order: `editCommentPlaceholder` / `editReplyPlaceholder` > `editPlaceholder` > existing `placeholder` > SDK defaults
- Priority: High
- Note: Existing `placeholder` prop already documented at line 672. New props slot alongside it.

### 3. UI Customization — Wireframes
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog/wireframes.mdx`
- Changes: Add two new sub-sections under the existing **Attachments (Composer)** section (around line 3326). The existing tree only has `Selected` and `Invalid` children. Add:
  - `#### Image (Composer Attachments)` — wireframe: `VeltCommentDialogWireframe.Composer.Attachments.Image` / `velt-comment-dialog-composer-attachments-image-wireframe`
  - `#### Other (Composer Attachments)` — wireframe: `VeltCommentDialogWireframe.Composer.Attachments.Other` / `velt-comment-dialog-composer-attachments-other-wireframe`
  - Each contains a `.Download` leaf node:
    - `VeltCommentDialogWireframe.Composer.Attachments.Image.Download` / `velt-comment-dialog-composer-attachments-image-download-wireframe`
    - `VeltCommentDialogWireframe.Composer.Attachments.Other.Download` / `velt-comment-dialog-composer-attachments-other-download-wireframe`
  - Follow the heading convention used for the ThreadCard equivalents at lines 2316–2338 (full parent path in heading, bold h5 for leaf)
  - Update the parent `### Attachments (Composer)` overview code block to include `.Image` and `.Other` alongside `.Selected` and `.Invalid`
- Priority: High

### 4. UI Customization — Primitives
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog/primitives.mdx`
- Changes: Add two new primitive entries after `VeltCommentDialogComposerFiles` (line 925):
  - `### VeltCommentDialogComposerAttachmentsImageDownload` — HTML: `velt-comment-dialog-composer-attachments-image-download` — Button to download an image attachment from the composer
  - `### VeltCommentDialogComposerAttachmentsOtherDownload` — HTML: `velt-comment-dialog-composer-attachments-other-download` — Button to download a non-image attachment from the composer
  - Follow the same pattern as adjacent primitives (annotationId prop, common inputs reference, React + Other Frameworks tabs)
- Priority: High

### 5. Confirm Dialog — CSS Class Documentation
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/confirm-dialog.mdx`
- Changes: Add a CSS customization note explaining the type-based modifier classes:
  - Root element always carries `velt-confirm-dialog`
  - When deleting a comment: also carries `velt-confirm-dialog--comment`
  - When deleting a reply: also carries `velt-confirm-dialog--reply`
  - Example: `target velt-confirm-dialog--comment { ... }` to style delete-comment dialog differently from delete-reply
- Priority: Medium

---

## Implementation Sequence
1. **data-models.mdx** — Add `ConfirmDialogComponentConfig` interface (no dependencies)
2. **api-methods.mdx** — Add `editPlaceholder`, `editCommentPlaceholder`, `editReplyPlaceholder` props to 4 components (no dependencies)
3. **wireframes.mdx** — Add Image and Other download sub-sections under Composer Attachments (no dependencies)
4. **primitives.mdx** — Add `VeltCommentDialogComposerAttachmentsImageDownload` and `VeltCommentDialogComposerAttachmentsOtherDownload` entries (no dependencies)
5. **confirm-dialog.mdx** — Add CSS modifier class documentation (no dependencies)

---

## Quality Checklist
- [ ] `ConfirmDialogComponentConfig` with `type?: 'comment' | 'reply'` added to data-models.mdx
- [ ] Three edit placeholder props documented on all four components in api-methods.mdx
- [ ] Priority order of placeholder props documented
- [ ] Wireframe `Image` and `Other` nodes added under `Composer Attachments` with `.Download` leaf
- [ ] Parent `Attachments (Composer)` overview block updated to show `.Image` and `.Other`
- [ ] Two new download primitives added to primitives.mdx after `VeltCommentDialogComposerFiles`
- [ ] CSS modifier classes `velt-confirm-dialog--comment` / `velt-confirm-dialog--reply` documented in confirm-dialog.mdx
- [ ] Code examples use React / Next.js + Other Frameworks tabs
- [ ] Wireframe headings follow full parent path convention (per feedback_wireframe_heading_conventions)
- [ ] No breaking changes — upgrade-guide.mdx not needed
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.19.md`
