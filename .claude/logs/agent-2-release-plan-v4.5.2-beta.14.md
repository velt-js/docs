# Release Update Plan for v4.5.2-beta.14

## Overview
- **Release Version**: 4.5.2-beta.14
- **Release Date**: September 18, 2025
- **Release Type**: Beta Patch
- **Key Changes**: Access Control API improvements and viewer role enforcement, plus Core bug fixes
- **Breaking Changes**: Yes - API payload changes (removal of `userIds` from request)

## Release Note Summary

### Improvements
1. **Access Control - Get User Permissions API Update**
   - Removed `userIds` from request payload (BREAKING CHANGE)
   - Added `errorCode` field to response with structured error codes
   - Three error code types: `DOES_NOT_EXIST`, `PERMISSION_DENIED`, `SOMETHING_WENT_WRONG`
   - Included TypeScript interfaces: GetUserPermissionsRequest, GetUserPermissionsResponse, UserPermissionAccessRoleResult enum, UserPermissionAccessRole enum
   - API method: `client.getUserPermissions()` (React) and `Velt.getUserPermissions()` (HTML)

2. **Access Control - Viewer Role Enforcement**
   - Users with `viewer` access role are now prevented from adding comments or updating metadata
   - Ensures proper read-only enforcement

### Bug Fixes
1. **Core - Document Switch Fix**: Resolved issue where comments were not disappearing when navigating between documents
2. **Core - Local Cache Fix**: Fixed local cache comment persistence issue causing stale data

---

## Areas Requiring Updates

### 1. Data Models
**Files to Update**:
- `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`

**Changes Needed**:
1. **GetUserPermissionsRequest interface** - Update to remove `userIds` field:
   - CURRENT: Has `userIds?: string[]` field with description "User IDs to fetch permissions for. If omitted, uses current user"
   - NEW: Remove the `userIds` field entirely from the table
   - Location: Around line 1144-1152

2. **UserPermissionInfo interface** - Add new `errorCode` field:
   - CURRENT: Has `accessRole`, `expiresAt`, `error` fields
   - NEW: Add `errorCode?: UserPermissionAccessRoleResult` field
   - Description: "Error code for structured error handling when permission resolution fails"
   - Location: Around line 1155-1162

3. **Add new enum: UserPermissionAccessRoleResult**:
   - Create new section after UserPermissionAccessRole enum (around line 1142)
   - Type: enum
   - Values:
     - `DOES_NOT_EXIST = 'does_not_exist'` - Resource does not exist
     - `PERMISSION_DENIED = 'permission_denied'` - User does not have permission to access resource
     - `SOMETHING_WENT_WRONG = 'something_went_wrong'` - Unknown error occurred during permission resolution
   - Include description explaining when each error code is returned

**Priority**: High (API contract changes)

---

### 2. API Methods
**Files to Update**:
- `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`

**Changes Needed**:
1. **getUserPermissions() method documentation** (around line 1954-1959):
   - CURRENT: References GetUserPermissionsRequest and GetUserPermissionsResponse
   - VERIFY: Ensure method signature and description remain accurate
   - ADD NOTE: Add note about breaking change (userIds removed from request)
   - The existing documentation already references the correct types, but needs to reflect the removal of userIds

**Priority**: High (API documentation accuracy)

---

### 3. Key Concepts Documentation
**Files to Update**:
- `/Users/yoenzhang/Downloads/docs/key-concepts/overview.mdx`

**Changes Needed**:

1. **Access Control Section - Roles subsection** (around line 1130-1141):
   - CURRENT: Describes Editor and Viewer roles
   - UPDATE: Add enhanced description for Viewer role enforcement
   - NEW TEXT: Add note that "Viewer role users are prevented from adding comments or updating metadata, ensuring read-only access is enforced at the SDK level"
   - Emphasize that this enforcement is automatic and requires no additional configuration

2. **Access Control Section - Add new subsection: "Get User Permissions"**:
   - Location: After the "Roles" subsection (after line 1141)
   - Purpose: Document the getUserPermissions API with updated request/response structure
   - Content:
     - Overview of what the API does
     - Request parameters (without userIds)
     - Response structure (with errorCode field)
     - Error code meanings and handling
     - Code examples for both React and Other Frameworks
     - Link to full API documentation

