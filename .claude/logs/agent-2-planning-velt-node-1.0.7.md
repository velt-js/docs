# Release Update Plan for Velt Node SDK v1.0.7 (`@veltdev/node`)

## Overview
- Release Type: Minor (additive, backend-only). No breaking changes.
- Key Changes:
  1. `CommentResolverSaveEvent` enum (14 members) + `event` widening + new `targetComment` on `SaveCommentResolverRequest`.
  2. New `sdk.selfHosting.verifyToken` helper (DB-free, fail-closed) + `resolverAuth` on `VeltConfig` + 7 new exported type names.
- Breaking Changes: No. `event` widening is a superset; `targetComment`, `resolverAuth`, `verifyToken` are all optional/new. Nothing for upgrade-guide; nothing for the changelog beyond what Agent-1 wrote.
- Changelog links already written by Agent-1 (anchors the docs MUST satisfy): `#comments` (save resolver changes) and `#verifytoken` (verify helper). Both anchors must resolve on `/backend-sdks/node`.

## Grounding confirmed (by reading)
- `node.mdx`: Installation ~23-42; Self-Hosting Configuration `<Tabs>` ~112-176; `## Self-Hosting Backend` line 178; `### Comments` 182, `#### saveComments` 210-234 (currently links `SaveCommentsRequest (SH)`, NOT the resolver type); `### Token` 604-630; `## REST API Backend` line 632.
- `data-models.mdx`: shared `#### SaveCommentResolverRequest` line 532 (has `event: ResolverActions`, no `targetComment`); `#### GetCommentResolverRequest` 520; `#### DeleteCommentResolverRequest` 543; `#### ResolverActions` enum 4932; `#### PartialComment` 5047; `#### ResolverConfig` 5170 (does NOT document `additionalSaveEvents`).
- Node SDK type sections run `### \`Name\` (Node)` / ` SH (Node)`, alphabetized 9574-11026 (then out-of-order `CreateAgentRequest` 11028+ from the now-hidden Agents block — do NOT alphabetize new types into that trailing block).

## Discrepancies found (flag for downstream agents)
1. **Two existing enums already carry `'comment.reaction_add'`-style values**, distinct from the new enum:
   - `#### CommentActivityActionTypes` (line 4001) is value-identical to `CommentResolverSaveEvent` for 12 of 14 members (incl. `REACTION_ADD='comment.reaction_add'`), but is an **activity-log** enum and LACKS `suggestion_accept`/`suggestion_reject`. Do NOT reuse or merge it.
   - `#### ResolverActions` (line 4932) has `REACTION_ADD='reaction.add'` (different value/owner).
   - => `CommentResolverSaveEvent.REACTION_ADD ('comment.reaction_add')` is distinct from `ResolverActions.REACTION_ADD ('reaction.add')`. This distinctness note is REQUIRED in the new enum section.
2. **node.mdx `saveComments` documents `SaveCommentsRequest (SH)`, not `SaveCommentResolverRequest`.** These are two different surfaces: the SH MongoDB type vs. the shared frontend-resolver type. The v1.0.7 changes (`event`/`targetComment`) belong to the **shared resolver type** (data-models line 532), NOT the SH type. node.mdx needs only a short resolver-contract note + link, not a type-table rewrite.
3. **`additionalSaveEvents` is NOT in `ResolverConfig`** (data-models 5170) and is a frontend-SDK capability. It is the *reason* the enum exists, not a Node deliverable. Frontend pages stay out of scope (see section 5).
4. v1.0.6 is absent from the changelog (expected per per-release-branch workflow). v1.0.7 entry is freshly written and not yet shipped to reference pages. Proceed.

## Areas Requiring Updates

