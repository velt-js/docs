# Release Update Plan for 5.0.0-beta.9

## Overview
- Release Type: Beta (Minor)
- Key Changes: Draft Mode enhancements with shake animation, draft attribute, isDraft property; Email detection for @-mentions
- Breaking Changes: No

## Areas Requiring Updates

### 1. Documentation - Main Feature Docs
Files: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
Changes:
- Enhance existing `draftMode` section (~line 4652) in UI/UX section with Draft Mode behavior details
- Add shake animation behavior description
- Add `data-velt-annotation-draft` attribute documentation
- Add `isDraft` property explanation
- Update description from basic "whether to store comments" to detailed feature explanation
- Keep existing enableDraftMode/disableDraftMode API methods
Priority: High

### 2. Data Models
Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
Changes:
- Verify `isDraft` property is documented in CommentAnnotation interface (already present at line 38)
- No changes needed (isDraft already documented)
Priority: Low (verification only)

### 3. API Methods
Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
Changes:
- Add `enableDraftMode()` method entry under Comments > Threads section
- Add `disableDraftMode()` method entry under Comments > Threads section
- Place after `submitComment()` method (~line 96-100 area)
Priority: Medium

## Implementation Sequence
1. Update api-methods.mdx: Add enableDraftMode and disableDraftMode method entries (10 min)
2. Update customize-behavior.mdx: Enhance draftMode section with new behavior details (15 min)
3. Verify data-models.mdx: Confirm isDraft is documented (5 min)

## Quality Checklist
- [ ] enableDraftMode() method added to api-methods.mdx
- [ ] disableDraftMode() method added to api-methods.mdx
- [ ] draftMode section in customize-behavior.mdx enhanced with behavior details
- [ ] Shake animation behavior documented
- [ ] data-velt-annotation-draft attribute documented
- [ ] isDraft property explanation added
- [ ] All code examples include React / Next.js and Other Frameworks tabs
- [ ] Link to full docs added from release note ([Learn more] link)
- [ ] isDraft property verified in CommentAnnotation interface
- [ ] All links follow Velt URL patterns
- [ ] No breaking changes flagged
- [ ] Log file written to .claude/logs/agent-2-planning-v5.0.0-beta.9.md

## Notes
- Draft Mode is an enhancement to existing feature, not a new feature
- Three key behaviors: 1) Saves partial comments as drafts with isDraft: true, 2) Shows shake animation on first outside click, 3) Sets data-velt-annotation-draft attribute
- Bug fixes (9 total) require no documentation updates (internal fixes only)
- Email detection improvement (@user@example.com) requires no documentation updates (automatic behavior)
- No new types or interfaces added
- No UI customization updates needed
- All changes are additive, no breaking changes
