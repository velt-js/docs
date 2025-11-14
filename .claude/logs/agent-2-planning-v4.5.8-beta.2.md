# Release Update Plan for v4.5.8-beta.2

## Overview
- **Release Type**: Minor (Beta)
- **Release Date**: October 30, 2025
- **Key Changes**:
  1. New Feature - Access Control: Revoke access functionality with configurable triggers
  2. Improvement - Access Control: Simplified Permission Provider implementation
  3. Improvement - Access Control: Added analytics events for permission revocation tracking
- **Breaking Changes**: Yes - Permission Provider API has been significantly simplified

## Analysis Summary

### Release Note Content
This release contains major updates to the Permission Provider system in the Access Control feature:

1. **New Feature: Revoke Access with Configurable Triggers**
   - New `revokeAccessOn` configuration option in `setPermissionProvider()`
   - Supports two trigger types: `DOCUMENT_UNSET` and `USER_LOGOUT`
   - Optional `revokeOrganizationAccess` flag to control organization-level permission revocation
   - Automatic permission revocation from cache and backend when triggered
   - New types: `RevokeAccessOnType` (enum), `RevokeAccessOn` (interface)

2. **Major Improvement: Simplified Permission Provider Implementation**
   - **BREAKING CHANGE**: Removed `onResourceAccessRequired` callback from client SDK
   - **BREAKING CHANGE**: Removed signature handling from Permission Provider responses
   - SDK now handles permission caching, validation, and synchronization internally
   - Backend configuration required in Velt Console (console.velt.dev)
   - New simplified `VeltPermissionProvider` interface configuration
   - New backend integration model with POST endpoint configuration
   - New request/response format for Permission Provider endpoint
   - Updated types: `VeltPermissionProvider` (simplified interface), `PermissionQuery`, `PermissionResult`, `PermissionSource`, `ResolverResponse`

3. **New Analytics Events**
   - `revokeAccessOnDocumentUnsetTriggered`: Fired when document unset trigger revokes access
   - `revokeAccessOnUserLogoutTriggered`: Fired when user logout trigger revokes access
   - Both events available via `client.on()` subscription

### Critical Breaking Changes
The Permission Provider implementation has fundamentally changed:
- **OLD**: Frontend callback (`onResourceAccessRequired`) handled permission requests and returned signed responses
- **NEW**: Backend endpoint configured in Velt Console handles permission requests; SDK manages everything internally
- **Migration Required**: Users must update their Permission Provider implementation to use the new backend-based model

## Areas Requiring Updates

### 1. Data Models
**Files to Update**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`

**Changes Needed**:

#### A. Add New Types (Add to appropriate sections)

**RevokeAccessOnType (New Enum)**
- Location: Add after existing Access Control type definitions
- Priority: High

```typescript
enum RevokeAccessOnType {
  DOCUMENT_UNSET = 'document_unset',
  USER_LOGOUT = 'user_logout',
}
```

**RevokeAccessOn (New Interface)**
- Location: Add after `RevokeAccessOnType`
- Priority: High

```markdown
#### RevokeAccessOn
---

Configuration for automatic access revocation triggers.

| Property                     | Type                    | Required | Description                                                                                          |
|------------------------------|-------------------------|----------|------------------------------------------------------------------------------------------------------|
| `type`                       | `RevokeAccessOnType`    | Yes      | Type of trigger that will revoke access. Options: `document_unset` or `user_logout`                |
| `revokeOrganizationAccess`   | `boolean`               | No       | Whether to also revoke organization-level permissions when triggered. Default: `false`              |
```

#### B. Update Existing Types

**VeltPermissionProvider (Major Update)**
- Location: Find existing `VeltPermissionProvider` definition (around line 3054)
- Priority: Critical (Breaking Change)
- Action: REPLACE the existing definition

**OLD Definition:**
```markdown
#### VeltPermissionProvider
---

Configuration interface for Permission Provider, a permission configuration mode. Instead of pre-syncing users via REST API or passing details in the `identify` method, Velt validates access requests in real-time by querying your authorization service.

