# Release Update Plan for velt-py v0.1.14

## Overview
- Release Type: Minor (additive)
- Key Changes: Two self-hosting features — (1) `verifyToken` resolver-auth helper (`resolver_auth` config + `VerifyTokenResult` + `ResolverAuthService`, opt-in `velt-py[auth]` extra); (2) comment-resolver save extensions (`SaveCommentResolverRequest.targetComment`, widened `event`, new 14-member `CommentResolverSaveEvent` enum).
- Breaking Changes: No. All additive; existing payloads parse byte-identically. REST API unchanged.
- Target file (ALL edits): `/Users/yoenzhang/Downloads/docs/backend-sdks/python.mdx` (Python SDK convention: dataclasses documented INLINE in its `## Data Models` section, not the shared reference).

## Scope Guardrails (read first)
- **`api-reference/sdk/models/data-models.mdx` is OUT OF SCOPE.** Python dataclasses never go there. The shared `SaveCommentResolverRequest` (lines 532, 9356) and `CommentResolverSaveEvent` there belong to a SEPARATE unmerged Node SDK branch; editing them here causes merge conflicts and violates the Python convention.
- **Agent-4 (wireframes): N/A.** Backend-only release, no UI.
- **Agent-5 (primitives): N/A.** Backend-only release, no UI.
- **Upgrade guide: N/A.** No breaking changes.
- Changelog (`release-notes/version-5/velt-py-changelog.mdx`) already done by Agent-1: v0.1.14 block at lines 9-17, three separate items, each `[Learn more →]` links to bare `/backend-sdks/python` (no anchors). Do not modify.

## Areas Requiring Updates

### 1. Installation — `velt-py[auth]` extra note (Priority: Medium)
- File: `/Users/yoenzhang/Downloads/docs/backend-sdks/python.mdx`
- Insertion point: `### Requirements` (line 29), append after the existing `requests` bullet (line 34).
- Change: Add one bullet — optional `velt-py[auth]` extra installs PyJWT>=2.8.0 and cryptography>=42.0.0, required ONLY for the built-in JWT/JWKS verifier path of `verifyToken`. Custom-callback path and all non-auth features need no new dependency. Install: `pip install 'velt-py[auth]'`.

### 2. Self-Hosting Configuration — `Resolver Auth` tab (Priority: High)
- File: `/Users/yoenzhang/Downloads/docs/backend-sdks/python.mdx`
- Insertion point: inside the `<Tabs>` block at `### Self-Hosting Configuration` (line 123), as a new `<Tab title="Resolver Auth">` placed before `<Tab title="Complete Example">` (line 197).
- Change: Document the `resolver_auth` config block passed to `VeltSDK.initialize`. Show both shapes in one python block:
  - `jwt` sub-block: `secret` (HS*) OR `public_key` (PEM, RS*/ES*) OR `jwks_url` (HTTPS JWKS); `algorithms` (REQUIRED allowlist, e.g. `['HS256']`); optional `issuer`, `audience` (enforced when set), `leeway` (seconds), `require` (e.g. `['exp']`).
  - `verify` escape hatch: `lambda token, headers: my_decode(token)` returning claims dict or None; takes priority over `jwt`.
  - Optional `header` (default `Authorization`), `scheme` (default `Bearer`).

