# Release Update Plan for v5.0.2-beta.15

## Overview
- Release Type: Minor (feature additions + bug fixes)
- Key Changes: 60+ new notification primitive components for VeltNotificationsPanel and VeltNotificationsTool; template forwarding for list primitives; 6 bug fixes (no API changes)
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models (new shared props type for notification primitives)
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes: Add `NotificationsPrimitiveCommonProps` section (analogous to `CommentDialogCommonProps`) documenting the four shared inputs all notification primitives accept: `variant`, `darkMode`, `shadowDom`, `parentLocalUIState`. Link to the new primitives overview page.
- Priority: High

### 2. API Methods
- No new SDK methods or hooks introduced. No update required.

### 3. New Documentation — Notification Primitives Overview Page
- File to create: `ui-customization/features/async/notifications/notifications-panel-primitives/overview.mdx`
  - This is the page the changelog already links to: `/ui-customization/features/async/notifications/notifications-panel-primitives/overview`
  - Model after `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog/primitives.mdx`
  - Must cover:
    - Overview section: standalone usage pattern (not nested), all primitives accept `variant`, `darkMode`, `shadowDom`, `parentLocalUIState`
    - Common Inputs table (link to `NotificationsPrimitiveCommonProps` in data-models.mdx)
    - Tool primitives section: `VeltNotificationsToolIcon`, `VeltNotificationsToolUnreadIcon`, `VeltNotificationsToolLabel`, `VeltNotificationsToolUnreadCount` (4 components)
    - Panel primitives section (56+ components): Title, Header tabs (ForYou/All), Content sections (ForYou/All/People/Documents), List items per section, Settings, Settings Accordion, Skeleton, and all sub-items
    - Template forwarding note for list-type primitives (`[listItemTemplate]`, `[itemTemplate]`, `[triggerTemplate]`)
    - React / Next.js and Other Frameworks tabs on all code examples
- Priority: High

### 4a. UI Customization — Wireframes
- No new wireframes introduced. Existing wireframes in `notifications-panel.mdx` and `notifications-tool.mdx` are unchanged.
- No update required.

### 4b. UI Customization — Primitives (new page, not an update to existing)
- The new page IS the primitives page described in Section 3 above.
- NOTE: The new primitives page lives at `ui-customization/features/async/notifications/notifications-panel-primitives/overview.mdx` — a new subdirectory.
- Priority: High

### 5. Navigation (docs.json)
- File: `/Users/yoenzhang/Downloads/docs/docs.json`
- Changes: Add the new primitives page to the notifications UI customization nav group. Current entries at lines 379–380 are:
  ```
  "ui-customization/features/async/notifications/notifications-tool",
  "ui-customization/features/async/notifications/notifications-panel"
  ```
  Add after these:
  ```
  "ui-customization/features/async/notifications/notifications-panel-primitives/overview"
  ```
  Follow the pattern used for comment-dialog primitives (line 343) and activity-logs-primitives (line 411).
- Priority: High

### 6. Upgrade Guide
- No breaking changes. No update required.

## Implementation Sequence
1. Create `NotificationsPrimitiveCommonProps` type entry in `data-models.mdx` — needed as a link target for the primitives page.
2. Create new file `ui-customization/features/async/notifications/notifications-panel-primitives/overview.mdx` with all 60+ primitive components documented using React/Other Frameworks tabs.
3. Add new page path to `docs.json` nav under the notifications UI customization group.

## Quality Checklist
- [ ] `NotificationsPrimitiveCommonProps` added to data-models.mdx with link to new primitives page
- [ ] New primitives overview page created at correct path matching changelog link target
- [ ] All 4 Tool primitives documented
- [ ] All 56+ Panel primitives documented (Title, Header tabs, Content per-tab lists, Settings, Accordion, Skeleton)
- [ ] Template forwarding behavior noted on list-type primitives
- [ ] Code examples include React / Next.js and Other Frameworks tabs
- [ ] docs.json updated with new page path
- [ ] No breaking changes added to changelog (none exist in this release)
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.15.md`
