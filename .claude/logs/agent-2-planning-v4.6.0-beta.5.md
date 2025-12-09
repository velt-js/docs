# Release Update Plan for v4.6.0-beta.5

**Date**: December 8, 2025
**Agent**: Agent-2 (Release Planning Specialist)
**Release Version**: 4.6.0-beta.5
**Release Date**: January 12, 2025
**Release Type**: Minor / API Enhancement

---

## Overview

### Release Summary
Version 4.6.0-beta.5 adds a new `verifyUserPermissions` boolean flag to four REST APIs. This flag prevents creating or updating resources for users who lack document access permissions.

### Key Changes
- **New Parameter**: `verifyUserPermissions` (boolean) added to 4 REST APIs
- **Affected APIs**:
  - Add Comment Annotations
  - Add Comments in Comment Annotation
  - Add Notifications
  - Update Notifications
- **Functionality**: Validates user permissions before creating/updating resources
- **Integration**: Works with existing PermissionProvider and Access Control systems
- **Default**: `false` (maintains current behavior)

### Breaking Changes
**No breaking changes** - This is an optional parameter that defaults to `false`, maintaining existing API behavior.

---

## Areas Requiring Updates

### 1. REST API Documentation (ONLY 2 of 4 APIs need updates)

**Status**: Partial updates required

**Already Documented** (from v4.5.6-beta.12):
- `/api-reference/rest-apis/v2/notifications/add-notifications.mdx` ✓ (lines 48-53)
- `/api-reference/rest-apis/v2/notifications/update-notifications.mdx` ✓ (lines 44-49)

**Requires Updates**:
- `/api-reference/rest-apis/v2/comments-feature/comment-annotations/add-comment-annotations.mdx`
- `/api-reference/rest-apis/v2/comments-feature/comments/add-comments.mdx`

**Changes**: Add `verifyUserPermissions` parameter documentation with description and example usage

**Priority**: High

---

### 2. Data Models Documentation (NOT REQUIRED)

**Analysis**: The `verifyUserPermissions` parameter uses primitive boolean type and does not require new type/interface definitions.

**Status**: No updates needed

**Rationale**:
- Parameter is a simple boolean flag
- No new interfaces, types, or enums introduced
- Not part of any response data models
- Request-level parameter only

---

### 3. SDK API Methods (NOT REQUIRED)

**Analysis**: This change only affects REST APIs, not SDK client methods.

**Status**: No updates needed

**Rationale**:
- Feature is REST API-specific
- No new SDK methods or hooks
- No changes to existing SDK signatures
- `/api-reference/sdk/api/api-methods.mdx` not affected

---

### 4. UI Customization / Wireframes (NOT APPLICABLE)

**Analysis**: Backend permission validation has no UI components.

**Status**: No updates needed

**Rationale**:
- Server-side validation feature
- No new wireframes or customization points
- No visual components

---

### 5. Migration Guides (NOT REQUIRED)

**Analysis**: Non-breaking change with backward-compatible default.

**Status**: No updates needed

**Rationale**:
- Optional parameter with `false` default
- Existing API calls continue working unchanged
- No migration steps required

---

## Detailed Update Requirements

### Update 1: Add Comment Annotations REST API

**File**: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/comments-feature/comment-annotations/add-comment-annotations.mdx`

**Location**: After line 38 (`documentId` parameter), before `commentAnnotations` parameter

**Changes Required**:
1. Add `verifyUserPermissions` parameter in Body Params section
2. Add example request demonstrating the parameter
3. Add Note explaining PermissionProvider limitation

**Content to Add**:

```markdown
    <ParamField body="verifyUserPermissions" type="boolean">
      When enabled, comment annotations are only created for users who have access to the specified document.
      This ensures operations respect document access permissions configured via Access Control or Permission Provider.

      Default: `false`
    </ParamField>
```

**Example Request Section** (add after line 293):

```markdown
#### Add comment annotation with permission verification

```JSON
{
  "data": {
    "organizationId": "acme-corp",
    "documentId": "design-mockup-v2",
    "verifyUserPermissions": true,
    "commentAnnotations": [
      {
        "commentData": [
          {
            "commentText": "Please review this design",
            "from": {
              "userId": "user_john_smith",
              "name": "John Smith",
              "email": "john.smith@acme-corp.com"
            }
          }
        ]
      }
    ]
  }
}
```

<Note>
When `verifyUserPermissions` is enabled, the API checks document access for each user before creating comment annotations. Only users with access to the document will have comment annotations created.
</Note>
```

**Info Callout** (add after the new example, before Response section):

```markdown
<Info>Note: If you are using the new `PermissionProvider` then this flag will not work, you will need to do the permissions validation on your end before adding or updating the resource.</Info>
```

**Priority**: High
**Estimated Effort**: Medium (15-20 minutes)

---

### Update 2: Add Comments in Comment Annotation REST API

**File**: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/comments-feature/comments/add-comments.mdx`

