# Release Update Plan for Velt Node SDK v1.0.3 (@veltdev/node)

## Overview
- Release Type: Minor (large additive REST API expansion)
- Key Changes: 3 new REST services (`agents` 24, `memory` 24, `approval` 14), new methods on `crdt`/`documents`/`users`/`workspace`, `getApiKeyMetadata` endpoint repoint, ~100 new TS interfaces.
- Breaking Changes: No.
- Target doc: `/Users/yoenzhang/Downloads/docs/backend-sdks/node.mdx` (2859 lines).

## Investigation Findings (correct the prompt framing)
- `-node` anchors come from data-models.mdx headings `### \`TypeName\` (Node)` (Mintlify slugifies to `typename-node`). **121 such headings already exist** (~lines 9281–10400). `(SH)` variants slugify to `-sh-node`.
- node.mdx makes **173** `-node` links — all resolve to that dedicated "(Node)" block. The convention is real and large.
- **velt-py precedent is the OPPOSITE of the prompt's claim.** `backend-sdks/python.mdx` makes **179** `data-models.mdx#anchor` links and does NOT inline its request types. Its 202 ```python blocks are call examples, not type definitions. So the cross-SDK convention is: link `Params:` to data-models.mdx, never inline.
- Conclusion: there is one consistent, established pattern across BOTH backend SDKs — link to data-models.mdx. Inlining (option B) would break that consistency.

## Areas Requiring Updates

### 1. Data Models — `api-reference/sdk/models/data-models.mdx`  [PRIMARY]
- Add the new request/response/shared types as `### \`TypeName\` (Node)` headings inside the existing Node block (alphabetical order, matching neighbors), each with the standard field table + a one-line "Request payload for `sdk.api.<svc>.<method>`." lede.
- Scope (see KEY DECISION for the cutoff): all `*Request` / `*Response` types referenced by a `Params:`/`Returns:` link, plus `Approval`-prefixed node/graph workflow types and `Memory`-prefixed types that appear in a method signature.
- `VeltApiResponse (Node)` already exists — reuse `#veltapiresponse-node` for all `Returns:`.
- Priority: High.

### 2. API Methods — `backend-sdks/node.mdx`  [PRIMARY, Agent-3]
New `### ` service sections (insert after `### Token` at line 2618, before `## Error Handling` at line 2646, in this order to match changelog anchors):
- `### Agents` → slug `#agents`, `**Namespace:** \`sdk.api.agents\``, 24 `####` method blocks. Note `agents` also exported directly from `@veltdev/node`.
- `### Memory` → slug `#memory`, `**Namespace:** \`sdk.api.memory\``, 24 `####` blocks (all types `Memory`-prefixed).
- `### Approval Workflows` → slug `#approval-workflows`, `**Namespace:** \`sdk.api.approval\``, 14 `####` blocks; routes under `/v2/workflow/*`; types `Approval`-prefixed.

New methods appended to existing services (after the named last `####` block, before next `###`):
- Documents (after `migrateDocumentsStatus`, ~L1048): `getDocumentsCount` (+1).
- Users (after `deleteUsers`, ~L1148): `getUsersCount, getDocUsers, addUserInvite, respondToUserInvite, getUserInvites, getUserInvitations, getInvitedPendingUsersCount` (+7).
- CRDT (after `updateCrdtData`, ~L1943): `deleteCrdtData` (+1).
- Workspace (after `updateWebhookConfig`, ~L2595): +20 (domain/additional-URL requests, `copyApiKey`, `updateApiKeyConfig`, notification/permission-provider/activity service configs, `ensureWorkspaceAuthToken`, Svix advanced webhook endpoint suite).

