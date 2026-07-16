## QA Summary for Velt Node SDK v1.0.7

Final QA pass. All verifications run with Read/Grep/diff against the working tree (not from memory).

### Changed files (git, working tree)
- `api-reference/sdk/models/data-models.mdx` (+104/-, modified `SaveCommentResolverRequest`; new `CommentResolverSaveEvent`; new `(Node)` sections: `VerifyTokenResult`, `ResolverAuthConfig`, `ResolverAuthErrorCode`, `ResolverAuthJwtConfig`, `ResolverAuthVerifyCallback`)
- `backend-sdks/node.mdx` (+139/-, install `jose` note, `Resolver Auth` config tab, `saveComments` resolver note, new `### verifyToken` section, `ResolverAuthService` prose)
- `release-notes/version-5/velt-node-changelog.mdx` (+12, new `1.0.7` Update block)
- Total: 3 files, 248 insertions, 7 deletions (deletions = SaveCommentResolverRequest row replacement + install-block edits; all expected/additive).

### Per-check results

**Check 1 — CommentResolverSaveEvent enum (expect 14): PASS.** data-models.mdx:4954. Exactly **14** member rows; all 14 required values present once each (status_change, priority_change, assign, access_mode_change, custom_list_change, approve, comment.accept, comment.reject, suggestion_accept, suggestion_reject, comment.reaction_add, comment.reaction_delete, subscribe, unsubscribe).

**Check 2 — ResolverAuthErrorCode (expect 9) + table parity: PASS.** `diff` of node.mdx:749-757 vs data-models.mdx:10833-10841 = **IDENTICAL string-for-string**. 9 codes each (NOT_CONFIGURED, MISSING_TOKEN, EXPIRED, INVALID_SIGNATURE, CLAIM_MISMATCH, ALGORITHM_NOT_ALLOWED, KEY_RESOLUTION_FAILED, DEPENDENCY_MISSING, VERIFICATION_FAILED).

**Check 3 — Anchor integrity: PASS.** Every link added this release resolves to a unique, real heading (no duplicate headings → no Mintlify `-2` slug collisions).

| Link anchor | Target heading | Loc | Resolves |
|---|---|---|---|
| `#verifytoken` | `### verifyToken` | node.mdx:651 | yes |
| `#verifytokenresult-node` | `### \`VerifyTokenResult\` (Node)` | data-models:11109 | yes |
| `#resolverauthconfig-node` | `### \`ResolverAuthConfig\` (Node)` | data-models:10816 | yes |
| `#resolverautherrorcode-node` | `### \`ResolverAuthErrorCode\` (Node)` | data-models:10827 | yes |
| `#resolverauthjwtconfig-node` | `### \`ResolverAuthJwtConfig\` (Node)` | data-models:10843 | yes |
| `#resolverauthverifycallback-node` | `### \`ResolverAuthVerifyCallback\` (Node)` | data-models:10858 | yes |
| `#commentresolversaveevent` | `#### CommentResolverSaveEvent` | data-models:4954 | yes |
| `#savecommentresolverrequest` | `#### SaveCommentResolverRequest` | data-models:532 | yes |
| `#comments` (changelog) | `### Comments` | node.mdx:199 | yes |
| `#resolveractions` (note) | `#### ResolverActions` | data-models:4933 | yes |
| `#savecommentsrequest-sh-node` | `### \`SaveCommentsRequest\` SH (Node)` | data-models | yes |

**Check 4 — REACTION_ADD distinctness note: PASS.** data-models.mdx:4977 correctly contrasts `CommentResolverSaveEvent.REACTION_ADD` (`'comment.reaction_add'`) vs `ResolverActions.REACTION_ADD` (`'reaction.add'`). Verified `ResolverActions` table (heading 4933) actually holds `'reaction.add'`. Not conflated with `CommentActivityActionTypes`.

**Check 5 — Terminology case-exactness: PASS.** All 11 terms present with exact casing across the 3 files (verifyToken, resolverAuth, CommentResolverSaveEvent, targetComment, ResolverAuthService, VerifyTokenResult, RESOLVER_AUTH_ERROR_CODES, ResolverAuthErrorCode, ResolverAuthConfig, ResolverAuthJwtConfig, ResolverAuthVerifyCallback). Drift hunt (mis-cased/misspelled variants) in changed files **and** repo-wide: **none**. `verifytoken` hits are all the legitimate `#verifytoken` anchor slug, not mis-cased identifiers.

**Check 6 — Escaped pipes / broken tables: PASS.** No `\|` inside any ```ts``` fence in the edited sections. The `\|` in `SaveCommentResolverRequest.event` (data-models:540) is a markdown table cell (`ResolverActions \| CommentResolverSaveEvent \| string`) — correct usage, not a code fence.

**Check 7 — Changelog: PASS.** `1.0.7` block sits above `1.0.5`; date "June 19, 2026"; 3 separate additive `### New Features` bullets (not merged); links `#comments` and `#verifytoken` resolve.

**Check 8 — Scope guard: PASS.** `git diff --name-only` = only the 3 expected files. No edits leaked into `self-host-data/*`, `velt-py-changelog.mdx`, or `python.mdx`.

### Fixes made
None. All checks passed; no safe-fix or flag-worthy issue found.

### Summary
- Files corrected: 0
- Critical issues: 0
- Exact counts confirmed: CommentResolverSaveEvent = **14**, ResolverAuthErrorCode = **9** (tables identical string-for-string)
- Anchors verified: 11/11 resolve

### Issues found: 0
