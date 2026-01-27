# Release Update Plan for v5.0.0-beta.1

## Overview
- Release Type: Major (Beta)
- Release Date: January 27, 2026
- Key Changes: Comment Dialog Primitives - 115+ independent primitive components for maximum customization
- Breaking Changes: No (additive-only release)

## Areas Requiring Updates

### 1. Data Models (NEW TYPES ONLY)
- Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes: Add new interfaces/types for primitive components
  - `CommentDialogContextProps` (annotationId, commentId, attachmentId, commentPinSelected)
  - `CommentDialogCommonProps` (annotationId, defaultCondition, inlineCommentSectionMode, commentPinSelected, fullExpanded)
  - `ThreadCardLookupProps` (commentObj, commentId, commentIndex - priority-based)
  - `ComposerPlaceholderProps` (placeholder, commentPlaceholder, replyPlaceholder, editPlaceholder, editMode)
  - `DropdownItemLookupProps` (statusObj/statusId/statusIndex, priorityObj/priorityId/priorityIndex)
  - `OptionsDropdownProps` (enableAssignment, enableEdit, enableNotifications, enablePrivateMode, enableMarkAsRead with V1 aliases)
  - `ReplyAvatarsListItemProps` (user: User, index: number - both required)
- Priority: High
- Effort: 20 minutes

### 2. API Methods (NEW COMPONENTS ONLY)
- Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Changes: Add section for Comment Dialog Primitive Components
  - VeltCommentDialogContextWrapper (required wrapper with annotationId prop)
  - 115+ primitive components organized by category
  - Categories: Header/Body, ThreadCard (14 subcomponents), Composer (7 subcomponents), StatusDropdown, PriorityDropdown, OptionsDropdown, CustomAnnotationDropdown, ReplyAvatars, AssigneeBanner, Utility components
- Priority: High
- Location: Add new "Comment Dialog Primitives" section after existing Comment Dialog API methods
- Pattern: Follow component → props → example structure
- Effort: 60 minutes

### 3. Documentation (NEW FEATURE DOCS)
- Files: Create new documentation page
  - `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/standalone-components/comment-dialog-primitives/overview.mdx`
  - `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/standalone-components/comment-dialog-primitives/setup.mdx`
  - `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/standalone-components/comment-dialog-primitives/customize-behavior.mdx`
- Changes: Create comprehensive guide for using primitive components
  - Problem statement: Previous limitation on subcomponent independence
  - Solution: VeltCommentDialogContextWrapper enables any component to be used individually
  - Common props pattern (annotationId, defaultCondition, etc.)
  - Component categories with examples
  - Priority-based lookup pattern (obj > id > index)
- Priority: High
- Effort: 90 minutes

### 4. UI Customization (UPDATE WIREFRAME DOCS)
- Files:
  - `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`
  - `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-structure.mdx`
- Changes: Add note about primitive components availability
  - Reference to standalone components documentation
  - Clarify difference between wireframe customization vs primitive component usage
  - Link to new primitive components guide
- Priority: Medium
- Effort: 15 minutes

### 5. Migration Guides (NOT REQUIRED)
- Breaking Changes: None
- This is an additive-only release providing new functionality
- Existing wireframe customization continues to work as-is

## Areas NOT Requiring Updates

### No API Changes to Existing Features
- Existing Comment Dialog wireframe components unchanged
- All previous customization methods remain valid
- Backward compatibility maintained

## Implementation Sequence

1. **Data Models First** (High Priority, Foundation)
   - Add all new interface types to data-models.mdx
   - Effort: 20 minutes

2. **API Methods Second** (High Priority, Technical Reference)
   - Add Comment Dialog Primitives section to api-methods.mdx
   - Document VeltCommentDialogContextWrapper wrapper component
   - Document all 115+ primitive components by category
   - Effort: 60 minutes

3. **Feature Documentation Third** (High Priority, User-Facing)
   - Create overview.mdx with problem/solution context
   - Create setup.mdx with VeltCommentDialogContextWrapper setup
   - Create customize-behavior.mdx with common props and component categories
   - Effort: 90 minutes