**Priority**: High (User-facing feature documentation)

---

### 4. Comments Feature Documentation
**Files to Update**:
- `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
- `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/overview.mdx` (if exists and covers permissions)

**Changes Needed**:

1. **Add section on Viewer Role Restrictions**:
   - Location: In customize-behavior.mdx, likely in a section about access control or permissions
   - Content:
     - Explain that users with viewer access role cannot add comments or update metadata
     - Describe the behavior users will experience (e.g., comment UI disabled, error messages)
     - Provide guidance on how to assign viewer vs editor roles
     - Link to Access Control documentation in key-concepts

**Priority**: Medium (Feature-specific behavior documentation)

---

### 5. Migration & Upgrade Guides
**Files to Create/Update**:
- `/Users/yoenzhang/Downloads/docs/release-notes/version-4/sdk-changelog.mdx` (already updated by Agent-1)

**Changes Needed**:
- The release note already includes the breaking change documentation
- VERIFY: Ensure migration path is clear for developers using getUserPermissions with userIds parameter
- ADD: Consider adding a migration guide section if this is the first breaking change in 4.5.x series

**Priority**: High (Breaking changes require clear migration guidance)

---

### 6. Error Handling Documentation
**Files Potentially Affected**:
- Any error handling or troubleshooting guides

**Changes Needed**:
- Document new error codes: DOES_NOT_EXIST, PERMISSION_DENIED, SOMETHING_WENT_WRONG
- Provide guidance on how to handle each error code programmatically
- Include examples of error response structures

**Priority**: Medium (Developer experience improvement)

**Note**: Need to verify if error handling documentation exists separately. If not, this should be covered in the Key Concepts Access Control section.

---

### 7. Advanced Setup Documentation
**Files to Update**:
- `/Users/yoenzhang/Downloads/docs/get-started/advanced.mdx`

**Changes Needed**:
1. **JWT Authentication Tokens section** (around line 30):
   - CURRENT: Mentions Editor/Viewer roles briefly
   - UPDATE: Enhance the description to mention the new viewer role enforcement
   - ADD NOTE: Reference that viewer enforcement is now automatic in SDK v4.5.2-beta.14+

**Priority**: Low (Context enhancement)

---

## Implementation Sequence

1. **Phase 1 - Critical API Updates (Agent-3)**:
   - Update GetUserPermissionsRequest in data-models.mdx (remove userIds)
   - Update UserPermissionInfo in data-models.mdx (add errorCode field)
   - Add UserPermissionAccessRoleResult enum to data-models.mdx
   - Verify getUserPermissions() method in api-methods.mdx

2. **Phase 2 - Feature Documentation (Agent-3)**:
   - Update Access Control Roles section in key-concepts/overview.mdx
   - Add "Get User Permissions" subsection in key-concepts/overview.mdx
   - Update advanced.mdx JWT section

3. **Phase 3 - Feature-Specific Documentation (Agent-4/5)**:
   - Add viewer role restrictions to comments customize-behavior.mdx
   - Add error handling guidance if separate documentation exists

4. **Phase 4 - Cross-Reference Validation (Agent-5)**:
   - Verify all links between documentation sections
   - Ensure terminology consistency
   - Validate code examples

5. **Phase 5 - Final QA (Agent-6)**:
   - Comprehensive review of all changes
   - Terminology alignment check
   - Breaking change documentation verification

---

## Quality Assurance Checklist

- [ ] GetUserPermissionsRequest updated to remove userIds field in data-models.mdx
- [ ] UserPermissionInfo updated to add errorCode field in data-models.mdx
- [ ] UserPermissionAccessRoleResult enum added to data-models.mdx with all three error codes
- [ ] getUserPermissions() method documentation verified in api-methods.mdx
- [ ] Access Control Roles section updated with viewer enforcement details
- [ ] "Get User Permissions" subsection added to key-concepts/overview.mdx
- [ ] Comments documentation updated with viewer role restrictions
- [ ] Code examples include both React and Other Frameworks tabs
- [ ] Error codes documented with clear descriptions
- [ ] Breaking change clearly documented in release notes (already done by Agent-1)
- [ ] Migration guidance provided for userIds removal
- [ ] Cross-references and links updated
- [ ] Terminology aligned across all documentation
- [ ] Version accuracy validated - all content matches v4.5.2-beta.14

---

## Breaking Changes Summary

### getUserPermissions API - Request Payload Change

**What Changed**:
- The `userIds` field has been removed from the `GetUserPermissionsRequest` interface
- The API now only returns permissions for the current authenticated user

**Migration Path**:
1. Remove any code passing `userIds` parameter to `getUserPermissions()`
2. If you need to fetch permissions for multiple users, call the API separately for each user after authenticating them
3. Update TypeScript interfaces if you're using custom type definitions

**Example**:

BEFORE:
```typescript
const permissions = await client.getUserPermissions({
  organizationId: 'org1',
  userIds: ['user1', 'user2', 'user3']
});
```

AFTER:
```typescript
// Now only fetches permissions for current authenticated user
const permissions = await client.getUserPermissions({
  organizationId: 'org1'
});
```

---

## Additional Notes

### Version Accuracy Validation
- Release note version: v4.5.2-beta.14
- Release date: September 18, 2025
- All documentation updates must reference this specific version
- Ensure no content is carried over from other versions

### Terminology Consistency
- Use "Access Control" (not "Cloud Functions" or old terminology)
- Use "viewer" and "editor" roles consistently (lowercase when referring to the role value, capitalized when referring to the role name)
- Use "getUserPermissions" (camelCase) consistently in code examples
- Use "error code" (not "error type" or "error status")

### Code Example Requirements
- All code examples must include both React/Next.js and Other Frameworks tabs
- React examples should show both hook and API method approaches where applicable
- Ensure proper TypeScript typing in all examples
- Include practical error handling examples using the new errorCode field

### Cross-References to Update
- Link from Access Control section to getUserPermissions API documentation
- Link from comments documentation to Access Control roles
- Link from advanced setup to Access Control documentation
- Ensure all data model references link correctly to data-models.mdx

---

## Files Summary

### Files to Update:
1. `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
2. `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
3. `/Users/yoenzhang/Downloads/docs/key-concepts/overview.mdx`
4. `/Users/yoenzhang/Downloads/docs/get-started/advanced.mdx`
5. `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`

### Files Already Updated:
1. `/Users/yoenzhang/Downloads/docs/release-notes/version-4/sdk-changelog.mdx` (by Agent-1)

### Total Files Requiring Updates: 5 files

---

## Agent Handoff Instructions

### For Agent-3 (Models and Methods Updater):
1. Start with data-models.mdx updates (remove userIds, add errorCode, add enum)
2. Then verify api-methods.mdx references
3. Then update key-concepts/overview.mdx Access Control section
4. Finally update get-started/advanced.mdx

Agent-3 should focus on technical API documentation and data models. Pass feature-specific behavior documentation to Agent-4/5.

### For Agent-4 (UI Customization Updater):
1. Review if any UI components are affected by viewer role enforcement
2. Check if wireframe examples need updates related to access control

### For Agent-5 (Documentation Alignment Enforcer):
1. Add viewer role restrictions to comments customize-behavior.mdx
2. Verify all cross-references are correct
3. Ensure terminology consistency across all updated files
4. Validate code example formatting

### For Agent-6 (QA & Terminology Aligner):
1. Comprehensive review of all changes
2. Verify breaking change documentation is clear
3. Check that all error codes are properly documented
4. Validate version references are accurate

---

## Risk Assessment

**High Risk Areas**:
- Breaking change in getUserPermissions API could impact existing implementations
- Need to ensure migration guidance is crystal clear

**Medium Risk Areas**:
- Viewer role enforcement changes user behavior - needs clear documentation
- Error code documentation needs to be comprehensive for proper error handling

**Low Risk Areas**:
- Bug fixes are non-breaking and don't require documentation beyond release notes

---

## Completion Criteria

This release update plan is complete when:
1. All data models are updated with correct types and enums
2. All API methods documentation reflects the changes
3. Key concepts documentation explains viewer role enforcement
4. Breaking changes are clearly documented with migration guidance
5. Code examples are consistent and include error handling
6. All cross-references are validated
7. QA checklist is fully satisfied

---

End of Release Update Plan for v4.5.2-beta.14
