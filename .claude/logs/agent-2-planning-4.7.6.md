# Release Update Plan for Version 4.7.6

## Overview
- **Release Date**: February 3, 2026
- **Release Type**: Minor
- **Key Changes**: New assignment mode configuration, page mode context passing, sidebar filter enhancement, thread card UI improvements, batched listener optimization
- **Breaking Changes**: No

## Areas Requiring Updates

### 1. Data Models Documentation

**File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`

#### 1.1 Add New Type: AssignToType
- **Section**: Component Props or Types
- **Change**: Add new type definition
- **Priority**: High
- **Details**:
  ```typescript
  #### AssignToType
  ---

  Type: `'dropdown' | 'checkbox'`

  Defines the UI mode for assignment functionality:
  - `dropdown`: Default mode with menu navigation
  - `checkbox`: Quick self-assignment mode
  ```

#### 1.2 Update SidebarFilterCriteria Type
- **Line**: Search for `SidebarFilterCriteria` definition
- **Change**: Add `'assignedToMe'` to enum values
- **Priority**: High
- **Details**:
  ```typescript
  // Add 'assignedToMe' to existing values
  type SidebarFilterCriteria = 'status' | 'priority' | 'category' | 'assignedToMe' | ...
  ```

#### 1.3 Add New Type: IVeltCommentDialogThreadCardReactionPinProps
- **Section**: Wireframe Component Props
- **Change**: Add new interface definition
- **Priority**: Medium
- **Details**:
  ```typescript
  #### IVeltCommentDialogThreadCardReactionPinProps
  ---

  | Property | Type | Required | Description |
  |----------|------|----------|-------------|
  | `reactionId` | `string` | Yes | Unique identifier of the reaction to pin and display |
  ```

#### 1.4 Add New Type: IVeltCommentDialogThreadCardReactionsProps
- **Section**: Wireframe Component Props
- **Change**: Add new interface definition
- **Priority**: Medium
- **Details**:
  ```typescript
  #### IVeltCommentDialogThreadCardReactionsProps
  ---

  | Property | Type | Required | Description |
  |----------|------|----------|-------------|
  | `excludeReactionIds` | `string[]` | No | Array of reaction IDs to exclude from display |
  ```

#### 1.5 Add New Type: IVeltCommentDialogThreadCardReactionToolProps
- **Section**: Wireframe Component Props
- **Change**: Add new interface definition
- **Priority**: Medium
- **Details**:
  ```typescript
  #### IVeltCommentDialogThreadCardReactionToolProps
  ---

  | Property | Type | Required | Description |
  |----------|------|----------|-------------|
  | `excludeReactionIds` | `string[]` | No | Array of reaction IDs to exclude from reaction picker |
  ```

#### 1.6 Update ReactionPinType Enum
- **Line**: Search for `ReactionPinType` definition
- **Change**: Add `'standalone'` value
- **Priority**: Medium
- **Details**:
  ```typescript
  // OLD
  type ReactionPinType = 'timeline' | 'comment'

  // NEW
  type ReactionPinType = 'timeline' | 'comment' | 'standalone'
  ```

#### 1.7 Update VeltCommentsProps Interface
- **Line**: Search for `VeltCommentsProps` or `VeltComments` component props
- **Change**: Add `assignToType` prop
- **Priority**: High
- **Details**:
  ```typescript
  | `assignToType` | `AssignToType` | No | Configure assignment UI mode: 'dropdown' (default) or 'checkbox' |
  ```

#### 1.8 Update VeltCommentToolProps Interface
- **Line**: Search for `VeltCommentToolProps` definition
- **Change**: Add context-related props
- **Priority**: High
- **Details**:
  ```typescript
  | `contextInPageModeComposer` | `boolean` | No | Enable passing context to page mode composer |
  | `context` | `object` | No | Context data to pass to page mode composer when sidebar opens |
  ```

#### 1.9 Update CommentRequestQuery Interface
- **Line**: Search for `CommentRequestQuery` or `getAnnotationsCount` parameters
- **Change**: Add batched listener mode parameters
- **Priority**: High
- **Details**:
  ```typescript
  | `batchedPerDocument` | `boolean` | No | Enable batched listener mode for large document lists (50+ documents) |
  | `debounceMs` | `number` | No | Debounce delay in milliseconds for batched updates (default: 300ms) |
  ```

### 2. API Methods Documentation

**File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`

