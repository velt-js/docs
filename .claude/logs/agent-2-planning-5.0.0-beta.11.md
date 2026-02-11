# Release Update Plan for 5.0.0-beta.11

## Overview
- Release Type: Beta (Minor)
- Key Changes: Private comments configuration with automatic visibility filtering; breaking change to updateVisibility API signature
- Breaking Changes: Yes - `updateVisibility()` API signature changed

## Areas Requiring Updates

### 1. Data Models
Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
Changes:
- Update `CommentVisibilityConfig` interface to include `annotationId` property (after type property, ~line 131)
- Mark `annotationId` as optional but required for `updateVisibility()` method
Priority: High

### 2. API Methods
Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
Changes:
- Update `updateVisibility()` method signature from `updateVisibility(annotationId, config)` to `updateVisibility(config)` (~line 138-143)
- Update params to single parameter: `config: CommentVisibilityConfig` (which now includes annotationId)
Priority: High

### 3. Documentation - Main Feature Docs
Files: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
Changes:
- Update `updateVisibility()` method examples to use new signature with annotationId inside config object (~line 2146-2195)
- Add new section for Private Comments Configuration feature explaining automatic visibility filtering
- Place Private Comments Configuration section near existing privateCommentMode documentation (~line 6345-6394)
- Document visibility tokens: public, self:userId, organizationPrivate:orgId
Priority: High

## Implementation Sequence
1. Update data-models.mdx: Add annotationId property to CommentVisibilityConfig (5 min)
2. Update api-methods.mdx: Update updateVisibility signature (5 min)
3. Update customize-behavior.mdx: Update updateVisibility examples with new signature (10 min)
4. Add Private Comments Configuration section in customize-behavior.mdx (15 min)

## Quality Checklist
- [ ] CommentVisibilityConfig updated with annotationId property
- [ ] updateVisibility() method signature updated in api-methods.mdx
- [ ] updateVisibility() examples updated in customize-behavior.mdx
- [ ] Private Comments Configuration section added explaining automatic filtering
- [ ] Visibility token types documented: public, self:userId, organizationPrivate:orgId
- [ ] All code examples include React / Next.js and Other Frameworks tabs
- [ ] Breaking change documented in signature update
- [ ] All links follow Velt URL patterns
- [ ] Log file written to .claude/logs/agent-2-planning-5.0.0-beta.11.md

## Notes
- **Breaking Change**: updateVisibility signature changed from `updateVisibility(annotationId, config)` to `updateVisibility(config)` where config now includes annotationId
- Private Comments Configuration is automatic after user authentication - no SDK setup required
- SDK builds visibility tokens (public, self:userId, organizationPrivate:orgId) based on project configuration
- Visibility filtering applied automatically via Firestore filters
- Three visibility modes: public (all users), organization (org members only), self (specific users only)
- No new UI components or wireframes required
- Feature complements existing privateCommentMode and updateAccess APIs
