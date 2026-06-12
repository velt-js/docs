# Release Update Plan for v5.0.2-beta.35

## Overview
- Release Type: Patch (beta)
- Key Changes: client-side dev permission resolver for `setPermissionProvider`; agent suggestions visible/actionable by all viewers; `maxOrganizations` removed from `CrossOrganizationConfig`; React SDK type-source consolidation.
- Breaking Changes: Yes — `CrossOrganizationConfig.maxOrganizations` removed (beta-only field, no shim). Already documented in upgrade-guide.mdx by Agent-1.

## Areas Requiring Updates

### 1. Data Models (Agent-3) — Priority: High

**File: `api-reference/sdk/models/data-models.mdx`**

a) `#### VeltPermissionProvider` (line 6116, table lines 6122-6127) — add 4 rows:
- `dev` | `boolean` | No — Opt-in browser-side permission resolution for local dev/testing. Honored only for dev/test API keys (`storeDbId === 'sdktest'`); production keys always use the server-side RTPP. Default: `false`.
- `endpointConfig` | [`ResolverEndpointConfig`](#resolverendpointconfig) | No — URL resolver; SDK POSTs `{ data: { requests: PermissionQuery[] } }` to the URL. Takes precedence over `resolvePermissions`. (`ResolverEndpointConfig` already exists at line 4798 — link, don't redefine.)
- `resolvePermissions` | `(request: PermissionResolverRequest) => Promise<PermissionResult[] \| ResolverResponse<PermissionResult[]>>` | No — In-browser callback resolver; same request envelope as the server-side RTPP.
- `resolveTimeout` | `number` | No — Per-call deadline in ms for the dev resolver. Default: `60000`.
- Note semantics: fails closed on errors/timeouts/malformed payloads; one-shot `console.warn` when active or misconfigured. `retryConfig` row already exists — no change.

b) New `#### PermissionResolverRequest` section — insert after `#### PermissionQuery` (ends ~line 6138), before `#### PermissionResult` (line 6140):
- Shape: `{ data: { requests:` [`PermissionQuery[]`](#permissionquery) `} }`; byte-identical to the server-side RTPP request envelope.

c) `#### CrossOrganizationConfig` (line 3366) — delete `maxOrganizations` row (line 3377). Remaining fields (`enabled`, `organizationIds`, `excludeOrganizationIds`, `feeds`) unchanged.

### 2. API Methods (Agent-3) — Priority: Low / verify-only

**File: `api-reference/sdk/api/api-methods.mdx`** — `#### setPermissionProvider()` (line 3078): param type is `VeltPermissionProvider` (unchanged signature). No edit required; optionally append "Supports a client-side dev resolver for local testing" to the one-line description. Do not add per-field params here.

### 3. Documentation — Feature Guide (Agent-6) — Priority: High

**File: `key-concepts/overview.mdx`** — `### c. Real-time Permission Provider` (line 1524), Step 3 (lines 1801-1860):
- Add `dev`, `endpointConfig`, `resolvePermissions`, `resolveTimeout` bullets to the Configuration Options list (lines 1809-1812), linking to data-models anchors.
- Add a "Local Development (Testing the Permission Provider locally)" subsection after Step 3: explain RTPP is server-to-server so localhost endpoints need a tunnel; `dev: true` resolves in-browser instead. Include `<Tabs>` (React / Next.js first, Other Frameworks second) with the URL-resolver and callback-resolver examples from the release note.
- State guardrails: dev/test API keys only (production keys always use server-side RTPP), fails closed, `endpointConfig.url` wins over `resolvePermissions`, one-shot `console.warn`.
- Existing `/api/check-permissions` handlers work unchanged (identical envelope) — say so once.
- `get-started/advanced.mdx`: verified — only the event table mentions permissionProvider; no change.

### 4. Notifications Customize Behavior — maxOrganizations removal (Agent-6) — Priority: High

**File: `async-collaboration/notifications/customize-behavior.mdx`**, `#### enableCrossOrganization` section (lines 384-495):
- Delete bullet "`maxOrganizations` defaults to `20`." (line 388).
- Remove `maxOrganizations: 10,` from code examples: lines 404, 408, 422, 465; remove `"maxOrganizations":10` from JSON-string attributes: lines 448, 450.
- Delete `maxOrganizations` row from the fields table (line 490).
- Note: main's PR #205 removed a Cross-Organization Notifications section elsewhere; verified working tree — this is the only remaining feature-doc occurrence. Repo-wide grep confirms no other guide pages reference `maxOrganizations`.

### 4a. UI Customization — Wireframes (Agent-4)
- None. No new wireframes in this release.

### 4b. UI Customization — Primitives (Agent-5)
- None. No new primitives or props in this release.

### 5. Upgrade Guide (Agent-1 — done)
- `release-notes/version-5/upgrade-guide.mdx` lines 15-48 already cover the `maxOrganizations` removal with before/after. No further edits.

### 6. Agent Suggestions Visibility (Agent-6 verify-only) — Priority: Low
- Verified: `ai/agent-comments.mdx` and `async-collaboration/comments/customize-behavior.mdx` contain NO admin-only statements about agent suggestions. No doc edits needed.
- `release-notes/version-5/sdk-changelog.mdx` line 142 (beta.34 entry) says "The card is admin-only (`appState.isUserAdmin`)" — historical changelog record; do NOT retro-edit. The beta.35 entry (line 48) already documents the gate removal.

### 7. React Type Consolidation (no action)
- `CrossOrganizationConfig` now imported from `@veltdev/types` — changelog-only; no doc surface.

## Implementation Sequence
1. Agent-3: data-models.mdx — VeltPermissionProvider rows + PermissionResolverRequest section + CrossOrganizationConfig row removal. (Medium effort)
2. Agent-3: api-methods.mdx setPermissionProvider — verify/optional one-line note. (Trivial)
3. Agent-4: skip (no wireframes). Agent-5: skip (no primitives).
4. Agent-6: key-concepts/overview.mdx dev-resolver subsection; notifications/customize-behavior.mdx maxOrganizations removal; verify agent-suggestion docs clean. (Medium effort)
5. Agent-7: repo-wide grep `maxOrganizations` — only changelog/upgrade-guide hits should remain; grep `PermissionResolverRequest` anchors resolve.

## Quality Checklist
- [ ] 4 new VeltPermissionProvider fields added to data-models.mdx
- [ ] PermissionResolverRequest section added with anchor `#permissionresolverrequest`
- [ ] CrossOrganizationConfig maxOrganizations row removed from data-models.mdx
- [ ] All maxOrganizations occurrences removed from notifications/customize-behavior.mdx (lines 388, 404, 408, 422, 448, 450, 465, 490)
- [ ] key-concepts dev-resolver docs use React/Next.js first, Other Frameworks second tab order
- [ ] Historical changelog entries NOT edited (beta.34 admin-only line stays)
- [ ] Breaking change confined to upgrade-guide.mdx, not duplicated into guides
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.35.md`