#### 2.1 Add setAssignToType() Method
- **Section**: Comment Element methods
- **Change**: Add new method entry
- **Priority**: High
- **Details**:
  ```markdown
  #### setAssignToType()
  Configure assignment UI mode as dropdown or checkbox.
  - Params: `type: AssignToType` ('dropdown' | 'checkbox')
  - Returns: `void`
  - React Hook: `n/a`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior/action-buttons/assignment-mode)
  ```

#### 2.2 Add enableContextInPageModeComposer() Method
- **Section**: Comment Element methods
- **Change**: Add new method entry
- **Priority**: High
- **Details**:
  ```markdown
  #### enableContextInPageModeComposer()
  Enable passing context data to page mode composer when opening via comment tool.
  - Params: `none`
  - Returns: `void`
  - React Hook: `n/a`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior/page-mode/context)
  ```

#### 2.3 Add disableContextInPageModeComposer() Method
- **Section**: Comment Element methods
- **Change**: Add new method entry
- **Priority**: High
- **Details**:
  ```markdown
  #### disableContextInPageModeComposer()
  Disable passing context data to page mode composer.
  - Params: `none`
  - Returns: `void`
  - React Hook: `n/a`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior/page-mode/context)
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
  - React Hook: `n/a`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior/page-mode/context)
  ```

#### 2.5 Update getAnnotationsCount() Method
- **Line**: Search for existing `getAnnotationsCount` entry
- **Change**: Update parameter documentation to include batched mode
- **Priority**: High
- **Details**:
  ```markdown
  #### getAnnotationsCount()
  Get real-time count of annotations. Supports batched listener mode for large document lists (50+ documents).
  - Params: [CommentRequestQuery](/api-reference/sdk/models/data-models#commentrequestquery) (includes `batchedPerDocument`, `debounceMs`)
  - Returns: `Observable<number>`
  - React Hook: `n/a`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior#getannotationscount)
  ```

### 3. Feature Documentation - Comments Customize Behavior

**File**: Create `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior/action-buttons/assignment-mode.mdx`

#### 3.1 Create Assignment Mode Documentation
- **Change**: Create new documentation page
- **Priority**: High
- **Details**:
  ```markdown
  ---
  title: "Assignment Mode Configuration"
  description: "Configure assignment UI as dropdown or checkbox mode"
  ---

  # Assignment Mode Configuration

  Configure how users interact with the assignment feature using dropdown or checkbox mode.

  ## Modes

  - **Dropdown** (default): Full assignment menu with team member selection
  - **Checkbox**: Quick self-assignment toggle without menu navigation

  ## Usage

  <Tabs>
  <Tab title="React / Next.js">
  ```jsx
  import { VeltComments } from '@veltdev/react';

  export function MyComponent() {
    return (
      <VeltComments assignToType="checkbox" />
    );
  }

  // Using API methods
  const commentElement = client.getCommentElement();
  commentElement.setAssignToType('checkbox');
  commentElement.setAssignToType('dropdown');
  ```
  </Tab>
  <Tab title="Other Frameworks">
  ```html
  <velt-comments assign-to-type="checkbox"></velt-comments>

  <script>
  const commentElement = Velt.getCommentElement();
  commentElement.setAssignToType('checkbox');
  commentElement.setAssignToType('dropdown');
  </script>
  ```
  </Tab>
  </Tabs>

  ## API Reference

  - Component: [VeltComments](/api-reference/components/velt-comments)
  - Type: [AssignToType](/api-reference/sdk/models/data-models#assigntotype)
  - Method: [setAssignToType()](/api-reference/sdk/api/api-methods#setassigntotype)
  ```

**File**: Create `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior/page-mode/context.mdx`

