# Release Update Plan for 4.6.0

## Overview
- Release Type: Minor
- Release Date: December 8, 2025
- Key Changes: New comment pin click event, read-only sidebar support, tabindex fix
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models
- Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes: Add `CommentPinClickedEvent` interface with annotationId, commentAnnotation, and metadata properties
- Priority: High
- Location: Add after other event types in Comments section (around line 50-70 area)

### 2. API Methods - Event Subscription
- Files: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
- Changes: Add `commentPinClicked` event to the event subscription table at line 2507-2540
- Priority: High
- Details:
  - Add new table row: `| UI | commentPinClicked | Triggered when comment pin is clicked | CommentPinClickedEvent |`
  - Insert in "UI" category, after existing UI events

### 3. React Hooks Documentation
- Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/react-hooks.mdx`
- Changes: Verify `useCommentEventCallback` hook documentation includes reference to new `commentPinClicked` event
- Priority: Medium
- Details: Hook already documented at line 147, just verify it links to customize-behavior.mdx event table

### 4. Comments Sidebar Component Documentation
- Files: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments-sidebar/customize-behavior.mdx`
- Changes: Add `readOnly` property documentation
- Priority: High
- Details:
  - Add new section documenting readOnly prop for VeltCommentsSidebar
  - Include React and Other Frameworks examples
  - Show both component prop and API method patterns (if available)

### 5. Comments Sidebar Setup
- Files: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments-sidebar/setup.mdx`
- Changes: Add optional readOnly prop example in setup code
- Priority: Low
- Details: Show readOnly in RequestExample section at bottom of file

## Implementation Sequence

1. Add `CommentPinClickedEvent` type to data-models.mdx (foundational)
2. Add `commentPinClicked` event row to event subscription table in comments/customize-behavior.mdx (depends on #1)
3. Add `readOnly` property section to comments-sidebar/customize-behavior.mdx (independent)
4. Update comments-sidebar/setup.mdx with readOnly example (optional enhancement)
5. Verify react-hooks.mdx links properly (verification only)

## Quality Checklist
- [ ] `CommentPinClickedEvent` interface added to data-models.mdx with all properties
- [ ] `commentPinClicked` event row added to event subscription table with correct link
- [ ] `readOnly` property documented in sidebar customize-behavior.mdx
- [ ] Code examples include both React/Next.js and Other Frameworks tabs
- [ ] Event type links to data-models.mdx using correct anchor pattern
- [ ] No breaking changes documented (this is non-breaking release)
- [ ] Tabindex fix NOT documented (no API changes, just bug fix)
- [ ] Log file written to `.claude/logs/agent-2-planning-4.6.0.md`

## Notes

**Not Requiring Updates**:
- Tabindex behavior fix: No API changes, purely internal behavior improvement
- API methods documentation: `commentElement.on()` already documented, just adding new event type
- UI Customization docs: No new wireframes or styling changes

**Pattern Compliance**:
- Event table entry must link to data model: `[CommentPinClickedEvent](/api-reference/sdk/models/data-models#commentpinclickedevent)`
- Tabs ordering: React / Next.js first, Other Frameworks second
- Heading structure: Follow existing event documentation patterns in customize-behavior.mdx
