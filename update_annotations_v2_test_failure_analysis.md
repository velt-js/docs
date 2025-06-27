# Update Annotations V2 Test Failure Analysis

Based on the Slack thread, **12 out of 177 tests are failing**, all related to Update Annotations V2. Here's a detailed analysis of each failing test and likely root causes:

## Failing Tests Analysis

### 1. **"Update Annotations V2 - All Required Fields Present (Happy Path)"**
**Status**: ❌ FAILING - This is the most critical failure

**Expected**: Should successfully update annotations with all required fields
**Likely Issues**:
- **Authentication**: Invalid or missing JWT token in `x-velt-auth-token` header
- **API Endpoint**: Wrong URL or HTTP method (should be `POST https://api.velt.dev/v2/commentannotations/update`)
- **Request Body**: Missing required `updatedData` or malformed request structure
- **Console Config**: Advanced queries not enabled for V2 APIs

**Required Request Structure**:
```json
{
  "data": {
    "organizationId": "test-org-id",
    "documentId": "test-doc-id",
    "updatedData": {
      "status": {
        "type": "ongoing"
      }
    }
  }
}
```

---

### 2. **"Update Annotations V2 - Missing apiKey - Omit apiKey"**
**Expected**: Should return 401/403 error when API key is missing
**Likely Issues**:
- Test expects specific HTTP status code (401) but API returns different code
- Error response format doesn't match test expectations
- API might return 500 instead of proper 4xx error

**Expected Response**: 
```json
{
  "error": {
    "message": "API key is required",
    "status": "UNAUTHORIZED"
  }
}
```

---

### 3-4. **Missing organizationId/documentId Tests**
**Expected**: Should return 400 Bad Request with clear error messages
**Likely Issues**:
- API returns generic error instead of field-specific validation errors
- Test assertions expect specific error messages that don't match API response
- HTTP status code mismatch (expecting 400, getting 500)

---

### 5-7. **Empty Array Tests (annotationIds, locationIds, userIds)**
**Status**: ❌ CRITICAL DESIGN ISSUE

**Expected Behavior**: Unclear how API should handle empty arrays
**Likely Issues**:
```json
// These requests may be ambiguous:
{
  "data": {
    "organizationId": "test-org",
    "documentId": "test-doc",
    "annotationIds": [],        // What should this do?
    "locationIds": [],          // Update nothing?
    "userIds": [],              // Return error?
    "updatedData": { ... }
  }
}
```

**Potential Problems**:
- API treats empty arrays as "update nothing" → returns success with no changes
- Tests expect this to be an error case
- API has no annotations to update → returns empty success response
- Conflicting business logic expectations

---

### 8. **"Empty updateUsers Array - updateUsers: []"**
**Expected**: Should handle empty updateUsers array gracefully
**Likely Issues**:
- Empty `updateUsers` array makes the entire request invalid
- API expects at least one user update operation
- Test might expect this to be ignored, but API treats it as error

---

### 9. **"Invalid updateUsers Format - updateUsers with missing oldUser or newUser"**
**Status**: ❌ STRICT VALIDATION ISSUE

**Required Format**:
```json
{
  "updateUsers": [
    {
      "oldUser": {
        "userId": "old-user-id"    // REQUIRED
      },
      "newUser": {
        "userId": "new-user-id",   // REQUIRED
        "name": "New User Name",
        "email": "new@example.com"
      }
    }
  ]
}
```

**Likely Test Issues**:
```json
// These would fail validation:
{"updateUsers": [{"oldUser": {}}]}                    // Missing userId
{"updateUsers": [{"newUser": {"userId": "new"}}]}     // Missing oldUser
{"updateUsers": [{}]}                                 // Missing both
```

---

### 10-12. **Multiple Annotations/Filtering Tests**
**Tests**:
- Update Multiple Annotations - Multiple valid annotation IDs
- Update by Location IDs - locationIds with valid values  
- Update by User IDs - userIds with valid values

**Likely Issues**:
- **Batch Processing**: API might not handle multiple IDs correctly
- **Response Format**: Success response for multiple updates might not match expected format
- **Rate Limiting**: Multiple operations might trigger rate limits
- **Data Consistency**: Some annotation/location/user IDs might not exist

