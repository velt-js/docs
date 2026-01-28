# Release Update Plan for 5.0.0-beta.7

## Overview
- Release Type: Beta (Minor)
- Key Changes: New comment annotation draft event, context provider method improvements
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models
Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
Changes:
- Add `AddCommentAnnotationDraftEvent` interface in Comments > Threads section
- Add `CommentContextProviderResponse` type definition
- Add `CommentContextProvider` type definition
- Add `addCommentAnnotationDraft` to event enum table
Priority: High

### 2. API Methods
Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
Changes:
- Add `setContextProvider()` method under Comments > Threads section
Priority: High

### 3. React Hooks
Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/react-hooks.mdx`
Changes:
- Add `useSetContextProvider()` hook under Comments > Threads section
Priority: High

### 4. Documentation - Main Feature Docs
Files: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
Changes:
- Add `addCommentAnnotationDraft` event to Event Subscription table (line ~2613)
- Add `setContextProvider()` method documentation in Threads section with React Hook and API Method examples
Priority: High

### 5. Snippets
Files: `/Users/yoenzhang/Downloads/docs/snippets/comments-methods-json.mdx`
Changes:
- Verify `setContextProvider` entry exists at line 451-456 (already present, no update needed)
Priority: Low

## Implementation Sequence
1. Update data-models.mdx: Add AddCommentAnnotationDraftEvent interface and type definitions (15 min)
2. Update api-methods.mdx: Add setContextProvider method entry (10 min)
3. Update react-hooks.mdx: Add useSetContextProvider hook entry (10 min)
4. Update customize-behavior.mdx: Add addCommentAnnotationDraft to event table and setContextProvider method docs (25 min)

## Quality Checklist
- [ ] AddCommentAnnotationDraftEvent interface added with annotationId, addContext function, and metadata properties
- [ ] CommentContextProviderResponse type added (CommentContext | null | undefined)
- [ ] CommentContextProvider type added with documentId and location parameters
- [ ] addCommentAnnotationDraft event added to enum table in data-models.mdx
- [ ] setContextProvider() method added to api-methods.mdx with parameters and return type
- [ ] useSetContextProvider() hook added to react-hooks.mdx
- [ ] addCommentAnnotationDraft event added to Event Subscription table in customize-behavior.mdx
- [ ] setContextProvider method documented with both hook and API method examples
- [ ] All code examples include React / Next.js and Other Frameworks tabs
- [ ] All links follow Velt URL patterns
- [ ] No breaking changes flagged
- [ ] Log file written to .claude/logs/agent-2-planning-5.0.0-beta.7.md

## Notes
- addCommentAnnotationDraft is a new event in the existing event system
- Event includes addContext function for dynamically setting context during annotation creation
- setContextProvider is a new method with corresponding React hook useSetContextProvider
- Context provider accepts documentId and optional location, returns CommentContext or null/undefined
- Context provider can be async (Promise) or sync
- All features are additive, no breaking changes
- No UI customization updates needed (no new wireframes or component changes)
