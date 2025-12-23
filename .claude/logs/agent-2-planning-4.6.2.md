# Release Update Plan for v4.6.2

## Overview
- Release Type: Patch
- Key Changes: New `dialogSelection` prop for Comments Sidebar, new `throwError` option for auth methods, reply count visibility in read-only mode, internal context handling improvements
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models
- Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes:
  - Add `throwError` property to `UserOptions` interface (used by `client.identify()`)
  - Add `throwError` property to `VeltAuthProvider` options
- Priority: High

### 2. API Methods
- Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Changes:
  - Update `identify()` method to document `throwError` option in `UserOptions` parameter
  - Add documentation for `setVeltAuthProvider()` method if missing (currently not in API methods index)
- Priority: High

### 3. Documentation - Comments Sidebar
- Files: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments-sidebar/customize-behavior.mdx`
- Changes:
  - Add new `dialogSelection` prop documentation under UI section
  - Document prop behavior: disables dialog selection in sidebar when set to false
  - Add React example: `<VeltCommentsSidebar dialogSelection={false}/>`
  - Add HTML example: `<velt-comments-sidebar dialog-selection="false">`
- Priority: Medium

### 4. Documentation - Authentication
- Files:
  - `/Users/yoenzhang/Downloads/docs/security/jwt-tokens.mdx`
  - `/Users/yoenzhang/Downloads/docs/get-started/quickstart.mdx`
  - `/Users/yoenzhang/Downloads/docs/key-concepts/overview.mdx`
- Changes:
  - Add `throwError` option documentation to `client.identify()` examples
  - Add `throwError` option documentation to `setVeltAuthProvider()` examples
  - Document return behavior: returns error instead of null when true (default: false)
  - Add error handling examples
- Priority: Medium

### 5. Migration Guides
No migration guide needed - backward compatible changes only.

## Implementation Sequence
1. Update `UserOptions` and `VeltAuthProvider` interfaces in data-models.mdx (foundational types)
2. Update api-methods.mdx with `throwError` parameter documentation (API reference)
3. Add `dialogSelection` prop to comments-sidebar/customize-behavior.mdx (feature documentation)
4. Update authentication docs with `throwError` examples (usage documentation)

## Quality Checklist
- [ ] `UserOptions` interface includes `throwError: boolean` property
- [ ] `VeltAuthProvider` options include `throwError` property
- [ ] `identify()` method documents `throwError` behavior
- [ ] `setVeltAuthProvider()` added to API methods index if missing
- [ ] `dialogSelection` prop documented in Comments Sidebar customize-behavior
- [ ] Code examples include React and Other Frameworks tabs
- [ ] `throwError` examples added to jwt-tokens.mdx, quickstart.mdx, overview.mdx
- [ ] Default values documented (`dialogSelection` default not specified, `throwError` default: false)
- [ ] Breaking changes documented: None
- [ ] Log file written to `.claude/logs/agent-2-planning-4.6.2.md`

## Notes
- Reply counts in read-only mode is a UI behavior change, no documentation update needed
- Context handling improvements are internal, no documentation update needed
- `dialogSelection` prop placement: under UI section in customize-behavior.mdx (not in setup.mdx)
- Follow existing pattern: Props section → React/Other Frameworks tabs → Default value
