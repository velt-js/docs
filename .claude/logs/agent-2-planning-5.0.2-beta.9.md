# Release Update Plan for v5.0.2-beta.9

## Overview
- Release Type: Minor
- Key Changes: Comments Sidebar V2 (new primitive-component-based sidebar with full wireframe support), Notification Resolver (custom PII management via NotificationDataProvider), `version` prop on VeltCommentsSidebar, `additionalFields` on CommentAnnotationDataProvider.config, `agentFields` filter on CommentRequestQuery
- Breaking Changes: No

---

## Areas Requiring Updates

### 1. Data Models
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Priority: High

**a. Add `notification` field to `VeltDataProvider` table** (existing type — field missing, currently ends at `anonymousUser`)

Add row after the `recorder` row (line 3829):
`| notification | NotificationDataProvider | No | Provider for notification PII data |`

**b. Add `NotificationDataProvider` type** (new type — does not exist)

Insert after `RecorderAnnotationDataProvider` block (around line 3973). Fields:
- `get?: (request: GetNotificationResolverRequest) => Promise<ResolverResponse<Record<string, PartialNotification>>>` — Fetch notification data from your backend
- `delete?: (request: DeleteNotificationResolverRequest) => Promise<ResolverResponse<undefined>>` — Delete notification data from your backend
- `config?: NotificationResolverConfig` — Configuration for the data provider

**c. Add `NotificationResolverConfig` type** (new type — does not exist)

Insert after `NotificationDataProvider`. Fields:
- `resolveTimeout?: number` — Timeout in milliseconds for resolver operations
- `getRetryConfig?: RetryConfig` — Retry configuration for get operations

**d. Add `GetNotificationResolverRequest` type** (new type — does not exist)

Insert after `NotificationResolverConfig`. Fields:
- `organizationId: string` — ID of the organization
- `notificationIds: string[]` — Array of notification IDs to fetch

**e. Add `DeleteNotificationResolverRequest` type** (new type — does not exist)

Insert after `GetNotificationResolverRequest`. Fields:
- `notificationId: string` — ID of the notification to delete
- `organizationId: string` — ID of the organization

**f. Add `PartialNotification` type** (new type — does not exist)

Insert after `DeleteNotificationResolverRequest`. Note: fields mirror the `Notification` model; mark all as optional. Fields include at minimum:
- `id?: string`
- `notificationSource?: string`
- `actionType?: string`
- `isUnread?: boolean`
- `actionUser?: User`
- `timestamp?: number`
- `displayHeadlineMessage?: string`
- `displayBodyMessage?: string`
- `notificationSourceData?: any`

**g. Add `isNotificationResolverUsed` field to `Notification` table** (existing type — field missing, at line 2534)

Add row:
`| isNotificationResolverUsed | boolean | No | True when the notification was enriched via the notification resolver |`

**h. Add `additionalFields` to `CommentAnnotationDataProvider`-specific config** (existing `ResolverConfig` at line 3841 already has `additionalFields` — verify this covers the comment resolver or add a note in `CommentAnnotationDataProvider` description clarifying that `config.additionalFields` copies fields to the resolver endpoint but retains them in Velt DB)

No new row needed in `ResolverConfig` — `additionalFields` already exists there (line 3854). Only documentation note/description clarification is needed if the current description does not distinguish "copies to resolver but retained in Velt DB" vs recorder's behavior.

**i. Add `agentFields` to `CommentRequestQuery` table** (existing type — field missing, currently ends at `debounceMs` at line 327)

Add row after `debounceMs`:
`| agentFields | string[] | No | Filters comment count queries to annotations where agent.agentFields contains any provided value; when set, unread count is treated as equal to total count |`

**j. Add `VeltCommentsSidebarV2Props` type** (new type — does not exist; `VeltCommentsSidebarProps` at line 2145 covers V1 only)