Each `####` block follows the Documents template exactly: `- <description>`, `- Params: [Type](/api-reference/sdk/models/data-models#<type>-node)`, `- Returns: [VeltApiResponse](/api-reference/sdk/models/data-models#veltapiresponse-node)` (or typed response anchor), a ```ts call block, optional `**Response**` block.

`getApiKeyMetadata` improvement: method already exists (Workspace, ~L2356). Add a one-line note that it now hits `/v2/workspace/apikeyconfig/get`; signature unchanged. Do NOT add a new method block.

Service count: "17 services" → "20 services" at line 21 (overview) and line 624 (REST intro). Grep-confirm no other "17 service(s)" prose remains.
- Priority: High.

### 3. Documentation (new feature pages)
- SKIP. node.mdx is the canonical reference for the Node SDK; new services are documented in-place there. No standalone feature page needed.

### 4a. UI Customization — Wireframes
- N/A. Backend-only release.

### 4b. UI Customization — Primitives
- N/A. Backend-only release.

### 5. Upgrade Guide
- N/A. No breaking changes. Do NOT touch `upgrade-guide.mdx`.

### 6. Navigation / config
- `docs.json`: no change. Both `node.mdx` and `data-models.mdx` are already registered; new content is in-page headings only.
- `api-methods.mdx`: no change. It is Web/React-SDK surface; the `-node` types are Node-specific and must stay in the data-models "(Node)" block, not leak into api-methods.

## THE KEY DECISION — where the ~100 new types live

**Recommendation: (C) Hybrid, weighted toward (A).** Concretely:

1. **Request/response types (the ones a `Params:`/`Returns:` link points at) → data-models.mdx `(Node)` block (option A).**
   Rationale: this is the single established convention across BOTH backend SDKs (node.mdx 173 links, python.mdx 179 links). `Params:` for the new methods must render as a data-models link `[Type](/api-reference/sdk/models/data-models#<type>-node)`, identical to every existing Node method. Inlining (B) would make the new services the only ones in either SDK that diverge — a maintainability and consistency regression. The prompt's velt-py "inline precedent" does not exist; python.mdx links out.

2. **Deeply-nested shared building blocks (Approval node/graph workflow types, shared config sub-types that are NOT themselves a method's top-level param) → INLINE within the owning service's `Types` subsection.**
   Rationale: many of the ~100 interfaces are internal shapes composed into a top-level request (e.g., a graph `node`/`edge` shape inside `ApprovalCreateWorkflowRequest`). Promoting every nested shape to its own `(Node)` heading would balloon data-models.mdx with anchors nothing links to. Document these as ```ts interface blocks under an `#### Types` (or `**Types**`) subsection at the end of the Agents / Memory / Approval Workflows service sections. Top-level request/response types still get their `(Node)` heading and link from `Params:`.

**The cutoff rule Agent-3 applies:** if a type is the value passed to `Params:` or returned by `Returns:` for a `####` method → it gets a `(Node)` heading in data-models.mdx and is linked. If a type only appears nested inside one of those → inline it as a ```ts block in the service's `Types` subsection. This bounds the data-models.mdx addition to roughly the ~63 method-level request/response types while keeping the long tail of nested config/graph shapes contained.

This keeps `Params:` rendering uniform (always a data-models link for the documented call surface), preserves the cross-SDK convention, and avoids unbounded data-models.mdx growth.

## Implementation Sequence (Agent-3)
1. data-models.mdx: add `(Node)` headings for the ~63 method-level request/response types, alphabetical, matching the existing field-table format. (High effort)
2. node.mdx: add `### Agents`, `### Memory`, `### Approval Workflows` after `### Token` (L2618), before `## Error Handling` (L2646); each with `Namespace`, method `####` blocks, and a trailing `Types` subsection for nested shapes. (High effort)
3. node.mdx: append new `####` blocks to Documents (+1), Users (+7), CRDT (+1), Workspace (+20) at the boundaries above. (Medium effort)
4. node.mdx: add `getApiKeyMetadata` endpoint note; flip "17 services" → "20 services" at L21 and L624. (Low effort)
5. Verify every new `Params:`/`Returns:` anchor resolves to a heading that now exists in data-models.mdx. (Low effort)

## Quality Checklist
- [ ] All ~63 method-level request/response types added to data-models.mdx as `(Node)` headings; nested shapes inlined in service `Types` subsections.
- [ ] All new APIs (3 services + 29 appended methods) documented in node.mdx with the Documents-template block structure.
- [ ] New `### ` headings slugify to `#agents`, `#memory`, `#approval-workflows` (matches changelog anchors).
- [ ] `Params:` renders as a `data-models.mdx#<type>-node` link for every documented method; `Returns:` reuses `#veltapiresponse-node` or a typed `(Node)` response anchor.
- [ ] "17 services" replaced with "20 services" at L21 and L624; no other stale count remains.
- [ ] `getApiKeyMetadata` endpoint-repoint note added (no new method block).
- [ ] No Web/React content added to data-models.mdx or api-methods.mdx; Node types stay in the `(Node)` block.
- [ ] docs.json untouched; upgrade-guide.mdx untouched (no breaking changes); no wireframe/primitive edits.
- [ ] Log file written to `.claude/logs/agent-2-planning-velt-node-1.0.3.md`.
