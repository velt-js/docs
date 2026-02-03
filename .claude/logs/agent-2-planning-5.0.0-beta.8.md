# Release Update Plan for 5.0.0-beta.8

## Overview
- Release Type: Beta (Minor)
- Key Changes: Comment visibility control API with organization and user-level access control
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models
Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
Changes:
- Add `CommentVisibilityType` type definition in Comments > Threads section (after CommentContextProvider, ~line 110)
- Add `CommentVisibilityConfig` interface in Comments > Threads section (after CommentVisibilityType)
Priority: High

### 2. API Methods
Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
Changes:
- Add `updateVisibility()` method under Comments > Threads section (after setContextProvider, ~line 123)
Priority: High

### 3. Documentation - Main Feature Docs
Files: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
Changes:
- Add `updateVisibility()` method documentation in Threads section with React Hook and API Method examples
- Place after `setContextProvider()` method (existing pattern suggests placement ~line 6150 area, but verify exact location in private comment mode section)
- Include all three visibility types: public, organization, self
- Reference existing private comment mode documentation for context continuity
Priority: High

## Implementation Sequence
1. Update data-models.mdx: Add CommentVisibilityType and CommentVisibilityConfig (10 min)
2. Update api-methods.mdx: Add updateVisibility method entry (10 min)
3. Update customize-behavior.mdx: Add updateVisibility method documentation with examples (20 min)

## Quality Checklist
- [ ] CommentVisibilityType type added ('public' | 'organization' | 'self')
- [ ] CommentVisibilityConfig interface added with type, organizationId, userIds properties
- [ ] updateVisibility() method added to api-methods.mdx with annotationId and config parameters
- [ ] updateVisibility method documented in customize-behavior.mdx with all three use cases
- [ ] All code examples include React / Next.js and Other Frameworks tabs
- [ ] Examples show organization-only, user-specific, and public visibility patterns
- [ ] All links follow Velt URL patterns
- [ ] No breaking changes flagged
- [ ] Log file written to .claude/logs/agent-2-planning-5.0.0-beta.8.md

## Notes
- updateVisibility is a new method on commentElement for programmatic visibility control
- Three visibility types: 'public' (all users), 'organization' (org-scoped), 'self' (user-scoped)
- organizationId required when type is 'organization'
- userIds array required when type is 'self'
- No React hook needed (method only)
- Complements existing private comment mode feature (privateCommentMode prop/API)
- All features are additive, no breaking changes
- No UI customization updates needed (no new wireframes)
- Bug fixes documented in release note but require no customer-facing docs updates
