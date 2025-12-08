# Release Update Plan for 4.6.0-beta.7

## Overview
- Release Type: Minor (Beta)
- Key Changes: Added `getCurrentUser()` method and `useCurrentUser()` hook to subscribe to current user changes
- Breaking Changes: No

## Areas Requiring Updates

### 1. API Methods Documentation
- Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Changes: Add `getCurrentUser()` method under Authentication section (after `getUser()` method at line 2120)
- Priority: High

**Details:**
- Add new method entry for `getCurrentUser()`
- Location: Insert after `getUser()` method in Authentication section (~line 2120)
- Include method signature, parameters, return type, React hook reference
- Link to User data model for return type

### 2. React Hooks Documentation
- Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/react-hooks.mdx`
- Changes: Add `useCurrentUser()` hook under Authentication section (after `useIdentify()` at line 575)
- Priority: High

**Details:**
- Add new hook entry for `useCurrentUser()`
- Location: Insert after `useIdentify()` hook in Authentication section (~line 575)
- Include parameters (void), return type (User | null), related API method reference
- Follow existing hook documentation pattern

### 3. Data Models Documentation
- Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes: NO UPDATE NEEDED - User type already exists and documented at line ~3001
- Priority: N/A

**Verification:**
- User type is fully documented with all properties (userId, name, email, photoUrl, etc.)
- Located at line 3001 in data-models.mdx
- No new properties or changes to User type in this release

## Implementation Sequence

1. **Update API Methods Documentation** (15 min)
   - Add `getCurrentUser()` method to api-methods.mdx
   - Insert in Authentication section after `getUser()`
   - Follow existing method documentation pattern

2. **Update React Hooks Documentation** (10 min)
   - Add `useCurrentUser()` hook to react-hooks.mdx
   - Insert in Authentication section after `useIdentify()`
   - Follow existing hook documentation pattern

## Quality Checklist
- [ ] `getCurrentUser()` method added to api-methods.mdx Authentication section
- [ ] Method includes proper parameters, return type, React hook reference
- [ ] `useCurrentUser()` hook added to react-hooks.mdx Authentication section
- [ ] Hook includes proper return type and API method reference
- [ ] Code examples follow React/Other Frameworks tab pattern (already in release note)
- [ ] Links to User data model use correct anchor (#user)
- [ ] No breaking changes documented (none exist)
- [ ] Log file written to `.claude/logs/agent-2-planning-4.6.0-beta.7.md`

## Notes

**Pattern Matching:**
- Follow authentication method pattern from `identify()` and `getUser()` methods
- Use Observable return type pattern: `Observable<User | null>`
- React hook returns direct value: `User | null`
- Link pattern: `/api-reference/sdk/models/data-models#user`

**Why No Data Model Updates:**
- User type already fully documented at line 3001 in data-models.mdx
- No new properties added to User type in this release
- Method only enables subscription to existing User object

**Why No Other Updates:**
- No new UI components or wireframes
- No breaking changes requiring migration guide
- Feature adds observability, doesn't modify existing behavior
- No new configuration or customization options
