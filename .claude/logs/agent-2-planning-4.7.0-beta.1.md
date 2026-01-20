# Release Update Plan for Version 4.7.0-beta.1

## Overview
- Release Type: Minor (Beta)
- Release Date: January 5, 2026
- Key Changes: New VeltCommentComposer props, VeltCommentsSidebar focus mode config, resolver moduleName enums
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models - NEW ENUMS ONLY
- Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes: Add three new resolver enum types with their values
  - `UserResolverModuleName` enum (5 values: IDENTIFY, GET_TEMPORARY_USERS, GET_USERS, GET_HUDDLE_USERS, GET_SINGLE_EDITOR_USERS)
  - `CommentResolverModuleName` enum (3 values: SET_DOCUMENTS, GET_COMMENT_ANNOTATIONS, GET_NOTIFICATIONS)
  - `ReactionResolverModuleName` enum (2 values: SET_DOCUMENTS, GET_REACTION_ANNOTATIONS)
- Priority: Medium
- Location: Add under existing resolver-related data models section

### 2. Component Documentation - NEW PROPS ONLY
- Files:
  - `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/standalone-components/comment-composer/setup.mdx`
  - `/Users/yoenzhang/Downloads/docs/async-collaboration/comments-sidebar/setup.mdx`
- Changes:
  - **VeltCommentComposer**: Document four new props (context, locationId, documentId, folderId)
  - **VeltCommentsSidebar**: Document new prop `openAnnotationInFocusMode` (requires `focusedThreadMode` enabled)
- Priority: High
- Pattern: Follow existing prop documentation format with React/Next.js and Other Frameworks tabs

### 3. Self-Host Data Documentation - ENHANCEMENT ONLY
- Files:
  - `/Users/yoenzhang/Downloads/docs/self-host-data/comments.mdx`
  - `/Users/yoenzhang/Downloads/docs/self-host-data/reactions.mdx`
  - `/Users/yoenzhang/Downloads/docs/self-host-data/users.mdx`
- Changes: Add brief note about `moduleName` parameter added to resolver callbacks for debugging
- Priority: Low
- Rationale: Improvement for debugging, not a required API change

## Areas NOT Requiring Updates

### Bug Fixes (No Documentation Impact)
- Inline comments read status fix - internal behavior fix
- Focused annotation clearing fix - internal behavior fix
- Notifications empty state fix - internal UI fix

These are bug fixes with no API changes, user-facing configuration changes, or new features requiring documentation.

## Implementation Sequence

1. **Data Models First** (Medium Priority)
   - Add three new enum types to data-models.mdx
   - Effort: 10 minutes

2. **Component Props** (High Priority)
   - Update VeltCommentComposer setup documentation
   - Update VeltCommentsSidebar setup documentation
   - Effort: 20 minutes

3. **Self-Host Enhancement** (Low Priority)
   - Add moduleName debugging notes to resolver documentation
   - Effort: 10 minutes

## Quality Checklist
- [ ] UserResolverModuleName enum added to data-models.mdx
- [ ] CommentResolverModuleName enum added to data-models.mdx
- [ ] ReactionResolverModuleName enum added to data-models.mdx
- [ ] VeltCommentComposer props documented (context, locationId, documentId, folderId)
- [ ] VeltCommentsSidebar openAnnotationInFocusMode prop documented
- [ ] moduleName debugging note added to self-host resolver docs
- [ ] Code examples include React/Next.js and Other Frameworks tabs
- [ ] No breaking changes flagged
- [ ] Planning log written to `.claude/logs/agent-2-planning-4.7.0-beta.1.md`

## Documentation Patterns to Follow

### Component Props Pattern
```markdown
### [Prop Name]
[Description]

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

### Enum Pattern (Data Models)
```markdown
#### [EnumName]
---

```typescript
export enum [EnumName] {
  KEY = 'value',
  // ...
}
```
```

## Notes for Agent-3
- VeltCommentComposer props enable passing organizational identifiers directly to standalone composer
- VeltCommentsSidebar prop enables opening comment dialog in focus mode when focusedThreadMode is active
- Resolver enums provide debugging visibility into which module triggered resolver calls
- All changes are additive; no breaking changes or deprecations