### 1. Data Models (data-models.mdx) — Agent-3
- **Modify** `#### SaveCommentResolverRequest` (line 532): change `event` type cell from `ResolverActions` to `` `ResolverActions \| CommentResolverSaveEvent \| string` ``; add `targetComment` row: type `PartialComment`, Required No, desc "Comment the action occurred on, resolved from `commentId`. Request context only — never persisted by `saveComments`." Priority: High.
- **Add** `#### CommentResolverSaveEvent` enum immediately after `#### ResolverActions` (after line 4951, before `#### UserResolverModuleName`). All 14 members exact (STATUS_CHANGE … UNSUBSCRIBE). Add a line below the table: `REACTION_ADD ('comment.reaction_add')` is distinct from `ResolverActions.REACTION_ADD ('reaction.add')`. Priority: High.
- **Add** 5 Node-type sections in the alphabetized `## Node SDK Types` block (between 9574-11026, NOT in the trailing Agents block). Use plain `(Node)` (verify helper is `sdk.selfHosting.*` but is config/auth, not a request/response payload; keep `(Node)`, not ` SH (Node)`, to avoid implying a MongoDB self-hosting request shape — note this choice for Agent-6):
  - `### \`ResolverAuthConfig\` (Node)` — insert before `### \`ResolverActions\``? (no Node section exists) => alphabetical slot: after `### \`RemovePermissionsRequest\`` (10773) / `ResetAuthTokenRequest` (10782), before `### \`SaveActivitiesRequest\` SH` (10790). Fields: `jwt?: ResolverAuthJwtConfig`, `verify?: ResolverAuthVerifyCallback`, `header?` (default `'Authorization'`), `scheme?` (default `'Bearer'`).
  - `### \`ResolverAuthJwtConfig\` (Node)` — same R-slot, after `ResolverAuthConfig`. Fields: `algorithms: string[]` (REQUIRED allowlist, e.g. `['RS256']`), `jwksUrl?`, `publicKey?` (PEM), `secret?` (HS*), `issuer?`, `audience?`, `leeway?`, `require?`.
  - `### \`ResolverAuthVerifyCallback\` (Node)` — type alias `async (token, headers) => claims`.
  - `### \`VerifyTokenResult\` (Node)` — slot before `### \`VeltApiResponse\`` is at top; alphabetically `VerifyTokenResult` sorts after `UpdateWebhookConfigRequest` (101019) — insert at end of the alphabetized run (right before the trailing out-of-order `CreateAgentRequest` at 11028). Fields: `verified: boolean`, `claims?: Record<string,unknown>`, `error?: string`, `errorCode?: ResolverAuthErrorCode`.
  - `### \`ResolverAuthErrorCode\` (Node)` — R-slot. Type union of the 9 codes; render the error-code table (9 rows + "When" meanings) here OR inline in node.mdx (see decision below).
- **Decision (inline vs. data-models)**: `RESOLVER_AUTH_ERROR_CODES` (the const readonly `string[]`) and the 9-code "When" table live **inline in node.mdx** verifyToken section (it is reference prose tied to the method), and `ResolverAuthErrorCode` gets a short `(Node)` stub in data-models that links back. Avoids duplicating the 9-row table. Priority: High for `ResolverAuthErrorCode`/`VerifyTokenResult`/`ResolverAuthConfig`/`ResolverAuthJwtConfig`; Medium for `ResolverAuthVerifyCallback`.
- Note: `ResolverAuthService` (class) is the implementation type behind `sdk.selfHosting.verifyToken`; document it by name in node.mdx prose only — no standalone data-models section needed.

### 2. API Methods / node.mdx — Agent-3 (node.mdx is the Node API reference; api-methods.mdx is N/A for backend)

#### 2a. node.mdx — `### Comments` / `#### saveComments` (~210-234) — anchor `#comments`
- Add a short **resolver-contract note** under `#### saveComments` (after the response block ~234), NOT a type-table change. One sentence: when this resolver runs behind the frontend `additionalSaveEvents` opt-in, `event` may be a `CommentResolverSaveEvent` (in addition to `ResolverActions`/`string`), and the request may include `targetComment?: PartialComment` (request context, never persisted).
- Link the resolver type table to data-models: `[SaveCommentResolverRequest](/api-reference/sdk/models/data-models#savecommentresolverrequest)` and `[CommentResolverSaveEvent](/api-reference/sdk/models/data-models#commentresolversaveevent)`. Do NOT alter the existing `SaveCommentsRequest (SH)` link/table (different type). Priority: High.