#### 3.2 Create Page Mode Context Documentation
- **Change**: Create new documentation page
- **Priority**: High
- **Details**:
  ```markdown
  ---
  title: "Page Mode Composer Context"
  description: "Pass context data to page mode composer when opening via comment tool"
  ---

  # Page Mode Composer Context

  Pass context data to the page mode composer when users open the comment sidebar via comment tool. Context automatically clears when sidebar closes.

  ## Use Cases

  - Track which section/element triggered the comment
  - Pre-populate metadata based on user location
  - Associate comments with specific UI contexts

  ## Usage

  <Tabs>
  <Tab title="React / Next.js">
  ```jsx
  import { VeltCommentTool } from '@veltdev/react';

  export function MyComponent() {
    return (
      <VeltCommentTool
        contextInPageModeComposer={true}
        context={{ section: 'header', elementId: 'nav-menu' }}
      />
    );
  }

  // Using API methods
  const commentElement = client.getCommentElement();
  commentElement.enableContextInPageModeComposer();
  commentElement.disableContextInPageModeComposer();
  commentElement.clearPageModeComposerContext();
  ```
  </Tab>
  <Tab title="Other Frameworks">
  ```html
  <velt-comment-tool
    context-in-page-mode-composer="true"
    context='{"section": "header", "elementId": "nav-menu"}'>
  </velt-comment-tool>

  <script>
  const commentElement = Velt.getCommentElement();
  commentElement.enableContextInPageModeComposer();
  commentElement.disableContextInPageModeComposer();
  commentElement.clearPageModeComposerContext();
  </script>
  ```
  </Tab>
  </Tabs>

  ## API Reference

  - Component: [VeltCommentTool](/api-reference/components/velt-comment-tool)
  - Methods:
    - [enableContextInPageModeComposer()](/api-reference/sdk/api/api-methods#enablecontextinpagemodecomposer)
    - [disableContextInPageModeComposer()](/api-reference/sdk/api/api-methods#disablecontextinpagemodecomposer)
    - [clearPageModeComposerContext()](/api-reference/sdk/api/api-methods#clearpagemodecomposercontext)
  ```

**File**: Update `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`

#### 3.3 Update getAnnotationsCount() Documentation
- **Line**: Search for existing `getAnnotationsCount` section
- **Change**: Add batched listener mode documentation
- **Priority**: High
- **Details**:
  - Add section explaining batched mode for large document lists
  - Show code examples with `batchedPerDocument` and `debounceMs` parameters
  - Explain performance benefits (reduces Firestore listeners from N to ~4)
  - Recommend usage for 50+ documents

### 4. UI Customization Documentation - Sidebar Filters

**File**: Create `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comments-sidebar/subcomponents/header/subcomponents/minimal-filter-dropdown/subcomponents/filter-assigned-to-me.mdx`

#### 4.1 Create FilterAssignedToMe Component Documentation
- **Change**: Create new wireframe component documentation
- **Priority**: Medium
- **Details**:
  - Document `VeltCommentsSidebarWireframe.MinimalFilterDropdown.Content.FilterAssignedToMe`
  - Provide React and Other Frameworks examples
  - Show usage within minimal filter dropdown structure
  - Link to filter overview documentation

**File**: Update `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comments-sidebar/subcomponents/header/subcomponents/minimal-filter-dropdown/overview.mdx`

#### 4.2 Update Minimal Filter Dropdown Overview
- **Line**: Component structure section
- **Change**: Add FilterAssignedToMe to component hierarchy
- **Priority**: Medium
- **Details**: List FilterAssignedToMe alongside other filter subcomponents

### 5. UI Customization Documentation - Thread Card

**File**: Update `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`

