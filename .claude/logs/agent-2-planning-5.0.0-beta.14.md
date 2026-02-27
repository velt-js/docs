# Release Update Plan for Version 5.0.0-beta.14

## Overview
- **Release Date**: February 10, 2026
- **Release Type**: Minor with Breaking Change
- **Key Changes**: Page mode composer context APIs, assignment UI mode switching, sidebar filtering enhancement, event tracking, component-level read-only mode, wireframe components
- **Breaking Changes**: Yes - `targetElementId` renamed to `targetComposerElementId` on VeltCommentComposer

## Areas Requiring Updates

### 1. Data Models Documentation

**File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`

#### 1.1 Add New Interface: PageModeComposerConfig
- **Section**: Component Props
- **Change**: Add new interface definition
- **Priority**: High
- **Details**:
  ```typescript
  #### PageModeComposerConfig
  ---

  Configuration object for setting context in page mode composer.

  | Property | Type | Required | Description |
  |----------|------|----------|-------------|
  | `context` | `object` | Yes | Context data to pass to the composer |
  | `targetElementId` | `string` | No | Target element ID for the composer |
  ```

#### 1.2 Add New Interface: AssignToConfig
- **Section**: Component Props
- **Change**: Add new interface definition
- **Priority**: High
- **Details**:
  ```typescript
  #### AssignToConfig
  ---

  Configuration object for assignment type.

  | Property | Type | Required | Description |
  |----------|------|----------|-------------|
  | `type` | `AssignToType` | Yes | Assignment UI mode: 'dropdown' or 'checkbox' |
  ```

#### 1.3 Add New Type: AssignToType
- **Section**: Types
- **Change**: Add new type definition
- **Priority**: High
- **Details**:
  ```typescript
  #### AssignToType
  ---

  Type: `'dropdown' | 'checkbox'`

  Defines the UI mode for assignment functionality:
  - `dropdown`: Default mode with team member selection menu
  - `checkbox`: Quick self-assignment toggle mode
  ```

#### 1.4 Add New Interface: CommentToolClickEvent
- **Section**: Event Types
- **Change**: Add new event interface
- **Priority**: High
- **Details**:
  ```typescript
  #### CommentToolClickEvent
  ---

  Event fired when comment tool button is clicked.

  | Property | Type | Description |
  |----------|------|-------------|
  | `context` | `object` | Context data from the comment tool |
  | `targetElementId` | `string` | Target element ID if configured |
  | `metadata` | `object` | Additional metadata |
  ```

#### 1.5 Add New Interface: SidebarButtonClickEvent
- **Section**: Event Types
- **Change**: Add new event interface
- **Priority**: High
- **Details**:
  ```typescript
  #### SidebarButtonClickEvent
  ---

  Event fired when sidebar button is clicked.

  | Property | Type | Description |
  |----------|------|-------------|
  | `metadata` | `object` | Metadata associated with the click event |
  ```

#### 1.6 Update SidebarFilterCriteria Type
- **Line**: Search for `SidebarFilterCriteria` definition
- **Change**: Add `'assignedToMe'` to enum values
- **Priority**: High
- **Details**:
  ```typescript
  // Add 'assignedToMe' to existing values
  type SidebarFilterCriteria = 'status' | 'priority' | 'category' | 'assignedToMe' | ...
  ```

#### 1.7 Update CommentAnnotation Interface
- **Line**: Search for `CommentAnnotation` interface
- **Change**: Add `resolvedByUser` property
- **Priority**: Medium
- **Details**:
  ```typescript
  | `resolvedByUser` | `User` | No | Full user object of who resolved the comment |
  ```

#### 1.8 Update VeltCommentComposerProps Interface
- **Line**: Search for `VeltCommentComposerProps` definition
- **Change**: Replace `targetElementId` with `targetComposerElementId`, add `readOnly` prop
- **Priority**: High (Breaking Change)
- **Details**:
  ```typescript
  | `targetComposerElementId` | `string` | No | Unique identifier for this composer instance (renamed from targetElementId) |
  | `readOnly` | `boolean` | No | Enable read-only mode for this composer |
  ```

#### 1.9 Update VeltInlineCommentsSectionProps Interface
- **Line**: Search for `VeltInlineCommentsSectionProps` definition
- **Change**: Add `readOnly` prop
- **Priority**: High
- **Details**:
  ```typescript
  | `readOnly` | `boolean` | No | Enable read-only mode for this inline comments section |
  ```

#### 1.10 Update VeltCommentsProps Interface
- **Line**: Search for `VeltCommentsProps` definition
- **Change**: Add `assignToType` prop
- **Priority**: High
- **Details**:
  ```typescript
  | `assignToType` | `AssignToType` | No | Configure assignment UI mode: 'dropdown' (default) or 'checkbox' |
  ```

#### 1.11 Update VeltCommentToolProps Interface
- **Line**: Search for `VeltCommentToolProps` definition
- **Change**: Add context-related props
- **Priority**: High
- **Details**:
  ```typescript
  | `contextInPageModeComposer` | `boolean` | No | Enable passing context to page mode composer when sidebar opens |
  | `context` | `object` | No | Context data to pass to page mode composer |
  ```

### 2. API Methods Documentation

**File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`