**Location**: After line 46 (`annotationId` parameter), before `commentData` parameter

**Changes Required**:
1. Add `verifyUserPermissions` parameter in Body Params section
2. Add example request demonstrating the parameter
3. Add Note explaining PermissionProvider limitation

**Content to Add**:

```markdown
    <ParamField body="verifyUserPermissions" type="boolean">
      When enabled, comments are only added for users who have access to the specified document.
      This ensures operations respect document access permissions configured via Access Control or Permission Provider.

      Default: `false`
    </ParamField>
```

**Example Request Section** (add after line 213, before Response section):

```markdown
#### 3. Add comment with permission verification

```JSON
{
  "data": {
    "organizationId": "yourOrganizationId",
    "documentId": "yourDocumentId",
    "annotationId": "yourAnnotationId",
    "verifyUserPermissions": true,
    "commentData": [
      {
        "commentText": "This is a verified comment",
        "commentHtml": "<div>This is a verified comment</div>",
        "from": {
          "userId": "yourUserId",
          "name": "Your Name",
          "email": "your.email@example.com"
        }
      }
    ]
  }
}
```

<Note>
When `verifyUserPermissions` is enabled, the API checks document access for each user before adding comments. Only users with access to the document will have comments created.
</Note>

<Info>Note: If you are using the new `PermissionProvider` then this flag will not work, you will need to do the permissions validation on your end before adding or updating the resource.</Info>
```

**Priority**: High
**Estimated Effort**: Medium (15-20 minutes)

---

## Implementation Sequence

### Phase 1: REST API Documentation Updates (Agent-3)

**Task 1**: Update Add Comment Annotations API
- File: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/comments-feature/comment-annotations/add-comment-annotations.mdx`
- Add `verifyUserPermissions` parameter documentation
- Add example request with permission verification
- Add Note and Info callouts

**Task 2**: Update Add Comments API
- File: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/comments-feature/comments/add-comments.mdx`
- Add `verifyUserPermissions` parameter documentation
- Add example request with permission verification
- Add Note and Info callouts

**Task 3**: Verify Existing Notifications API Documentation
- Confirm Add Notifications API already has correct documentation
- Confirm Update Notifications API already has correct documentation
- No changes needed to these files

**Dependencies**: None (tasks can be executed in parallel)

---

### Phase 2: Quality Assurance (Agent-6)

**Task 1**: Verify Documentation Accuracy
- Confirm parameter descriptions match across all 4 APIs
- Verify default values correctly stated (`false`)
- Check example requests are syntactically correct
- Validate Note and Info callouts are consistent

**Task 2**: Cross-Reference Validation
- Verify consistency with existing Add Notifications documentation
- Verify consistency with existing Update Notifications documentation
- Ensure terminology aligns across all 4 API docs

**Task 3**: Content Standards Compliance
- Verify JSON examples are properly formatted
- Check callout types (Note vs Info) used correctly
- Validate parameter placement in documentation structure

---

## Quality Checklist

### Documentation Completeness
- [ ] `verifyUserPermissions` parameter added to Add Comment Annotations API
- [ ] `verifyUserPermissions` parameter added to Add Comments API
- [ ] Example requests added for both APIs
- [ ] Note callouts explaining behavior added
- [ ] Info callouts about PermissionProvider limitation added
- [ ] Existing Add Notifications API documentation verified (already complete)
- [ ] Existing Update Notifications API documentation verified (already complete)

### Technical Accuracy
- [ ] Parameter type documented as `boolean`
- [ ] Default value documented as `false`
- [ ] Description explains permission validation behavior
- [ ] Integration with Access Control mentioned
- [ ] Integration with Permission Provider mentioned
- [ ] PermissionProvider limitation clearly noted

### Content Standards
- [ ] Parameter follows existing ParamField format
- [ ] Example requests use realistic organization/document IDs
- [ ] JSON formatting is correct
- [ ] Note callouts use `<Note>` component
- [ ] Info callouts use `<Info>` component
- [ ] Descriptions are concise and action-oriented

### Cross-File Consistency
- [ ] Descriptions match between Add Comment Annotations and Add Comments
- [ ] Descriptions match existing Add Notifications documentation
- [ ] Descriptions match existing Update Notifications documentation
- [ ] Note callout wording consistent across all 4 APIs
- [ ] Info callout wording consistent across all 4 APIs

### Areas Verified as Not Requiring Updates
- [x] Data Models - No new types/interfaces
- [x] SDK API Methods - REST API only change
- [x] UI Customization - No visual components
- [x] Migration Guides - Non-breaking change
- [x] Setup Guides - No setup changes
- [x] Overview Pages - No feature overview changes

