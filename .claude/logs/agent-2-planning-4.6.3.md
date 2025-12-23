# Release Update Plan for v4.6.3

## Overview
- Release Type: Patch
- Key Changes: New `expandOnSelection` prop for Comments Sidebar, `Velt.on` method support for data providers debugging
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models
- Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes:
  - Add new event type `DATA_PROVIDER` to Client Events table (section ~line 2055)
  - Add event name `dataProvider` with description: "Data Provider events for debugging get, save, and delete operations"
  - Add new `DataProviderEvent` interface similar to `PermissionProviderEvent`
  - Document sub-event types: `getTriggered`, `saveTriggered`, `deleteTriggered`, `getResult`, `saveResult`, `deleteResult`, `getError`, `saveError`, `deleteError`
- Priority: High

### 2. API Methods
No changes needed - event subscription uses existing `client.on()` / `Velt.on()` methods already documented.

### 3. Documentation - Comments Sidebar
- Files: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments-sidebar/customize-behavior.mdx`
- Changes:
  - Add `expandOnSelection` prop under UI section (after `dialogSelection` prop, ~line 558)
  - Document behavior: controls whether dialogs expand when selected in sidebar
  - Default value: `true` (inferred from feature description)
  - Add React example: `<VeltCommentsSidebar expandOnSelection={false} />`
  - Add HTML example: `<velt-comments-sidebar expand-on-selection="false"></velt-comments-sidebar>`
- Priority: High

### 4. Documentation - Self-Host Data
- Files:
  - `/Users/yoenzhang/Downloads/docs/self-host-data/overview.mdx`
  - `/Users/yoenzhang/Downloads/docs/self-host-data/comments.mdx`
  - `/Users/yoenzhang/Downloads/docs/self-host-data/reactions.mdx`
  - `/Users/yoenzhang/Downloads/docs/self-host-data/attachments.mdx`
  - `/Users/yoenzhang/Downloads/docs/self-host-data/users.mdx`
- Changes:
  - Add debugging section using `Velt.on('dataProvider')` for each provider type
  - Document event subscription pattern matching `permissionProvider` pattern
  - Show how to subscribe to all data provider events for debugging
  - Add examples for React and Other Frameworks tabs
- Priority: Medium

### 5. Documentation - Advanced Guide
- Files: `/Users/yoenzhang/Downloads/docs/get-started/advanced.mdx`
- Changes:
  - Add `dataProvider` to the list of available event subscriptions (near line 476)
  - Show example of subscribing to data provider events for debugging
- Priority: Low

### 6. Migration Guides
No migration guide needed - backward compatible additions only.

## Implementation Sequence
1. Add `DataProviderEvent` interface and event type to data-models.mdx (foundational types)
2. Add `expandOnSelection` prop to comments-sidebar/customize-behavior.mdx (feature documentation)
3. Add data provider debugging examples to self-host-data documentation files (usage patterns)
4. Add data provider event subscription to advanced.mdx (general reference)

## Quality Checklist
- [ ] `DATA_PROVIDER` event type added to Client Events table in data-models.mdx
- [ ] `DataProviderEvent` interface documented with all sub-event types
- [ ] `expandOnSelection` prop documented in Comments Sidebar customize-behavior
- [ ] Code examples include React and Other Frameworks tabs
- [ ] Default value for `expandOnSelection` documented (true)
- [ ] Data provider debugging section added to self-host-data/comments.mdx
- [ ] Data provider debugging section added to self-host-data/reactions.mdx
- [ ] Data provider debugging section added to self-host-data/attachments.mdx
- [ ] Data provider debugging section added to self-host-data/users.mdx
- [ ] Data provider event subscription example added to get-started/advanced.mdx
- [ ] Breaking changes documented: None
- [ ] Log file written to `.claude/logs/agent-2-planning-4.6.3.md`

## Notes
- `expandOnSelection` placement: under UI section in customize-behavior.mdx after `dialogSelection` prop
- Follow existing pattern for props: Props heading → Description → Default value → React/Other Frameworks tabs
- Data provider event subscription follows same pattern as `permissionProvider` event (already documented)
- Event payload structure should match resolver request/response patterns already documented
- Sub-event types should cover complete lifecycle: triggered → result/error
