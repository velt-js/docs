# Release Update Plan for v4.6.10

## Overview
- Release Type: Minor
- Key Changes: Read/unread status for comments, new wireframe components, context prop for sidebar
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models
- Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes: Add `unread` property to CommentAnnotation table
- Priority: High

**Details:**
Add new row to CommentAnnotation properties table (after line 41):
```
| `unread` | `boolean` | No | Whether the comment annotation is unread by current user |
```

### 2. UI Customization - Comment Dialog Structure
- Files: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-structure.mdx`
- Changes: Add MarkAsRead wireframe components for Options and ThreadCard.Options
- Priority: High

**Details:**

**Section A - Add to VeltCommentDialogWireframe.Options (after line 51):**
- Add child components for Options dropdown structure:
  - `VeltCommentDialogWireframe.Options.Trigger` (Leaf)
  - `VeltCommentDialogWireframe.Options.Content`
  - `VeltCommentDialogWireframe.Options.Content.Delete` (Leaf)
  - `VeltCommentDialogWireframe.Options.Content.MarkAsRead` (Leaf)

**Section B - Update ThreadCard.Options (at line 117):**
- Change from **(Leaf)** to expandable with children:
  - `VeltCommentDialogWireframe.ThreadCard.Options.Trigger` (Leaf)
  - `VeltCommentDialogWireframe.ThreadCard.Options.Content`
  - `VeltCommentDialogWireframe.ThreadCard.Options.Content.Delete` (Leaf)
  - `VeltCommentDialogWireframe.ThreadCard.Options.Content.Edit` (Leaf)
  - `VeltCommentDialogWireframe.ThreadCard.Options.Content.MarkAsRead` (Leaf)

**Section C - HTML mirror sections:**
- Update `velt-comment-dialog-options-wireframe` (around line 282)
- Update `velt-comment-dialog-thread-card-wireframe` for Options dropdown (around line 344)

### 3. UI Customization - Comment Dialog Components
- Files: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`
- Changes: Add documentation for Options and ThreadCard.Options subcomponents with MarkAsRead
- Priority: High

**Details:**

**Section A - Add "Options" section (after existing sections, before footer):**
- Overview with image showing Options dropdown
- Nested structure showing:
  - Options.Trigger
  - Options.Content with Delete and MarkAsRead children
- React and HTML examples with Tabs

**Section B - Add "Thread Card Options" section:**
- Overview with image showing thread-level options
- Nested structure showing:
  - ThreadCard.Options.Trigger
  - ThreadCard.Options.Content with Delete, Edit, and MarkAsRead children
- React and HTML examples with Tabs

### 4. UI Customization - Minimal Filter Dropdown
- Files: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comments-sidebar/subcomponents/header/subcomponents/minimal-filter-dropdown/overview.mdx`
- Changes: Add FilterOpen and FilterReset wireframe components to existing examples
- Priority: Medium

**Details:**
Update code examples (lines 22-52 for React, 60-96 for HTML):
- Add `FilterOpen` wireframe component in structure
- Add `FilterReset` wireframe component in structure
- Position after existing filter options, before closing tags

### 5. Comments Sidebar - Customize Behavior
- Files: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments-sidebar/customize-behavior.mdx`
- Changes: Add `context` prop documentation
- Priority: Medium

**Details:**
Add new section after existing props (verify insertion point with section headings):
- Heading: `#### context`
- Description: Pass custom context data to page mode composer comments
- Method signature showing prop type
- React and Other Frameworks tabs with code examples matching release note format

### 6. UI Customization - Styling Classes
- Files: `/Users/yoenzhang/Downloads/docs/ui-customization/styling.mdx`
- Changes: Add new CSS class names for read-only dialog and selected filter items
- Priority: Low

**Details:**
Add to CSS class reference table:
- `velt-comment-dialog--read-only`: Applied to read-only comment dialogs
- `velt-comment-sidebar-minimal-filter-content-item--selected`: Applied to selected items in minimal filter dropdown

## Implementation Sequence
1. Update data-models.mdx with unread property (5 min)
2. Update comment-dialog-structure.mdx with Options and ThreadCard.Options hierarchy (15 min)
3. Update comment-dialog-components.mdx with Options wireframe documentation (20 min)
4. Update minimal-filter-dropdown/overview.mdx with FilterOpen and FilterReset (10 min)
5. Update comments-sidebar/customize-behavior.mdx with context prop (10 min)
6. Update styling.mdx with new CSS classes (5 min)

Total Estimated Effort: 65 minutes

## Quality Checklist
- [ ] `unread` property added to CommentAnnotation in data-models.mdx
- [ ] Options dropdown structure documented in comment-dialog-structure.mdx
- [ ] ThreadCard.Options structure expanded in comment-dialog-structure.mdx
- [ ] MarkAsRead components documented in comment-dialog-components.mdx
- [ ] FilterOpen and FilterReset added to minimal-filter-dropdown/overview.mdx
- [ ] Context prop documented in comments-sidebar/customize-behavior.mdx
- [ ] New CSS classes added to styling.mdx
- [ ] All code examples use React / Next.js and Other Frameworks tabs
- [ ] All wireframe component names match release note exactly
- [ ] HTML wireframe names follow kebab-case conversion pattern
- [ ] Log file written to `/Users/yoenzhang/Downloads/docs/.claude/logs/agent-2-planning-4.6.10.md`

## Notes
- No breaking changes detected
- Bug fix (sidebar button count) does not require documentation updates
- Auto-close behavior improvement does not require documentation updates
- Template directive examples (velt-if, velt-class, velt-data) for unread property shown in release note but not requiring separate documentation (already covered by existing template docs)
