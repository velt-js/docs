# Release Update Plan for Version 4.7.1-beta.1

## Overview
- Release Type: Patch (Beta)
- Release Date: January 12, 2026
- Key Changes: REST API `elementId` support, Comments autocomplete scroll config, sidebar props for control and filtering, notifications pageSize prop
- Breaking Changes: No

## Areas Requiring Updates

### 1. REST API Documentation - PARAMETER DESCRIPTION UPDATE
- Files: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/comments-feature/comment-annotations/add-comment-annotations.mdx`
- Changes: Enhance `targetElement.elementId` description to clarify text search boundary functionality
- Priority: High
- Current State: Parameter exists at line 66-68 but description is minimal ("Element DOM Id")
- Required Action: Update description to explain that when used with `targetText`, `elementId` defines text search boundaries for text comments
- Effort: 5 minutes

### 2. Data Models - NEW TYPE ONLY
- Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes: Add `AutoCompleteScrollConfig` interface with four properties
  - `itemSize`: number (height of each item in pixels)
  - `minBufferPx`: number (minimum buffer in pixels)
  - `maxBufferPx`: number (maximum buffer in pixels)
  - `templateCacheSize`: number (cache size for templates)
- Priority: High
- Location: Add in data models section with other configuration interfaces
- Effort: 5 minutes

### 3. Comments Documentation - NEW PROPS ONLY
- Files:
  - `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
  - `/Users/yoenzhang/Downloads/docs/async-collaboration/comments-sidebar/customize-behavior.mdx`
- Changes:
  - **Comments autocomplete**: Document `autoCompleteScrollConfig` prop for VeltComments component
  - **Comments Sidebar**: Document four new props (`forceClose`, `sortOrder`, `sortBy`, `defaultMinimalFilter`)
- Priority: High
- Pattern: Follow existing prop documentation with React/Next.js and Other Frameworks tabs

### 4. Notifications Documentation - NEW PROP ONLY
- Files: `/Users/yoenzhang/Downloads/docs/async-collaboration/notifications/customize-behavior.mdx`
- Changes: Document `pageSize` prop for VeltNotificationsPanel and VeltNotificationsTool components
- Priority: High
- Location: Add in Configuration section after existing props

## Areas NOT Requiring Updates

### Improvements (No New Public APIs)
- Context data passed to dialog from sidebar - internal improvement, no new API surface
- Notification text truncation - UI improvement only
- `velt-confirm-dialog-overlay-pane` class - styling class only, already available

### Bug Fixes (No Documentation Impact)
- Script tag search highlighting - internal behavior fix
- Sidebar tooltip z-index - UI fix
- Autocomplete chip height - UI fix
- Edit mode persistence - internal state fix
- Notifications panel settings wireframe mapping - internal fix

These are internal improvements and bug fixes with no new public APIs requiring documentation.

## Implementation Sequence

1. **REST API Documentation** (High Priority)
   - Update elementId description in /v2/commentannotations/add endpoint
   - Effort: 5 minutes

2. **Data Models First** (High Priority)
   - Add AutoCompleteScrollConfig interface to data-models.mdx
   - Effort: 5 minutes

3. **Comments Props** (High Priority)
   - Add autoCompleteScrollConfig to comments/customize-behavior.mdx
   - Add forceClose, sortOrder, sortBy, defaultMinimalFilter to comments-sidebar/customize-behavior.mdx
   - Effort: 15 minutes

4. **Notifications Props** (High Priority)
   - Add pageSize to notifications/customize-behavior.mdx
   - Effort: 5 minutes

## Quality Checklist
- [ ] Updated elementId description in REST API /v2/commentannotations/add endpoint
- [ ] AutoCompleteScrollConfig interface added to data-models.mdx
- [ ] autoCompleteScrollConfig prop documented in comments/customize-behavior.mdx
- [ ] forceClose prop documented in comments-sidebar/customize-behavior.mdx
- [ ] sortOrder prop documented in comments-sidebar/customize-behavior.mdx
- [ ] sortBy prop documented in comments-sidebar/customize-behavior.mdx
- [ ] defaultMinimalFilter prop documented in comments-sidebar/customize-behavior.mdx
- [ ] pageSize prop documented for VeltNotificationsPanel in notifications/customize-behavior.mdx
- [ ] pageSize prop documented for VeltNotificationsTool in notifications/customize-behavior.mdx
- [ ] Code examples include React/Next.js and Other Frameworks tabs
- [ ] No breaking changes flagged
- [ ] Planning log written to `.claude/logs/agent-2-planning-4.7.1-beta.1.md`

## Documentation Patterns to Follow

### Component Props Pattern
```markdown
#### [propName]
[Description]

Default: `[value]` (if applicable)

<Tabs>
<Tab title="React / Next.js">
```jsx
[React example]
```
</Tab>
<Tab title="Other Frameworks">
```html
[HTML example]
```
</Tab>
</Tabs>
```

### Data Model Interface Pattern
```markdown
#### [InterfaceName]
---

```typescript
export interface [InterfaceName] {
  propertyName: type; // description
  // ...
}
```
```

## Specific Documentation Updates

### 1. elementId in REST API (add-comment-annotations.mdx)
- Section: targetElement object in Body parameters
- Current: "Element DOM Id" (line 66-68)
- Updated Description: "Element DOM Id. When used with `targetText`, defines the text search boundaries for locating text comments within the specified element."
- No new examples needed: existing example already demonstrates usage pattern (lines 242-246)

### 2. AutoCompleteScrollConfig (data-models.mdx)
- Add new interface definition
- Include all four properties with type annotations
- Add brief description of purpose (virtual scroll behavior in autocomplete)

### 2. autoCompleteScrollConfig (comments/customize-behavior.mdx)
- Section: Add after existing VeltComments configuration props
- Description: "Customize virtual scroll behavior in autocomplete dropdown"
- Type reference: Link to AutoCompleteScrollConfig in data-models
- Examples: Show all four properties (itemSize, minBufferPx, maxBufferPx, templateCacheSize)

### 4. Sidebar Props (comments-sidebar/customize-behavior.mdx)
- **forceClose**: Boolean prop to programmatically close sidebar
- **sortOrder**: String prop with values "asc" or "desc" for default sort order
- **sortBy**: String prop with values "createdAt" or "lastUpdated" for sort field
- **defaultMinimalFilter**: String prop for default minimal filter setting
- Add in UI or System Filters section based on prop purpose
- Note: sortBy and sortOrder already exist for VeltInlineCommentsSection, follow that pattern

### 5. pageSize (notifications/customize-behavior.mdx)
- Section: Configuration (after existing props like tabConfig, considerAllNotifications)
- Description: "Control initial notification load count"
- Type: number
- Default: Document the default value if available in release note
- Examples: Show usage on both VeltNotificationsPanel and VeltNotificationsTool

## Notes for Agent-3
- REST API elementId improvement clarifies text search boundary functionality when used with targetText
- autoCompleteScrollConfig enables fine-tuning of virtual scroll performance in comments autocomplete
- Sidebar props provide more control over default UI state and sorting behavior
- pageSize prop optimizes initial notification load performance
- Context data improvement is internal; no new APIs to document
- All changes are additive; no breaking changes or deprecations
- Follow existing patterns for sortBy/sortOrder documentation (already exists for VeltInlineCommentsSection)