Insert after `VeltCommentsSidebarProps` block. Fields:
- `pageMode?: boolean` — Enable page-mode composer
- `focusedThreadMode?: boolean` — Enable focused-thread view on comment click
- `readOnly?: boolean` — Enable read-only mode
- `position?: string` — Sidebar position (e.g., `'right'`, `'left'`)
- `variant?: string` — Sidebar variant (e.g., `'sidebar'`, `'inline'`)
- `forceClose?: boolean` — Force-close the sidebar
- `version?: string` — When `"2"`, routes `VeltCommentsSidebar` to the V2 implementation (prop on existing `VeltCommentsSidebar`)
- `onSidebarOpen?: (data: any) => void` — Callback when sidebar opens
- `onSidebarClose?: (data: any) => void` — Callback when sidebar closes
- `onCommentClick?: (data: any) => void` — Callback when a comment is clicked
- `onCommentNavigationButtonClick?: (data: any) => void` — Callback when nav button is clicked

Also update existing `VeltCommentsSidebarProps` table to add `version` prop:
`| version | string | No | When set to "2", renders the V2 sidebar implementation |`

---

### 2. API Methods
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Priority: Medium

**a. No new methods added.** `setDataProviders()` (line 2951) already covers the `VeltDataProvider` param which now includes `notification`. No new method entry needed — the existing entry's param link points to `VeltDataProvider` which Agent-3 will update.

No additional api-methods.mdx changes required.

---

### 3. Documentation — New Pages Required

**a. New self-host-data page: Notifications**
- File: `/Users/yoenzhang/Downloads/docs/self-host-data/notifications.mdx` (new file)
- Priority: High
- Create following same pattern as `/Users/yoenzhang/Downloads/docs/self-host-data/recordings.mdx`. Cover:
  - What PII is managed (notification content, custom notification data)
  - Only `notificationSource === 'custom'` notifications are routed through the resolver
  - Resolution pipeline order: notification → user → comment
  - Setup via `setDataProviders({ notification: NotificationDataProvider })`
  - Code examples with React/Next.js and Other Frameworks tabs (use release note code blocks verbatim)
  - `isNotificationResolverUsed` field on `Notification` for downstream detection
  - Link anchor: `/self-host-data/notifications`
- Also update `/Users/yoenzhang/Downloads/docs/self-host-data/overview.mdx` to add a bullet: `**Notifications**: Manage custom notification PII from your own backend using get and delete handlers`
- Also update `/Users/yoenzhang/Downloads/docs/docs.json` to add `"self-host-data/notifications"` in the self-host nav group (after `"self-host-data/recordings"`)

**b. New async-collaboration pages: Comments Sidebar V2 setup and customize-behavior**
- Files:
  - `/Users/yoenzhang/Downloads/docs/async-collaboration/comments-sidebar/setup-v2.mdx` (new file) — OR — add a V2 section to existing `/Users/yoenzhang/Downloads/docs/async-collaboration/comments-sidebar/setup.mdx`
  - Preference: add a `## V2 Setup` section to existing `setup.mdx` with the V2 component snippet and `version="2"` shortcut
- Priority: High
- Cover: importing `VeltCommentsSidebarV2`, using `version="2"` on existing `VeltCommentsSidebar`, props list referencing `VeltCommentsSidebarV2Props`
- Add to `customize-behavior.mdx` in the same folder: a V2 section covering the unified filter model and CDK virtual scroll behavior differences from V1

---

### 4. UI Customization — New Wireframe Documentation
- Priority: High

**a. New Comments Sidebar V2 components reference page**
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-sidebar-components-v2.mdx` (new file)
- Pattern: mirror `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-sidebar-components.mdx`
- Include full wireframe for `VeltCommentsSidebarV2Wireframe` showing all 27+ primitives with React/Next.js and Other Frameworks tabs (use release note code block verbatim)

**b. New Comments Sidebar V2 structure page**
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-sidebar-structure-v2.mdx` (new file)
- Pattern: mirror `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-sidebar-structure.mdx`
- Document the V2 primitive hierarchy: `VeltCommentsSidebarV2Wireframe` → `Panel` → `Header` → `MinimalActionsDropdown` (Trigger / Content / Content.MarkAllRead / Content.MarkAllResolved), `FilterDropdown` (Trigger / Content / Content.List / Content.List.Item / Content.List.Item.Indicator / Content.List.Item.Label / Content.List.Category / Content.List.Category.Content), `List`, `EmptyPlaceholder` (ResetFilterButton), `PageModeComposer`, `FocusedThread` (BackButton / DialogContainer); also `Skeleton`
- Mark leaf nodes per existing convention

