# Release Update Plan for 5.0.2-beta.16

## Overview
- Release Type: Minor
- Key Changes: anonymousEmail prop/API for @mention filtering; updateContactList gains `filters` config; rich text paste; velt-mention CSS classes
- Breaking Changes: No

## Areas Requiring Updates

### 1. API Methods — new enable/disable pair + updated method signature

**File:** `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`

**Changes:**

a) Add `enableAnonymousEmail()` and `disableAnonymousEmail()` entries under the Comments section, near the `enablePaginatedContactList` / `disablePaginatedContactList` block (~line 557). Pattern: same as sibling enable/disable pairs (no params, returns void, React Hook: n/a, link to customize-behavior anchor).

b) Update `updateContactList()` entry (~line 621) to reflect new optional `filters` boolean in the config object:
- Current params: `contacts: Array<{userId: string, name: string, email: string}>, options?: {merge: boolean}`
- New params: `contacts: Array<{userId: string, name: string, email: string}>, options?: {merge: boolean, filters: boolean}`
- Priority: High

### 2. Customize Behavior — new anonymousEmail section + updateContactList update

**File:** `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`

**Changes:**

a) Add new `#### anonymousEmail` section near the @mention / contact list section. Describe the prop (boolean, default true), its effect (suppresses unrecognized email addresses from suggestions when false), and include `<Tabs>` with React/Next.js and Other Frameworks code examples matching the changelog. Anchor must be `#anonymousemail`.

b) Update `#### updateContactList` section (~line 1886) to document the new `filters` boolean option: when true, restricts sidebar People/Assigned/Tagged/Involved filters to the custom contact list plus the current user. Add `filters: boolean` to the options table/description and update code examples to show `{ filters: true }`.

- Priority: High

### 3. snippets/comments-methods-json.mdx — new JSON method entries

**File:** `/Users/yoenzhang/Downloads/docs/snippets/comments-methods-json.mdx`

**Changes:** Add two JSON entries at the end of the array (before closing `]`, ~line 722), following the existing enable/disable pattern:

```json
{
  "methodName": "enableAnonymousEmail",
  "description": "To enable anonymous email in @mention suggestions.",
  "signature": "enableAnonymousEmail()",
  "parameters": "none",
  "returnType": "void"
},
{
  "methodName": "disableAnonymousEmail",
  "description": "To disable anonymous email in @mention suggestions.",
  "signature": "disableAnonymousEmail()",
  "parameters": "none",
  "returnType": "void"
}
```

- Priority: Medium

## Implementation Sequence
1. Update `api-methods.mdx` — add enable/disable entries and update updateContactList signature (no dependencies)
2. Update `customize-behavior.mdx` — add anonymousEmail section; update updateContactList section (links to api-methods anchors, so do after step 1)
3. Update `snippets/comments-methods-json.mdx` — add JSON entries (independent)

## Quality Checklist
- [ ] enableAnonymousEmail / disableAnonymousEmail added to api-methods.mdx
- [ ] updateContactList params updated to include `filters: boolean` in api-methods.mdx
- [ ] anonymousEmail section added to customize-behavior.mdx with React and Other Frameworks tabs
- [ ] updateContactList section in customize-behavior.mdx updated with filters option
- [ ] Two JSON entries added to comments-methods-json.mdx
- [ ] Code examples include React / Next.js and Other Frameworks tabs
- [ ] No breaking changes — upgrade guide not needed
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.16.md`