#### 2.1 Add enableContextInPageModeComposer() Method
- **Section**: Comment Element methods
- **Change**: Add new method entry
- **Priority**: High
- **Details**:
  ```markdown
  #### enableContextInPageModeComposer()
  Enable passing context data to page mode composer when opening via comment tool.
  - Params: `none`
  - Returns: `void`
  - React Hook: `useCommentUtils()`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior#context-in-page-mode-composer)
  ```

#### 2.2 Add disableContextInPageModeComposer() Method
- **Section**: Comment Element methods
- **Change**: Add new method entry
- **Priority**: High
- **Details**:
  ```markdown
  #### disableContextInPageModeComposer()
  Disable passing context data to page mode composer.
  - Params: `none`
  - Returns: `void`
  - React Hook: `useCommentUtils()`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior#context-in-page-mode-composer)
  ```

#### 2.3 Add setContextInPageModeComposer() Method
- **Section**: Comment Element methods
- **Change**: Add new method entry
- **Priority**: High
- **Details**:
  ```markdown
  #### setContextInPageModeComposer()
  Set context data for the page mode composer programmatically.
  - Params: `config: PageModeComposerConfig | null`
  - Returns: `void`
  - React Hook: `useCommentUtils()`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior#context-in-page-mode-composer)
  ```

#### 2.4 Add clearPageModeComposerContext() Method
- **Section**: Comment Element methods
- **Change**: Add new method entry
- **Priority**: High
- **Details**:
  ```markdown
  #### clearPageModeComposerContext()
  Clear context data from page mode composer.
  - Params: `none`
  - Returns: `void`
  - React Hook: `useCommentUtils()`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior#context-in-page-mode-composer)
  ```

#### 2.5 Add focusPageModeComposer() Method
- **Section**: Comment Element methods
- **Change**: Add new method entry
- **Priority**: High
- **Details**:
  ```markdown
  #### focusPageModeComposer()
  Focus the page mode composer input programmatically.
  - Params: `none`
  - Returns: `void`
  - React Hook: `useCommentUtils()`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior#context-in-page-mode-composer)
  ```

#### 2.6 Add setAssignToType() Method
- **Section**: Comment Element methods
- **Change**: Add new method entry
- **Priority**: High
- **Details**:
  ```markdown
  #### setAssignToType()
  Configure assignment UI mode as dropdown or checkbox.
  - Params: `config: AssignToConfig`
  - Returns: `void`
  - React Hook: `useCommentUtils()`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior#assignment-ui-mode)
  ```

#### 2.7 Add commentToolClick Event
- **Section**: Comment Events
- **Change**: Add new event entry
- **Priority**: High
- **Details**:
  ```markdown
  #### commentToolClick
  Event fired when comment tool button is clicked.
  - Event Type: `CommentToolClickEvent`
  - React Hook: `useCommentEventCallback('commentToolClick')`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior#comment-tool-click-event)
  ```

#### 2.8 Add sidebarButtonClick Event
- **Section**: Comment Events
- **Change**: Add new event entry
- **Priority**: High
- **Details**:
  ```markdown
  #### sidebarButtonClick
  Event fired when sidebar button is clicked.
  - Event Type: `SidebarButtonClickEvent`
  - React Hook: `useCommentEventCallback('sidebarButtonClick')`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior#sidebar-button-click-event)
  ```

### 3. Feature Documentation - Comments Customize Behavior