#### 2b. node.mdx — NEW `### Resolver Token Verification` section — anchor `#verifytoken`
- Place under `## Self-Hosting Backend`, immediately **after `### Token`** (after line 630), before `## REST API Backend` (632). Heading must slugify to `#verifytoken` to match Agent-1's link — use `### verifyToken` (or `### Resolver Token Verification {#verifytoken}` if explicit anchor is needed; verify Mintlify slug rule — RECOMMEND `### verifyToken`).
- Content (inline):
  - One-line intro: DB-free, fail-closed (every error path returns `{ verified: false }`, never throws), authentication only — never an authorization decision. Callable immediately after `VeltSDK.initialize` (no Mongo).
  - Method signature: `sdk.selfHosting.verifyToken(options?) => Promise<VerifyTokenResult>`. Link `VerifyTokenResult` to data-models.
  - Optional peer dep note: `npm install jose` (`^5`; jose v6 needs a WebCrypto global absent on Node 18). Built-in JWT path without `jose` => `{ verified:false, errorCode:'DEPENDENCY_MISSING' }`. Callback path needs no dep.
  - `resolverAuth` config example (link `ResolverAuthConfig`/`ResolverAuthJwtConfig`): show JWT path (`algorithms:['RS256']` REQUIRED, `jwksUrl`|`publicKey`|`secret`, `issuer?`/`audience?`/`leeway?`/`require?`) AND custom `verify` callback path, plus `header`/`scheme` defaults.
  - Per-call override note: per-call `options` override configured `resolverAuth` (deep-merged with `jwt`); may pass raw `{ token }` or `{ headers }`, and override e.g. `{ jwt: { leeway: 30 } }`.
  - Usage example (React/Next.js + Other Frameworks tabs per convention): call from an endpoint-based resolver route, branch on `result.verified`.
  - **Error-code table (9 rows)** inline — list `RESOLVER_AUTH_ERROR_CODES` and each code with its "When" meaning: NOT_CONFIGURED, MISSING_TOKEN, EXPIRED, INVALID_SIGNATURE, CLAIM_MISMATCH, ALGORITHM_NOT_ALLOWED, KEY_RESOLUTION_FAILED, DEPENDENCY_MISSING, VERIFICATION_FAILED.
  - **Security guarantees** list (verbatim intent): `alg=none` always rejected even if allowlisted; mixed symmetric+asymmetric allowlists refused; PEM in `jwt.secret` refused; JWKS HTTPS-only (http + redirect-downgrade rejected pre-fetch); JWKS cached per-URL 5-min TTL (not per-kid); alg checked vs allowlist before any JWKS fetch; `error` is generic/code-based, never contains token or secret.
- Priority: High.

#### 2c. node.mdx — Installation (~29-34) + Self-Hosting Configuration (~112-176)
- Installation: add `npm install jose   # optional — only for built-in JWT/JWKS verifyToken (^5)` to the optional-peer block (~33). Update Requirements bullet (41) to mention `jose` ^5 as optional peer. Priority: Medium.
- Self-Hosting Configuration `<Tabs>`: add a new `<Tab title="Resolver Auth">` showing `resolverAuth` on `VeltConfig.initialize(...)`, OR keep the full `resolverAuth` example only in the verifyToken section and add a one-line pointer here. RECOMMEND: new `<Tab title="Resolver Auth">` with a minimal `resolverAuth` block + link to `#verifytoken` (keeps config discoverable without duplicating the full table). Priority: Medium.

### 3. Documentation (new pages)
- None. Both features extend the existing `/backend-sdks/node` page. No new page. Priority: N/A.

### 4a. UI Customization — Wireframes — **N/A**
- Backend-only release, no UI surface. Agent-4 SKIP.

### 4b. UI Customization — Primitives — **N/A**
- Backend-only release, no primitive components or props. Agent-5 SKIP.

