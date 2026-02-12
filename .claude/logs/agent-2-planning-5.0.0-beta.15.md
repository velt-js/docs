# Release Update Plan for 5.0.0-beta.15

## Overview
- Release Type: Beta (Minor with Breaking Changes)
- Key Changes: Text formatting toolbar, composer management APIs, enhanced composer events, standalone composer context
- Breaking Changes: Yes - submitComment() signature changed, target-element-id renamed, ComposerTextChangeEvent extended

## Areas Requiring Updates

### 1. Data Models
Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
Changes:
- Add `FormatConfig` type definition (object with bold, italic, underline, strikethrough enable flags)
- Update `SubmitCommentRequest` type to reflect object signature (already exists, verify structure)
- Update `ClearComposerRequest` type (already exists, verify structure)
- Update `GetComposerDataRequest` type (already exists, verify structure)
- Update `ComposerTextChangeEvent` interface - add `annotation: CommentAnnotation` and `targetComposerElementId: string` fields
- No new CommentAnnotation changes needed (context already documented)
Priority: High

### 2. API Methods
Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
Changes:
- Add `enableFormatOptions()` method under Comments section
- Add `disableFormatOptions()` method under Comments section
- Add `setFormatConfig()` method under Comments section with FormatConfig param
- Update `submitComment()` to reflect breaking change (string to SubmitCommentRequest object)
- Verify `clearComposer()` entry exists and is correct (added in beta.2)
- Verify `getComposerData()` entry exists and is correct (added in beta.2)
Priority: High

### 3. Documentation - Main Feature Docs
Files: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
Changes:
- Add `enableFormatOptions()` method documentation in Threads section
- Add `disableFormatOptions()` method documentation in Threads section
- Add `setFormatConfig()` method documentation in Threads section
- Update `submitComment()` method to show breaking change migration
- Update composerTextChange event documentation to include `annotation` and `targetComposerElementId` fields
- Add migration note for breaking changes
Priority: High

### 4. UI Customization - Wireframes
Files: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-primitives/overview.mdx`
Changes:
- Add `VeltCommentDialogComposerWireframe.FormatToolbar` component
- Add `VeltCommentDialogComposerWireframe.FormatToolbar.Button` component with type prop (bold, italic, underline, strikethrough)
- Update `VeltCommentDialogComposerWireframe.ActionButton` to document new type="format" option
- Add React and Other Frameworks examples for all wireframe components
Priority: High

### 5. Component Props - VeltComments
Files: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/setup/` (multiple files)
Changes:
- Add `formatOptions` prop documentation to VeltComments component
- Document boolean prop to enable/disable formatting toolbar
- Include React and Other Frameworks tabs
Priority: Medium

### 6. Component Props - VeltCommentDialogComposer
Files: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/standalone-components/comment-composer.mdx` or dialog composer docs
Changes:
- Add `context` prop documentation for VeltCommentDialogComposer
- Add `targetComposerElementId` prop (rename from targetElementId - breaking change)
- Document context object structure and use cases
Priority: High

### 7. Migration Guides
Files: `/Users/yoenzhang/Downloads/docs/release-notes/version-5/sdk-changelog.mdx` (already updated by Agent-1)
Changes:
- Verify breaking changes section is complete and accurate
- No additional work needed - Agent-1 already documented migration steps
Priority: N/A (Complete)

## Implementation Sequence
1. Update data-models.mdx: Add FormatConfig type, update ComposerTextChangeEvent interface (20 min)
2. Update api-methods.mdx: Add format methods (enableFormatOptions, disableFormatOptions, setFormatConfig), update submitComment signature (25 min)
3. Update customize-behavior.mdx: Add format methods with full examples, update submitComment and composerTextChange event docs (35 min)
4. Update comment-dialog-primitives/overview.mdx: Add FormatToolbar and FormatToolbar.Button wireframe components, update ActionButton (30 min)
5. Update VeltComments component docs: Add formatOptions prop across setup files (15 min)
6. Update VeltCommentDialogComposer docs: Add context prop and update targetComposerElementId breaking change (20 min)

## Quality Checklist
- [ ] FormatConfig type added to data-models.mdx with all format types (bold, italic, underline, strikethrough)
- [ ] ComposerTextChangeEvent updated with annotation and targetComposerElementId fields
- [ ] SubmitCommentRequest, ClearComposerRequest, GetComposerDataRequest verified in data-models.mdx
- [ ] enableFormatOptions() method documented in api-methods.mdx
- [ ] disableFormatOptions() method documented in api-methods.mdx
- [ ] setFormatConfig() method documented in api-methods.mdx
- [ ] submitComment() signature updated to reflect breaking change (object instead of string)
- [ ] clearComposer() and getComposerData() entries verified
- [ ] Format methods added to customize-behavior.mdx with React Hook and API Method examples
- [ ] submitComment() updated in customize-behavior.mdx with migration guidance
- [ ] composerTextChange event updated with new fields in customize-behavior.mdx
- [ ] VeltCommentDialogComposerWireframe.FormatToolbar component documented
- [ ] VeltCommentDialogComposerWireframe.FormatToolbar.Button component documented with type prop
- [ ] ActionButton type="format" documented
- [ ] formatOptions prop added to VeltComments documentation
- [ ] context prop added to VeltCommentDialogComposer documentation
- [ ] targetComposerElementId breaking change documented (renamed from targetElementId)
- [ ] All code examples include React / Next.js and Other Frameworks tabs
- [ ] All links follow Velt URL patterns
- [ ] Breaking changes clearly flagged with migration steps
- [ ] Log file written to .claude/logs/agent-2-planning-5.0.0-beta.15.md

## Notes - Breaking Changes Summary
1. submitComment() changed from `submitComment('composer-id')` to `submitComment({ targetComposerElementId: 'composer-id' })`
2. VeltCommentDialogComposer prop renamed from `targetElementId` to `targetComposerElementId`
3. ComposerTextChangeEvent extended with `annotation` and `targetComposerElementId` fields (non-breaking if consumers use optional chaining)

## Notes - New Types
- FormatConfig: Object with optional enable flags for each format type (bold, italic, underline, strikethrough)
- Example: `{ bold: { enable: true }, italic: { enable: true }, underline: { enable: false }, strikethrough: { enable: false } }`

## Notes - Wireframe Components
- FormatToolbar: Container for format buttons in composer
- FormatToolbar.Button: Individual format button with type prop
- ActionButton type="format": New action button type for opening format toolbar
- Follow existing wireframe pattern from comment-dialog-primitives/overview.mdx

## Notes - Context Prop
- context prop on VeltCommentDialogComposer allows attaching custom metadata to standalone composer annotations
- Example: `context={{ projectId: 'abc123', section: 'header' }}`
- Complements existing setContextProvider method