#### 5.1 Add ThreadCard.ReactionPin Component
- **Line**: Search for ThreadCard component section
- **Change**: Document new ReactionPin subcomponent
- **Priority**: Medium
- **Details**:
  - Document `VeltCommentDialogWireframe.ThreadCard.ReactionPin` with `reactionId` prop
  - Provide React and Other Frameworks examples
  - Show multiple reaction pins usage
  - Link to data model: [IVeltCommentDialogThreadCardReactionPinProps](/api-reference/sdk/models/data-models#iveltcommentdialogthreadcardreactionpinprops)

#### 5.2 Update ThreadCard.Reactions Component
- **Line**: Search for ThreadCard.Reactions section
- **Change**: Add `excludeReactionIds` prop documentation
- **Priority**: Medium
- **Details**:
  - Document `excludeReactionIds` array prop
  - Provide example excluding specific reactions
  - Link to data model: [IVeltCommentDialogThreadCardReactionsProps](/api-reference/sdk/models/data-models#iveltcommentdialogthreadcardreactionsprops)

#### 5.3 Update ThreadCard.ReactionTool Component
- **Line**: Search for ThreadCard.ReactionTool section
- **Change**: Add `excludeReactionIds` prop documentation
- **Priority**: Medium
- **Details**:
  - Document `excludeReactionIds` array prop
  - Provide example excluding specific reactions from picker
  - Link to data model: [IVeltCommentDialogThreadCardReactionToolProps](/api-reference/sdk/models/data-models#iveltcommentdialogthreadcardreactiontoolprops)

## Implementation Sequence

1. **Update Data Models** (High Priority, No Dependencies)
   - Add AssignToType, wireframe prop interfaces, update SidebarFilterCriteria, ReactionPinType, component props
   - Effort: 45 min

2. **Update API Methods Index** (High Priority, Depends on #1)
   - Add setAssignToType, context management methods, update getAnnotationsCount
   - Effort: 20 min

3. **Create Feature Documentation** (High Priority, Depends on #1-2)
   - Create assignment-mode.mdx and page-mode/context.mdx
   - Update getAnnotationsCount section in customize-behavior.mdx
   - Effort: 60 min

4. **Update UI Customization - Sidebar Filters** (Medium Priority, Depends on #1)
   - Create filter-assigned-to-me.mdx
   - Update minimal-filter-dropdown overview
   - Effort: 30 min

5. **Update UI Customization - Thread Card** (Medium Priority, Depends on #1)
   - Document ReactionPin, update Reactions and ReactionTool with excludeReactionIds
   - Effort: 30 min

**Total Estimated Effort**: 3 hours 5 min

## Quality Checklist

- [ ] AssignToType type added to data-models.mdx
- [ ] SidebarFilterCriteria updated with 'assignedToMe' value
- [ ] IVeltCommentDialogThreadCardReactionPinProps added to data-models.mdx
- [ ] IVeltCommentDialogThreadCardReactionsProps added to data-models.mdx
- [ ] IVeltCommentDialogThreadCardReactionToolProps added to data-models.mdx
- [ ] ReactionPinType updated with 'standalone' value
- [ ] VeltCommentsProps updated with assignToType prop
- [ ] VeltCommentToolProps updated with contextInPageModeComposer and context props
- [ ] CommentRequestQuery updated with batchedPerDocument and debounceMs params
- [ ] setAssignToType() method added to api-methods.mdx
- [ ] enableContextInPageModeComposer() method added to api-methods.mdx
- [ ] disableContextInPageModeComposer() method added to api-methods.mdx
- [ ] clearPageModeComposerContext() method added to api-methods.mdx
- [ ] getAnnotationsCount() method updated with batched mode documentation
- [ ] assignment-mode.mdx created at `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior/action-buttons/assignment-mode.mdx`
- [ ] page-mode/context.mdx created at `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior/page-mode/context.mdx`
- [ ] getAnnotationsCount section updated in customize-behavior.mdx with batched mode examples
- [ ] filter-assigned-to-me.mdx created for minimal filter dropdown
- [ ] Minimal filter dropdown overview updated with FilterAssignedToMe component
- [ ] ThreadCard.ReactionPin documented in comment-dialog-components.mdx
- [ ] ThreadCard.Reactions updated with excludeReactionIds prop
- [ ] ThreadCard.ReactionTool updated with excludeReactionIds prop
- [ ] All code examples include React / Next.js and Other Frameworks tabs
- [ ] All new documentation includes API reference links
- [ ] Planning log written to `/Users/yoenzhang/Downloads/docs/.claude/logs/agent-2-planning-4.7.6.md`

## Notes

- **No Breaking Changes**: All changes are additive features and enhancements
- **New Documentation Pages**: Two new feature docs required (assignment-mode.mdx, page-mode/context.mdx)
- **Wireframe Components**: Three new wireframe components/props for thread card reactions and sidebar filter
- **Performance Enhancement**: getAnnotationsCount batched mode is optimization, not breaking change
- **Link Verification**: Ensure all "Learn more →" links in release note match planned documentation paths