**File**: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`

#### 3.1 Add Context in Page Mode Composer Section
- **Line**: After existing page mode sections
- **Change**: Add new documentation section
- **Priority**: High
- **Details**:
  - Document `enableContextInPageModeComposer()`, `disableContextInPageModeComposer()`, `setContextInPageModeComposer()`, `clearPageModeComposerContext()`, `focusPageModeComposer()`
  - Show examples with VeltCommentTool using `contextInPageModeComposer` and `context` props
  - Explain use cases: tracking UI context, pre-populating metadata, analytics
  - Include both React and Other Frameworks tabs
  - Link to API reference sections

#### 3.2 Add Assignment UI Mode Section
- **Line**: After existing assignment sections
- **Change**: Add new documentation section
- **Priority**: High
- **Details**:
  - Document `setAssignToType()` method
  - Explain dropdown vs checkbox modes
  - Show VeltComments component with `assignToType` prop
  - Include both React and Other Frameworks tabs
  - Link to API reference: AssignToType type and setAssignToType method

#### 3.3 Add Comment Tool Click Event Section
- **Line**: In events section
- **Change**: Add new event documentation
- **Priority**: Medium
- **Details**:
  - Document `commentToolClick` event
  - Show hook usage with `useCommentEventCallback('commentToolClick')`
  - Show API usage with `.on('commentToolClick').subscribe()`
  - Explain event properties: context, targetElementId, metadata
  - Include both React and Other Frameworks tabs

#### 3.4 Add Sidebar Button Click Event Section
- **Line**: In events section
- **Change**: Add new event documentation
- **Priority**: Medium
- **Details**:
  - Document `sidebarButtonClick` event
  - Show hook usage with `useCommentEventCallback('sidebarButtonClick')`
  - Show API usage with `.on('sidebarButtonClick').subscribe()`
  - Explain event properties: metadata
  - Include both React and Other Frameworks tabs

#### 3.5 Add Read-Only Mode Component-Level Section
- **Line**: In read-only mode section
- **Change**: Update existing or add new section
- **Priority**: High
- **Details**:
  - Document component-level `readOnly` prop on VeltCommentComposer and VeltInlineCommentsSection
  - Explain that local prop takes precedence over global state
  - Show examples for both components
  - Include both React and Other Frameworks tabs
  - Link to component props documentation

### 4. UI Customization Documentation - Sidebar Filters

**File**: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comments-sidebar/subcomponents/header/subcomponents/minimal-filter-dropdown/overview.mdx`

#### 4.1 Update Minimal Filter Dropdown Overview
- **Line**: Component structure section
- **Change**: Add FilterAssignedToMe to component hierarchy
- **Priority**: Medium
- **Details**: Document VeltCommentsSidebarWireframe.MinimalFilterDropdown.Content.FilterAssignedToMe wireframe component

### 5. UI Customization Documentation - Comment Dialog Thread Card

**File**: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`

#### 5.1 Add ThreadCard.AssignButton Component
- **Line**: Search for ThreadCard component section
- **Change**: Document new AssignButton subcomponent
- **Priority**: Medium
- **Details**:
  - Document `VeltCommentDialogWireframe.ThreadCard.AssignButton`
  - Provide React and Other Frameworks examples
  - Show usage within thread card structure

#### 5.2 Add ThreadCard.EditComposer Component
- **Line**: Search for ThreadCard component section
- **Change**: Document new EditComposer subcomponent
- **Priority**: Medium
- **Details**:
  - Document `VeltCommentDialogWireframe.ThreadCard.EditComposer`
  - Provide React and Other Frameworks examples
  - Show usage within thread card structure

#### 5.3 Update ThreadCard.ReactionPin Component
- **Line**: Search for existing ReactionPin or add new section
- **Change**: Document ReactionPin component and excludeReactionIds functionality
- **Priority**: Medium
- **Details**:
  - Document `VeltCommentDialogWireframe.ThreadCard.ReactionPin` with `reactionId` prop
  - Document `excludeReactionIds` prop on ThreadCard.Reactions
  - Document `excludeReactionIds` prop on ThreadCard.ReactionTool
  - Provide React and Other Frameworks examples
  - Link to data models: [IVeltCommentDialogThreadCardReactionPinProps](/api-reference/sdk/models/data-models#iveltcommentdialogthreadcardreactionpinprops)

#### 5.4 Update comment-dialog-structure.mdx
- **File**: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-structure.mdx`
- **Change**: Add AssignButton and EditComposer to ThreadCard hierarchy
- **Priority**: Low
- **Details**: Update wireframe component tree to include new subcomponents

### 6. Migration Guide

