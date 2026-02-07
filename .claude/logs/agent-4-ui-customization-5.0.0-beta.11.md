# Agent-4 UI Customization Updates for v5.0.0-beta.11

## Overview
Updated UI/feature documentation for v5.0.0-beta.11 private comments configuration and updateVisibility() API signature change.

## Changes Made

### 1. Updated updateVisibility() Code Examples
**File**: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
**Lines**: 2146-2200

Updated all code examples to use new single-parameter signature where annotationId is included in the config object:

**Old Signature:**
```javascript
commentElement.updateVisibility(annotationId, { type: 'public' });
```

**New Signature:**
```javascript
commentElement.updateVisibility({
  annotationId: 'annotation-123',
  type: 'public'
});
```

Updated both React/Next.js and Other Frameworks tabs with:
- Organization visibility example
- Self (private) visibility example
- Public visibility example

### 2. Added Private Comments Configuration Section
**File**: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
**Lines**: 6404-6431

Added new section documenting:
- Automatic visibility-based access control after authentication
- Three visibility types: Public, Organization, Self
- Visibility tokens: public, self:userId, organizationPrivate:orgId
- Automatic Firestore filtering behavior
- Related APIs: updateVisibility(), updateAccess(), enablePrivateComments

### 3. Verified Other Files
**Files Checked:**
- `/Users/yoenzhang/Downloads/docs/webhooks/advanced.mdx` - Only has reference link, no code examples
- `/Users/yoenzhang/Downloads/docs/release-notes/version-5/sdk-changelog.mdx` - Already updated by Agent-3, beta.8 examples intentionally kept with old signature as historical record

## Quality Checklist
- [x] updateVisibility() examples updated with new signature
- [x] Both React/Next.js and Other Frameworks tabs updated
- [x] Private Comments Configuration section added
- [x] Visibility types documented: public, organization, self
- [x] Visibility tokens documented: public, self:userId, organizationPrivate:orgId
- [x] Related APIs cross-referenced with correct anchor links
- [x] No wireframes created (no UI components changed)
- [x] Description text within verbosity limits (≤3 bullets)
- [x] All prose links follow standard Velt URL patterns
- [x] No links in code examples or comments

## Files Modified
1. `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`

## Notes
- No wireframes required - this is a behavior/API change only
- Private Comments Configuration placed after enablePrivateComments section for logical grouping
- All related API methods properly cross-referenced
- Breaking change from v5.0.0-beta.8 handled correctly in release notes
