# Release Update Plan for v5.0.0-beta.13

## Overview
- Release Type: Minor (New Feature)
- Key Changes: Organization-level notification settings feature
- Breaking Changes: No

## Areas Requiring Updates

### 1. API Methods (`/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`)
Add two new NotificationElement methods under the "Notification Settings" section (after line 1519):

**Methods to add:**
- `enableSettingsAtOrganizationLevel()`: Enable organization-level notification settings mode
- `disableSettingsAtOrganizationLevel()`: Disable organization-level notification settings mode

**Priority:** High

**Changes:**
```markdown
#### enableSettingsAtOrganizationLevel()
Enable organization-level notification settings. When enabled, settings apply to all documents in the organization instead of per-document. Requires `settings={true}` and `addUserInfoToOrganization` proxy.
- Params: none
- Returns: `void`
- React Hook: `n/a`
- [Full Documentation →](/async-collaboration/notifications/customize-behavior#enablesettingsatorganizationlevel)

#### disableSettingsAtOrganizationLevel()
Disable organization-level notification settings. Settings revert to per-document configuration.
- Params: none
- Returns: `void`
- React Hook: `n/a`
- [Full Documentation →](/async-collaboration/notifications/customize-behavior#disablesettingsatorganizationlevel)
```

### 2. Documentation - Customize Behavior (`/Users/yoenzhang/Downloads/docs/async-collaboration/notifications/customize-behavior.mdx`)
Add new section after `enableSettings`/`disableSettings` section (after line 753).

**Section to add:** `enableSettingsAtOrganizationLevel`

**Priority:** High

**Changes:**
Add API documentation for enabling/disabling org-level settings with code examples in both React and Other Frameworks tabs. Include:
- Method signatures
- Description: org-level vs document-level behavior
- Requirements: `settings={true}`, `addUserInfoToOrganization` proxy
- Code examples showing both API and component prop usage

### 3. Documentation - Setup (`/Users/yoenzhang/Downloads/docs/async-collaboration/notifications/setup.mdx`)
Update Step 4 "Enable Notification Settings for Users" (line 70-119).

**Priority:** Medium

**Changes:**
- Update warning box to mention organization-level option
- Add note about org-level settings requiring `addUserInfoToOrganization` proxy
- Update code examples to show `enableSettingsAtOrganizationLevel` prop usage alongside existing `settings` prop

### 4. UI Customization - Notifications Panel (`/Users/yoenzhang/Downloads/docs/ui-customization/features/async/notifications/notifications-panel.mdx`)
Add new prop documentation.

**Priority:** Low

**Changes:**
Add `enableSettingsAtOrganizationLevel` prop documentation (boolean or string) with React and HTML examples showing usage with `settings={true}`.

### 5. UI Customization - Notifications Tool (`/Users/yoenzhang/Downloads/docs/ui-customization/features/async/notifications/notifications-tool.mdx`)
Add new prop documentation.

**Priority:** Low

**Changes:**
Add `enableSettingsAtOrganizationLevel` prop documentation (boolean or string) with React and HTML examples showing usage with `settings={true}`.

## Implementation Sequence
1. Update API Methods documentation (High priority, no dependencies)
2. Update Customize Behavior documentation (High priority, references API Methods)
3. Update Setup documentation (Medium priority, references Customize Behavior)
4. Update UI Customization Panel documentation (Low priority, references Customize Behavior)
5. Update UI Customization Tool documentation (Low priority, references Customize Behavior)

## Quality Checklist
- [ ] New API methods added to api-methods.mdx under Notification Settings section
- [ ] Full documentation added to customize-behavior.mdx with code examples
- [ ] Setup guide updated to mention org-level option and requirements
- [ ] Notifications Panel wireframe docs include new prop
- [ ] Notifications Tool wireframe docs include new prop
- [ ] All code examples include both React / Next.js and Other Frameworks tabs
- [ ] Warning about `addUserInfoToOrganization` proxy requirement included
- [ ] Requirement to use `settings={true}` with org-level feature clearly stated
- [ ] Links between documentation pages use correct anchor patterns
- [ ] Log file written to `/Users/yoenzhang/Downloads/docs/.claude/logs/agent-2-planning-v5.0.0-beta.13.md`
