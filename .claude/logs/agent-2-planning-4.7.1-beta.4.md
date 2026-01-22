# Release Update Plan for 4.7.1-beta.4

## Overview
- Release Type: Patch
- Key Changes: Config-based resolver endpoints for self-hosting, notifications settings layout option
- Breaking Changes: No (fully backward compatible)

## Areas Requiring Updates

### 1. Data Models - New Types
- Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes: Add new `ResolverEndpointConfig` interface definition and update `ResolverConfig` interface with new config properties (getConfig, saveConfig, deleteConfig)
- Priority: High

### 2. Feature Documentation - Comments Self-Hosting
- Files: `/Users/yoenzhang/Downloads/docs/self-host-data/comments.mdx`
- Changes: Add config-based approach section showing getConfig/saveConfig/deleteConfig usage alongside existing custom method approach
- Priority: High

### 3. Feature Documentation - Reactions Self-Hosting
- Files: `/Users/yoenzhang/Downloads/docs/self-host-data/reactions.mdx`
- Changes: Add config-based approach section showing getConfig/saveConfig/deleteConfig usage alongside existing custom method approach
- Priority: High

### 4. Feature Documentation - Users Self-Hosting
- Files: `/Users/yoenzhang/Downloads/docs/self-host-data/users.mdx`
- Changes: Add config-based approach section showing getConfig usage with new request/response format (organizationId + userIds array)
- Priority: High

### 5. Feature Documentation - Notifications Setup
- Files: `/Users/yoenzhang/Downloads/docs/async-collaboration/notifications/setup.mdx`
- Changes: Add settingsLayout prop documentation for VeltNotificationsTool and VeltNotificationsPanel components
- Priority: Medium

### 6. UI Customization - Notifications Tool
- Files: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/notifications/notifications-tool.mdx`
- Changes: Add settingsLayout prop to component properties section
- Priority: Medium

### 7. UI Customization - Notifications Panel
- Files: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/notifications/notifications-panel.mdx`
- Changes: Add settingsLayout prop to component properties section
- Priority: Medium

## Implementation Sequence
1. Update data-models.mdx with ResolverEndpointConfig interface and ResolverConfig updates (Medium effort, foundational)
2. Update comments.mdx with config-based approach (Medium effort, depends on data models)
3. Update reactions.mdx with config-based approach (Medium effort, depends on data models)
4. Update users.mdx with config-based approach and new request format (Medium effort, depends on data models)
5. Update notifications setup.mdx with settingsLayout prop (Low effort, independent)
6. Update notifications-tool.mdx with settingsLayout prop (Low effort, independent)
7. Update notifications-panel.mdx with settingsLayout prop (Low effort, independent)

## Quality Checklist
- [ ] ResolverEndpointConfig interface added to data-models.mdx
- [ ] ResolverConfig interface updated with getConfig, saveConfig, deleteConfig properties in data-models.mdx
- [ ] Config-based approach documented in comments.mdx with VeltProvider and setDataProviders examples
- [ ] Config-based approach documented in reactions.mdx with VeltProvider and setDataProviders examples
- [ ] Config-based approach documented in users.mdx with new request/response format
- [ ] User resolver config-based request format shows organizationId + userIds structure
- [ ] Backward compatibility notes added to self-hosting docs
- [ ] settingsLayout prop documented in notifications setup.mdx
- [ ] settingsLayout prop documented in notifications-tool.mdx
- [ ] settingsLayout prop documented in notifications-panel.mdx
- [ ] Code examples include React and Other Frameworks tabs
- [ ] All examples show both VeltProvider and API method approaches where applicable
- [ ] Default values specified for settingsLayout ('accordion')
- [ ] Type definitions included (NotificationSettingsLayout = 'accordion' | 'dropdown')
- [ ] Log file written to `.claude/logs/agent-2-planning-4.7.1-beta.4.md`
