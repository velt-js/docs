# Release Update Plan for v5.0.0-beta.12

## Overview
- Release Type: Minor (Beta)
- Release Date: February 6, 2026
- Key Changes: Local UI state management, sidebar grouping enhancements, lightbox integration, UI improvements
- Breaking Changes: Yes - dialogInstanceId parameter required for scoped state operations

## Areas Requiring Updates

### 1. Data Models - NEW INTERFACE AND PARAMETERS
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes:
  - Add `LocalUIState` interface for per-instance comment dialog state
  - Add `dialogInstanceId` parameter documentation for action service methods
  - Update relevant event types if LocalUIState is exposed in events
- Priority: High
- Effort: 15 minutes

### 2. API Methods - dialogInstanceId PARAMETER ADDITION
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Changes:
  - Update CommentDialogActionService method signatures to include `dialogInstanceId` parameter
  - Methods affected: state management operations (edit mode, composer content, attachments)
  - Add parameter documentation for scoped state control
- Priority: High
- Effort: 20 minutes

### 3. Comments Sidebar - UNASSIGNED/UNTAGGED GROUPS
- File: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments-sidebar/customize-behavior.mdx`
- Changes:
  - Document new "Unassigned" and "Untagged" groups in group-by views
  - Add behavior description for annotations without assignees/tags
  - Update grouping examples to show new default groups
- Priority: Medium
- Effort: 10 minutes

### 4. UI Customization - LIGHTBOX AND ATTACHMENTS
- Files:
  - `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-structure.mdx`
  - `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`
- Changes:
  - Document snippyly-lightbox integration for image attachment previews
  - Document 200px max height for attachments container with scroll behavior
  - Add visual examples showing lightbox preview functionality
- Priority: Medium
- Effort: 15 minutes

### 5. Comment Dialog Behavior - LOCAL STATE TRACKING
- File: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
- Changes:
  - Document composerInOpenState tracking
  - Document localRecordedData state management
  - Document recording state determination logic (panelId/annotationId comparison)
- Priority: Low
- Effort: 10 minutes

## Areas NOT Requiring Updates

### Bug Fixes (Internal Changes)
- User mention @ prefix fix - internal implementation detail
- Org ID fallback logic - internal data handling
- Recorder control panel visibility - internal state management
- Comment dialog selector tag change - internal component architecture
- Options/sidebar mode fixes - behavior correction without API changes

## Implementation Sequence

1. **Data Models** (High Priority)
   - Add LocalUIState interface definition
   - Add dialogInstanceId parameter documentation
   - Effort: 15 minutes

2. **API Methods** (High Priority)
   - Update action service method signatures with dialogInstanceId
   - Document scoped state control pattern
   - Effort: 20 minutes
   - Dependency: Requires LocalUIState from step 1

3. **Comments Sidebar** (Medium Priority)
   - Add Unassigned/Untagged group documentation
   - Update grouping behavior examples
   - Effort: 10 minutes

4. **UI Customization** (Medium Priority)
   - Document lightbox integration for images
   - Document attachments container height limit
   - Effort: 15 minutes

5. **Comment Dialog Behavior** (Low Priority)
   - Document local state tracking properties
   - Document recording state logic
   - Effort: 10 minutes

## Breaking Changes

### dialogInstanceId Parameter
- **What Changed**: Action service methods now require `dialogInstanceId` for scoped state operations
- **Migration Required**: Yes
- **Impact**: Developers using CommentDialogActionService must update method calls
- **Documentation Needed**: Migration guide section in release note

## Quality Checklist
- [ ] LocalUIState interface added to data-models.mdx
- [ ] dialogInstanceId parameter documented in data-models.mdx
- [ ] Action service methods updated with dialogInstanceId in api-methods.mdx
- [ ] Unassigned/Untagged groups documented in comments-sidebar/customize-behavior.mdx
- [ ] Lightbox integration documented in comment-dialog UI customization
- [ ] Attachments container height limit documented
- [ ] Local state tracking documented in comments/customize-behavior.mdx
- [ ] Code examples include React/Next.js and Other Frameworks tabs
- [ ] Breaking changes documented with migration guidance
- [ ] Planning log written to `.claude/logs/agent-2-planning-5.0.0-beta.12.md`

## Documentation Patterns to Follow

### LocalUIState Interface Pattern (data-models.mdx)
```markdown
#### LocalUIState
---

| Property              | Type      | Required | Description                                           |
|-----------------------|-----------|----------|-------------------------------------------------------|
| `isEditMode`          | `boolean` | No       | Whether dialog instance is in edit mode               |
| `composerContent`     | `string`  | No       | Current composer text content for this instance       |
| `attachments`         | `any[]`   | No       | Attachments array for this dialog instance            |
| `composerInOpenState` | `boolean` | No       | Whether composer is in open state                     |
| `localRecordedData`   | `any`     | No       | Local recorded data for this dialog instance          |
```

### Action Service Method Pattern (api-methods.mdx)
```markdown
#### setEditMode
- Params: `dialogInstanceId: string`, `isEditMode: boolean`
- Sets edit mode for specific dialog instance
- Scoped to dialogInstanceId for per-instance state control
```

### Sidebar Grouping Pattern (comments-sidebar/customize-behavior.mdx)
```markdown
## Group-by Views

When grouping by assignee or tagged users, the sidebar automatically displays:
- **Unassigned**: Annotations without assigned users
- **Untagged**: Annotations without tagged users
```

## Notes for Agent-3

### New Type Introduction
LocalUIState is a new public interface requiring full documentation in data-models.mdx.

### Breaking Change Handling
dialogInstanceId parameter is a breaking change requiring careful migration documentation.

### Cross-Reference Strategy
- Link dialogInstanceId parameter docs to LocalUIState interface
- Link action service methods to local state management concepts
- Link lightbox docs to attachments documentation

### Pattern Consistency
Follow existing action service method documentation patterns in api-methods.mdx.