**File**: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx` or dedicated migration section

#### 6.1 Document Breaking Change: targetElementId → targetComposerElementId
- **Section**: Breaking Changes or Migration Guide
- **Change**: Document prop rename with migration steps
- **Priority**: High
- **Details**:
  - Explain that `targetElementId` is renamed to `targetComposerElementId` on VeltCommentComposer
  - Show before/after code examples
  - Emphasize this is required in v5.0.0-beta.14+
  - Include both React and Other Frameworks examples

## Implementation Sequence

1. **Update Data Models** (High Priority, No Dependencies)
   - Add PageModeComposerConfig, AssignToConfig, AssignToType, CommentToolClickEvent, SidebarButtonClickEvent interfaces/types
   - Update SidebarFilterCriteria, CommentAnnotation
   - Update VeltCommentComposerProps (breaking: targetElementId → targetComposerElementId, add readOnly)
   - Update VeltInlineCommentsSectionProps, VeltCommentsProps, VeltCommentToolProps
   - Effort: 50 min

2. **Update API Methods Index** (High Priority, Depends on #1)
   - Add enableContextInPageModeComposer, disableContextInPageModeComposer, setContextInPageModeComposer, clearPageModeComposerContext, focusPageModeComposer
   - Add setAssignToType
   - Add commentToolClick, sidebarButtonClick events
   - Effort: 25 min

3. **Update Feature Documentation - Customize Behavior** (High Priority, Depends on #1-2)
   - Add context in page mode composer section
   - Add assignment UI mode section
   - Add event documentation (commentToolClick, sidebarButtonClick)
   - Update read-only mode with component-level examples
   - Document breaking change: targetElementId → targetComposerElementId
   - Effort: 75 min

4. **Update UI Customization - Sidebar Filters** (Medium Priority, Depends on #1)
   - Update minimal-filter-dropdown/overview.mdx with FilterAssignedToMe
   - Effort: 15 min

5. **Update UI Customization - Thread Card** (Medium Priority, Depends on #1)
   - Document ThreadCard.AssignButton, ThreadCard.EditComposer
   - Update ThreadCard.ReactionPin with reactionId and excludeReactionIds functionality
   - Update comment-dialog-structure.mdx hierarchy
   - Effort: 40 min

**Total Estimated Effort**: 3 hours 25 min

## Quality Checklist

- [ ] PageModeComposerConfig interface added to data-models.mdx
- [ ] AssignToConfig interface added to data-models.mdx
- [ ] AssignToType type added to data-models.mdx
- [ ] CommentToolClickEvent interface added to data-models.mdx
- [ ] SidebarButtonClickEvent interface added to data-models.mdx
- [ ] SidebarFilterCriteria updated with 'assignedToMe' value
- [ ] CommentAnnotation updated with resolvedByUser property
- [ ] VeltCommentComposerProps updated: targetElementId → targetComposerElementId (breaking), readOnly added
- [ ] VeltInlineCommentsSectionProps updated with readOnly prop
- [ ] VeltCommentsProps updated with assignToType prop
- [ ] VeltCommentToolProps updated with contextInPageModeComposer and context props
- [ ] enableContextInPageModeComposer() method added to api-methods.mdx
- [ ] disableContextInPageModeComposer() method added to api-methods.mdx
- [ ] setContextInPageModeComposer() method added to api-methods.mdx
- [ ] clearPageModeComposerContext() method added to api-methods.mdx
- [ ] focusPageModeComposer() method added to api-methods.mdx
- [ ] setAssignToType() method added to api-methods.mdx
- [ ] commentToolClick event added to api-methods.mdx
- [ ] sidebarButtonClick event added to api-methods.mdx
- [ ] Context in page mode composer section added to customize-behavior.mdx
- [ ] Assignment UI mode section added to customize-behavior.mdx
- [ ] Comment tool click event documented in customize-behavior.mdx
- [ ] Sidebar button click event documented in customize-behavior.mdx
- [ ] Component-level read-only mode documented in customize-behavior.mdx
- [ ] Breaking change documented: targetElementId → targetComposerElementId
- [ ] FilterAssignedToMe documented in minimal-filter-dropdown/overview.mdx
- [ ] ThreadCard.AssignButton documented in comment-dialog-components.mdx
- [ ] ThreadCard.EditComposer documented in comment-dialog-components.mdx
- [ ] ThreadCard.ReactionPin documented with reactionId and excludeReactionIds
- [ ] comment-dialog-structure.mdx updated with new thread card components
- [ ] All code examples include React / Next.js and Other Frameworks tabs
- [ ] All new documentation includes API reference links
- [ ] Planning log written to `/Users/yoenzhang/Downloads/docs/.claude/logs/agent-2-planning-5.0.0-beta.14.md`

## Notes

- **Breaking Change**: `targetElementId` → `targetComposerElementId` on VeltCommentComposer requires migration documentation
- **New Feature Categories**: Page mode context APIs (5 methods), assignment mode switching, event tracking (2 events), component-level read-only, wireframe components (3 new)
- **Documentation Impact**: Major additions to customize-behavior.mdx for new APIs and events
- **Wireframe Impact**: 3 new thread card components require UI customization documentation
- **Link Verification**: Ensure all "Learn more →" links in release note match planned documentation paths
