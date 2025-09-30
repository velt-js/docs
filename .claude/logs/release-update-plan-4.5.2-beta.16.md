# Release Update Plan for Version 4.5.2-beta.16

**Release Date**: September 19, 2025
**Analysis Date**: September 29, 2025
**Agent**: Agent-2 (Release Planning Specialist)

---

## Overview

- **Release Type**: Minor (Beta)
- **Key Changes**:
  - Full-screen mode for Comments Sidebar
  - Fixed annotation numbering system
  - Search by annotation number
  - Three new wireframe components (CommentNumber for dialog/pin, FullscreenButton for sidebar)
  - Bug fixes for Recorder (Firefox) and Notifications Panel
- **Breaking Changes**: No

---

## Areas Requiring Updates

### 1. Data Models

**Files to Update**:
- `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`

**Changes Needed**:
- Add `annotationNumber` field to `CommentAnnotation` type definition (if not already present)
- Field should be documented as: `number` type, required, with description: "Fixed annotation number that persists across sessions. Used for referencing specific comments."
- **Investigation Required**: Verify if `annotationNumber` is different from existing `annotationIndex` field or if it's a rename

**Priority**: High
**Dependencies**: None
**Estimated Effort**: Low (1 field addition, ~15 minutes)

---

### 2. API Methods

**Files to Update**:
- `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`

**Changes Needed**:
- Add `enableFullScreenInSidebar()` method entry in Comments section
  - No params, void return, no React hook
  - Links to `/async-collaboration/comments-sidebar/customize-behavior#enablefullscreeninsidebar`
- Add `disableFullScreenInSidebar()` method entry in Comments section
  - No params, void return, no React hook
  - Links to `/async-collaboration/comments-sidebar/customize-behavior#disablefullscreeninsidebar`

**Priority**: High
**Dependencies**: None
**Estimated Effort**: Low (2 method entries, ~20 minutes)

---

### 3. Documentation - Comments Sidebar Customize Behavior

**Files to Update**:
- `/Users/yoenzhang/Downloads/docs/async-collaboration/comments-sidebar/customize-behavior.mdx`

**Changes Needed**:

**Section 1: Full-Screen Mode**
- Add new section documenting full-screen mode feature
- Include use case explanation (large volumes of feedback, detailed reviews)
- Document default state (false/disabled)
- Document mode limitations (default mode only, not floating/embed)
- Include both prop and API method examples
- Include both React/Next.js and Other Frameworks tabs
- Example code:
  - Prop: `<VeltCommentsSidebar fullScreen={true} />`
  - Attribute: `<velt-comments-sidebar full-screen="true">`
  - API: `commentElement.enableFullScreenInSidebar()` / `disableFullScreenInSidebar()`

**Section 2: Search by Annotation Number**
- Add new section near existing search placeholder documentation
- Explain search pattern: type `#` followed by number (e.g., `#2`)
- Explain relationship to fixed annotation numbers
- Note that numbers persist across sessions
- No code examples needed (uses existing search field)

**Priority**: High
**Dependencies**: API Methods (for links)
**Estimated Effort**: Medium (~1-1.5 hours for both sections)

---

### 4. Documentation - Comments Customize Behavior

**Files to Update**:
- `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`

**Changes Needed**:
- Add new section documenting annotation numbers feature
- Explain persistence across sessions
- Explain use case (referencing comments in discussions/documentation)
- Document display locations (pins and dialogs)
- Document search capability (reference sidebar search by number)
- Include cross-references to wireframe customization documentation:
  - Link to Comment Pin Number Wireframe
  - Link to Comment Dialog Number Wireframe
- No code examples needed (automatic behavior)

**Priority**: Medium
**Dependencies**: Data Models (for field understanding)
**Estimated Effort**: Medium (~45 minutes)

---

### 5. UI Customization - Comment Dialog Structure

**Files to Update**:
- `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-structure.mdx`

**Changes Needed**:
- Add `VeltCommentDialogWireframe.CommentNumber` to structure listing
- Add after Header section (around line 35-37)
- Mark as **(Leaf)** since it has no children
- Add horizontal rule separator

**Priority**: High
**Dependencies**: None
**Estimated Effort**: Low (~10 minutes)

---

### 6. UI Customization - Comment Dialog Components

**Files to Update**:
- `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`

**Changes Needed**:
- Add new `CommentNumber` component section
- Include description: "Annotation number displayed in comment dialog header that persists across sessions"
- Include both React and Other Frameworks wireframe examples
- React: `<VeltCommentDialogWireframe.CommentNumber />`
- HTML: `<velt-comment-dialog-comment-number-wireframe>`
- Include parent context (VeltCommentDialogWireframe.Header)
- Follow existing component documentation patterns
- Position alphabetically with other components