| Property                  | Type                                                           | Required | Description                                                                                                                                                    |
|--------------------------|----------------------------------------------------------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `onResourceAccessRequired` | `(requests:` [PermissionQuery[]](#permissionquery)`) => Promise<`[ResolverResponse](#resolverresponse)`<`[PermissionResult[]](#permissionresult)`>>` | Yes | Async function that receives permission queries and returns access decisions. Velt calls this when a user requests access to a resource.                       |
| `retryConfig`            | [AuthRetryConfig](#authretryconfig)                            | No       | Configuration for retrying failed permission requests. Defaults to 3 retries with 2000ms delay.                                                                 |
| `forceRefresh`           | `boolean`                                                      | No       | Set to `true` if access control changes frequently (e.g., for high-frequency notifications). Forces Velt to revalidate permissions on each request. Default: `false` |
```

**NEW Definition:**
```markdown
#### VeltPermissionProvider
---

Configuration interface for Permission Provider, a permission configuration mode. Velt validates access requests in real-time by querying your backend endpoint configured in the [Velt Console](https://console.velt.dev). The SDK automatically handles permission caching, validation, and synchronization.

<Warning>
**Breaking Change in v4.5.8-beta.2**: The `onResourceAccessRequired` callback has been removed from the client SDK. Permission requests are now handled by a backend endpoint configured in the Velt Console. [Learn how to migrate →](/key-concepts/overview#c-real-time-permission-provider)
</Warning>

| Property          | Type                                      | Required | Description                                                                                                                                                    |
|-------------------|-------------------------------------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `isProviderEnabled` | `boolean`                               | No       | Enable or disable the Permission Provider. Default: `true`                                                                                                      |
| `retryConfig`     | [AuthRetryConfig](#authretryconfig)       | No       | Configuration for retrying failed permission requests. Defaults to 3 retries with 2000ms delay.                                                                 |
| `forceRefresh`    | `boolean`                                 | No       | Set to `true` if access control changes frequently. Forces re-validation on each access check in the current session. Default: `false`                        |
| `revokeAccessOn`  | [RevokeAccessOn[]](#revokeon)             | No       | Configure automatic access revocation triggers. Revokes permissions when specified events occur (e.g., document unset or user logout).                         |
```

**PermissionQuery (Update existing)**
- Location: Find existing definition (around line 3066)
- Priority: High
- Action: Update the `resource` property to include `organizationId`

**OLD:**
```markdown
| `resource`| `{ type: 'document' | 'folder' | 'organization'; id: string; source: 'setDocuments' | 'identify' | 'getNotifications' | 'setNotifications' }` | Yes | Resource the user is requesting access to. The `source` field identifies which SDK method triggered the permission check. |
```

**NEW:**
```markdown
| `resource`| `{ type: 'document' | 'folder' | 'organization'; id: string; source:` [PermissionSource](#permissionsource)`; organizationId: string }` | Yes | Resource the user is requesting access to. The `source` field identifies which SDK method triggered the permission check. Includes `organizationId` for context. |
```

**PermissionResult (Update existing)**
- Location: Find existing definition (around line 3077)
- Priority: High
- Action: Add `organizationId` property

Add new row to table:
```markdown
| `organizationId`| `string`                                  | Yes      | Organization ID associated with the resource.                                                      |
```

**PermissionSource (New Enum)**
- Location: Add before `PermissionQuery` definition
- Priority: High

```markdown
#### PermissionSource
---

Enum identifying which SDK method triggered the permission check.

| Value                | Description                                                    |
|----------------------|----------------------------------------------------------------|
| `SET_DOCUMENTS`      | Permission check triggered by `setDocuments()` method          |
| `IDENTIFY`           | Permission check triggered by `identify()` method              |
| `GET_NOTIFICATIONS`  | Permission check triggered by notifications fetching           |
| `SET_NOTIFICATIONS`  | Permission check triggered by notifications setting            |
```

**ResolverResponse (New Interface)**
- Location: Add after `PermissionResult` definition
- Priority: High

```markdown
#### ResolverResponse
---

Generic response format for Permission Provider backend endpoint.

| Property      | Type      | Required | Description                                                           |
|---------------|-----------|----------|-----------------------------------------------------------------------|
| `data`        | `T`       | No       | Response data payload (generic type)                                  |
| `success`     | `boolean` | Yes      | Whether the request was successful                                    |
| `message`     | `string`  | No       | Optional message describing the result                                |
| `timestamp`   | `number`  | No       | Optional timestamp of the response                                    |
| `statusCode`  | `number`  | Yes      | HTTP status code (must be 200 for successful responses)               |
```

**Priority**: Critical (Breaking Changes and New Features)

### 2. API Methods Documentation
**Files to Update**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`

**Changes Needed**:

#### A. Update setPermissionProvider() Documentation
- Location: Find existing `setPermissionProvider()` entry (around line 2080)
- Priority: Critical (Breaking Change)
- Action: REPLACE the existing documentation

**OLD:**
```markdown
#### setPermissionProvider()
Configure a permission provider for real-time access validation. Instead of pre-syncing users via REST API or passing details in the `identify` method, Velt validates access requests in real-time by querying your authorization service.
- Params: [VeltPermissionProvider](/api-reference/sdk/models/data-models#veltpermissionprovider)
- Returns: `void`
- React Hook: `n/a`
- [Full Documentation →](/key-concepts/overview#c-real-time-permission-provider)

<Note>
**Prerequisites:** Set your API key's `defaultDocumentAccessType` to `restricted` in the [console](https://console.velt.dev/dashboard/config/appconfig) to ensure access is denied by default unless explicitly granted through the provider.
</Note>
```

**NEW:**
```markdown
#### setPermissionProvider()
Configure Permission Provider for real-time access validation. Velt validates access requests by querying your backend endpoint configured in the [Velt Console](https://console.velt.dev). The SDK automatically handles permission caching, validation, and synchronization.
- Params: [VeltPermissionProvider](/api-reference/sdk/models/data-models#veltpermissionprovider)
- Returns: `void`
- React Hook: `n/a`
- [Full Documentation →](/key-concepts/overview#c-real-time-permission-provider)

<Warning>
**Breaking Change in v4.5.8-beta.2**: The `onResourceAccessRequired` callback has been removed. Configure your backend endpoint in the [Velt Console](https://console.velt.dev) under Permission Provider settings instead.
</Warning>

**Configuration Options:**
- `isProviderEnabled`: Enable/disable Permission Provider (default: `true`)
- `retryConfig`: Retry configuration for failed requests
- `forceRefresh`: Force re-validation on each access check
- `revokeAccessOn`: Configure automatic access revocation triggers

<Note>
**Prerequisites:**
1. Set your API key's `defaultDocumentAccessType` to `restricted` in the [console](https://console.velt.dev/dashboard/config/appconfig)
2. Configure your Permission Provider endpoint in the [console](https://console.velt.dev) under Permission Provider tab
3. Add your POST endpoint URL and optional auth token
</Note>
```

**Priority**: Critical

#### B. Add Event Subscription Documentation
- Location: Add in the appropriate "Events" or "Authentication" section
- Priority: High

```markdown
#### on('revokeAccessOnDocumentUnsetTriggered')
Subscribe to document unset revocation events. Fired when permissions are automatically revoked due to document unset trigger.
- Params: `'revokeAccessOnDocumentUnsetTriggered'`
- Returns: `Observable<RevokeAccessEvent>`
- React Hook: `n/a`
- [Full Documentation →](/key-concepts/overview#c-real-time-permission-provider)

#### on('revokeAccessOnUserLogoutTriggered')
Subscribe to user logout revocation events. Fired when permissions are automatically revoked due to user logout trigger.
- Params: `'revokeAccessOnUserLogoutTriggered'`
- Returns: `Observable<RevokeAccessEvent>`
- React Hook: `n/a`
- [Full Documentation →](/key-concepts/overview#c-real-time-permission-provider)
```

**Priority**: High

### 3. Access Control Documentation (Main Feature Docs)
**Files to Update**: `/Users/yoenzhang/Downloads/docs/key-concepts/overview.mdx`

**Changes Needed**:

#### A. Update "c. Real-time Permission Provider" Section
- Location: Section starting around line 1441
- Priority: Critical (Breaking Change Documentation)
- Action: MAJOR REWRITE of entire section

**Key Updates Required:**
1. **Remove all frontend callback examples** (the `onResourceAccessRequired` function in VeltProvider and setPermissionProvider)
2. **Add new simplified configuration examples** (without callback)
3. **Add backend configuration instructions** (Velt Console setup)
4. **Update backend integration flow** (new request/response format)
5. **Add revoke access functionality documentation**
6. **Add migration guidance** from old to new approach
7. **Update all code examples** to reflect new API

**New Section Structure:**

```markdown
#### c. Real-time Permission Provider
With this approach, Velt validates access requests in real-time by querying your backend endpoint configured in the [Velt Console](https://console.velt.dev). The SDK automatically handles permission caching, validation, and synchronization. This ensures your backend remains the source of truth without requiring direct permission syncing.

<Warning>
**Breaking Change in v4.5.8-beta.2**: The Permission Provider implementation has been significantly simplified. The `onResourceAccessRequired` callback has been removed from the client SDK. Configure your backend endpoint in the Velt Console instead.
</Warning>

##### **How it works**
1. Configure your backend endpoint in the [Velt Console](https://console.velt.dev) under Permission Provider settings
2. Add your POST endpoint URL and optional auth token
3. Configure Permission Provider in your frontend using `setPermissionProvider()`
4. When users access resources, Velt automatically queries your endpoint
5. Your backend determines access and returns permission decisions
6. Velt validates and caches the response internally

##### **When to use**
- Your app has complex, dynamic permissions that change frequently
- You want to avoid syncing permission data to an external system
- You need real-time permission validation without backend synchronization overhead
- You want automatic permission revocation based on user actions

##### **Backend Configuration**

**Step 1: Configure Endpoint in Velt Console**

1. Go to [Velt Console](https://console.velt.dev)
2. Navigate to Permission Provider tab
3. Enable Permission Provider
4. Add your POST endpoint URL (e.g., `https://yourdomain.com/api/check-permissions`)
5. (Optional) Add auth token for request authentication

**Step 2: Implement Backend Endpoint**

Your backend receives permission requests from Velt, checks your authorization system, and returns access decisions:

[Include updated backend code examples with new request/response format]

**Request Format Velt Sends:**
```typescript
// Headers
{
  'Content-Type': 'application/json',
  'Authorization': 'Basic ${permissionProviderToken}' // If auth token configured
}

// Body
{
  data: {
    requests: PermissionQuery[]
  }
}
```

**Response Format Expected:**
```typescript
interface ResolverResponse<T> {
  data?: T;
  success: boolean;
  message?: string;
  timestamp?: number;
  statusCode: number; // Must be 200 for success
}
```

**Step 3: Configure Frontend**

[Include new simplified frontend configuration examples]

##### **Revoke Access Functionality**

Automatically revoke permissions when specific events occur, providing better control over user access and security.

**Configure Revocation Triggers:**

<Tabs>
<Tab title="React / Next.js">

**Option 1: In VeltProvider**
```jsx
<VeltProvider
  apiKey="YOUR_API_KEY"
  permissionProvider={{
    isProviderEnabled: true,
    forceRefresh: false,
    retryConfig: {
      retryCount: 3,
      retryDelay: 2000
    },
    revokeAccessOn: [
      {
        type: RevokeAccessOnType.DOCUMENT_UNSET,
        revokeOrganizationAccess: false
      },
      {
        type: RevokeAccessOnType.USER_LOGOUT,
        revokeOrganizationAccess: true
      }
    ]
  }}
>
  {/* Your app */}
</VeltProvider>
```

**Option 2: Using setPermissionProvider()**
```jsx
const { client } = useVeltClient();

client.setPermissionProvider({
  isProviderEnabled: true,
  forceRefresh: false,
  retryConfig: {
    retryCount: 3,
    retryDelay: 2000
  },
  revokeAccessOn: [
    {
      type: RevokeAccessOnType.DOCUMENT_UNSET,
      revokeOrganizationAccess: false
    },
    {
      type: RevokeAccessOnType.USER_LOGOUT,
      revokeOrganizationAccess: true
    }
  ]
});
```

</Tab>
<Tab title="Other Frameworks">
```javascript
Velt.setPermissionProvider({
  isProviderEnabled: true,
  forceRefresh: false,
  retryConfig: {
    retryCount: 3,
    retryDelay: 2000
  },
  revokeAccessOn: [
    {
      type: RevokeAccessOnType.DOCUMENT_UNSET,
      revokeOrganizationAccess: false
    },
    {
      type: RevokeAccessOnType.USER_LOGOUT,
      revokeOrganizationAccess: true
    }
  ]
});
```
</Tab>
</Tabs>

**Available Revoke Triggers:**
- `DOCUMENT_UNSET`: Revokes access when user unsets/leaves a document
- `USER_LOGOUT`: Revokes access when user logs out

**Configuration Options:**
- `type`: Type of trigger (`RevokeAccessOnType.DOCUMENT_UNSET` or `RevokeAccessOnType.USER_LOGOUT`)
- `revokeOrganizationAccess`: Set to `true` to also revoke organization-level permissions (default: `false`)

<Info>
Access is automatically revoked from both cache and backend when triggered. This ensures immediate permission removal without requiring manual cleanup.
</Info>

##### **Track Revocation Events**

Subscribe to analytics events to monitor permission revocation workflows:

<Tabs>
<Tab title="React / Next.js">
```jsx
const { client } = useVeltClient();

// Track document unset revocations
client.on('revokeAccessOnDocumentUnsetTriggered').subscribe(event => {
  console.log('Document unset revocation:', event);
});

// Track logout revocations
client.on('revokeAccessOnUserLogoutTriggered').subscribe(event => {
  console.log('Logout revocation:', event);
});
```
</Tab>
<Tab title="Other Frameworks">
```javascript
// Track document unset revocations
Velt.on('revokeAccessOnDocumentUnsetTriggered').subscribe(event => {
  console.log('Document unset revocation:', event);
});

// Track logout revocations
Velt.on('revokeAccessOnUserLogoutTriggered').subscribe(event => {
  console.log('Logout revocation:', event);
});
```
</Tab>
</Tabs>

##### **Migration from v4.5.7 and Earlier**

If you're currently using Permission Provider with the `onResourceAccessRequired` callback, follow these steps to migrate:

**Before (v4.5.7 and earlier):**
```jsx
// OLD APPROACH - Frontend callback
client.setPermissionProvider({
  onResourceAccessRequired: async (requests) => {
    const response = await fetch('/api/check-permissions', {
      method: 'POST',
      body: JSON.stringify({ requests })
    });
    const result = await response.json();
    return {
      data: result.permissions,
      success: result.success,
      statusCode: result.statusCode,
      signature: result.signature // Signature required
    };
  },
  retryConfig: { retryCount: 3, retryDelay: 2000 }
});
```

**After (v4.5.8-beta.2 and later):**
```jsx
// NEW APPROACH - Backend endpoint configuration
// 1. Configure endpoint in Velt Console (https://console.velt.dev)
// 2. Simplified frontend configuration
client.setPermissionProvider({
  isProviderEnabled: true,
  retryConfig: { retryCount: 3, retryDelay: 2000 },
  forceRefresh: false
});
```

**Migration Checklist:**
1. ✅ Configure Permission Provider endpoint in [Velt Console](https://console.velt.dev)
2. ✅ Update backend endpoint to match new request/response format (no signatures needed)
3. ✅ Remove `onResourceAccessRequired` callback from frontend code
4. ✅ Update `setPermissionProvider()` calls to use new configuration
5. ✅ (Optional) Add `revokeAccessOn` configuration for automatic access revocation
6. ✅ Test permission validation flow end-to-end

<Warning>
The signature generation step has been removed. Velt now handles all validation internally through the backend endpoint configuration.
</Warning>
```

**Priority**: Critical

#### B. Update "Subscribe to Permission Provider Events" Section
- Location: Around line 1844
- Priority: Medium
- Action: Add new revocation events to existing documentation

Add to existing event subscription section:
```markdown
**New Revocation Events** (Available from v4.5.8-beta.2):

```jsx
// Track automatic access revocation
client.on('revokeAccessOnDocumentUnsetTriggered').subscribe(event => {
  console.log('Access revoked on document unset:', event);
});

client.on('revokeAccessOnUserLogoutTriggered').subscribe(event => {
  console.log('Access revoked on logout:', event);
});
```
```

**Priority**: Medium

### 4. Migration & Upgrade Guides
**Files to Update**: Create new migration guide or update existing migration documentation

**Changes Needed**:

#### Option A: Add to Existing Migration Guide (if exists)
- Check if there's a migration guide file in `/Users/yoenzhang/Downloads/docs/migration/` or similar
- Add v4.5.8-beta.2 migration section

#### Option B: Add Migration Section to Release Notes
- Already included in release notes with full examples
- Ensure migration guidance is complete and actionable

**Migration Content Required:**
1. Clear explanation of what changed and why
2. Before/after code comparison
3. Step-by-step migration instructions
4. Checklist for verification
5. Common pitfalls and troubleshooting

**Priority**: Critical (Breaking Changes Require Migration Guidance)

### 5. Code Examples
**Files to Update**: Various files need code example updates

**Changes Needed**:
- All Permission Provider code examples must be updated throughout documentation
- Remove all `onResourceAccessRequired` callback examples
- Update to new simplified configuration pattern
- Ensure all examples include backend endpoint setup instructions

**Affected Files** (to be searched and updated):
- `/Users/yoenzhang/Downloads/docs/key-concepts/overview.mdx` (primary location)
- Any setup guides referencing Permission Provider
- Any tutorial content using Permission Provider

**Priority**: Critical (Code Examples Must Match New API)

### 6. Console/Backend Configuration Documentation
**Files to Update**: May need new documentation section

**Changes Needed**:
- Document how to configure Permission Provider in Velt Console
- Screenshot or step-by-step guide for console configuration
- Explain auth token setup (optional)
- Document endpoint requirements and testing

**Potential New Section Location**:
- Could be part of setup documentation
- Could be subsection of Access Control documentation
- Should be referenced from Permission Provider section

**Priority**: High (Required for users to implement feature)

### 7. Analytics/Event Tracking Documentation
**Files to Update**: Check if analytics documentation exists

**Search Results**: Found `/Users/yoenzhang/Downloads/docs/async-collaboration/view-analytics/` directory

**Changes Needed**:
- Add `revokeAccessOnDocumentUnsetTriggered` event to analytics documentation
- Add `revokeAccessOnUserLogoutTriggered` event to analytics documentation
- Document event payload structure
- Provide usage examples for tracking these events

**Priority**: Medium (New events should be documented)

### 8. REST API Documentation (Generate Signature)
**Files to Update**: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/auth/generate-signature.mdx`

**Changes Needed**:
- Update documentation to note that signature generation is NO LONGER required for Permission Provider
- Add deprecation notice or clarification about signature removal
- Update examples to remove Permission Provider use cases
- Keep signature documentation for any other use cases that still require it

**Priority**: High (Breaking change affects API usage)

### 9. Cross-references and Internal Links
**Files to Update**: Multiple files may need link updates

**Changes Needed**:
- Verify all links to Permission Provider documentation remain valid
- Update any links referencing `onResourceAccessRequired`
- Ensure cross-references point to updated sections
- Check that anchor links within long pages still work

**Priority**: Medium (Ensure navigation works correctly)

## Areas NOT Requiring Updates

### UI Customization
**Analysis**: This release does not introduce any new UI components or wireframes. All changes are backend/API-focused.

**Priority**: N/A (No updates needed)

### Setup Guides
**Analysis**: Core setup guides likely don't need updates unless they specifically reference Permission Provider setup. Most setup is now in Velt Console rather than code.

**Priority**: Low (Check for Permission Provider references only)

## Implementation Sequence

### Phase 1: Critical Breaking Changes (Agent-3)
**Priority: CRITICAL - Must be completed first**

1. **Update Data Models** (`/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`)
   - Add new types: `RevokeAccessOnType`, `RevokeAccessOn`, `PermissionSource`, `ResolverResponse`
   - Update existing types: `VeltPermissionProvider` (remove `onResourceAccessRequired`, add new fields), `PermissionQuery` (add `organizationId`), `PermissionResult` (add `organizationId`)
   - Add breaking change warnings
   - Estimated effort: 45-60 minutes

2. **Update API Methods** (`/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`)
   - Update `setPermissionProvider()` documentation
   - Add breaking change warnings
   - Add new event subscription methods
   - Update prerequisites and notes
   - Estimated effort: 30-45 minutes

3. **Rewrite Permission Provider Section** (`/Users/yoenzhang/Downloads/docs/key-concepts/overview.mdx`)
   - Complete rewrite of "c. Real-time Permission Provider" section
   - Remove all frontend callback examples
   - Add backend configuration instructions
   - Add revoke access functionality documentation
   - Add comprehensive migration guide
   - Update all code examples
   - Estimated effort: 2-3 hours

### Phase 2: Supporting Documentation (Agent-3)
**Priority: HIGH - Required for feature completeness**

4. **Update Generate Signature API Docs** (`/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/auth/generate-signature.mdx`)
   - Add note about signature removal from Permission Provider
   - Update or deprecate Permission Provider examples
   - Estimated effort: 15-20 minutes

5. **Add Analytics Event Documentation** (Find appropriate file in `/Users/yoenzhang/Downloads/docs/async-collaboration/view-analytics/`)
   - Document `revokeAccessOnDocumentUnsetTriggered` event
   - Document `revokeAccessOnUserLogoutTriggered` event
   - Estimated effort: 20-30 minutes

### Phase 3: Code Example Cleanup (Agent-3)
**Priority: HIGH - Ensure consistency**

6. **Search and Update All Permission Provider Examples**
   - Search entire docs for `onResourceAccessRequired`
   - Replace all old examples with new simplified configuration
   - Ensure consistency across all files
   - Estimated effort: 30-45 minutes

### Phase 4: Cross-references and Links (Agent-5)
**Priority: MEDIUM - Ensure navigation**

7. **Verify and Update Internal Links**
   - Check all links to Permission Provider documentation
   - Update anchor links if section names changed
   - Verify cross-references are accurate
   - Estimated effort: 20-30 minutes

### Phase 5: Console Configuration Guide (Agent-5)
**Priority: MEDIUM - May require new content**

8. **Create or Update Console Configuration Documentation**
   - Document Velt Console Permission Provider setup
   - Add screenshots or step-by-step guide
   - Explain endpoint and auth token configuration
   - Estimated effort: 45-60 minutes (if new content needed)

## Quality Assurance Checklist

### Breaking Changes and Migration
- [ ] Breaking changes clearly documented with warnings
- [ ] Migration guide provides step-by-step instructions
- [ ] Before/after code comparisons included
- [ ] Migration checklist provided for users
- [ ] Old approach clearly marked as deprecated/removed
- [ ] Timeline for breaking change documented (v4.5.8-beta.2)

### Data Models Documentation
- [ ] All new types added: `RevokeAccessOnType`, `RevokeAccessOn`, `PermissionSource`, `ResolverResponse`
- [ ] `VeltPermissionProvider` interface updated (removed `onResourceAccessRequired`, added new fields)
- [ ] `PermissionQuery` updated with `organizationId` and typed `source`
- [ ] `PermissionResult` updated with `organizationId`
- [ ] Breaking change warnings added to type definitions
- [ ] All type definitions include complete property descriptions

### API Methods Documentation
- [ ] `setPermissionProvider()` documentation completely rewritten
- [ ] Breaking change warning added to method documentation
- [ ] New configuration options documented (`isProviderEnabled`, `revokeAccessOn`)
- [ ] Prerequisites updated (console configuration required)
- [ ] Event subscription methods added (`revokeAccessOnDocumentUnsetTriggered`, `revokeAccessOnUserLogoutTriggered`)
- [ ] Links to full documentation accurate

### Access Control Documentation
- [ ] "Real-time Permission Provider" section completely rewritten
- [ ] Frontend callback examples removed entirely
- [ ] Backend configuration process documented (Velt Console setup)
- [ ] New request/response format documented
- [ ] Revoke access functionality fully documented
- [ ] All code examples updated to new API
- [ ] Migration guide comprehensive and actionable
- [ ] When to use guidance updated
- [ ] Flow diagram or explanation accurate

### Code Examples
- [ ] All code examples use new simplified configuration (no `onResourceAccessRequired`)
- [ ] Examples include both React and Other Frameworks tabs
- [ ] React examples show both VeltProvider and setPermissionProvider approaches
- [ ] Revoke access examples include both trigger types
- [ ] Backend endpoint examples show new request/response format
- [ ] Event subscription examples provided
- [ ] No old API examples remain in documentation

### Migration Documentation
- [ ] Clear explanation of what changed and why
- [ ] Complete before/after comparison
- [ ] Step-by-step migration instructions
- [ ] Verification checklist for users
- [ ] Common pitfalls documented
- [ ] Timeline for migration specified

### Console Configuration
- [ ] Velt Console setup process documented
- [ ] Screenshot or visual guide provided (if possible)
- [ ] Endpoint configuration explained
- [ ] Auth token setup documented (optional feature)
- [ ] Testing and verification steps included

### Analytics Events
- [ ] `revokeAccessOnDocumentUnsetTriggered` event documented
- [ ] `revokeAccessOnUserLogoutTriggered` event documented
- [ ] Event payload structure defined
- [ ] Usage examples provided
- [ ] Integration with existing analytics documentation

### Terminology and Consistency
- [ ] "Permission Provider" terminology consistent throughout
- [ ] "Revoke access" vs "remove permissions" terminology consistent
- [ ] "Backend endpoint" vs "authorization service" terminology consistent
- [ ] Type names match exactly: `RevokeAccessOnType.DOCUMENT_UNSET`, `RevokeAccessOnType.USER_LOGOUT`
- [ ] Configuration option names match exactly: `isProviderEnabled`, `revokeAccessOn`, `revokeOrganizationAccess`

### Cross-references and Links
- [ ] All internal links to Permission Provider documentation verified
- [ ] Links to Velt Console accurate (https://console.velt.dev)
- [ ] Anchor links within long pages functional
- [ ] Cross-references to related documentation updated
- [ ] Generate Signature API documentation updated with deprecation note

### REST API Documentation
- [ ] Generate Signature API docs updated to note Permission Provider no longer needs signatures
- [ ] Permission Provider examples removed or marked as deprecated
- [ ] Other use cases for signatures still documented (if applicable)

### Version Accuracy
- [ ] All documentation references v4.5.8-beta.2 correctly
- [ ] Breaking change version clearly stated
- [ ] Migration guidance specifies which versions are affected
- [ ] "Available from v4.5.8-beta.2" notes added where appropriate

### No Unnecessary Updates
- [ ] UI customization documentation skipped (no new wireframes)
- [ ] Setup guides only updated if they reference Permission Provider
- [ ] Unrelated features not modified
- [ ] Bug fix documentation not included (this release has improvements/new features)

## Log File Requirements

This comprehensive log file documents:
- **Analysis Summary**: Complete breakdown of v4.5.8-beta.2 changes
- **Breaking Changes**: Detailed explanation of Permission Provider API changes
- **Areas Requiring Updates**: 9 major documentation areas identified
- **New Features**: Revoke access functionality with configurable triggers
- **Migration Requirements**: Critical migration guidance needed
- **Implementation Sequence**: 5-phase approach prioritizing breaking changes
- **Quality Assurance**: 14 detailed checklists covering all aspects

**File Path**: `/Users/yoenzhang/Downloads/docs/.claude/logs/agent-2-planning-v4.5.8-beta.2.md`

## Special Considerations

### 1. Breaking Change Communication
This is a MAJOR breaking change that fundamentally alters how Permission Provider works. Documentation must:
- Clearly communicate the change with prominent warnings
- Provide comprehensive migration guidance
- Explain the benefits of the new approach
- Make the transition as smooth as possible
- Include troubleshooting for common issues

### 2. Backend Configuration Complexity
The new approach requires:
- Velt Console configuration (new step for users)
- Backend endpoint implementation (more complex than before)
- Understanding of the request/response flow
- Proper error handling and retry logic

Documentation must guide users through all steps clearly.

### 3. Signature Removal
The removal of signature requirement from Permission Provider is significant:
- Simplifies implementation considerably
- Removes security ceremony from client side
- SDK handles validation internally
- Must be clearly communicated to avoid confusion

### 4. Revoke Access Feature
This new feature adds important security capabilities:
- Automatic permission cleanup on document unset
- Automatic permission cleanup on user logout
- Optional organization-level revocation
- Analytics events for tracking

Documentation must explain when and why to use each trigger type.

### 5. Analytics Events
Two new analytics events provide visibility into permission revocation:
- Important for security auditing
- Useful for debugging access issues
- Should be documented with other analytics events
- Payload structure should be defined

### 6. Console Documentation Gap
There may be a gap in documentation about Velt Console features:
- Permission Provider configuration is new to console
- May need screenshots or visual guides
- Should link to console documentation if it exists
- Consider creating dedicated console guide

### 7. Backward Compatibility
This is a breaking change with NO backward compatibility:
- Old `onResourceAccessRequired` approach will not work
- Users MUST migrate to new approach
- Migration should be prioritized and well-documented
- Consider providing migration support resources

## Dependencies and Related Documentation

### Critical Dependencies
1. **Velt Console Documentation**: May need to document console configuration process
2. **Generate Signature API**: Needs update to reflect Permission Provider no longer uses signatures
3. **Access Control Overview**: Foundation for Permission Provider documentation
4. **Data Models**: Central repository for all type definitions

### Related Sections
1. **Authentication** (`key-concepts/overview.mdx`): Permission Provider is part of auth system
2. **Access Control** (`key-concepts/overview.mdx`): Permission Provider is a configuration mode
3. **REST APIs** - Generate Signature: Related to Permission Provider (previously)
4. **Analytics**: New events need documentation

### No Impact Areas
- UI Customization (no new components)
- Comments features (unrelated)
- Recorder features (unrelated)
- Presence/Cursors features (unrelated)
- Most setup guides (unless they reference Permission Provider)

## Agent-3 (Technical Documentation) Instructions

### Critical Priority Tasks

#### Task 1: Update Data Models Documentation
**File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`

**Location 1: Add New Enum - RevokeAccessOnType**
- Find the Access Control types section
- Add after existing access control type definitions

**Content to Add**:
```markdown
#### RevokeAccessOnType
---

Enum specifying when to automatically revoke permissions.

| Value            | Description                                                           |
|------------------|-----------------------------------------------------------------------|
| `DOCUMENT_UNSET` | Revoke access when user unsets or leaves a document                  |
| `USER_LOGOUT`    | Revoke access when user logs out of the organization                 |
```

**Location 2: Add New Interface - RevokeAccessOn**
- Add immediately after `RevokeAccessOnType`

**Content to Add**:
```markdown
#### RevokeAccessOn
---

Configuration for automatic access revocation triggers.

| Property                     | Type                    | Required | Description                                                                                          |
|------------------------------|-------------------------|----------|------------------------------------------------------------------------------------------------------|
| `type`                       | [RevokeAccessOnType](#revokeontype) | Yes | Type of trigger that will revoke access. Options: `document_unset` or `user_logout` |
| `revokeOrganizationAccess`   | `boolean`               | No       | Whether to also revoke organization-level permissions when triggered. Default: `false`              |
```

**Location 3: Replace VeltPermissionProvider Definition**
- Find existing `VeltPermissionProvider` (around line 3054)
- REPLACE completely with new definition

**Content to Replace**:
```markdown
#### VeltPermissionProvider
---

Configuration interface for Permission Provider. Velt validates access requests in real-time by querying your backend endpoint configured in the [Velt Console](https://console.velt.dev). The SDK automatically handles permission caching, validation, and synchronization.

<Warning>
**Breaking Change in v4.5.8-beta.2**: The `onResourceAccessRequired` callback has been removed from the client SDK. Permission requests are now handled by a backend endpoint configured in the Velt Console. [Learn how to migrate →](/key-concepts/overview#c-real-time-permission-provider)
</Warning>

| Property          | Type                                      | Required | Description                                                                                                                                                    |
|-------------------|-------------------------------------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `isProviderEnabled` | `boolean`                               | No       | Enable or disable the Permission Provider. Default: `true`                                                                                                      |
| `retryConfig`     | [AuthRetryConfig](#authretryconfig)       | No       | Configuration for retrying failed permission requests. Defaults to 3 retries with 2000ms delay.                                                                 |
| `forceRefresh`    | `boolean`                                 | No       | Set to `true` if access control changes frequently. Forces re-validation on each access check in the current session. Default: `false`                        |
| `revokeAccessOn`  | [RevokeAccessOn[]](#revokeon)             | No       | Configure automatic access revocation triggers. Revokes permissions when specified events occur (e.g., document unset or user logout).                         |
```

**Location 4: Add PermissionSource Enum**
- Add before `PermissionQuery` definition (around line 3066)

**Content to Add**:
```markdown
#### PermissionSource
---

Enum identifying which SDK method triggered the permission check. This helps debug and trace permission request origins.

| Value                | Description                                                    |
|----------------------|----------------------------------------------------------------|
| `SET_DOCUMENTS`      | Permission check triggered by `setDocuments()` method          |
| `IDENTIFY`           | Permission check triggered by `identify()` method              |
| `GET_NOTIFICATIONS`  | Permission check triggered by notifications fetching           |
| `SET_NOTIFICATIONS`  | Permission check triggered by notifications setting            |
```

**Location 5: Update PermissionQuery**
- Find existing `PermissionQuery` definition (around line 3066)
- Update the `resource` property row

**OLD Property Row**:
```markdown
| `resource`| `{ type: 'document' | 'folder' | 'organization'; id: string; source: 'setDocuments' | 'identify' | 'getNotifications' | 'setNotifications' }` | Yes | Resource the user is requesting access to. The `source` field identifies which SDK method triggered the permission check. |
```

**NEW Property Row**:
```markdown
| `resource`| `{ type: 'document' \| 'folder' \| 'organization'; id: string; source:` [PermissionSource](#permissionsource)`; organizationId: string }` | Yes | Resource the user is requesting access to. The `source` field identifies which SDK method triggered the permission check. Includes `organizationId` for context. |
```

**Location 6: Update PermissionResult**
- Find existing `PermissionResult` definition (around line 3077)
- Add new row to the table (after `type` property)

**Row to Add**:
```markdown
| `organizationId`| `string`                                  | Yes      | Organization ID associated with the resource.                                                      |
```

**Location 7: Add ResolverResponse Interface**
- Add after `PermissionResult` definition

**Content to Add**:
```markdown
#### ResolverResponse
---

Generic response format for Permission Provider backend endpoint. Your backend must return responses in this format.

| Property      | Type      | Required | Description                                                           |
|---------------|-----------|----------|-----------------------------------------------------------------------|
| `data`        | `T`       | No       | Response data payload (generic type)                                  |
| `success`     | `boolean` | Yes      | Whether the request was successful. Must be `true` for successful requests |
| `message`     | `string`  | No       | Optional message describing the result                                |
| `timestamp`   | `number`  | No       | Optional timestamp of the response                                    |
| `statusCode`  | `number`  | Yes      | HTTP status code. Must be `200` for Velt to accept the response      |
```

**Verification**:
- Confirm all 7 updates are made
- Verify internal links work (e.g., `[RevokeAccessOnType](#revokeontype)`)
- Check that table formatting is preserved
- Ensure breaking change warning is prominent

#### Task 2: Update API Methods Documentation
**File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`

**Location 1: Replace setPermissionProvider() Documentation**
- Find existing `setPermissionProvider()` entry (around line 2080)
- REPLACE with new content

**Content to Replace**:
```markdown
#### setPermissionProvider()
Configure Permission Provider for real-time access validation. Velt validates access requests by querying your backend endpoint configured in the [Velt Console](https://console.velt.dev). The SDK automatically handles permission caching, validation, and synchronization.
- Params: [VeltPermissionProvider](/api-reference/sdk/models/data-models#veltpermissionprovider)
- Returns: `void`
- React Hook: `n/a`
- [Full Documentation →](/key-concepts/overview#c-real-time-permission-provider)

<Warning>
**Breaking Change in v4.5.8-beta.2**: The `onResourceAccessRequired` callback has been removed. Configure your backend endpoint in the [Velt Console](https://console.velt.dev) under Permission Provider settings instead.
</Warning>

**Configuration Options:**
- `isProviderEnabled`: Enable/disable Permission Provider (default: `true`)
- `retryConfig`: Retry configuration for failed requests
- `forceRefresh`: Force re-validation on each access check
- `revokeAccessOn`: Configure automatic access revocation triggers

<Note>
**Prerequisites:**
1. Set your API key's `defaultDocumentAccessType` to `restricted` in the [console](https://console.velt.dev/dashboard/config/appconfig)
2. Configure your Permission Provider endpoint in the [console](https://console.velt.dev) under Permission Provider tab
3. Add your POST endpoint URL and optional auth token
</Note>
```

**Location 2: Add Event Subscription Methods**
- Find appropriate location in events section (or create new "Access Control Events" section)
- Add both new event methods

**Content to Add**:
```markdown
#### on('revokeAccessOnDocumentUnsetTriggered')
Subscribe to document unset revocation events. Fired when permissions are automatically revoked due to document unset trigger.
- Params: `'revokeAccessOnDocumentUnsetTriggered'`
- Returns: `Observable<RevokeAccessEvent>`
- React Hook: `n/a`
- [Full Documentation →](/key-concepts/overview#c-real-time-permission-provider)

#### on('revokeAccessOnUserLogoutTriggered')
Subscribe to user logout revocation events. Fired when permissions are automatically revoked due to user logout trigger.
- Params: `'revokeAccessOnUserLogoutTriggered'`
- Returns: `Observable<RevokeAccessEvent>`
- React Hook: `n/a`
- [Full Documentation →](/key-concepts/overview#c-real-time-permission-provider)
```

**Verification**:
- Confirm breaking change warning is prominent
- Verify prerequisites list is complete
- Check that links to console and full documentation are accurate
- Ensure event subscription methods are in appropriate section

#### Task 3: Rewrite Real-time Permission Provider Section
**File**: `/Users/yoenzhang/Downloads/docs/key-concepts/overview.mdx`

**Location**: Section "c. Real-time Permission Provider" (around line 1441)

**CRITICAL**: This is a COMPLETE REWRITE of the entire section. The section is approximately 400 lines long. ALL content related to the old `onResourceAccessRequired` approach must be removed.

**New Section Content**:

See detailed content in main planning document Section 3.A above. The rewrite must include:

1. **Updated Overview** (remove callback approach, add backend endpoint approach)
2. **Breaking Change Warning** (prominent Warning component)
3. **How it Works** (new 6-step flow with console configuration)
4. **When to Use** (updated with revoke access mention)
5. **Backend Configuration** (NEW - 3-step process):
   - Step 1: Configure in Velt Console
   - Step 2: Implement backend endpoint
   - Step 3: Configure frontend
6. **Revoke Access Functionality** (NEW complete section):
   - Configuration examples (VeltProvider and setPermissionProvider)
   - Available triggers documentation
   - Configuration options explanation
   - Info callout about automatic revocation
7. **Track Revocation Events** (NEW section):
   - Event subscription examples for both triggers
8. **Migration Guide** (NEW section):
   - Before/after comparison
   - Step-by-step migration checklist
   - Breaking change explanation

**Key Changes to Make**:
- REMOVE ALL `onResourceAccessRequired` callback examples (frontend permission handling)
- REMOVE signature generation instructions from frontend examples
- ADD backend configuration in Velt Console instructions
- ADD simplified frontend configuration (no callback)
- ADD new request/response format for backend endpoint
- ADD complete revoke access documentation
- ADD migration guide with checklist

**Verification**:
- Confirm ALL old callback examples are removed
- Verify breaking change warning appears early
- Check that console configuration is clearly explained
- Ensure code examples are complete and correct
- Verify migration guide is comprehensive
- Check that all tabs (React/Other Frameworks) are present

#### Task 4: Update Generate Signature API Documentation
**File**: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/auth/generate-signature.mdx`

**Changes Required**:
- Add note that signature generation is NO LONGER required for Permission Provider (as of v4.5.8-beta.2)
- Update or remove Permission Provider examples
- Keep signature documentation for any other use cases

**Content to Add** (at beginning of file or in prominent location):
```markdown
<Info>
**Permission Provider Update (v4.5.8-beta.2)**: Signature generation is no longer required for Permission Provider implementation. The SDK now handles all validation internally through backend endpoint configuration in the Velt Console.
</Info>
```

**Verification**:
- Confirm deprecation notice is clear
- Verify remaining use cases for signatures are still documented
- Check that Permission Provider examples are removed or marked as outdated

### High Priority Tasks

#### Task 5: Add Analytics Event Documentation
**Files to Update**: Find appropriate file in `/Users/yoenzhang/Downloads/docs/async-collaboration/view-analytics/`

**Investigation Required**:
1. Search for existing analytics/events documentation
2. Determine correct file structure for event documentation
3. Add new events following existing patterns

**Content to Add**:
```markdown
### Access Control Events

#### revokeAccessOnDocumentUnsetTriggered
Fired when permissions are automatically revoked because a user unset or left a document.

**Subscription:**
```jsx
// React / Next.js
const { client } = useVeltClient();
client.on('revokeAccessOnDocumentUnsetTriggered').subscribe(event => {
  console.log('Document unset revocation:', event);
});

// Other Frameworks
Velt.on('revokeAccessOnDocumentUnsetTriggered').subscribe(event => {
  console.log('Document unset revocation:', event);
});
```

**Use Cases:**
- Security auditing and compliance tracking
- Debugging access control issues
- Analytics on document access patterns

#### revokeAccessOnUserLogoutTriggered
Fired when permissions are automatically revoked because a user logged out.

**Subscription:**
```jsx
// React / Next.js
const { client } = useVeltClient();
client.on('revokeAccessOnUserLogoutTriggered').subscribe(event => {
  console.log('Logout revocation:', event);
});

// Other Frameworks
Velt.on('revokeAccessOnUserLogoutTriggered').subscribe(event => {
  console.log('Logout revocation:', event);
});
```

**Use Cases:**
- Session management tracking
- Security monitoring
- User behavior analytics
```

**Verification**:
- Confirm events follow existing documentation patterns
- Verify code examples are complete
- Check that both React and Other Frameworks examples are provided

#### Task 6: Search and Update All Permission Provider Examples
**Scope**: Entire documentation directory

**Search Pattern**: Look for `onResourceAccessRequired` in all `.mdx` files

**Action for Each Found Instance**:
1. Determine if example is related to Permission Provider
2. Replace with new simplified configuration (no callback)
3. Ensure backend endpoint setup is mentioned
4. Verify consistency with main documentation

**Verification**:
- Run global search for `onResourceAccessRequired` - should find ZERO results after cleanup
- Confirm all Permission Provider examples use new API
- Verify consistency across all files

## Agent-4 (UI Customization) Instructions

**No Actions Required**

This release contains no changes to UI components or wireframes. All changes are backend/API-focused related to Access Control and Permission Provider configuration.

## Agent-5 (Alignment & Cross-references) Instructions

### Task 1: Verify Internal Links
**Scope**: All documentation files

**Actions**:
1. Verify all links to Permission Provider documentation work correctly
2. Check anchor links within `key-concepts/overview.mdx` (section is rewritten)
3. Update any broken links found
4. Verify links to Velt Console are correct (https://console.velt.dev)

**Verification**:
- All internal links navigate correctly
- Anchor links work within long pages
- External links to console are accurate

### Task 2: Update Cross-references
**Files to Check**:
- Setup guides mentioning Permission Provider
- Access Control documentation
- Authentication documentation
- Any tutorials using Permission Provider

**Actions**:
- Verify cross-references to Permission Provider section are accurate
- Update any references to old callback approach
- Ensure terminology is consistent across files

**Verification**:
- Cross-references point to correct sections
- No references to removed `onResourceAccessRequired` callback
- Terminology aligned

### Task 3: Console Configuration Guide (If Needed)
**Investigation Required**:
1. Check if Velt Console has existing documentation
2. Determine if new guide is needed for Permission Provider setup
3. Create or update console configuration documentation

**Potential New Content**:
- Step-by-step guide for configuring Permission Provider in console
- Screenshots or visual guide (if possible)
- Explanation of endpoint and auth token settings
- Testing and verification steps

**Verification**:
- Console setup process is clearly documented
- Users can follow guide to complete configuration
- Links between main docs and console guide work correctly

## Summary for Agent-1

This release (v4.5.8-beta.2) requires MAJOR documentation updates across multiple areas:

### Critical Changes (Breaking)
1. **Permission Provider API completely changed** - removed frontend callback, added backend endpoint configuration
2. **VeltPermissionProvider interface updated** - removed `onResourceAccessRequired`, added new fields
3. **New backend configuration required** - Velt Console setup now mandatory

### New Features
1. **Revoke access functionality** - automatic permission revocation on document unset and user logout
2. **New analytics events** - track revocation workflows
3. **Simplified configuration** - no more signatures, SDK handles validation internally

### Documentation Impact
- **9 major documentation areas** require updates
- **3 critical files** need immediate attention (Data Models, API Methods, Access Control)
- **Complete rewrite** of Permission Provider section (400+ lines)
- **Migration guide required** for breaking changes
- **All code examples** must be updated (remove callback approach)

### Estimated Effort
- **Phase 1 (Critical)**: 3-4 hours
- **Phase 2 (Supporting)**: 1-2 hours
- **Phase 3 (Cleanup)**: 1 hour
- **Phase 4-5 (Cross-refs)**: 1-2 hours
- **Total**: 6-9 hours of documentation work

### Risk Assessment
- **HIGH RISK**: Breaking change requires careful communication
- **HIGH COMPLEXITY**: Backend endpoint configuration adds implementation complexity
- **HIGH IMPACT**: Permission Provider is critical feature for many users
- **MIGRATION REQUIRED**: All existing users must update their implementation

This is the most significant documentation update in recent releases due to the fundamental change in Permission Provider architecture.