### 3. Self-Hosting Backend — new `### Resolver Token Verification` section (Priority: High)
- File: `/Users/yoenzhang/Downloads/docs/backend-sdks/python.mdx`
- Insertion point: between `### Token` (ends at the getToken Note, line 665) and `### Framework Examples` (line 667). New top-level `###` section under `## Self-Hosting Backend`.
- Change: Document `sdk.selfHosting.verifyToken(headers=None, token=None, **overrides) -> VerifyTokenResult`. Contents in this order (mirror existing Method → note → example pattern):
  1. Intro: opt-in via `resolver_auth`; framework-agnostic; fail-closed; authenticates ONLY (resolver services keep their own apiKey/organizationId scoping; helper never consults apiKey/organizationId/resolver DB).
  2. Config recap: one-line pointer back to the `Resolver Auth` config tab (area 2).
  3. Usage example (Flask/Django-style): `result = sdk.selfHosting.verifyToken(headers=request.headers)`; branch on `result.verified`; return 401 with `result.errorCode` when False; read `result.claims` when True. Also show `token='<raw_jwt>'` direct-pass variant.
  4. `VerifyTokenResult` field table — link to the inline `### \`VerifyTokenResult\`` Data Models entry (area 4a).
  5. The 9 `errorCode` values: MISSING_TOKEN, EXPIRED, INVALID_SIGNATURE, CLAIM_MISMATCH, ALGORITHM_NOT_ALLOWED, KEY_RESOLUTION_FAILED, VERIFICATION_FAILED, NOT_CONFIGURED, DEPENDENCY_MISSING.
  6. Security properties: fail-closed; algorithm pinning (allowlist always required; `alg=none` rejected unconditionally; mixed symmetric+asymmetric allowlists rejected — HS/RS confusion); HTTPS-only JWKS (https:// required; redirect downgrade https→http rejected; 3xx rejected; cache keyed by `(url, kid)`); no credential leakage (token/secret/claims never in error strings or logs); authentication only.
  7. Token extraction: from configured header (default `Authorization`, case-insensitive) stripping configured scheme (default `Bearer`); or pass `token=`. Missing/empty/wrong-scheme → `MISSING_TOKEN`.
  8. Key resolution: `jwt.secret` → symmetric HS256/384/512 (PEM string in `secret` REJECTED — prevents PEM-as-HMAC forgery); `jwt.public_key` → static RSA/EC for RS*/ES*; `jwt.jwks_url` → HTTPS fetch, cached by `(url, kid)`; fetch failure / non-2xx / unresolvable kid → `KEY_RESOLUTION_FAILED` without raising.
  9. Per-call overrides: `**overrides` kwargs merge over configured `resolver_auth` (one-off `jwt`/`verify`/`header`/`scheme`).
  10. NOT_CONFIGURED behavior: when `resolver_auth` not configured, returns `verified=False`, `errorCode='NOT_CONFIGURED'` (does not raise, does not silently pass).
  11. `ResolverAuthService` export note: newly in `velt_py.services.self_hosting` `__all__`; DB-free service backing `verifyToken`; direct use optional.

### 4a. Data Models (inline) — `### \`VerifyTokenResult\`` dataclass (Priority: High)
- File: `/Users/yoenzhang/Downloads/docs/backend-sdks/python.mdx`
- Insertion point: in `## Data Models` (line 4933), after `### UNSET Sentinel` (line 5019) / before `### \`BaseMetadata\`` (line 5040), OR appended after `### \`BaseMetadata\`` (line 5058). Recommend appending the three new entries (4a, 4b, 4c) after `BaseMetadata`, before `## Resources` (line 5060), to keep the existing comment/reaction cluster intact.
- Change: Follow existing pattern (`### \`Name\``, description w/ version note, ```python @dataclass``` block, **Field notes**). Module: `velt_py.models.resolver_auth`; exported from `velt_py` and `velt_py.models`.
  - Fields: `verified: bool`; `claims: Optional[Dict]`; `error: Optional[str]`; `errorCode: Optional[str]`.
  - Field notes: `verified` True only when token present & fully verified, or custom callback returned non-None. `claims` decoded payload when verified else None. `error` generic, code-based — never contains token/secret. `errorCode` one of the 9 values (list them).

### 4b. Data Models (inline) — `### \`CommentResolverSaveEvent\`` enum (Priority: High)
- File: `/Users/yoenzhang/Downloads/docs/backend-sdks/python.mdx`
- Insertion point: in `## Data Models`, immediately after the `VerifyTokenResult` entry (4a).
- Change: `CommentResolverSaveEvent(str, Enum)`, exported from `velt_py` and `velt_py.models`; wire values byte-identical to upstream frontend enum. Include a 14-member table (member → wire value):
  - STATUS_CHANGE → `comment_annotation.status_change`
  - PRIORITY_CHANGE → `comment_annotation.priority_change`
  - ASSIGN → `comment_annotation.assign`
  - ACCESS_MODE_CHANGE → `comment_annotation.access_mode_change`
  - CUSTOM_LIST_CHANGE → `comment_annotation.custom_list_change`
  - APPROVE → `comment_annotation.approve`
  - ACCEPT → `comment.accept`
  - REJECT → `comment.reject`
  - SUGGESTION_ACCEPT → `comment_annotation.suggestion_accept`
  - SUGGESTION_REJECT → `comment_annotation.suggestion_reject`
  - REACTION_ADD → `comment.reaction_add`
  - REACTION_DELETE → `comment.reaction_delete`
  - SUBSCRIBE → `comment_annotation.subscribe`
  - UNSUBSCRIBE → `comment_annotation.unsubscribe`
- Notes to include: parse order in `SaveCommentResolverRequest.from_dict` (ResolverActions FIRST → CommentResolverSaveEvent → raw string fallback for unknown future values); dual export. **CRITICAL preserve verbatim:** `CommentResolverSaveEvent.REACTION_ADD` wire value `comment.reaction_add` is DISTINCT from `ResolverActions.REACTION_ADD` (`reaction.add`, the reaction-resolver action); parse order routes each correctly.

### 4c. Data Models (inline) — `### \`SaveCommentResolverRequest\`` focused entry (Priority: High)
- File: `/Users/yoenzhang/Downloads/docs/backend-sdks/python.mdx`
- Decision: **Add a focused inline `### \`SaveCommentResolverRequest\`` entry** documenting ONLY the v0.1.14 additions (do NOT re-document the whole type). Reason: keeps the `#### saveComments` method note short, gives a stable in-page anchor, and avoids touching the shared `data-models.mdx`. The widened-`event` parse order naturally references the `CommentResolverSaveEvent` entry (4b) directly above it.
- Insertion point: in `## Data Models`, immediately after the `CommentResolverSaveEvent` entry (4b).
- Change: Description with version note (**New in v0.1.14**, additive — existing payloads parse byte-identically). Document:
  - `targetComment: Optional[PartialComment]` — the comment the action occurred on, resolved by frontend from `commentId`. `from_dict` parses a `targetComment` dict into `PartialComment`, fail-open (malformed/partial dict never raises). `to_dict` emits `targetComment` only when not None. `saveComments` NEVER persists it (request context only).
  - `event` widened to `Optional[Union[ResolverActions, CommentResolverSaveEvent, str]]`. Parse order: ResolverActions FIRST (preserves every existing value), then `CommentResolverSaveEvent`, then raw string for unknown future values.

### 5. `#### saveComments` method note (Priority: Medium)
- File: `/Users/yoenzhang/Downloads/docs/backend-sdks/python.mdx`
- Insertion point: `#### \`saveComments\`` (line 287). Add an additive note after the Response block (line 307), before `#### \`deleteComment\`` (line 309).
- Params link decision: **Keep the existing Params link to `/api-reference/sdk/models/data-models#savecommentresolverrequest` (line 290) as-is** (it documents the full shared shape) AND add one sentence pointing to the new inline `### \`SaveCommentResolverRequest\`` entry (4c) for the v0.1.14 additions. Do not edit `data-models.mdx`.
- Change wording: brief note — "As of v0.1.14, `SaveCommentResolverRequest` adds optional `targetComment` (request context only; never persisted) and a widened `event` accepting `CommentResolverSaveEvent`. See [`SaveCommentResolverRequest`](#savecommentresolverrequest) below." Anchor must match the inline heading from 4c.

## Implementation Sequence (for Agent-3)
1. Area 4a/4b/4c: add the three inline Data Models entries first (anchors must exist before method note links them). Effort: medium.
2. Area 3: add `### Resolver Token Verification` section (links to 4a). Effort: high.
3. Area 2: add `Resolver Auth` config tab. Effort: medium.
4. Area 5: add `saveComments` note linking to 4c anchor. Effort: low.
5. Area 1: add `velt-py[auth]` Requirements bullet. Effort: low.

## Notes for Agent-6 / Agent-7
- Terminology to keep EXACT (do not rephrase/case-fold): `verifyToken`, `resolver_auth`, `CommentResolverSaveEvent`, `SaveCommentResolverRequest`, `targetComment`, `VerifyTokenResult`, `ResolverAuthService`, `velt-py[auth]`.
- The 9 errorCode strings EXACT: MISSING_TOKEN, EXPIRED, INVALID_SIGNATURE, CLAIM_MISMATCH, ALGORITHM_NOT_ALLOWED, KEY_RESOLUTION_FAILED, VERIFICATION_FAILED, NOT_CONFIGURED, DEPENDENCY_MISSING.
- Counts to verify: 14 `CommentResolverSaveEvent` members; 9 errorCode values.
- WATCH wire-value distinctness: `CommentResolverSaveEvent.REACTION_ADD` = `comment.reaction_add` vs `ResolverActions.REACTION_ADD` = `reaction.add`. Never collapse these.
- No anchor changes in `velt-py-changelog.mdx`; its `[Learn more →]` links stay bare `/backend-sdks/python`.

## Quality Checklist
- [ ] All three new inline Data Models entries added to `python.mdx` `## Data Models` (`VerifyTokenResult`, `CommentResolverSaveEvent`, `SaveCommentResolverRequest`) — NOT to `data-models.mdx`.
- [ ] `verifyToken` documented under `## Self-Hosting Backend` (between Token and Framework Examples).
- [ ] `Resolver Auth` config tab + `velt-py[auth]` install note added.
- [ ] `saveComments` additive note added; Params link unchanged; new inline anchor link valid.
- [ ] 14 enum members and 9 errorCodes present and counted.
- [ ] REACTION_ADD wire-value distinctness preserved verbatim.
- [ ] No edits to `api-reference/sdk/models/data-models.mdx`; no wireframe/primitive/upgrade-guide changes.
- [ ] Log written to `/Users/yoenzhang/Downloads/docs/.claude/logs/agent-2-planning-velt-py-0.1.14.md`.
