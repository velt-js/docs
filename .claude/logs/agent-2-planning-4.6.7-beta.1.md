# Release Update Plan for v4.6.7-beta.1

## Overview
- Release Type: Minor (Beta)
- Key Changes: 5 new features enhancing Live Selection, Sidebar Button, and Comment Bubble functionality
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models
**File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`

**Changes**:
- Add `CommentCountType` enum after Comment Sidebar section (around line 1227)
  - Union type: `'total' | 'unread'`
  - Description: Controls whether comment counts show total or unread
- Add `CommentBubbleClickedEvent` interface after existing comment events (around line 60)
  - Properties: `annotationId: string`, `commentAnnotation: CommentAnnotation`, `metadata?: VeltEventMetadata`
  - Description: Event triggered when comment bubble is clicked

**Priority**: High

### 2. API Methods
**File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`

**Changes**:
- Add `setInactivityTime()` method under Live Selection section (after line 1629 where Cursors section begins)
  - Params: `milliseconds: number`
  - Returns: `void`
  - Default: 300000 (5 minutes)
  - Description: Set inactivity duration for Live Selection
  - Full docs link: `/realtime-collaboration/live-selection/customize-behavior#setinactivitytime`

**Priority**: High

### 3. Live Selection Documentation
**File**: `/Users/yoenzhang/Downloads/docs/realtime-collaboration/live-selection/customize-behavior.mdx`

**Changes**:
- Add new section `## setInactivityTime` after `getLiveSelectionData` section (after line 159)
  - Include both React and Other Frameworks tabs
  - Show API usage with example: `selectionElement.setInactivityTime(600000)` for 10 minutes
  - Document default value: 300000ms (5 minutes)
  - Description: Configure how long before inactive selections are hidden

**Priority**: High

### 4. Sidebar Button Documentation
**File**: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments-sidebar/setup.mdx`

**Changes**:
- No changes needed (prop documentation goes in customize-behavior)

**File**: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments-sidebar/customize-behavior.mdx`

**Changes**:
- Add new section under UI category (after `sidebarButtonCountType` around line 817)
  - Section title: `## commentCountType`
  - Document prop on `VeltSidebarButton` component
  - Type: `CommentCountType: 'total' | 'unread'`
  - Default: `'total'`
  - Show React example: `<VeltSidebarButton commentCountType="unread" />`
  - Show HTML example: `<velt-sidebar-button comment-count-type="unread">`
  - Description: Control whether button shows total or unread comment count

**Priority**: Medium

### 5. Comment Bubble Documentation
**File**: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`

**Changes**:
- Add new section `## openDialog` after `commentCountType` section (after line 6920)
  - Document prop on `VeltCommentBubble` component
  - Type: `boolean`
  - Default: `true`
  - React example: `<VeltCommentBubble openDialog={false} />`
  - HTML example: `<velt-comment-bubble open-dialog="false">`
  - Description: Control whether clicking bubble opens comment dialog

**Priority**: Medium

### 6. Comment Events Documentation
**File**: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`

**Changes**:
- Add new event section under existing events (search for other event documentation patterns)
  - Event name: `commentBubbleClicked`
  - Returns: `CommentBubbleClickedEvent`
  - React hook: `useCommentEventCallback('commentBubbleClicked')`
  - API: `commentElement.on('commentBubbleClicked').subscribe()`
  - Include both React and Other Frameworks tabs
  - Show event properties: `annotationId`, `commentAnnotation`, `metadata`
  - Link to data model: `/api-reference/sdk/models/data-models#commentbubbleclickedevent`

**Priority**: High

### 7. UI Customization - Sidebar Button Wireframe
**File**: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comments-sidebar/subcomponents/sidebar-button/overview.mdx`

**Changes**:
- Add `UnreadIcon` subcomponent to wireframe structure (around line 23)
  - Update default component example to include `VeltSidebarButtonWireframe.UnreadIcon`
  - Add new subcomponent section with description

**New File**: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comments-sidebar/subcomponents/sidebar-button/subcomponents/unread-icon.mdx`