**c. Update `docs.json` navigation** to add V2 sidebar customization entries in the ui-customization section. Follow existing sidebar entries pattern. Verify link pattern: `/ui-customization/features/async/comments/comment-sidebar-components-v2` and `/ui-customization/features/async/comments/comment-sidebar-structure-v2`.

**NOTE**: The release note references `[UI Customization docs](#TODO-confirm-doc-link)` — the above files fulfill that placeholder. Agent-3 should NOT invent a different path.

---

### 5. Migration Guides
- Not applicable. No breaking changes.

---

## Implementation Sequence

1. `data-models.mdx`: Add `notification` to `VeltDataProvider`, add `isNotificationResolverUsed` to `Notification`, add `agentFields` to `CommentRequestQuery`, add `version` to `VeltCommentsSidebarProps`, add `VeltCommentsSidebarV2Props`. (No prerequisites)
2. `data-models.mdx`: Add five new notification resolver types: `NotificationDataProvider`, `NotificationResolverConfig`, `GetNotificationResolverRequest`, `DeleteNotificationResolverRequest`, `PartialNotification`. (Prerequisite: step 1 complete so `VeltDataProvider` anchor exists)
3. `self-host-data/overview.mdx`: Add Notifications bullet. (No prerequisites)
4. `self-host-data/notifications.mdx`: Create new page with setup code, resolver pipeline explanation, `isNotificationResolverUsed` note. (Prerequisite: step 2 — types must exist in data-models)
5. `docs.json`: Add `"self-host-data/notifications"` to nav. (Prerequisite: step 4)
6. `async-collaboration/comments-sidebar/setup.mdx`: Add V2 Setup section. (Prerequisite: step 1 — VeltCommentsSidebarV2Props must exist)
7. `async-collaboration/comments-sidebar/customize-behavior.mdx`: Add V2 section covering unified filter model. (Prerequisite: step 6)
8. `ui-customization/features/async/comments/comment-sidebar-structure-v2.mdx`: Create V2 structure page. (No prerequisites)
9. `ui-customization/features/async/comments/comment-sidebar-components-v2.mdx`: Create V2 components page with full wireframe. (Prerequisite: step 8)
10. `docs.json`: Add V2 sidebar UI customization entries to nav. (Prerequisite: steps 8–9)

---

## Quality Checklist
- [ ] `notification` field added to `VeltDataProvider` table in `data-models.mdx`
- [ ] `isNotificationResolverUsed` added to `Notification` table in `data-models.mdx`
- [ ] `agentFields` added to `CommentRequestQuery` table in `data-models.mdx`
- [ ] `version` prop added to `VeltCommentsSidebarProps` in `data-models.mdx`
- [ ] `VeltCommentsSidebarV2Props` type added to `data-models.mdx`
- [ ] All five notification resolver types added to `data-models.mdx`: `NotificationDataProvider`, `NotificationResolverConfig`, `GetNotificationResolverRequest`, `DeleteNotificationResolverRequest`, `PartialNotification`
- [ ] `self-host-data/notifications.mdx` created with dual-tab code examples
- [ ] `self-host-data/overview.mdx` updated with Notifications bullet
- [ ] `docs.json` updated with `self-host-data/notifications` nav entry
- [ ] `async-collaboration/comments-sidebar/setup.mdx` updated with V2 setup section
- [ ] `async-collaboration/comments-sidebar/customize-behavior.mdx` updated with V2 behavior section
- [ ] `comment-sidebar-structure-v2.mdx` created with full V2 primitive hierarchy
- [ ] `comment-sidebar-components-v2.mdx` created with full wireframe code (React + Other Frameworks tabs)
- [ ] `docs.json` updated with V2 ui-customization nav entries
- [ ] `#TODO-confirm-doc-link` placeholder resolved to `/ui-customization/features/async/comments/comment-sidebar-components-v2`
- [ ] Code examples use React/Next.js first, Other Frameworks second tab order throughout
- [ ] No breaking change migration guide needed (confirmed)
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.9.md`
