# Release Update Plan for 5.0.2-beta.1

## Overview
- Release Type: Minor (new feature + bug fix)
- Key Changes: Comment dialog visibility dropdown lets users set public/private visibility before submitting a comment
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes: Add `VisibilityOptionClickedEvent` type after `CommentSavedEvent` (line ~89). Fields: `annotationId: string` (required), `commentAnnotation: CommentAnnotation` (required), `visibility: string` (required), `metadata?: VeltEventMetadata` (optional).
- Priority: High

### 2. API Methods
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Changes: Add `enableVisibilityOptionDropdown()` and `disableVisibilityOptionDropdown()` under the existing `### UI` section (around line 1010) or adjacent to `enablePrivateMode()` / `disablePrivateMode()` entries (lines 145–157). Each entry follows the standard pattern: one-line description, Params, Returns, React Hook, Full Documentation link pointing to `/async-collaboration/comments/customize-behavior#enablevisibilityoptiondropdown`.
- Priority: High

### 3. Documentation — Customize Behavior
- File: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
- Changes: Add new `#### enableVisibilityOptionDropdown` and `#### disableVisibilityOptionDropdown` sections under `# Private Comments` (after `disablePrivateMode` at line ~2718), including the `visibilityOptionDropdown` prop, both API methods with React/Other Frameworks tabs, and the `visibilityOptionClicked` event subscription using `useCommentEventCallback`. Use anchor IDs `#enablevisibilityoptiondropdown`, `#disablevisibilityoptiondropdown`, `#visibilityoptionclicked`.
- Priority: High

### 4. UI Customization — Comment Dialog Wireframe
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`
- Changes: Add `### Visibility Dropdown (Composer)` section after the `### Assign User (Composer)` section (around line 3582). Document the following wireframe components using the same `#### Component / ##### Subcomponent` pattern as `Priority` and `Status`:
  - `VeltCommentDialogWireframe.VisibilityDropdown` (root; HTML: `velt-comment-dialog-visibility-dropdown-wireframe`)
  - `VeltCommentDialogWireframe.VisibilityDropdown.Trigger` (HTML: `velt-comment-dialog-visibility-dropdown-trigger-wireframe`)
    - `.Trigger.Label` (HTML: `velt-comment-dialog-visibility-dropdown-trigger-label-wireframe`)
    - `.Trigger.Icon` (HTML: `velt-comment-dialog-visibility-dropdown-trigger-icon-wireframe`)
  - `VeltCommentDialogWireframe.VisibilityDropdown.Content` (HTML: `velt-comment-dialog-visibility-dropdown-content-wireframe`)
    - `.Content.Public` (HTML: `velt-comment-dialog-visibility-dropdown-content-public-wireframe`)
    - `.Content.Private` (HTML: `velt-comment-dialog-visibility-dropdown-content-private-wireframe`)
  - Template variables: `selectedVisibility`, `visibilityOptionDropdown`
  - No image assets exist yet; use placeholder `<Frame>` blocks without `src` or note "image pending".
- Priority: High

## Implementation Sequence
1. Add `VisibilityOptionClickedEvent` to `data-models.mdx` (no dependencies)
2. Add `enableVisibilityOptionDropdown()` / `disableVisibilityOptionDropdown()` to `api-methods.mdx` (depends on data-models anchor existing)
3. Add full feature docs (prop, methods, event) to `customize-behavior.mdx` (depends on api-methods anchors for cross-links)
4. Add wireframe components to `comment-dialog-components.mdx` (independent of steps 1–3)

## Quality Checklist
- [ ] `VisibilityOptionClickedEvent` added to data-models.mdx with all four fields
- [ ] `enableVisibilityOptionDropdown()` and `disableVisibilityOptionDropdown()` added to api-methods.mdx with correct anchor links
- [ ] `visibilityOptionDropdown` prop, both API methods, and `visibilityOptionClicked` event documented in customize-behavior.mdx under `# Private Comments`
- [ ] Wireframe section added to comment-dialog-components.mdx with all 7 sub-components in both React and Other Frameworks tabs
- [ ] All cross-links verified (data-models ↔ api-methods ↔ customize-behavior)
- [ ] Bug fix (Comments Sidebar "This Page" indicator) not documented — internal fix, no API change, correctly excluded
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.1.md`
