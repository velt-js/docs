# Release Update Plan for 5.0.0-beta.17

## Overview
- Release Type: Patch/Improvement (beta)
- Key Changes: Auto-defaults for `updateVisibility()`, auto-batching for `getAnnotationsCount()`, deprecated private comment methods
- Breaking Changes: No - deprecated methods still function with warnings

## Areas Requiring Updates

### 1. API Methods (/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx)

**Changes Required:**
- Update `updateVisibility()` documentation (line 138-143): Add note that `userIds` parameter is now optional for `type: 'self'` and auto-defaults to current authenticated user
- Add deprecation warnings to `enablePrivateCommentMode()` at line 1150 with reference to `updateVisibility()`
- Search for and add deprecation warnings to `disablePrivateCommentMode()` and `updateAccess()` methods
- Priority: High

### 2. Data Models (/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx)

**Changes Required:**
- Update `CommentVisibilityConfig` type definition (line 127-135): Mark `userIds` as optional for `type: 'self'` visibility
- Update `CommentRequestQuery` type definition (line 210-225): Add documentation explaining auto-batching behavior when 2+ `documentIds` provided
- Clarify that `debounceMs` parameter applies to auto-batching (already present but needs context)
- Priority: High

### 3. Documentation - Customize Behavior (/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx)

**Changes Required:**
- Update `updateVisibility()` section (line 2539-2589):
  - Update parameter description to note `userIds` is optional for `type: 'self'`
  - Add code example showing auto-default behavior (omitting `userIds`)
  - Add "After v5.0.0-beta.17" note explaining the improvement
- Update `getCommentAnnotationsCount()` section (line 270-521):
  - Add documentation on automatic batching when 2+ `documentIds` are provided
  - Explain Firestore listener reduction (N to ceil(N/5))
  - Update existing batched request examples to clarify auto-batching vs explicit batching
  - Add note about `debounceMs` parameter usage with auto-batching
- Add deprecation notices to any sections mentioning:
  - `enablePrivateCommentMode()`
  - `disablePrivateCommentMode()`
  - `updateAccess()`
  - Include migration guidance pointing to `updateVisibility()`
- Priority: High

### 4. Migration Guides

**No breaking changes** - existing code continues to work. However, should add optional "Best Practices" note in relevant documentation:
- Recommend removing `userIds` parameter when using `type: 'self'` in `updateVisibility()` for simpler code
- Recommend removing explicit `batchedPerDocument: true` when only querying 2+ documents, as auto-batching handles this
- Priority: Low

## Implementation Sequence

1. **Data Models Update** (Agent-3)
   - Update `CommentVisibilityConfig` type: mark `userIds` as optional
   - Update `CommentRequestQuery` type: document auto-batching behavior
   - Effort: 10-15 minutes

2. **API Methods Update** (Agent-3)
   - Update `updateVisibility()` parameter description
   - Add deprecation warnings to `enablePrivateCommentMode()`, `disablePrivateCommentMode()`, `updateAccess()`
   - Effort: 15-20 minutes

3. **Customize Behavior Documentation Update** (Agent-3)
   - Update `updateVisibility()` section with new examples
   - Update `getCommentAnnotationsCount()` section with auto-batching documentation
   - Add deprecation notices with migration guidance
   - Effort: 25-30 minutes

4. **Cross-Reference Verification** (Agent-5)
   - Verify all links between sections work correctly
   - Ensure consistency in terminology (auto-batching, auto-default, etc.)
   - Effort: 10 minutes

## Quality Checklist
- [ ] `CommentVisibilityConfig` type updated to show optional `userIds`
- [ ] `CommentRequestQuery` type documents auto-batching
- [ ] `updateVisibility()` API method shows optional parameter
- [ ] `updateVisibility()` full documentation includes auto-default example
- [ ] `getCommentAnnotationsCount()` documents auto-batching behavior
- [ ] Deprecation warnings added to `enablePrivateCommentMode()`, `disablePrivateCommentMode()`, `updateAccess()`
- [ ] Migration guidance points to `updateVisibility()` as replacement
- [ ] Code examples include React and Other Frameworks tabs
- [ ] No new wireframes needed
- [ ] No new UI customization documentation needed
- [ ] Log file written to `/Users/yoenzhang/Downloads/docs/.claude/logs/agent-2-planning-5.0.0-beta.17.md`