**Expected Success Response**:
```json
{
  "result": {
    "status": "success",
    "message": "Annotations updated successfully.",
    "data": {
      "annotationId1": {
        "success": true,
        "id": "annotationId1", 
        "message": "Annotations updated successfully"
      },
      "annotationId2": {
        "success": true,
        "id": "annotationId2",
        "message": "Annotations updated successfully"  
      }
    }
  }
}
```

---

## Root Cause Categories

### 🔐 **Authentication Issues (HIGH PRIORITY)**
- **JWT Token Generation**: `x-velt-auth-token` must be server-generated JWT
- **Token Expiration**: JWT tokens expire after 48 hours
- **Console Auth Token**: Invalid CLIENT_AUTH_TOKEN from Velt console

### ⚙️ **Configuration Issues (CRITICAL DISCOVERY)**
- **V2 API Requirements**: Advanced queries not enabled in console
- **SDK Version**: Not using V4 series SDK  
- **Console Settings**: Missing required feature toggles

**🚨 CRITICAL FINDING**: Most V2 APIs require this configuration:
```
Prior to using this API, you must:
- Enable advanced queries option in the console  
- Deploy v4 series of the Velt SDK
```

**However, the Update Annotations V2 API documentation is missing this warning!** This is likely a **documentation bug** - the Update API probably requires the same configuration as other V2 APIs.

### 📝 **Request Format Issues**
- **Missing Required Fields**: No `updatedData` or `updateUsers` in request
- **Incorrect Data Structure**: Wrong object nesting or field names
- **Empty Array Handling**: Unclear API behavior for empty filter arrays

### 🧪 **Test Implementation Issues**
- **Response Assertions**: Expected vs actual response format mismatches
- **HTTP Status Codes**: Tests expect different error codes than API returns
- **Error Messages**: Hardcoded error message expectations don't match API

### 🏗️ **API Design Issues**
- **Empty Array Semantics**: Unclear behavior for empty filter arrays
- **Error Response Format**: Inconsistent error response structure
- **Validation Messages**: Generic errors instead of field-specific validation

---

## Recommended Investigation Steps

### 1. **Verify Authentication Setup**
```javascript
// Check if tests are generating JWT tokens properly:
const authToken = await generateJWTToken({
  userId: 'test-user',
  apiKey: process.env.VELT_API_KEY,
  authToken: process.env.VELT_CLIENT_AUTH_TOKEN,
  userProperties: {
    organizationId: 'test-org-id'
  }
});
```

### 2. **Console Configuration Checklist**
- [ ] Advanced queries enabled for V2 APIs
- [ ] JWT Token requirement configured correctly
- [ ] API keys are valid and active
- [ ] Organization/Document IDs exist in console

### 3. **Request Debugging**
```javascript
// Log actual request being sent:
console.log('Headers:', {
  'Content-Type': 'application/json',
  'x-velt-api-key': apiKey,
  'x-velt-auth-token': jwtToken
});

console.log('Request Body:', JSON.stringify(requestBody, null, 2));
```

### 4. **Response Analysis**
```javascript
// Log actual API responses vs expected:
console.log('Expected Status:', expectedStatus);
console.log('Actual Status:', response.status);
console.log('Expected Response:', expectedResponse);  
console.log('Actual Response:', actualResponse);
```

---

## Quick Fixes Priority Order

1. **🔥 CRITICAL**: Enable advanced queries in Velt console - this is likely the root cause
   - Go to [Velt Console](https://console.velt.dev/dashboard/config/appconfig) 
   - Enable "Advanced Queries and Filters" option
   - **Wait 15-30 minutes** for it to take effect
   
2. **🔥 CRITICAL**: Fix authentication - ensure proper JWT token generation
   - Generate JWT tokens server-side using proper CLIENT_AUTH_TOKEN
   - Ensure tokens aren't expired (48-hour limit)
   
3. **⚡ HIGH**: Verify V4 SDK deployment requirement
   - Confirm using V4 series Velt SDK
   - Deploy latest SDK version if needed
   
4. **📋 MEDIUM**: Fix request body structure - ensure `updatedData` is included

5. **🔍 LOW**: Update test assertions to match actual API response formats

**Expected Impact**: 
- **Enabling advanced queries alone should fix 10-12 of the 12 failing tests**
- The Update Annotations V2 API likely has the same requirements as other V2 APIs but the documentation is missing the warning
- This explains why ALL Update Annotations V2 tests are failing, including the happy path