4. **UI Customization Updates Fourth** (Medium Priority, Cross-Reference)
   - Add primitive components reference to existing wireframe docs
   - Clarify customization approach differences
   - Effort: 15 minutes

## Quality Checklist
- [ ] CommentDialogContextProps interface added to data-models.mdx
- [ ] CommentDialogCommonProps interface added to data-models.mdx
- [ ] ThreadCardLookupProps interface added to data-models.mdx
- [ ] ComposerPlaceholderProps interface added to data-models.mdx
- [ ] DropdownItemLookupProps interface added to data-models.mdx
- [ ] OptionsDropdownProps interface added to data-models.mdx
- [ ] ReplyAvatarsListItemProps interface added to data-models.mdx
- [ ] VeltCommentDialogContextWrapper documented in api-methods.mdx
- [ ] All 115+ primitive components documented in api-methods.mdx
- [ ] Components organized by category (Header/Body, ThreadCard, Composer, Dropdowns, etc.)
- [ ] overview.mdx created with problem/solution context
- [ ] setup.mdx created with VeltCommentDialogContextWrapper usage
- [ ] customize-behavior.mdx created with common props and categories
- [ ] comment-dialog-components.mdx updated with primitives reference
- [ ] comment-dialog-structure.mdx updated with primitives note
- [ ] Code examples include React/Next.js and Other Frameworks tabs
- [ ] Priority-based lookup pattern documented (obj → id → index)
- [ ] Common props pattern explained (inherited by all components)
- [ ] No breaking changes (additive-only)
- [ ] Planning log written to `.claude/logs/agent-2-planning-5.0.0-beta.1.md`

## Component Categories Breakdown

### Header/Body (2 components)
- VeltCommentDialogHeader
- VeltCommentDialogBody

### ThreadCard (14 subcomponents)
- ThreadCard, ThreadCardAvatar, ThreadCardName, ThreadCardTime, ThreadCardMessage, ThreadCardReactions, ThreadCardReactionTool, ThreadCardRecordings, ThreadCardReply, ThreadCardUnread, ThreadCardEdited, ThreadCardDraft, ThreadCardDeviceType, ThreadCardOptions

### Composer (7 subcomponents)
- Composer, ComposerInput, ComposerActionButton, ComposerAttachmentButton, ComposerRecorderButton, ComposerRecorderPlayer, ComposerFiles

### StatusDropdown (7 subcomponents)
- StatusDropdown, Trigger, TriggerIcon, TriggerName, TriggerArrow, Content, ContentItem, ContentItemIcon, ContentItemName

### PriorityDropdown (7 subcomponents)
- Same hierarchy as StatusDropdown

### OptionsDropdown (enable/allow flags)
- enableAssignment, enableEdit, enableNotifications, enablePrivateMode, enableMarkAsRead
- V1 aliases: allowAssignment, etc.

### CustomAnnotationDropdown (full hierarchy)
- Complete dropdown structure with Trigger and Content variants

### ReplyAvatars (3 subcomponents)
- ReplyAvatars, ReplyAvatarsList, ReplyAvatarsListItem (requires user object and index)

### AssigneeBanner (3 variants)
- AssigneeBanner, Resolved, Unresolved, UnresolveButton

### Utility Components (10+ components)
- ResolveButton, UnresolveButton, CopyLink, CloseButton, DeleteButton, PrivateBanner, GhostBanner, SignIn, NavigationButton, etc.

## Documentation Patterns to Follow

### API Method Component Entry Pattern
```markdown
#### VeltComponentName

Description of what the component displays/does.

**Props:**
- `propName` (type): Description
- `propName2` (type): Description

<Tabs>
<Tab title="React / Next.js">
```jsx
<VeltCommentDialogContextWrapper annotationId="annotation-123">
  <VeltComponentName propName="value" />
</VeltCommentDialogContextWrapper>
```
</Tab>
<Tab title="Other Frameworks">
```html
<velt-comment-dialog-context-wrapper annotation-id="annotation-123">
  <velt-component-name prop-name="value"></velt-component-name>
