# Release Update Planning Log for v4.5.6-beta.11
**Date:** October 14, 2025
**Agent:** Agent-2 (Release Planning Specialist)
**Release Type:** Beta Release (Minor feature addition with improvements)

---

## Executive Summary

Release v4.5.6-beta.11 introduces a significant new authentication method (Permission Provider) and several improvements to folder management and access control. This release requires:

1. **NEW FEATURE DOCUMENTATION**: Permission Provider authentication method (no existing documentation)
2. **Data model updates**: 5 new interfaces need to be added to data-models.mdx
3. **API method updates**: 1 new SDK method (`setPermissionProvider`) needs documentation
4. **REST API updates**: 4 existing REST API endpoints need parameter/response updates
5. **Behavior change documentation**: `setDocuments` method behavior change needs clarification
6. **Key concepts updates**: Access control section needs updates for new authentication flow

**Breaking Changes:** None, but behavior changes in `setDocuments` and document-level access priority need clear documentation.

---

## Analysis Summary

### Release Content Breakdown

**New Features (1):**
- Permission Provider: New real-time authentication method that validates access by querying customer authorization services instead of pre-syncing users

**Improvements (7):**
1. Added `maxDepth` parameter to getFolders REST API with new response fields
2. Added `inheritFromParent` parameter to update folder access REST API
3. Update folder API handles folder moves gracefully
4. Added `accessType` parameter to create folder REST API
5. `setDocuments` now filters out inaccessible documents instead of failing
6. Document-level access now prioritized over folder-level access
7. Folder document limit set to 50 when using `allDocuments` flag

**Bug Fixes:** None

---

## Documentation Areas Requiring Updates

### 1. Data Models (data-models.mdx)
**File Path:** `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`

#### New Interfaces to Add:

**VeltPermissionProvider**
```typescript
interface VeltPermissionProvider {
  onResourceAccessRequired: (requests: PermissionQuery[]) => Promise<PermissionResult>;
  retryConfig?: AuthRetryConfig;
  forceRefresh?: boolean;
}
```

**PermissionQuery**
```typescript
interface PermissionQuery {
  userId: string;
  resource: {
    type: 'document' | 'folder' | 'organization';
    id: string;
  };
}
```

**PermissionResult**
```typescript
interface PermissionResult {
  data: PermissionData[];
  success: boolean;
  statusCode: number;
  signature: string;
}
```

**PermissionData**
```typescript
interface PermissionData {
  userId: string;
  resourceId: string;
  type: 'document' | 'folder' | 'organization';
  hasAccess: boolean;
  accessRole?: 'viewer' | 'editor';
  expiresAt?: number;
}
```

**Note:** `AuthRetryConfig` already exists (confirmed via grep) but needs to be referenced in `VeltPermissionProvider` documentation.

**Priority:** HIGH
**Reason:** Required for new Permission Provider feature

---

### 2. API Methods (api-methods.mdx)
**File Path:** `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`

#### New Method to Add:

**setPermissionProvider()**
- **Description:** Configure a permission provider for real-time access validation instead of pre-syncing users
- **Params:** [VeltPermissionProvider](/api-reference/sdk/models/data-models#veltpermissionprovider)
- **Returns:** `void`
- **React Hook:** `n/a`
- **Full Documentation:** Link to new feature documentation (to be created)
- **Section:** Create new "Access Control" section or add under existing authentication section

#### Method Behavior Update:

**setDocuments()**
- **Current documentation location:** Line 2218-2225 in api-methods.mdx
- **Update needed:** Add behavior note about filtering inaccessible documents
- **New note to add:**
```
Note: This method now filters out documents the user doesn't have access to instead of failing the entire operation. When using the `allDocuments` flag with a folder, only the first 50 documents are retrieved, and any inaccessible documents are automatically filtered out.
```

**Priority:** HIGH (new method), MEDIUM (behavior update)
**Reason:** Core feature addition and behavior change that affects existing API usage

---

### 3. REST API Documentation Updates

#### 3.1 Get Folders API
**File Path:** `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/folders/get-folders.mdx`

**Changes Required:**
- Add new `maxDepth` parameter to request body
- Add new response fields: `ancestors` (array), `inheritAccessFromParent` (boolean)

**New Parameter:**
```
<ParamField body="maxDepth" type="number">
  Maximum depth level for retrieving nested subfolders. Allows you to retrieve subfolders at any depth level.
</ParamField>
```

**Updated Response Schema:**
Add to folder object in response:
```json
{
  "folderId": "folderId1",
  "folderName": "Folder 1",
  "organizationId": "yourOrganizationId",
  "parentFolderId": "root",
  "createdAt": 1738695077691,
  "lastUpdated": 1738695077691,
  "ancestors": ["root", "parentFolder1"],  // NEW
  "inheritAccessFromParent": true,  // NEW
  "subFolders": [...]
}
```

**Priority:** HIGH
**Reason:** New API parameter and response fields

---

#### 3.2 Update Folder Access API
**File Path:** `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/folders/update-folder-access.mdx`

**Changes Required:**
- Add new `inheritFromParent` parameter to request body

**New Parameter:**
```
<ParamField body="inheritFromParent" type="boolean">
  Configure the folder to inherit access permissions from its parent folder.
</ParamField>
```

**Example Request to Add:**
```json
{
  "data": {
    "organizationId": "org1",
    "folderIds": ["folder1"],
    "inheritFromParent": true
  }
}
```

**Priority:** HIGH
**Reason:** New API parameter

---

#### 3.3 Add Folder API
**File Path:** `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/folders/add-folder.mdx`

**Changes Required:**
- Add new `accessType` parameter to folders array

**New Parameter (within folders array):**
```
<ParamField body="accessType" type="string">
  Access type for the folder. Allowed values: `organizationPrivate`, `restricted`, `public`. [Learn more](/key-concepts/overview#access-control).
</ParamField>
```

**Example Request to Add:**
```json
{
  "data": {
    "organizationId": "org1",
    "folders": [
      {
        "folderId": "folder2025",
        "folderName": "folder2025",
        "accessType": "restricted"
      }
    ]
  }
}
```

**Priority:** MEDIUM
**Reason:** New optional parameter for folder creation

---

#### 3.4 Update Folder API
**File Path:** `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/folders/update-folder.mdx`

**Changes Required:**
- Add behavior note about automatic handling of folder moves

**New Note to Add:**
```
<Note>
When moving a folder to a different parent, the API automatically updates the folder's `ancestors` array and `accessType`, and propagates these changes to all subfolders.
</Note>
```

**Priority:** LOW
**Reason:** Behavior improvement documentation (no API signature changes)

---

#### 3.5 NEW REST API: Generate Signature
**File Path:** `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/auth/generate-signature.mdx` (NEW FILE)

**Status:** MISSING DOCUMENTATION - This REST API is referenced in the release note but no documentation exists

**Endpoint:** `POST https://api.velt.dev/v2/auth/generate_signature`

**Purpose:** Generate secure signature for Permission Provider responses

**Required Documentation:**
- Endpoint details
- Request parameters (data array with permission data)
- Response format (signature)
- Example requests/responses
- Integration guidance with Permission Provider

**Priority:** HIGH
**Reason:** New REST API endpoint required for Permission Provider feature

---

### 4. Feature Documentation (NEW DOCUMENTATION REQUIRED)

#### 4.1 Permission Provider Authentication Method
**Status:** NO EXISTING DOCUMENTATION
**Documentation Type:** New Feature Guide
**Recommended File Path:** Create new section in `/Users/yoenzhang/Downloads/docs/key-concepts/overview.mdx` under "Authentication" section OR create new dedicated file

**Required Content:**

**Section: "Authentication Methods"**
Update the authentication section in key-concepts/overview.mdx to include three methods:
1. Use Auth Provider (existing)
2. Use Identify with JWT Token (existing)
3. **Use Permission Provider (NEW)**

**New Content Structure:**

```markdown
##### 3. Use Permission Provider (Real-time Access Validation)

With this approach, Velt validates access requests in real-time by querying your authorization service. Instead of pre-syncing users or passing details during identification, Velt calls your permission provider whenever a user requests access to a resource.

**When to Use:**
- Your app has complex, frequently changing access control rules
- You want to maintain your authorization system as the single source of truth
- You need real-time access validation without pre-syncing
- Access control changes frequently (e.g., high-frequency notifications)

**How It Works:**
1. User requests access to a resource (document, folder, organization)
2. Velt calls your `onResourceAccessRequired` function with the access request details
3. Your function queries your authorization service
4. You return access decisions with a secure signature
5. Velt handles user syncing automatically

**Prerequisites:**
- Set your API key's `defaultDocumentAccessType` to `restricted` in the [console](https://console.velt.dev/dashboard/config/appconfig)
- Deploy v4 series of the Velt SDK

**Parameters:**
- `onResourceAccessRequired`: Async function that receives permission queries and returns access decisions
  - Input: [PermissionQuery[]](/api-reference/sdk/models/data-models#permissionquery)
  - Output: [PermissionResult](/api-reference/sdk/models/data-models#permissionresult)
- `retryConfig`: [AuthRetryConfig](/api-reference/sdk/models/data-models#authretryconfig) - Retry configuration for failed requests
  - `retryCount`: Number of retry attempts (default: 3)
  - `retryDelay`: Delay between retries in milliseconds (default: 2000)
- `forceRefresh`: boolean - Set to `true` if access control changes frequently (e.g., for high-frequency notifications). Default: `false`

[Include code examples from release note]

**Generating Secure Signatures:**
Use the [Generate Signature REST API](/api-reference/rest-apis/v2/auth/generate-signature) to create secure signatures for your permission responses.

**Error Handling:**
- Failed requests are retried based on `retryConfig`
- Access is denied by default if the provider returns an error
- Velt logs errors to the console for debugging
```

**Priority:** HIGH
**Reason:** New major feature without existing documentation

---

#### 4.2 Update Key Concepts - Access Control Section
**File Path:** `/Users/yoenzhang/Downloads/docs/key-concepts/overview.mdx`

**Changes Required:**

**Section: "Access Control" (starting around line 1116)**

Add new subsection after "Configuration Modes":

```markdown
#### 3) Real-time Permission Provider (New)
Validate access in real-time by querying your authorization service when users request access to resources.
- Best when you have complex access control that changes frequently
- Your authorization system remains the single source of truth
- Velt calls your provider on-demand and handles user syncing automatically
- No need to pre-sync users or maintain duplicate permission state

##### How It Works
1. Configure a permission provider using `setPermissionProvider` method
2. When a user requests access, Velt calls your `onResourceAccessRequired` function
3. Your function queries your authorization service and returns access decisions
4. Velt validates the signature and grants/denies access accordingly
5. User is automatically synced if access is granted

##### APIs
- **Frontend SDK:** Use `setPermissionProvider` to configure your permission provider. [Learn more](/key-concepts/overview#use-permission-provider)
- **Backend API:** Use [Generate Signature](/api-reference/rest-apis/v2/auth/generate-signature) to create secure signatures for permission responses

##### Configuration
Set your API key's `defaultDocumentAccessType` to `restricted` in the [console](https://console.velt.dev/dashboard/config/appconfig) to ensure access is denied by default unless explicitly granted through the provider.
```

**Additional Update - Document Access Priority:**
Add note under "Documents" section (around line 280):

```markdown
<Note>
**Access Priority:** Document-level access settings take precedence over folder-level access. If a document has explicit access settings, they override the folder's permissions. If no explicit document access is set, the document inherits from its folder or organization.
</Note>
```

**Priority:** HIGH
**Reason:** Core concept update for new authentication method and access behavior clarification

---

### 5. Code Examples & Integration Guides

#### 5.1 Update setDocuments Examples
**File Path:** `/Users/yoenzhang/Downloads/docs/key-concepts/overview.mdx`

**Section: "Subscribe to a folder" (lines 81-200)**

Add note after code examples:

```markdown
<Note>
**Document Filtering:** When subscribing to folders with `allDocuments` flag:
- Maximum of 50 documents are retrieved
- Documents the user doesn't have access to are automatically filtered out
- The operation continues successfully even if some documents are inaccessible
</Note>
```

**Priority:** MEDIUM
**Reason:** Behavior change clarification for existing feature

---

### 6. Migration & Upgrade Guides

**Assessment:** No migration guide required
**Reason:**
- No breaking changes in this release
- New feature is additive (Permission Provider)
- Behavior changes are improvements that don't break existing implementations
- API parameter additions are optional

**Priority:** N/A

---

## Missing Documentation Identified

### Critical Missing Documentation:

1. **Generate Signature REST API** (`/v2/auth/generate_signature`)
   - Referenced in release note code examples
   - Required for Permission Provider feature
   - No documentation file exists
   - **Agent-5 Action Required:** Create new file at `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/auth/generate-signature.mdx`

### New Documentation Structure Required:

**File:** Permission Provider feature guide
**Recommended Location:** Add to `/Users/yoenzhang/Downloads/docs/key-concepts/overview.mdx` under Authentication section
**Content Type:** New authentication method documentation
**Integration Points:**
- Links to data models for interface definitions
- Links to API methods for SDK usage
- Links to Generate Signature REST API
- Links to console configuration

---

## Implementation Sequence

### Phase 1: Foundation (Data Models & API Signatures)
**Priority: HIGH - Must be completed first**

1. Update `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
   - Add VeltPermissionProvider interface
   - Add PermissionQuery interface
   - Add PermissionResult interface
   - Add PermissionData interface
   - Verify AuthRetryConfig exists and is properly documented

2. Update `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
   - Add setPermissionProvider() method entry
   - Update setDocuments() behavior note

**Estimated Effort:** 1-2 hours
**Dependencies:** None
**Assigned to:** Agent-3 (Technical Documentation Specialist)

---

### Phase 2: REST API Documentation
**Priority: HIGH - Required for feature completeness**

3. Create `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/auth/generate-signature.mdx` (NEW FILE)
   - Document endpoint, parameters, responses
   - Add code examples
   - Link to Permission Provider feature guide

4. Update `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/folders/get-folders.mdx`
   - Add maxDepth parameter
   - Update response schema with ancestors and inheritAccessFromParent fields
   - Add example requests

5. Update `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/folders/update-folder-access.mdx`
   - Add inheritFromParent parameter
   - Add example request

6. Update `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/folders/add-folder.mdx`
   - Add accessType parameter to folders array
   - Add example request

7. Update `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/folders/update-folder.mdx`
   - Add behavior note about automatic folder move handling

**Estimated Effort:** 3-4 hours
**Dependencies:** Phase 1 (data models for type references)
**Assigned to:** Agent-3 (Technical Documentation Specialist)

---

### Phase 3: Feature Documentation & Guides
**Priority: HIGH - Required for feature adoption**

8. Update `/Users/yoenzhang/Downloads/docs/key-concepts/overview.mdx`
   - Add "Use Permission Provider" authentication method section
   - Add "Real-time Permission Provider" configuration mode
   - Add document access priority note
   - Add setDocuments filtering behavior note
   - Link all sections appropriately

**Estimated Effort:** 2-3 hours
**Dependencies:** Phase 1 & 2 (all API references must exist)
**Assigned to:** Agent-5 (Cross-reference & Alignment Specialist)

---

### Phase 4: Cross-references & Alignment
**Priority: MEDIUM - Quality assurance**

9. Verify all internal links work correctly
10. Ensure terminology consistency across all updated files
11. Validate code examples compile/execute correctly
12. Check that all new types reference Data Models page correctly

**Estimated Effort:** 1-2 hours
**Dependencies:** Phase 1, 2, 3 (all updates complete)
**Assigned to:** Agent-6 (QA Specialist)

---

## Quality Assurance Checklist

- [ ] All new types added to Data Models page with correct interface definitions
- [ ] VeltPermissionProvider interface documented with all properties
- [ ] PermissionQuery interface documented
- [ ] PermissionResult interface documented
- [ ] PermissionData interface documented
- [ ] AuthRetryConfig properly referenced in VeltPermissionProvider

- [ ] setPermissionProvider() method added to API Methods index
- [ ] setPermissionProvider() method includes all parameters and return types
- [ ] setDocuments() behavior note added about filtering inaccessible documents
- [ ] setDocuments() note includes 50-document limit with allDocuments flag

- [ ] Generate Signature REST API documentation created (NEW FILE)
- [ ] Get Folders REST API updated with maxDepth parameter
- [ ] Get Folders REST API response updated with ancestors and inheritAccessFromParent
- [ ] Update Folder Access REST API updated with inheritFromParent parameter
- [ ] Add Folder REST API updated with accessType parameter
- [ ] Update Folder REST API includes folder move behavior note

- [ ] Permission Provider authentication method documented in key concepts
- [ ] Permission Provider includes prerequisites (defaultDocumentAccessType = restricted)
- [ ] Permission Provider includes when to use guidance
- [ ] Permission Provider includes how it works explanation
- [ ] Permission Provider includes all parameters with descriptions
- [ ] Permission Provider includes code examples for React and Other Frameworks
- [ ] Permission Provider links to Generate Signature REST API
- [ ] Real-time Permission Provider configuration mode added to Access Control section
- [ ] Document access priority note added to Documents section
- [ ] setDocuments filtering behavior note added to Folders section

- [ ] Code examples include both React and Other Frameworks tabs
- [ ] All code examples are syntactically correct
- [ ] All type references link to Data Models page
- [ ] All method references link to API Methods page
- [ ] All REST API references link to correct endpoints

- [ ] Cross-references updated between related documentation
- [ ] Internal links verified and working
- [ ] Terminology aligned across all documentation (no inconsistencies)
- [ ] No unnecessary updates planned (bug fixes without API changes excluded)

- [ ] Version accuracy validated - all content matches v4.5.6-beta.11 exactly
- [ ] No breaking changes incorrectly documented as such
- [ ] Behavior improvements clearly distinguished from breaking changes
- [ ] Optional parameters clearly marked as optional

- [ ] Detailed analysis findings written to this log file
- [ ] Implementation sequence clearly defined with dependencies
- [ ] Agent assignments made for each phase
- [ ] Estimated effort provided for each phase

---

## Special Considerations

### 1. Permission Provider Prerequisites
The documentation MUST emphasize that `defaultDocumentAccessType` must be set to `restricted` for Permission Provider to work correctly. This is a critical configuration step.

**Recommendation:** Add Warning component in the documentation:
```markdown
<Warning>
Before using Permission Provider, you must set your API key's `defaultDocumentAccessType` to `restricted` in the [console](https://console.velt.dev/dashboard/config/appconfig). This ensures access is denied by default unless explicitly granted through your permission provider.
</Warning>
```

### 2. Signature Security
The Generate Signature REST API is a security-critical endpoint. Documentation should emphasize:
- Signature must be generated server-side
- Never expose API keys in frontend code
- Signature validates the integrity of permission responses

### 3. Access Priority Clarification
The change to document-level access taking priority over folder-level access is a behavior change that could affect existing implementations. While not technically breaking (it's more intuitive), it should be clearly documented.

### 4. setDocuments Filtering Behavior
The change from "fail entire operation" to "filter and continue" is a significant improvement but represents a behavior change. Existing error handling code may need adjustment. Include a note about this in the documentation.

### 5. Folder Document Limit
The 50-document limit when using `allDocuments` flag is a new constraint. This should be clearly documented to prevent confusion when users expect all documents.

---

## Dependencies & Cross-References

### Internal Documentation Links Required:

**From Permission Provider Documentation:**
- → Data Models: VeltPermissionProvider, PermissionQuery, PermissionResult, PermissionData
- → API Methods: setPermissionProvider()
- → REST APIs: Generate Signature
- → Key Concepts: Access Control, Authentication
- → Console: App Configuration settings

**From Generate Signature REST API:**
- → Permission Provider feature documentation
- → Security: Auth Tokens
- → Key Concepts: Access Control

**From Updated Folder REST APIs:**
- → Key Concepts: Folders, Access Control
- → Data Models: Folder interface (if exists)

**From Key Concepts Updates:**
- → Permission Provider documentation
- → REST APIs: Generate Signature, Add Permissions, Remove Permissions
- → API Methods: setPermissionProvider, setDocuments
- → Console: App Configuration

### External Dependencies:
- None (all changes are internal to Velt documentation)

---

## Risk Assessment

### Low Risk:
- Folder REST API parameter additions (optional parameters, backward compatible)
- Behavior notes for folder move handling (clarification only)
- setDocuments filtering behavior documentation (improvement, not breaking)

### Medium Risk:
- Document access priority change (could affect existing access control logic)
- 50-document limit with allDocuments flag (new constraint on existing feature)

### High Risk:
- Permission Provider feature (entirely new authentication method)
- Generate Signature REST API (security-critical, no existing documentation)

### Mitigation Strategies:
1. Clear documentation of all behavior changes with warnings where appropriate
2. Code examples for all new features showing correct implementation
3. Prerequisites clearly stated for Permission Provider
4. Security best practices emphasized for Generate Signature API
5. Thorough QA review by Agent-6 before publishing

---

## Notes for Agent-3 (Technical Documentation Specialist)

### Data Models Section:
- Place new Permission Provider interfaces in a new "Access Control" section or after existing auth-related types
- Use consistent formatting with existing interface documentation
- Include clear descriptions for each property
- Reference existing AuthRetryConfig type (confirmed to exist)

### API Methods Section:
- Add setPermissionProvider() under a new "Access Control" or existing auth section
- Follow existing method documentation pattern (params, returns, hooks, full docs link)
- Update setDocuments() entry with new behavior note using `<Note>` component
- Ensure proper linking to data models

### REST API Documentation:
- Follow existing REST API file structure for Generate Signature
- Use consistent ParamField components for all parameter documentation
- Include multiple example requests showing different use cases
- Add both success and failure response examples
- Reference security documentation where appropriate

---

## Notes for Agent-5 (Cross-reference & Alignment Specialist)

### Key Concepts Updates:
- Integrate Permission Provider seamlessly into existing authentication section
- Maintain consistent tone and style with existing documentation
- Use the three-method structure for authentication documentation
- Ensure all code examples follow Velt patterns (React first, Other Frameworks second)
- Add appropriate warning/note components for prerequisites
- Link extensively to related documentation (data models, REST APIs, console)

### Cross-Reference Tasks:
- Verify all data model type links work correctly
- Ensure API method references are consistent
- Check REST API endpoint links
- Validate console configuration links
- Ensure terminology alignment (e.g., "Permission Provider" vs "permission provider")

---

## Success Criteria

This planning is successful when:

1. ✅ All new interfaces are identified and specifications written
2. ✅ All API method changes are documented with clear specifications
3. ✅ All REST API updates are identified with parameter/response changes
4. ✅ Missing documentation (Generate Signature REST API) is identified
5. ✅ New feature documentation requirements are clearly defined
6. ✅ Implementation sequence is prioritized with dependencies
7. ✅ Quality assurance checklist is comprehensive
8. ✅ Agent-3 has clear instructions for technical documentation updates
9. ✅ Agent-5 has clear instructions for feature documentation and alignment
10. ✅ All risks are identified with mitigation strategies

---

## Conclusion

Release v4.5.6-beta.11 introduces a significant new feature (Permission Provider) that requires comprehensive new documentation, along with several REST API improvements that need parameter/response updates. The primary challenge is creating documentation for the Permission Provider authentication method and the missing Generate Signature REST API.

**Total Estimated Effort:** 7-11 hours across all phases

**Critical Path:**
1. Data Models (Phase 1) →
2. Generate Signature REST API (Phase 2) →
3. Permission Provider Feature Documentation (Phase 3) →
4. QA & Cross-reference Validation (Phase 4)

**Next Step:** Agent-3 should begin with Phase 1 (Data Models & API Signatures) as all subsequent work depends on these foundation updates.

---

**Log Complete**
**Planning Status:** ✅ COMPLETE
**Ready for Agent-3:** ✅ YES