**Content**:
- Create new subcomponent documentation page
- Follow pattern from `icon.mdx` and `comments-count.mdx`
- Include React example: `<VeltSidebarButtonWireframe.UnreadIcon />`
- Include HTML example: `<velt-sidebar-button-unread-icon-wireframe>`
- Description: Displays unread indicator on sidebar button

**Priority**: Medium

### 8. UI Customization - Comments Sidebar Button Wireframe
**New File**: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comments-sidebar-button-wireframe.mdx`

**Content**:
- Create new wireframe documentation page for `VeltCommentsSidebarButtonWireframe`
- Include `UnreadIcon` subcomponent
- Follow structure from `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-sidebar-button.mdx`
- React: `VeltCommentsSidebarButtonWireframe.UnreadIcon`
- HTML: `<velt-comments-sidebar-button-unread-icon-wireframe>`

**Priority**: Medium

### 9. UI Customization - Comment Bubble Wireframe
**File**: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-bubble.mdx`

**Changes**:
- Add `UnreadIcon` subcomponent to wireframe structure (after Avatar section around line 72)
  - Add new section: `## UnreadIcon`
  - React example: `<VeltCommentBubbleWireframe.UnreadIcon />`
  - HTML example: `<velt-comment-bubble-unread-icon-wireframe>`
  - Description: Shows unread indicator on comment bubble
  - Include image placeholder path: `/images/customization/comments/comment-bubble/comment-bubble-unread-icon.png`

**Priority**: Medium

## Implementation Sequence
1. Update data models with new types/interfaces (CommentCountType, CommentBubbleClickedEvent) - HIGH
2. Update API methods with setInactivityTime() - HIGH
3. Add setInactivityTime() to Live Selection customize-behavior - HIGH
4. Add commentBubbleClicked event to Comments customize-behavior - HIGH
5. Add commentCountType prop to Sidebar customize-behavior - MEDIUM
6. Add openDialog prop to Comment Bubble customize-behavior - MEDIUM
7. Update Sidebar Button wireframe with UnreadIcon subcomponent - MEDIUM
8. Create new UnreadIcon subcomponent documentation file - MEDIUM
9. Update Comment Bubble wireframe with UnreadIcon subcomponent - MEDIUM
10. Create VeltCommentsSidebarButtonWireframe documentation (if needed) - LOW

## Quality Checklist
- [ ] CommentCountType enum added to data-models.mdx
- [ ] CommentBubbleClickedEvent interface added to data-models.mdx
- [ ] setInactivityTime() method documented in api-methods.mdx
- [ ] setInactivityTime() behavior documented in live-selection/customize-behavior.mdx
- [ ] commentBubbleClicked event documented with both React and Other Frameworks tabs
- [ ] commentCountType prop documented for VeltSidebarButton
- [ ] openDialog prop documented for VeltCommentBubble
- [ ] UnreadIcon wireframe subcomponents documented for all three components
- [ ] All code examples include React / Next.js and Other Frameworks tabs
- [ ] All data model links follow pattern: `/api-reference/sdk/models/data-models#anchor`
- [ ] All API method links follow pattern: `/api-reference/sdk/api/api-methods#anchor`
- [ ] No breaking changes flagged
- [ ] Log file written to `.claude/logs/agent-2-planning-4.6.7-beta.1.md`

## Notes for Agent-3
- Focus on data-models.mdx and api-methods.mdx updates first
- Ensure CommentCountType is added in Comment Sidebar section (around line 1227)
- CommentBubbleClickedEvent should be added after existing comment events (around line 60)
- Follow existing formatting patterns for events and types
- Maintain consistent table formatting for interface properties

## Notes for Agent-4
- Add setInactivityTime section to live-selection/customize-behavior.mdx
- Add commentBubbleClicked event documentation to comments/customize-behavior.mdx
- Add commentCountType prop documentation to comments-sidebar/customize-behavior.mdx
- Add openDialog prop documentation to comments/customize-behavior.mdx
- Follow existing section patterns in each file
- Ensure both React and Other Frameworks tabs are included

## Notes for Agent-5
- Create UnreadIcon subcomponent documentation for all three wireframe locations
- Update sidebar button overview to include UnreadIcon in structure
- Update comment bubble wireframe to include UnreadIcon section
- Follow existing wireframe documentation patterns
- Include proper image placeholder paths