---

## Risk Assessment

### Low Risk Areas
- **Non-Breaking**: Optional parameter with backward-compatible default
- **Established Pattern**: Follows same pattern as existing Notifications APIs
- **Limited Scope**: Only affects 4 REST API endpoints
- **Well-Tested**: Feature already deployed in Notifications APIs (v4.5.6-beta.12)

### Medium Risk Areas
- **Consistency**: Must ensure descriptions match across all 4 APIs
- **PermissionProvider Limitation**: Must clearly document when flag doesn't work

### Mitigation Strategies
- Use existing Notifications API documentation as template
- Copy exact wording for Note and Info callouts
- Run quality checks comparing all 4 API docs side-by-side

### Dependencies
- **No breaking dependencies**: Existing API calls unaffected
- **No feature dependencies**: Works with existing permission systems
- **No SDK dependencies**: REST API-only change

---

## Notes for Agent-3 (Technical Documentation Specialist)

### Implementation Guidelines

#### 1. Parameter Documentation Format

Follow this exact structure (consistent with Add Notifications API):

```markdown
<ParamField body="verifyUserPermissions" type="boolean">
  When enabled, [RESOURCE_TYPE] are only [ACTION] for users who have access to the specified document.
  This ensures operations respect document access permissions configured via Access Control or Permission Provider.

  Default: `false`
</ParamField>
```

**Variable Replacements**:
- Add Comment Annotations: RESOURCE_TYPE = "comment annotations", ACTION = "created"
- Add Comments: RESOURCE_TYPE = "comments", ACTION = "added"

#### 2. Example Request Placement

- **Add Comment Annotations**: Insert after line 293 (after "access context" example)
- **Add Comments**: Insert after line 213 (after "attachments" example, before Response section)

#### 3. Note Callout Format

Use this exact format (matches Add Notifications):

```markdown
<Note>
When `verifyUserPermissions` is enabled, the API checks document access for each user before [ACTION] [RESOURCE_TYPE]. Only users with access to the document will [RESULT].
</Note>
```

**Variable Replacements**:
- Add Comment Annotations: ACTION = "creating", RESOURCE_TYPE = "comment annotations", RESULT = "have comment annotations created"
- Add Comments: ACTION = "adding", RESOURCE_TYPE = "comments", RESULT = "have comments created"

#### 4. Info Callout Format

Copy this exact text (matches release note and Notifications APIs):

```markdown
<Info>Note: If you are using the new `PermissionProvider` then this flag will not work, you will need to do the permissions validation on your end before adding or updating the resource.</Info>
```

#### 5. JSON Example Guidelines

- Use realistic IDs (e.g., "acme-corp", "design-mockup-v2", "user_john_smith")
- Include `verifyUserPermissions: true` in the data object
- Keep examples minimal but complete
- Follow existing JSON formatting style in each file

### Reference Files

For consistency, reference these files:

1. **Add Notifications** (`/api-reference/rest-apis/v2/notifications/add-notifications.mdx`):
   - Lines 48-53: Parameter documentation format
   - Lines 163-196: Example request with permission verification
   - Line 195-196: Note callout format

2. **Update Notifications** (`/api-reference/rest-apis/v2/notifications/update-notifications.mdx`):
   - Lines 44-49: Parameter documentation format
   - Lines 192-211: Example request with permission verification
   - Lines 209-211: Note callout format

### Quality Standards

1. **Consistency**: All 4 APIs must use identical wording for:
   - Default value statement
   - PermissionProvider Info callout
   - Note callout structure (only noun/verb changes)

2. **Placement**: Parameter must appear in logical order:
   - After core identifiers (organizationId, documentId, annotationId)
   - Before resource-specific data (commentAnnotations, commentData)

3. **Formatting**: Follow existing file conventions for:
   - Indentation (spaces, not tabs, in ParamField sections)
   - Capitalization in descriptions
   - Backtick usage for code elements

---

## Notes for Agent-6 (Quality Assurance Specialist)

### Verification Checklist

#### 1. Parameter Documentation Verification

Compare all 4 APIs side-by-side and verify:
- [ ] Parameter name spelled identically: `verifyUserPermissions`
- [ ] Type documented identically: `boolean`
- [ ] Default value stated identically: `Default: \`false\``
- [ ] Description structure matches (only noun/verb differs)
- [ ] Mentions both "Access Control" and "Permission Provider"

#### 2. Example Request Validation

For each of the 2 new examples:
- [ ] JSON is syntactically valid
- [ ] `verifyUserPermissions` is inside `data` object
- [ ] Example is numbered correctly in sequence
- [ ] Example title clearly indicates "permission verification"
- [ ] Example includes realistic, complete data

