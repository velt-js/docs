## QA Summary for Python SDK (velt-py) v0.1.14

Scope: final QA on the velt-py v0.1.14 docs release. All findings verified via Read/Grep/sed — no answers from memory.

### Per-check results

**Check 1 — `CommentResolverSaveEvent` table — PASS**
Exactly **14** members (table rows 5188–5201 of `backend-sdks/python.mdx`). Wire values match the required set byte-for-byte, in order: comment_annotation.status_change, comment_annotation.priority_change, comment_annotation.assign, comment_annotation.access_mode_change, comment_annotation.custom_list_change, comment_annotation.approve, comment.accept, comment.reject, comment_annotation.suggestion_accept, comment_annotation.suggestion_reject, comment.reaction_add, comment.reaction_delete, comment_annotation.subscribe, comment_annotation.unsubscribe.

**Check 2 — error-code set (9) agreement — PASS**
`diff` of the two locations returned **MATCH** (no drift). Both lists are exactly: MISSING_TOKEN, EXPIRED, INVALID_SIGNATURE, CLAIM_MISMATCH, ALGORITHM_NOT_ALLOWED, KEY_RESOLUTION_FAILED, VERIFICATION_FAILED, NOT_CONFIGURED, DEPENDENCY_MISSING.
- `VerifyTokenResult.errorCode` field-note: line 5175.
- Resolver-Token-Verification error table: lines 722–730.

**Check 3 — distinctness + parse-order notes — PASS**
- Distinctness (line 5205): `CommentResolverSaveEvent.REACTION_ADD` (`comment.reaction_add`) vs `ResolverActions.REACTION_ADD` (`reaction.add`) — present and correct.
- Parse order (line 5203, echoed 5223): ResolverActions first → CommentResolverSaveEvent → raw string — present and correct.

**Check 4 — in-page anchor integrity — PASS**

| Anchor | Headings resolving | Result |
|--------|--------------------|--------|
| `#resolver-token-verification` | 1 (L697) | OK |
| `#verifytokenresult` | 1 (L5155) | OK |
| `#commentresolversaveevent` | 1 (L5177) | OK |
| `#savecommentresolverrequest` | 1 (L5207) | OK — no slug collision |
| `#self-hosting-configuration` | 1 (L122) | OK |

In-page `[`SaveCommentResolverRequest`](#savecommentresolverrequest)` (L337) targets the python.mdx heading. The `#### saveComments` Params link (L318) points to `/api-reference/sdk/models/data-models#savecommentresolverrequest` — different page, correct.

**Check 5 — terminology case-exactness — PASS**
No wrong-case variants found (`verify_token`/`VerifyToken` standalone: none; `resolverAuth`: none). All required exact tokens present: `verifyToken` (8), `resolver_auth` (10), `CommentResolverSaveEvent` (11), `SaveCommentResolverRequest` (13), `targetComment` (5), `VerifyTokenResult` (8), `ResolverAuthService` (2), `velt-py[auth]` (6). snake_case keys (`resolver_auth`/`public_key`/`jwks_url`) and camelCase `errorCode` left as-is (intentional, not drift).

**Check 6 — escaped pipes / table sanity — PASS**
No `\|` inside any ```python``` fence (awk scan empty). No escaped pipes anywhere in the two files. New-table pipe counts consistent: event table = 3/row, error table = 3/row, UNSET table = 4/row (header/separator/rows aligned). `RS\*`/`ES\*` at L738–740 are escaped asterisks in prose, not table pipes — fine.

**Check 7 — changelog — PASS**
Order newest-first: v0.1.14 (L9) sits above v0.1.12 (L21). v0.1.14 block has **3** separate `[**Self Hosting**]` bullets (not merged). Date `description="June 19, 2026"`. All 3 links are bare `(/backend-sdks/python)`.

**Check 8 — scope guard — PASS**
`git diff --name-only`:
```
backend-sdks/python.mdx
release-notes/version-5/velt-py-changelog.mdx
```
Forbidden files all untouched: `api-reference/sdk/models/data-models.mdx`, `release-notes/version-5/velt-node-changelog.mdx`, `backend-sdks/node.mdx`, `self-host-data/*`. (Node v1.0.7 correctly absent — lives on its own branch.) The only other working-tree entry is the untracked planning artifact `.claude/logs/agent-2-planning-velt-py-0.1.14.md`, not a doc edit.

### Fixes applied
None. All 8 checks passed on first review; no safe/justified edit was warranted.

### Counts confirmed
- `CommentResolverSaveEvent` members: **14**
- `errorCode` set: **9** (field-note ↔ table: MATCH)

Issues found: 0