</velt-comment-dialog-context-wrapper>
```
</Tab>
</Tabs>
```

### Data Model Interface Pattern
```markdown
#### InterfaceName
---

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `propName` | `type` | Yes/No | Description |
```

### Feature Documentation Structure
```markdown
---
title: "Comment Dialog Primitives"
description: "Use 115+ primitive components independently for maximum customization"
---

## Problem
Previously, Comment Dialog subcomponents could not be used individually...

## Solution
VeltCommentDialogContextWrapper enables any comment dialog subcomponent to be used independently...

## Setup
[VeltCommentDialogContextWrapper usage with annotationId]

## Common Props
All primitive components inherit these props:
- annotationId
- defaultCondition
- inlineCommentSectionMode
- commentPinSelected
- fullExpanded

## Component Categories
[Organized breakdown with examples]
```

## Specific Documentation Updates

### 1. Data Models (data-models.mdx)
**Location:** Add in Comments section after CommentAnnotation interface

**New Interfaces:**
- CommentDialogContextProps: Required wrapper props (annotationId + optional commentId, attachmentId, commentPinSelected)
- CommentDialogCommonProps: Props inherited by all primitive components
- ThreadCardLookupProps: Priority-based lookup (commentObj > commentId > commentIndex)
- ComposerPlaceholderProps: Placeholder text variants for different modes
- DropdownItemLookupProps: Status/Priority item lookup patterns
- OptionsDropdownProps: Enable/allow flags for dropdown features
- ReplyAvatarsListItemProps: Required user object and index

### 2. API Methods (api-methods.mdx)
**Location:** Add new "Comment Dialog Primitives" section after existing Comment Dialog section

**Structure:**
1. Introduction explaining VeltCommentDialogContextWrapper requirement
2. Component categories with hierarchy
3. Each component entry with:
   - Component name (React + HTML variants)
   - Description
   - Props table
   - Code examples (React/Next.js + Other Frameworks tabs)
4. Priority-based lookup explanation for ThreadCard, StatusDropdown, PriorityDropdown
5. Common props inheritance pattern

### 3. Feature Documentation (NEW FILES)
**Files to Create:**
- `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/standalone-components/comment-dialog-primitives/overview.mdx`
- `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/standalone-components/comment-dialog-primitives/setup.mdx`
- `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/standalone-components/comment-dialog-primitives/customize-behavior.mdx`

**Content Structure:**
- overview.mdx: Problem statement, solution explanation, use cases
- setup.mdx: VeltCommentDialogContextWrapper setup, required props (annotationId)
- customize-behavior.mdx: Common props, component categories, examples by category

### 4. UI Customization Updates
**Files:**
- `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`
- `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-structure.mdx`

**Changes:**
- Add note at top referencing new primitive components capability
- Link to `/async-collaboration/comments/standalone-components/comment-dialog-primitives/overview`
- Clarify: "For independent component usage, see Comment Dialog Primitives. For wireframe customization, continue below."

## Notes for Agent-3

### Key Concepts to Document
1. **Context Wrapper Requirement:** VeltCommentDialogContextWrapper is required; annotationId is mandatory prop
2. **Common Props Pattern:** All primitives inherit annotationId, defaultCondition, inlineCommentSectionMode, commentPinSelected, fullExpanded
3. **Priority-Based Lookup:** ThreadCard, StatusDropdown, PriorityDropdown use obj > id > index priority
4. **Independence:** Any component can be used standalone (not limited to wireframe hierarchy)
5. **Component Hierarchy:** 115+ components organized into 9 categories

### Link Patterns
- Data model references: `/api-reference/sdk/models/data-models#interface-name`
- API method references: `/api-reference/sdk/api/api-methods#component-name`
- Feature docs: `/async-collaboration/comments/standalone-components/comment-dialog-primitives/overview`

### Code Example Pattern
Always show VeltCommentDialogContextWrapper wrapping primitive components with annotationId prop in examples.

### Naming Conventions
- React: VeltCommentDialog[ComponentName]
- HTML: velt-comment-dialog-[component-name]
- Props: camelCase in React, kebab-case in HTML
