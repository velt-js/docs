# Release Update Plan for Version 4.7.7

## Overview
- **Release Date**: February 3, 2026
- **Release Type**: Patch
- **Key Changes**: Page mode composer control methods, comment tool click event, sidebar button click event
- **Breaking Changes**: No

## Areas Requiring Updates

### 1. Data Models Documentation

**File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`

#### 1.1 Add New Event Type: CommentToolClickEvent
- **Section**: Comments > Threads (after existing event types)
- **Change**: Add new event interface
- **Priority**: High
- **Details**:
  ```typescript
  #### CommentToolClickEvent
  ---

  | Property | Type | Required | Description |
  |----------|------|----------|-------------|
  | `context` | `any` | No | Custom context data when comment tool is clicked |
  | `metadata` | `VeltEventMetadata` | Yes | Event metadata |
  | `targetElementId` | `string` | No | ID of the target element if available |
  ```

#### 1.2 Add New Event Type: SidebarButtonClickEvent
- **Section**: Comments > Threads (after CommentToolClickEvent)
- **Change**: Add new event interface
- **Priority**: High
- **Details**:
  ```typescript
  #### SidebarButtonClickEvent
  ---

  | Property | Type | Required | Description |
  |----------|------|----------|-------------|
  | `metadata` | `VeltEventMetadata` | Yes | Event metadata |
  ```

#### 1.3 Update Event Types Enum
- **Section**: Comments > Threads > Enum (line ~45-51)
- **Change**: Add new event type constants to enum table
- **Priority**: High
- **Details**:
  ```markdown
  | `COMMENT_TOOL_CLICK` | `commentToolClick` | Triggered when comment tool button is clicked |
  | `SIDEBAR_BUTTON_CLICK` | `sidebarButtonClick` | Triggered when sidebar button is clicked |
  ```

### 2. API Methods Documentation

**File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`

#### 2.1 Add setContextInPageModeComposer() Method
- **Section**: Comments > DOM Controls (around line 751)
- **Change**: Add new method entry
- **Priority**: High
- **Details**:
  ```markdown
  #### setContextInPageModeComposer()
  Set context data for the page mode composer programmatically.
  - Params: `context: any | null` (pass null to clear)
  - Returns: `void`
  - React Hook: `n/a`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior#setcontextinpagemodecomposer)
  ```

#### 2.2 Add focusPageModeComposer() Method
- **Section**: Comments > DOM Controls (after setContextInPageModeComposer)
- **Change**: Add new method entry
- **Priority**: High
- **Details**:
  ```markdown
  #### focusPageModeComposer()
  Focus the page mode composer input field.
  - Params: none
  - Returns: `void`
  - React Hook: `n/a`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior#setcontextinpagemodecomposer)
  ```

#### 2.3 Update on() Method Documentation Reference
- **Section**: Comments > Event Subscription > on() (line ~503-508)
- **Change**: Update reference to note new event types
- **Priority**: Medium
- **Details**: Ensure link to customize-behavior#on includes new event types (no change needed if link already points to dynamic list)

### 3. Main Feature Documentation

**File**: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`

#### 3.1 Add setContextInPageModeComposer Section
- **Section**: New section under appropriate category
- **Change**: Add full documentation for both new methods
- **Priority**: High
- **Details**:
  - Method signature and parameters
  - Use cases and when to use
  - Code examples in Tabs format (React / Next.js first, Other Frameworks second)
  - Both `setContextInPageModeComposer()` and `focusPageModeComposer()` in same section
  - Link already present in release note: `/async-collaboration/comments/customize-behavior#setcontextinpagemodecomposer`

#### 3.2 Add Event Documentation for commentToolClick
- **Section**: Event Subscription section (where .on() events are documented)
- **Change**: Add event documentation
- **Priority**: High
- **Details**:
  - Event name and description
  - Event payload structure (CommentToolClickEvent)
  - Code examples in Tabs format
  - Use cases
  - Target anchor: `#commenttoolclick` (note: release note links to `/api-reference/sdk/api/events#commenttoolclick` - verify correct path)

#### 3.3 Add Event Documentation for sidebarButtonClick
- **Section**: Event Subscription section (after commentToolClick)
- **Change**: Add event documentation
- **Priority**: High
- **Details**:
  - Event name and description
  - Event payload structure (SidebarButtonClickEvent)
  - Code examples in Tabs format
  - Use cases
  - Target anchor: `#sidebarbuttonclick`

### 4. UI Customization Documentation

**File**: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-primitives/overview.mdx` (or related wireframe documentation)

#### 4.1 Update ReactionPin Component Documentation
- **Section**: VeltCommentDialogThreadCardReactionPin section
- **Change**: Verify `reactionId` prop documented correctly
- **Priority**: Low
- **Details**: Bug fix ensures prop is properly passed to HTML element - no documentation update needed unless prop was missing

## Implementation Sequence

1. **Data Models** (Agent-3): Add new event types and enum entries
   - Effort: Low
   - Blocking: None

2. **API Methods Index** (Agent-3): Add new method entries for setContextInPageModeComposer and focusPageModeComposer
   - Effort: Low
   - Blocking: Task 1 (data models should be documented first)

3. **Main Feature Documentation** (Agent-4): Add full documentation for new methods and events in customize-behavior.mdx
   - Effort: Medium
   - Blocking: Tasks 1-2 (ensures links work)

4. **Verify Event Documentation Path** (Agent-5): Confirm release note links point to correct locations
   - Effort: Low
   - Blocking: Task 3
   - Note: Release note links to `/api-reference/sdk/api/events#commenttoolclick` but events may be documented in `/async-collaboration/comments/customize-behavior#on`

## Quality Checklist

- [ ] New event types (CommentToolClickEvent, SidebarButtonClickEvent) added to data-models.mdx
- [ ] Event type enum updated with COMMENT_TOOL_CLICK and SIDEBAR_BUTTON_CLICK
- [ ] New methods (setContextInPageModeComposer, focusPageModeComposer) added to api-methods.mdx
- [ ] Full method documentation added to customize-behavior.mdx at anchor #setcontextinpagemodecomposer
- [ ] Event documentation added for commentToolClick and sidebarButtonClick
- [ ] Code examples use Tabs pattern (React / Next.js first, Other Frameworks second)
- [ ] All links in release note verified to point to correct anchors
- [ ] Bug fix for reactionId prop documented (if needed)
- [ ] Log file written to `.claude/logs/agent-2-planning-4.7.7.md`

## Notes

- **Event Documentation Location**: Release note links to `/api-reference/sdk/api/events#commenttoolclick` but this file may not exist. Events are typically documented in customize-behavior.mdx. Agent-5 should verify and correct links if needed.
- **Bug Fix**: reactionId prop fix is internal - no documentation update needed unless prop was previously undocumented.
- **Pattern Consistency**: Maintain existing documentation patterns for method entries and event documentation.
