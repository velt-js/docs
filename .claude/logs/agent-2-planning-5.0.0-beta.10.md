# Release Update Plan for 5.0.0-beta.10

## Overview
- Release Type: Beta (Minor)
- Key Changes: Batched per-document mode for getAnnotationsCount() reduces Firestore listeners by up to 80%
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models
Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
Changes:
- Add `batchedPerDocument` property to CommentRequestQuery interface (~line 205, after filterGhostComments)
- Add `debounceMs` property to CommentRequestQuery interface (~line 206, after batchedPerDocument)
Priority: High

### 2. Documentation - Main Feature Docs
Files: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
Changes:
- Add new code example in getCommentAnnotationsCount section (~line 270)
- Insert "Batched Per-Document Mode" code group after existing examples
- Show batchedPerDocument: true usage with documentIds array
- Show debounceMs parameter (default: 5000ms)
- Include React Hook and API Method patterns
- Explain listener reduction benefit (100 documents → ~20 listeners)
Priority: High

## Implementation Sequence
1. Update data-models.mdx: Add batchedPerDocument and debounceMs to CommentRequestQuery (5 min)
2. Update customize-behavior.mdx: Add batched mode example to getCommentAnnotationsCount section (15 min)

## Quality Checklist
- [ ] batchedPerDocument property added to CommentRequestQuery (boolean, optional, default: false)
- [ ] debounceMs property added to CommentRequestQuery (number, optional, default: 5000)
- [ ] Batched mode example added to customize-behavior.mdx with React Hook and API Method
- [ ] Code examples include React / Next.js and Other Frameworks tabs
- [ ] Example shows documentIds array with batchedPerDocument: true
- [ ] Example shows debounceMs customization
- [ ] Performance benefit documented (listener reduction)
- [ ] Return format matches existing per-document pattern (doc-id → {total, unread})
- [ ] All links follow Velt URL patterns
- [ ] No breaking changes flagged
- [ ] Log file written to .claude/logs/agent-2-planning-5.0.0-beta.10.md

## Notes
- batchedPerDocument is a new optimization mode for existing getCommentAnnotationsCount() method
- Uses batched Firestore listeners (ceil(N/5) instead of N) while maintaining per-document granularity
- Return format unchanged: { data: { "doc-id": { total: number, unread: number } } }
- debounceMs controls batching window (default: 5000ms)
- For dashboards with 100 documents: reduces from 100 listeners to ~20 listeners
- No new method needed - adds optional parameters to existing CommentRequestQuery
- No UI customization updates needed (backend optimization only)
- No new types/interfaces beyond extending CommentRequestQuery
- All changes are additive, no breaking changes