### 5. Frontend cross-references (`self-host-data/comments.mdx`, `ResolverConfig`)
- Default position: this is a NODE SDK release. `additionalSaveEvents` / `ResolverConfig` are frontend-SDK surfaces and are mentioned only as the *reason* the enum exists.
- **REQUIRED**: none.
- **OPTIONAL** (do NOT do unless orchestrator approves): in `self-host-data/comments.mdx` `### config` (~553) add an `additionalSaveEvents` bullet referencing `CommentResolverSaveEvent`, and add an `additionalSaveEvents` row to `#### ResolverConfig` (data-models 5170). These describe a frontend capability not shipped by `@veltdev/node` v1.0.7 — leave for the frontend release that ships `additionalSaveEvents`. Mark clearly OPTIONAL/out-of-scope.

### 6. Upgrade Guide — **N/A**
- No breaking changes. Nothing to add to any `upgrade-guide.mdx`. Do NOT add v1.0.7 items to the changelog beyond Agent-1's entry.

## Implementation Sequence
1. Agent-3: modify shared `SaveCommentResolverRequest` (event widen + targetComment row) in data-models.mdx. (Low effort)
2. Agent-3: add `CommentResolverSaveEvent` enum after `ResolverActions` with the REACTION_ADD distinctness note. (Low effort)
3. Agent-3: add 5 `(Node)` type sections (`ResolverAuthConfig`, `ResolverAuthJwtConfig`, `ResolverAuthVerifyCallback`, `VerifyTokenResult`, `ResolverAuthErrorCode`) at correct alphabetical slots, NOT in the trailing Agents block. (Medium effort)
4. Agent-3: node.mdx `saveComments` resolver-contract note + data-models links (anchor `#comments`). (Low effort)
5. Agent-3: node.mdx new `### verifyToken` section (anchor `#verifytoken`) — signature, resolverAuth example, usage tabs, 9-row error table, security guarantees. (High effort)
6. Agent-3: node.mdx Installation `jose` optional peer + Self-Hosting Configuration `Resolver Auth` tab/pointer. (Low effort)
7. Agent-6/7: terminology + anchor QA (below).

## Notes for Agent-6 / Agent-7
- Keep terminology exact: `verifyToken`, `resolverAuth`, `CommentResolverSaveEvent`, `targetComment`, `ResolverAuthService`, `VerifyTokenResult`, `RESOLVER_AUTH_ERROR_CODES`, `ResolverAuthErrorCode`, `ResolverAuthConfig`, `ResolverAuthJwtConfig`, `ResolverAuthVerifyCallback`.
- Anchors that MUST resolve (Agent-1's changelog links): `/backend-sdks/node#comments`, `/backend-sdks/node#verifytoken`.
- Counts to verify: **14** `CommentResolverSaveEvent` members; **9** error codes; **7** new exported type names (`VerifyTokenResult`, `RESOLVER_AUTH_ERROR_CODES`, `ResolverAuthErrorCode`, `ResolverAuthConfig`, `ResolverAuthJwtConfig`, `ResolverAuthVerifyCallback`, `ResolverAuthService`) **plus** the `CommentResolverSaveEvent` enum.
- Error-code string values are case-exact UPPER_SNAKE (e.g. `DEPENDENCY_MISSING`), used in code examples and the table.
- Distinctness guard: do NOT collapse `CommentResolverSaveEvent` into `CommentActivityActionTypes` (line 4001) or `ResolverActions` (4932); the REACTION_ADD value/owner difference must survive QA. QA should diff value strings, not just member counts.

## Quality Checklist
- [x] Version in filename and document
- [x] Specific file paths + line/anchor for every update
- [x] Change descriptions per file
- [x] Priority levels assigned
- [x] Implementation sequence (dependency order)
- [ ] All new types added to data-models.mdx (Agent-3)
- [ ] All new APIs documented in node.mdx (Agent-3)
- [ ] Code examples include React/Next.js + Other Frameworks tabs (Agent-3)
- [x] No breaking changes => upgrade-guide untouched, changelog unchanged beyond Agent-1
- [x] Wireframes (Agent-4) and Primitives (Agent-5) marked N/A
- [x] Log written to `.claude/logs/agent-2-planning-velt-node-1.0.7.md`
