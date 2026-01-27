# Release Update Plan for 5.0.0-beta.2

## Overview
- Release Type: Beta (Minor)
- Key Changes: Global CSS configuration, programmatic comment submission, composer customization, composer text change events
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models
Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
Changes:
- Add `globalStyles` property to `Config` interface (line ~2649-2658)
- Add `ComposerTextChangeEvent` interface in Comments section
Priority: High

### 2. API Methods
Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
Changes:
- Update `initConfig()` method documentation (~line 2142) to include `globalStyles` parameter
- Add `submitComment()` method under Comments > Threads section (~line 6-96)
Priority: High

### 3. Documentation - Main Feature Docs
Files: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
Changes:
- Add `submitComment()` method documentation in Threads section with React Hook and API Method examples
- Add `composerTextChange` event documentation with useCommentEventCallback and API Method examples
Priority: High

### 4. UI Customization - Component Props
Files: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/standalone-components/comment-composer.mdx`
Changes:
- Add `placeholder` prop documentation with React and Other Frameworks examples
Priority: Medium

### 5. UI Customization - Component Dialog Components
Files: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`
Changes:
- Add `placeholder` prop to Composer component section with React and Other Frameworks examples
Priority: Medium

## Implementation Sequence
1. Update data-models.mdx: Add Config.globalStyles property and ComposerTextChangeEvent interface (15 min)
2. Update api-methods.mdx: Add initConfig globalStyles param and submitComment method (20 min)
3. Update customize-behavior.mdx: Add submitComment and composerTextChange event docs (25 min)
4. Update comment-composer.mdx: Add placeholder prop documentation (10 min)
5. Update comment-dialog-components.mdx: Add placeholder prop to Composer section (10 min)

## Quality Checklist
- [ ] Config interface updated with globalStyles boolean property
- [ ] ComposerTextChangeEvent interface added with text property
- [ ] initConfig() method includes globalStyles parameter example
- [ ] submitComment() method added with targetElementId parameter
- [ ] composerTextChange event documented with useCommentEventCallback pattern
- [ ] placeholder prop documented in both standalone composer and dialog composer
- [ ] All code examples include React / Next.js and Other Frameworks tabs
- [ ] All links follow Velt URL patterns (/api-reference/sdk/..., /async-collaboration/comments/...)
- [ ] No breaking changes flagged
- [ ] Log file written to .claude/logs/agent-2-planning-5.0.0-beta.2.md

## Notes
- globalStyles is a boolean config option, not a new data type
- submitComment is a new method on commentElement
- placeholder is a new prop on existing components
- composerTextChange is a new event with simple { text: string } payload
- All features are additive, no breaking changes
