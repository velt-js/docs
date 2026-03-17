# Release Update Plan for 5.0.2-beta.3

## Overview
- Release Type: Minor
- Key Changes: New AnonymousUserDataProvider for resolving email→userId mappings; `visibilityConfig` field persisted on CommentAnnotation; restricted visibility auto-includes current user
- Breaking Changes: No

---

## Areas Requiring Updates

### 1. Data Models
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Priority: High

**a. `CommentAnnotation` table (line ~9–44)**
- Add row: `visibilityConfig | CommentAnnotationVisibilityConfig | No | Human-readable visibility config stored on the annotation (type, organizationId, userIds)`

**b. New type: `CommentAnnotationVisibilityConfig` — insert after `PrivateModeConfig` block (~line 158)**
```
#### CommentAnnotationVisibilityConfig
---
Top-level field stored on CommentAnnotation with the resolved visibility configuration.

| Property         | Type                                                              | Required | Description                                              |
|------------------|-------------------------------------------------------------------|----------|----------------------------------------------------------|
| `type`           | [`CommentVisibilityType`](#commentvisibilitytype)                 | Yes      | Visibility level: `'public'`, `'organizationPrivate'`, or `'restricted'` |
| `organizationId` | `string`                                                          | No       | Organization ID. Present when `type` is `'organizationPrivate'` |
| `userIds`        | `string[]`                                                        | No       | User IDs who can view the comment. Present when `type` is `'restricted'` |
```

**c. `VeltDataProvider` table (line ~3464–3472)**
- Add row: `anonymousUser | AnonymousUserDataProvider | No | Provider to resolve email → userId for anonymous tagged users`

**d. New types: `AnonymousUserDataProvider`, `AnonymousUserDataProviderConfig`, `ResolveUserIdsByEmailRequest` — insert after `AttachmentDataProvider` block (~line 3584)**
```
#### AnonymousUserDataProvider
---
| Property                 | Type                                                                              | Required | Description                                         |
|--------------------------|-----------------------------------------------------------------------------------|----------|-----------------------------------------------------|
| `resolveUserIdsByEmail`  | `(request: ResolveUserIdsByEmailRequest) => Promise<ResolverResponse<Record<string, string>>>` | Yes | Function to map emails to userIds |
| `config`                 | `AnonymousUserDataProviderConfig`                                                 | No       | Timeout and retry configuration                     |

#### AnonymousUserDataProviderConfig
---
| Property          | Type           | Required | Description                                     |
|-------------------|----------------|----------|-------------------------------------------------|
| `resolveTimeout`  | `number`       | No       | Timeout in milliseconds for the resolver call   |
| `getRetryConfig`  | `RetryConfig`  | No       | Retry configuration for resolver calls          |

#### ResolveUserIdsByEmailRequest
---
| Property  | Type       | Required | Description                              |
|-----------|------------|----------|------------------------------------------|
| `emails`  | `string[]` | Yes      | List of emails to resolve to user IDs    |
```

---

### 2. API Methods
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Priority: High

**a. `setDataProviders()` entry (line ~2840–2845)**
- Update params description to reference the new `anonymousUser` key in `VeltDataProvider`.
- Current: `Params: VeltDataProvider`
- No signature change needed — the type itself gains `anonymousUser`; the method entry can stay as-is since it already links to `VeltDataProvider`. No edit required here unless a note about the new key is warranted.

**b. New method: `setAnonymousUserDataProvider()` — insert in the `### Self Hosting` section, after `setDataProviders()` (~line 2845)**
```
#### setAnonymousUserDataProvider()
Register a provider to resolve email → userId mappings for anonymous users tagged in comments.
- Params: [`AnonymousUserDataProvider`](/api-reference/sdk/models/data-models#anonymoususerdataprovider)
- Returns: `void`
- React Hook: `n/a`
- [Full Documentation →](/self-host-data/overview)
```

**c. `updateVisibility()` docs (line ~138–143 in api-methods.mdx)**
- Add a note: when `type` is `'restricted'`, the current user's `userId` is automatically appended to `userIds` if not already present (as of v5.0.2-beta.3).

---

### 3. Feature Documentation — updateVisibility behavior note
- File: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
- Priority: Medium

**`updateVisibility` section (~line 2586–2654)**
- Add a callout or note under the `'restricted'` type description: the SDK automatically appends the current user's `userId` to `userIds`, ensuring authors always retain access to their own restricted comments.

---

## No Updates Required

- UI Customization docs: no new wireframes or UI components
- Migration guide: no breaking changes
- `self-host-data/` docs: no new page needed; `setDataProviders` overview page covers the pattern — only the new method entry and type in the reference files above are required
- REST API docs: no REST endpoints changed

---

## Implementation Sequence

1. **data-models.mdx** — Add `visibilityConfig` row to `CommentAnnotation` table
2. **data-models.mdx** — Add `CommentAnnotationVisibilityConfig` type after `PrivateModeConfig`
3. **data-models.mdx** — Add `anonymousUser` row to `VeltDataProvider` table
4. **data-models.mdx** — Add `AnonymousUserDataProvider`, `AnonymousUserDataProviderConfig`, `ResolveUserIdsByEmailRequest` types after `AttachmentDataProvider`
5. **api-methods.mdx** — Add `setAnonymousUserDataProvider()` in Self Hosting section after `setDataProviders()`
6. **api-methods.mdx** — Add auto-append note to `updateVisibility()` restricted behavior
7. **customize-behavior.mdx** — Add auto-append note to `updateVisibility` restricted section

---

## Anchor Patterns to Use

| Type / Method | Anchor |
|---|---|
| `CommentAnnotationVisibilityConfig` | `#commentannotationvisibilityconfig` |
| `AnonymousUserDataProvider` | `#anonymoususerdataprovider` |
| `AnonymousUserDataProviderConfig` | `#anonymoususerdataproviderconfig` |
| `ResolveUserIdsByEmailRequest` | `#resolveusersidsbyemailrequest` |
| `setAnonymousUserDataProvider()` | `#setanonymoususerdataprovider` |

---

## Quality Checklist
- [x] Analyzed release note from Agent-1
- [x] Flagged only areas with actual API/type changes (skipped bug fix, skipped behavior-only improvement for UI customization)
- [x] No breaking changes present — no migration guide needed
- [x] `CommentAnnotationVisibilityConfig` planned for `data-models.mdx` after existing visibility types
- [x] Three new AnonymousUser types planned for `data-models.mdx` in the Self Hosting / Data Providers section
- [x] `setAnonymousUserDataProvider()` planned for `api-methods.mdx` Self Hosting section
- [x] Auto-append behavior note planned for both `api-methods.mdx` and `customize-behavior.mdx`
- [x] Anchor patterns defined; follow existing `#lowercasenospaces` convention
- [x] Code examples use React/Next.js tab first, Other Frameworks second
- [x] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.3.md`