**Priority**: High
**Dependencies**: Comment Dialog Structure
**Estimated Effort**: Medium (~30 minutes)

---

### 7. UI Customization - Comment Pin

**Files to Update**:
- `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-pin.mdx`

**Changes Needed**:
- **Investigation Required**: Determine if `Index` is being renamed to `Number` or if both exist
- **If Rename**:
  - Update section title from "Index" to "Number" (line 60)
  - Update all wireframe examples
  - Update description to mention persistent annotation numbers
- **If New Component**:
  - Add new `Number` component section
  - Clarify difference between `Index` and `Number`
  - Keep existing `Index` documentation
- Update overview wireframe example to include correct component

**Priority**: High
**Dependencies**: Investigation into Index vs Number
**Estimated Effort**: Medium (~45 minutes after clarification)

---

### 8. UI Customization - Comment Sidebar Structure

**Files to Update**:
- `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-sidebar-structure.mdx`

**Changes Needed**:
- Add `VeltCommentsSidebarWireframe.FullscreenButton` to structure listing
- Add after Header section (around line 27)
- Mark as **(Leaf)** since it has no children
- Add horizontal rule separator

**Priority**: High
**Dependencies**: None
**Estimated Effort**: Low (~10 minutes)

---

### 9. UI Customization - Comment Sidebar Components

**Files to Update**:
- `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-sidebar-components.mdx`

**Changes Needed**:
- Add new `FullscreenButton` component section under Header components
- Include description: "Button to toggle full-screen mode for Comments Sidebar. Only appears when full-screen mode is enabled."
- Include both React and Other Frameworks wireframe examples
- React: `<VeltCommentsSidebarWireframe.FullscreenButton />`
- HTML: `<velt-comments-sidebar-fullscreen-button-wireframe>`
- Include parent context (VeltCommentsSidebarWireframe.Header)
- **Note**: May require image `/images/customization/comments/comments-sidebar/fullscreen-button.png`
- Follow existing component documentation patterns

**Priority**: High
**Dependencies**: Comment Sidebar Structure
**Estimated Effort**: Medium (~45 minutes + image if needed)

---

### 10. Migration & Upgrade Guides

**Files to Update**: None

**Changes Needed**: No migration guidance required

**Reason**: All changes are additive and backwards compatible. No breaking changes.

**Priority**: N/A

---

### 11. New Documentation Creation

**Files to Create**: None

**Reason**: All required documentation areas already exist. Updates only needed to existing files.

**Priority**: N/A

---

## Implementation Sequence

### Phase 1: Foundation (Critical Path)
1. ✓ **Data Models** - Add `annotationNumber` field
   - No dependencies
   - Required for: Comments Customize Behavior
   - Effort: Low (~15 min)

2. ✓ **API Methods** - Add full-screen API methods
   - No dependencies
   - Required for: Comments Sidebar Customize Behavior
   - Effort: Low (~20 min)

### Phase 2: Structure Files (High Priority)
3. ✓ **Comment Dialog Structure** - Add CommentNumber
   - No dependencies
   - Required for: Comment Dialog Components
   - Effort: Low (~10 min)

4. ✓ **Comment Sidebar Structure** - Add FullscreenButton
   - No dependencies
   - Required for: Comment Sidebar Components
   - Effort: Low (~10 min)

### Phase 3: Component Detail Pages (High Priority)
5. ✓ **Comment Dialog Components** - Add CommentNumber section
   - Depends on: Comment Dialog Structure
   - Required for: Cross-references
   - Effort: Medium (~30 min)

6. ✓ **Comment Sidebar Components** - Add FullscreenButton section
   - Depends on: Comment Sidebar Structure
   - Required for: Cross-references
   - Effort: Medium (~45 min + image)

7. ✓ **Comment Pin** - Update Number/Index documentation
   - Depends on: Investigation results
   - Required for: Cross-references
   - Effort: Medium (~45 min)

### Phase 4: Feature Documentation (Medium Priority)
8. ✓ **Comments Sidebar Customize Behavior** - Add full-screen and search sections
   - Depends on: API Methods, Sidebar Components
   - Required for: Complete feature documentation
   - Effort: Medium (~1-1.5 hours)

9. ✓ **Comments Customize Behavior** - Add annotation numbers section
   - Depends on: Data Models, Dialog/Pin Components
   - Required for: Complete feature documentation
   - Effort: Medium (~45 min)

### Phase 5: Verification (Complete)
10. ✓ Cross-reference verification
11. ✓ Terminology consistency check
12. ✓ Code example validation

**Total Estimated Time**: 6-8 hours (including investigations and image coordination)

---

## Quality Assurance Checklist

