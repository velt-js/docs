# Release Update Plan for Velt Node SDK v1.0.5

## Overview
- Release Type: Patch (tiny — 4 files, +33/-3 in SDK; single self-hosting field rename)
- Key Changes: `PartialReactionAnnotation.user` renamed to `from` (reacting user), matching the frontend SDK's `PartialReactionAnnotation.from`. Affects self-hosting reaction resolvers (`sdk.selfHosting.getReactions().saveReactions()` persists `from`; resolved reactions expose `from`).
- Breaking Changes: Yes — clean rename, no backward-compat read shim documented (unlike velt-py v0.1.12).

> CRITICAL FRAMING: This is NOT a find-and-replace rename. The Node docs on `main` ALREADY use `from` for reactions (verified). There is NO stale `user` reaction-author field anywhere in the repo. The real work is illustrative/clarifying additions so the renamed field is actually shown in examples and the SH request type. Agent-3/6 must NOT fabricate a `user` → `from` rename.

## Areas Requiring Updates

### 1. Data Models — `SaveReactionsRequest` SH (Node)
- File: `api-reference/sdk/models/data-models.mdx` (~line 10826, heading `### \`SaveReactionsRequest\` SH (Node)`)
- Changes: Update the `reactionAnnotation` field's inline shape from `Record<string, { annotationId: string; icon: string; metadata: object }>` to include the renamed field: `Record<string, { annotationId: string; icon?: string; from?: PartialUser; metadata?: object }>`. This reflects that the reacting user is now carried as `from`.
- Priority: Medium

### 2. Data Models — `PartialReactionAnnotation` (NO CHANGE — confirm only)
- File: `api-reference/sdk/models/data-models.mdx` (~line 4921, `#### PartialReactionAnnotation`)
- Changes: NONE. Table already lists `| \`from\` | \`PartialUser\` | No | User who created the reaction annotation |` (verified line 4930). Do NOT duplicate, do NOT re-add, do NOT rename.
- Priority: N-A (confirm correct, leave untouched)

### 3. Documentation — `backend-sdks/node.mdx` `#### saveReactions` example
- File: `backend-sdks/node.mdx` (~line 279, under `### Reactions` → `#### saveReactions`)
- Changes: The example object currently OMITS the reacting user (`{ annotationId, icon, metadata }`). Add `from: { userId: 'u-1' }` to the `'reaction-1'` reaction object so the renamed field is shown. Optionally add a one-line note that the reacting user is set via `from` (renamed from `user` in v1.0.5), making the `#reactions` anchor target meaningful for the changelog link.
- Priority: High (this is the changelog's `Learn more` link target)

### 4a. UI Customization — Wireframes
- N/A — no UI/wireframe changes in this release.

### 4b. UI Customization — Primitives
- N/A — no new primitive components or props.

### 5. Upgrade Guide
- SKIP. `release-notes/version-5/upgrade-guide.mdx` is the JS v4→v5 guide. A Node-SDK self-hosting field rename does NOT belong there (consistent with velt-py v0.1.12 precedent). The changelog Breaking Changes entry + the node.mdx example/note are sufficient.

### Other SKIP / N-A
- `api-reference/sdk/api/api-methods.mdx` — SKIP (no method signature change).
- `docs.json` — no navigation change.

## Anchor Verification
- Changelog `Learn more` link in `release-notes/version-5/velt-node-changelog.mdx` (line 14) targets `/backend-sdks/node#reactions`.
- `backend-sdks/node.mdx` line 247 has `### Reactions`, which slugifies to `reactions`. CONFIRMED: the anchor resolves correctly. No anchor fix needed.

## Implementation Sequence
1. Agent-3: Add `from: { userId: 'u-1' }` to the `saveReactions` example in `backend-sdks/node.mdx` (~line 282); optionally add the one-line `from` (renamed from `user`) note. (Small)
2. Agent-3: Update `SaveReactionsRequest` SH (Node) `reactionAnnotation` inline shape in `data-models.mdx` (~line 10833) to include `from?: PartialUser`. (Small)
3. Agent-3: Confirm `#### PartialReactionAnnotation` already shows `from` (line 4930) — leave untouched. (Verify only)
4. Agent-6: Confirm NO stale `user` reaction-author field exists repo-wide; do NOT introduce a rename. (Verify only)

## Quality Checklist
- [ ] `SaveReactionsRequest` SH (Node) `reactionAnnotation` shape updated to include `from?: PartialUser`
- [ ] `saveReactions` example in node.mdx shows `from: { userId: 'u-1' }`
- [ ] `#### PartialReactionAnnotation` confirmed already correct (`from`), NOT duplicated or re-renamed
- [ ] No stale `user` reaction-author field introduced anywhere (it does not exist on main)
- [ ] `#reactions` anchor confirmed resolving to node.mdx `### Reactions`
- [ ] Breaking change kept in changelog only; NOT added to upgrade-guide.mdx
- [ ] api-methods.mdx, UI/wireframes/primitives, docs.json untouched
- [ ] Log file written to `.claude/logs/agent-2-planning-velt-node-1.0.5.md`
