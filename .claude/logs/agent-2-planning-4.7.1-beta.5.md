# Release Update Plan for 4.7.1-beta.5

## Overview
- Release Type: Patch
- Key Changes: Config-based attachment resolver endpoints for self-hosting
- Breaking Changes: No (fully backward compatible with existing custom method approach)

## Areas Requiring Updates

### 1. Feature Documentation - Attachments Self-Hosting
- Files: `/Users/yoenzhang/Downloads/docs/self-host-data/attachments.mdx`
- Changes: Add config-based approach section showing saveConfig/deleteConfig usage alongside existing custom method approach
- Priority: High

## Implementation Sequence
1. Update attachments.mdx with config-based approach section (Medium effort, follows pattern from comments/reactions docs)

## Quality Checklist
- [ ] Config-based approach section added to attachments.mdx showing both saveConfig and deleteConfig
- [ ] Section placed before or alongside existing custom method examples
- [ ] Config examples show VeltProvider and setDataProviders approaches
- [ ] Code examples include React and Other Frameworks tabs
- [ ] Multipart/form-data file upload handling documented for saveConfig
- [ ] JSON format documented for deleteConfig requests
- [ ] Backend endpoint examples updated to show config-based request handling
- [ ] Backward compatibility notes confirm existing save/delete methods still work
- [ ] ResolverEndpointConfig type references link to data-models.mdx
- [ ] Implementation Approaches section matches pattern from comments.mdx and reactions.mdx
- [ ] Log file written to `.claude/logs/agent-2-planning-4.7.1-beta.5.md`

## Notes
- Bug fixes (Notifications loading, Comments read status) require no documentation updates
- ResolverEndpointConfig and ResolverConfig types already exist in data-models.mdx (added in 4.7.1-beta.4)
- Follow existing pattern from comments.mdx and reactions.mdx for config-based sections
- Attachments use multipart/form-data for save operations (file uploads) unlike comments/reactions which use JSON