### Core Documentation
- [ ] All new types added to Data Models page
- [ ] All new APIs documented in API reference
- [ ] All new hooks added to hooks documentation (N/A - no new hooks)
- [ ] **Customize behavior documentation planned for main feature docs** (Comments Sidebar and Comments)

### Code Examples
- [ ] Code examples include both React and Other Frameworks tabs
- [ ] Prop examples use correct syntax (`fullScreen` vs `full-screen`)
- [ ] API examples show correct method calls
- [ ] Wireframe examples include parent wrapper tags (`<VeltWireframe>`)
- [ ] All examples follow established patterns from similar features

### Wireframe Documentation
- [ ] New wireframe components added to structure files first
- [ ] Component detail pages created after structure files
- [ ] Parent-child relationships correctly documented
- [ ] Leaf components marked with **(Leaf)**
- [ ] Both React (PascalCase) and HTML (kebab-case) names included

### Cross-References
- [ ] API Methods link to customize behavior documentation
- [ ] Customize behavior sections reference wireframe documentation
- [ ] Wireframe documentation references feature documentation
- [ ] All internal links verified and working
- [ ] Data Models referenced from appropriate sections

### Terminology
- [ ] "Full-screen mode" (hyphenated, not "fullscreen" or "full screen")
- [ ] "Comments Sidebar" (both capitalized)
- [ ] "Annotation number" consistently used
- [ ] "Default mode" vs "floating mode" vs "embed mode" clearly distinguished
- [ ] Consistent use of "persists across sessions" for annotation numbers

### Technical Accuracy
- [ ] Default values specified (`fullScreen` defaults to `false`)
- [ ] Mode limitations documented (full-screen only in default mode)
- [ ] Search pattern documented (`#2` format with hash prefix)
- [ ] Persistence behavior explained (survives page refresh and sessions)
- [ ] Use cases clearly described for each feature

### Version Accuracy
- [ ] **All planned content matches version 4.5.2-beta.16 exactly**
- [ ] No features from other versions mixed in
- [ ] Release note content accurately reflected in documentation
- [ ] All examples tested against beta.16 specifications

### Breaking Changes
- [ ] No breaking changes to document (verified)
- [ ] All features are additive and optional
- [ ] Backwards compatibility maintained
- [ ] No migration warnings needed

### Missing Documentation
- [ ] All required documentation areas identified
- [ ] No new files need to be created
- [ ] All updates to existing files
- [ ] Investigation items clearly marked

### Log File
- [ ] **Detailed analysis findings written to log file for review**
- [ ] Log location: `/Users/yoenzhang/Downloads/docs/release-notes-analysis-log-4.5.2-beta.16.md`

---

## Risk Mitigation

### Identified Risks

**Risk 1: Index vs Number Component Naming**
- **Issue**: Unclear if `VeltCommentPinWireframe.Index` is renamed to `.Number` or both exist
- **Impact**: Medium - Could lead to incorrect documentation
- **Mitigation**:
  - Mark as investigation required
  - Agent-3 to verify with engineering before documentation
  - Document both if they coexist with different purposes

**Risk 2: annotationNumber vs annotationIndex**
- **Issue**: Unclear if these are different fields or same field renamed
- **Impact**: Medium - Could lead to confusion in data model documentation
- **Mitigation**:
  - Mark as investigation required
  - Agent-3 to verify field naming and purpose
  - Update data models with clear descriptions of each

**Risk 3: Full-Screen Mode Limitations**
- **Issue**: Behavior when enabled in non-default modes not documented
- **Impact**: Low - Users may have questions
- **Mitigation**:
  - Clearly document "only supported in default mode"
  - Consider adding note about behavior in other modes if known
  - Agent-3 to verify and document actual behavior

**Risk 4: Missing Images**
- **Issue**: New wireframe components may need visual documentation
- **Impact**: Low - Text documentation sufficient but images improve clarity
- **Mitigation**:
  - Note image requirements in plan
  - Agent-4 to coordinate with design team if images needed
  - Documentation functional without images initially

---

## Dependencies Matrix

| Update Area | Depends On | Required For |
|-------------|------------|--------------|
| Data Models | None | Comments Customize Behavior |
| API Methods | None | Comments Sidebar Customize Behavior |
| Comment Dialog Structure | None | Comment Dialog Components |
| Comment Sidebar Structure | None | Comment Sidebar Components |
| Comment Dialog Components | Comment Dialog Structure | Cross-references, Comments Behavior |
| Comment Sidebar Components | Comment Sidebar Structure | Comments Sidebar Behavior |
| Comment Pin | Investigation | Cross-references, Comments Behavior |
| Comments Sidebar Behavior | API Methods, Sidebar Components | Complete documentation |
| Comments Behavior | Data Models, Dialog/Pin Components | Complete documentation |

