# Release Update Plan for v5.0.0-beta.9

## Overview
- Release Type: Minor (Beta)
- Key Changes: Draft Mode API method added, 10 bug fixes
- Breaking Changes: No

## Areas Requiring Updates

### 1. API Methods
**File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`

**Changes Required**:
- Add `enableDraftMode()` method entry under Comments > Behavior section
- Add `disableDraftMode()` method entry under Comments > Behavior section
- Link to existing documentation at `/async-collaboration/comments/customize-behavior#draftmode`

**Priority**: Medium

**Reason**: New API methods exposed in release note (lines 26, 31). Currently documented in customize-behavior.mdx (lines 4665, 4666, 4677, 4678) but missing from api-methods.mdx index.

### 2. Data Models
**File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`

**Changes Required**: None

**Reason**: `isDraft` property already documented in `CommentAnnotation` model (line 38). No new data structures introduced in this release.

### 3. Documentation - Draft Mode Enhancement
**File**: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`

**Changes Required**:
- Update `draftMode` section (around line 4652) to include:
  - Draft behavior details (saves text, attachments, recordings)
  - Shake animation on first click outside
  - `data-velt-annotation-draft` attribute for styling

**Priority**: High

**Reason**: Existing documentation only covers enable/disable methods. Missing behavioral details from release note: partial comment preservation, shake animation, draft attribute for styling.

### 4. UI Customization
**File**: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-structure.mdx` OR `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog/styling.mdx`

**Changes Required**:
- Add section about `data-velt-annotation-draft` attribute for styling draft dialogs
- Mention shake animation behavior

**Priority**: Low

**Reason**: New draft attribute provides styling hook for custom themes. Developers need to know how to target draft dialogs with CSS.

## Implementation Sequence

1. **Update api-methods.mdx** (5 min effort)
   - Add two method entries with standard format
   - Link to existing customize-behavior docs

2. **Enhance customize-behavior.mdx** (10 min effort)
   - Expand draftMode section with behavioral details
   - Add code examples showing draft persistence

3. **Update UI customization docs** (5 min effort)
   - Document data-velt-annotation-draft attribute
   - Add CSS example for styling draft state

## Quality Checklist

- [ ] `enableDraftMode()` method added to api-methods.mdx
- [ ] `disableDraftMode()` method added to api-methods.mdx
- [ ] Both methods link to customize-behavior.mdx#draftmode
- [ ] Draft behavior details added to customize-behavior.mdx
- [ ] Shake animation documented
- [ ] `data-velt-annotation-draft` attribute documented for styling
- [ ] Code examples follow React / Other Frameworks tab pattern
- [ ] No new data models needed (isDraft already exists)
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.0-beta.9.md`