#### 3. Callout Consistency

Compare Note callouts across all 4 APIs:
- [ ] All use `<Note>` component (not `<Warning>` or other)
- [ ] All mention "`verifyUserPermissions` is enabled"
- [ ] All mention "checks document access"
- [ ] Only appropriate nouns/verbs differ (notifications vs comments)

Compare Info callouts across all 4 APIs:
- [ ] All use `<Info>` component
- [ ] All have identical text (word-for-word)
- [ ] All mention "new `PermissionProvider`"
- [ ] All explain the limitation clearly

#### 4. Cross-Reference with Existing Docs

Verify against Add Notifications (lines 48-53, 163-196):
- [ ] Parameter description structure matches
- [ ] Default value format matches
- [ ] Note callout structure matches
- [ ] Info callout text is identical

Verify against Update Notifications (lines 44-49, 192-211):
- [ ] Parameter description structure matches
- [ ] Default value format matches
- [ ] Note callout structure matches
- [ ] Info callout text is identical

#### 5. Format Standards Validation

- [ ] Parameter uses `<ParamField body="..." type="boolean">`
- [ ] Description uses consistent capitalization
- [ ] Default value uses backticks: `Default: \`false\``
- [ ] JSON code blocks use correct syntax highlighting
- [ ] Example titles start with "####" (4 hashes)

---

## Pipeline Handoff

### To Agent-3 (Technical Documentation Specialist)

**Status**: Ready for implementation
**Priority**: High
**Estimated Time**: 30-40 minutes total

**Files to Update**:
1. `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/comments-feature/comment-annotations/add-comment-annotations.mdx`
2. `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/comments-feature/comments/add-comments.mdx`

**Files to Verify (No Changes)**:
3. `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/notifications/add-notifications.mdx`
4. `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/notifications/update-notifications.mdx`

**Implementation Order**:
1. Update Add Comment Annotations API (15-20 min)
2. Update Add Comments API (15-20 min)
3. Verify existing Notifications API docs (5 min)
4. Cross-check consistency across all 4 files (5-10 min)

### Success Criteria
- [ ] 2 new parameter documentations added
- [ ] 2 new example requests added
- [ ] 2 new Note callouts added
- [ ] 2 new Info callouts added
- [ ] All descriptions consistent across 4 APIs
- [ ] All callouts use identical text
- [ ] All examples syntactically correct
- [ ] All formatting matches existing style

---

## Version Control Notes

**Branch**: Feature branch recommended
**Commit Message Template**:
```
docs: add verifyUserPermissions to Comments REST APIs

- Add verifyUserPermissions parameter to Add Comment Annotations API
- Add verifyUserPermissions parameter to Add Comments API
- Include permission verification examples
- Document PermissionProvider limitation
- Align with existing Notifications API documentation

Release: v4.6.0-beta.5
```

---

## Appendix: Release Note Reference

### Original Release Note Content
```
Version: 4.6.0-beta.5
Date: January 12, 2025
Category: Improvements

What was added:
- Added `verifyUserPermissions` flag to 4 REST APIs:
  * Add Comment Annotations
  * Add Comments in Comment Annotation
  * Add Notifications
  * Update Notifications
- When enabled, prevents creating/updating resources for users without document access
- Works with PermissionProvider

Important Note:
If you are using the new `PermissionProvider` then this flag will not work,
you will need to do the permissions validation on your end before adding or
updating the resource.
```

### Previously Documented (v4.5.6-beta.12)
The `verifyUserPermissions` flag was first introduced in v4.5.6-beta.12 for:
- Add Notifications API
- Update Notifications API

This release (v4.6.0-beta.5) extends the same flag to Comments-related APIs.

---

## Analysis Summary

### What Changed
- **Scope**: 4 REST APIs gained new optional parameter
- **Type**: API enhancement (non-breaking)
- **Default**: `false` (maintains existing behavior)

### Documentation Impact
- **Files Requiring Updates**: 2 (Comments REST APIs)
- **Files Already Updated**: 2 (Notifications REST APIs from v4.5.6-beta.12)
- **New Types/Interfaces**: 0 (primitive boolean)
- **New SDK Methods**: 0 (REST API only)
- **UI Changes**: 0 (backend validation)

### Update Strategy
- Follow established pattern from Notifications APIs (v4.5.6-beta.12)
- Ensure exact consistency in wording across all 4 APIs
- Focus updates on Comments-specific REST API documentation
- No SDK, Data Models, or UI Customization updates needed

---

**Log File Created**: December 8, 2025
**Planning Agent**: Agent-2
**Next Agent**: Agent-3 (Technical Documentation Specialist)
**Status**: Planning Complete - Ready for Implementation