---

## Agent Handoff Notes

### For Agent-3 (Technical Documentation Specialist)

**Your Tasks**:
1. Update Data Models with `annotationNumber` field (investigate vs `annotationIndex`)
2. Update API Methods with full-screen methods
3. Update Comments Sidebar Customize Behavior with full-screen and search sections
4. Update Comments Customize Behavior with annotation numbers section

**Investigations Required**:
- [ ] Is `annotationNumber` different from `annotationIndex` or a rename?
- [ ] What's the exact behavior when full-screen enabled in non-default modes?
- [ ] Are there any additional API parameters not shown in release notes?

**Then Pass to Agent-4**: All wireframe-related updates

---

### For Agent-4 (UI Customization Documentation Specialist)

**Your Tasks**:
1. Update Comment Dialog Structure - add CommentNumber
2. Update Comment Dialog Components - add CommentNumber section
3. Update Comment Pin - handle Number/Index clarification
4. Update Comment Sidebar Structure - add FullscreenButton
5. Update Comment Sidebar Components - add FullscreenButton section

**Investigations Required**:
- [ ] Is `VeltCommentPinWireframe.Index` renamed to `.Number` or both exist?
- [ ] What's the visual difference between Index and Number (if both exist)?

**Image Needs**:
- Potentially: `/images/customization/comments/comments-sidebar/fullscreen-button.png`
- Coordinate with design team if required

**Then Pass to Agent-5**: For alignment and consistency check

---

### For Agent-5 (Alignment & Consistency Specialist)

**Your Tasks**:
1. Verify all cross-references are accurate
2. Check terminology consistency across all updated files
3. Ensure code examples follow established patterns
4. Verify wireframe parent-child hierarchies are correct
5. Check that all tabs (React vs Other Frameworks) have matching content

**Focus Areas**:
- Consistent use of "annotation number" terminology
- Proper hyphenation of "full-screen mode"
- Correct capitalization of "Comments Sidebar"
- Matching React PascalCase and HTML kebab-case names

**Then Pass to Agent-6**: For QA verification

---

### For Agent-6 (QA Specialist)

**Your Tasks**:
1. Verify all checklist items completed
2. Test all code examples for syntax correctness
3. Click all internal links to verify they work
4. Check that all wireframe examples include parent wrappers
5. Verify no missing references or broken links
6. Confirm all features match release note specifications exactly

**Special Checks**:
- [ ] Version 4.5.2-beta.16 content only (no version mixing)
- [ ] All examples copy-pasteable by users
- [ ] No placeholder content or TODOs left
- [ ] Images display correctly (if added)

---

## Success Metrics

### Documentation Completeness
- 9 files updated with all required changes
- 0 files created (all existing files)
- 3 new wireframe components fully documented
- 2 new API methods fully documented
- 1 new data field documented (if applicable)

### Quality Indicators
- 100% of code examples include both React and Other Frameworks
- 100% of wireframe examples include parent wrapper
- 100% of cross-references functional
- 0 broken links
- 0 inconsistent terminology
- 0 version mixing

### User Experience
- Users can understand full-screen mode without additional support
- Users can find and use annotation numbers immediately
- Users can customize wireframes following clear examples
- Users can search by annotation number without confusion

---

## Timeline Estimate

| Phase | Duration | Agent |
|-------|----------|-------|
| Investigations | 30 min | Agent-3 |
| Data Models & API Methods | 45 min | Agent-3 |
| Feature Documentation | 2.5 hours | Agent-3 |
| Wireframe Structures | 30 min | Agent-4 |
| Wireframe Components | 2 hours | Agent-4 |
| Alignment & Consistency | 1 hour | Agent-5 |
| QA & Verification | 1 hour | Agent-6 |
| **Total** | **8-9 hours** | **All Agents** |

---

## Appendices

### Release Note Reference

**Source File**: `/Users/yoenzhang/Downloads/docs/release-notes/version-4/sdk-changelog.mdx`
**Version**: 4.5.2-beta.16
**Date**: September 19, 2025
**Lines**: 14-135

### Log File Reference

**Detailed Analysis**: `/Users/yoenzhang/Downloads/docs/release-notes-analysis-log-4.5.2-beta.16.md`
**Contains**:
- Complete release note content analysis
- Field-by-field breakdown
- Investigation questions
- Risk assessment details
- Effort estimations
- Agent-specific notes

---

## Plan Approval

**Status**: Ready for Implementation
**Next Step**: Pass to Agent-3 for technical documentation updates
**Blockers**: None (investigations can be done during implementation)

---

**End of Release Update Plan**