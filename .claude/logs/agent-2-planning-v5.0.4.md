# Release Update Plan for v5.0.4

> Authoritative plan. Supersedes the stray `.claude/logs/agent-2-planning-5.0.4.md` (no `v`); ignore/overwrite that one.
> SDK: core Velt **frontend** — HTML/Vanilla `@veltdev/sdk` + React `@veltdev/react`. Types DO go in `data-models.mdx` (shared Web/React reference). Resolver usage docs live in `self-host-data/*.mdx`.

## Overview
- Release Type: **Patch** (5.0.4). All changes additive/backward-compatible.
- Key Changes: Resolver endpoint async headers + `credentials`; opt-in `additionalSaveEvents` (+ `CommentResolverSaveEvent` enum, `AdditionalSaveEventConfig`); `targetComment` on `SaveCommentResolverRequest`; `event`/`eventType` widening; stored `CommentAnnotationVisibilityConfig` gains `organizationIds` + author-self-token `userIds` invariant.
- Breaking Changes: **None.** No upgrade-guide.mdx entry. (Backward-compatible defaults are byte-identical.)
- Agent-1 changelog: already written at `release-notes/version-5/sdk-changelog.mdx` (lines ~18-24). Do not re-add; verify only.

## RESOLVED FACTS (verified against files — read before planning)

- **`eventType` at line 5441 belongs to `#### PartialRecorderAnnotationResult`** (heading line 5433), a RECORDER type — NOT `PartialCommentAnnotationResult`.
  - `#### PartialCommentAnnotationResult` **does NOT exist** in data-models.mdx (grep: no heading).
  - The only resolver-result `eventType: ResolverActions` row is the recorder one at 5441. The other two `eventType` rows (lines 3882, 3950) are unrelated `string`-typed sub-event fields.
  - **DECISION: do NOT widen line 5441.** Widening a recorder type to `CommentResolverSaveEvent` would be wrong. Since the comment-side result type is genuinely undocumented, **SKIP the eventType widening (item 4)** rather than fabricate a `PartialCommentAnnotationResult` section without evidence. See "Open discrepancy" below.
- `SaveCommentResolverRequest` (line 532) on this branch: `commentAnnotation`/`metadata`/`event: ResolverActions`/`commentId`. **Clean — no `targetComment`, no `| string`** (node-docs overlap not present here).
- `ResolverEndpointConfig` (line 5159): `url` + `headers: Record<string,string>` only. No `credentials`.
- `ResolverConfig` (line 5170): no `additionalSaveEvents`.
- `CommentAnnotationVisibilityConfig` (line 296, STORED/output): `type`/`organizationId`/`userIds`. No `organizationIds`.
- `CommentVisibilityConfig` (line 265, INPUT): `type`/`annotationId`/`organizationId`/`userIds`, **no `organizationIds`** — this is v5.0.3 scope; **DO NOT touch** (item 5 only edits the STORED type).
- `targetComment: Comment` rows at lines 5634 / 5825 are DIFFERENT (other event types) — do NOT touch.
- `VeltPermissionProvider.endpointConfig` (line 6490) is typed `ResolverEndpointConfig` → item 1's type change covers the permission resolver automatically (no separate edit).
- `PartialComment` (5047) and `PartialCommentAnnotation` (5074) already exist — referenced by `targetComment`, not modified.

## Areas Requiring Updates

### 1. Data Models — `api-reference/sdk/models/data-models.mdx`
SIX edits (NOT seven — eventType widening skipped, see Resolved Facts). All High priority; technical reference is canonical source of truth.

**1a. `ResolverEndpointConfig` (table at lines 5165-5168)** — item 1.
- Change `headers` Type cell from `Record<string, string>` to `Record<string, string> \| (() => Promise<Record<string, string>>)`; note in Description: static object OR async function resolved on every request (including every retry, so tokens stay fresh).
- ADD row: `credentials` / `'include' \| 'same-origin' \| 'omit'` / No / forwarded to `fetch()` for cookie/session auth on cross-origin endpoints; when unset the key is omitted (byte-identical to the browser default `'same-origin'`).

**1b. `ResolverConfig` (table at lines 5174-5185)** — item 2.
- ADD row: `additionalSaveEvents` / `AdditionalSaveEventConfig[]` / No / opt-in; delivers non-core annotation-level lifecycle events to the same save endpoint as the 4 core PII events. Absent/empty ⇒ no extra events. Link `AdditionalSaveEventConfig` to its new anchor.

**1c. `SaveCommentResolverRequest` (table at lines 536-541)** — item 3 (+ NOT item 4).
- ADD row (after `commentId`): `targetComment` / `PartialComment` / No / the comment the action occurred on, resolved from `commentId` against `commentAnnotation[*].comments`. Omitted when `commentId` absent or unmatched. Convenience alias for data already in the payload (no new egress).
- WIDEN `event` Type cell: `ResolverActions` → `ResolverActions \| CommentResolverSaveEvent`. **Frontend canonical form — NO `\| string`** (see cross-branch flag).

**1d. NEW `#### CommentResolverSaveEvent` enum** — item 2. INSERT immediately AFTER `#### ResolverActions` table (after line 4951, before `#### UserResolverModuleName` at 4953). 14 members, EXACT name=value (verify count = 14):
| Name | Value |
| `STATUS_CHANGE` | `comment_annotation.status_change` |
| `PRIORITY_CHANGE` | `comment_annotation.priority_change` |
| `ASSIGN` | `comment_annotation.assign` |
| `ACCESS_MODE_CHANGE` | `comment_annotation.access_mode_change` |
| `CUSTOM_LIST_CHANGE` | `comment_annotation.custom_list_change` |
| `APPROVE` | `comment_annotation.approve` |
| `ACCEPT` | `comment.accept` |
| `REJECT` | `comment.reject` |
| `SUGGESTION_ACCEPT` | `comment_annotation.suggestion_accept` |
| `SUGGESTION_REJECT` | `comment_annotation.suggestion_reject` |
| `REACTION_ADD` | `comment.reaction_add` |
| `REACTION_DELETE` | `comment.reaction_delete` |
| `SUBSCRIBE` | `comment_annotation.subscribe` |
| `UNSUBSCRIBE` | `comment_annotation.unsubscribe` |
- CRITICAL distinctness note in the description: `CommentResolverSaveEvent.REACTION_ADD` = `comment.reaction_add` is DISTINCT from `ResolverActions.REACTION_ADD` = `reaction.add`. Preserve both; do not collapse.

**1e. NEW `#### AdditionalSaveEventConfig`** — item 2. INSERT right after the new `CommentResolverSaveEvent` enum.
- One-row table: `event` / `CommentResolverSaveEvent` / Yes / the annotation-level lifecycle event to additionally deliver to the save endpoint.

**1f. `CommentAnnotationVisibilityConfig` (table at lines 302-306)** — item 5. STORED type only.
- ADD row (after `organizationId`): `organizationIds` / `string[]` / No / display-only mirror of `CommentVisibilityConfig.organizationIds`. Word it so it reads correctly even before v5.0.3 merges (see DEPENDENCY flag) — describe as the stored mirror of the input's `organizationIds` without asserting the input field's current presence/version.
- TIGHTEN `userIds` Description: display-only mirror of self tokens in `context.accessFields`; for non-public comments (`organizationPrivate`, `restricted`) it ALWAYS includes the author's `userId` (author self-token invariant, deduped). Public comments carry no `userIds`.

- eventType widening (item 4): **SKIPPED** — no `PartialCommentAnnotationResult` exists; line 5441 is the recorder type. Do not edit.

### 2. Documentation (resolver usage) — `self-host-data/comments.mdx`
Priority: High. This is the canonical frontend resolver page for items 1-3.

**2a. Async headers + `credentials` (item 1).** Canonical placement here. Add ONE `<Note>` + augmented example near `### getConfig`/`### saveConfig`/`### deleteConfig` (lines 53-186) or the `### Endpoint based Complete Example` (line 188). Show:
  - `headers` as `async () => { ... return { Authorization: 'Bearer ' + token }; }` (re-resolved every request incl. retries).
  - `credentials: 'include'` for cross-origin cookie/session auth; note default behavior when omitted.
  - Keep `<Tabs>` order: `React / Next.js` first, `Other Frameworks` second.

**2b. `additionalSaveEvents` (item 2).** Add to the `config` example (Complete Example, line ~188-253) AND describe behavior in the `### save` resolver section (line 372). Cover the nuances exactly:
  - opt-in; delivered to the SAME save endpoint as the 4 core events.
  - Additional events **bypass the `isCommentsDataChanged` dedup gate** (sent even when no PII changed).
  - Same stripped `PartialCommentAnnotation` payload (no new egress).
  - Annotation-level events **OMIT `commentId` and `targetComment`**; reaction events (`comment.reaction_add` / `comment.reaction_delete`) **INCLUDE `commentId` and `targetComment`** (reaction is on a specific comment).
  - Core 4 = `COMMENT_ANNOTATION_ADD`, `COMMENT_ADD`, `COMMENT_UPDATE`, `COMMENT_DELETE`.

**2c. `targetComment` on `SaveCommentResolverRequest` (item 3).** Update the `### save` section (lines 372-380). The note at line 375 currently mentions only "the event name" + links `ResolverActions`. Extend to mention `targetComment` (resolved from `commentId`) and widen the event-name link/text to include `CommentResolverSaveEvent`.
  - DO NOT conflate with the EXISTING `targetComment` in the webhook/email section (lines 719-759) — that is a webhook payload field, a different context. Leave that block unchanged.

### 3. Sibling resolver pages — async headers/`credentials` scope
Priority: Medium. **RECOMMENDATION: LIGHT TOUCH.** The shared `ResolverEndpointConfig` type in data-models.mdx is the single source of truth; full duplication on every page bloats the docs.
- **Canonical, full treatment:** `self-host-data/comments.mdx` only (item 2a above).
- **Short note + link only** (one `<Note>` linking to `#resolverendpointconfig` and the comments.mdx async-headers example) on the pages that show endpoint configs:
  - `self-host-data/attachments.mdx` (`## Endpoint based DataProvider`, line 55)
  - `self-host-data/recordings.mdx` (line 55)
  - `self-host-data/reactions.mdx` (line 59)
  - `self-host-data/notifications.mdx` (line 57)
  - `self-host-data/users.mdx` (line 37)
  - `self-host-data/activity.mdx` (if it exposes endpoint configs — verify; add note only if `ResolverEndpointConfig` is referenced)
- **No edit needed:** `VeltPermissionProvider.endpointConfig` (data-models.mdx line 6490) already points at `ResolverEndpointConfig`; the type change in item 1a covers it. Optionally add a one-line note there only if desired — not required.
- `additionalSaveEvents` / `targetComment` are comment-only → siblings get NOTHING for items 2 and 3.

### 4. UI Customization — N/A
- 4a. Wireframes (Agent-4): **N/A** — no UI components in this release.
- 4b. Primitives (Agent-5): **N/A** — no new primitives or props.

### 5. Upgrade Guide — N/A
- No breaking changes. Do NOT create/edit `release-notes/version-5/upgrade-guide.mdx`.

## CROSS-BRANCH FLAGS (orchestrator: read these)

- **OVERLAP — `velt-node-docs-v1.0.7` (exists locally).** That branch ALREADY modified shared `#### SaveCommentResolverRequest` (added `targetComment`, widened `event` to include `\| string`) and ADDED `#### CommentResolverSaveEvent` in data-models.mdx. This `v5.0.4` branch (off main, where those are absent — verified) must document them with the **FRONTEND canonical form**: `event: ResolverActions \| CommentResolverSaveEvent` with **NO `\| string`**. **Merge-conflict risk** on `SaveCommentResolverRequest` and `CommentResolverSaveEvent`. Frontend definition is canonical; on conflict, drop the node branch's `\| string`.

- **DEPENDENCY — item 5 references `CommentVisibilityConfig.organizationIds`**, which lives on the unmerged `v5.0.3` branch, not this branch/main (verified: input type at line 265 has no `organizationIds` here). Word the STORED `organizationIds` description so it reads correctly BEFORE v5.0.3 merges — describe it as the stored display mirror of the input's `organizationIds` field without asserting that field's current presence/version on this branch.

## Open discrepancy for Agent-6/7 (resolve, do not silently propagate)
- Agent-1's changelog (`sdk-changelog.mdx` line 24) and the release note name **`PartialCommentAnnotationResult`** as carrying the widened `eventType`. **That type does not exist in data-models.mdx.** Options for Agent-6/7: (a) keep the changelog's prose as-is but ensure NO data-models edit fabricates the type; or (b) if engineering confirms the type should be documented, add it WITH evidence and then widen its `eventType`. Default: **leave line 5441 (`PartialRecorderAnnotationResult`) untouched**; flag the changelog wording for verification. Do NOT widen the recorder type.

## Implementation Sequence
1. (Agent-3) data-models.mdx edits 1a-1f — six edits; enum + `AdditionalSaveEventConfig` inserted after `ResolverActions`. Low-medium effort.
2. (Agent-3 or docs author) comments.mdx items 2a-2c — async headers/credentials, additionalSaveEvents nuances, targetComment on save. Medium effort.
3. Sibling short notes (light touch) on the 5-6 endpoint pages listed in §3. Low effort.
4. (Agent-6) Verify changelog vs data-models for the PartialCommentAnnotationResult discrepancy; align terminology repo-wide.
5. (Agent-7) QA counts + exact terminology.

## Quality Checklist
- [ ] `ResolverEndpointConfig`: `headers` union + `credentials` row added (1a)
- [ ] `ResolverConfig`: `additionalSaveEvents` row added (1b)
- [ ] `SaveCommentResolverRequest`: `targetComment` row + `event` widened to `ResolverActions \| CommentResolverSaveEvent` (NO `\| string`) (1c)
- [ ] New `CommentResolverSaveEvent` enum with **exactly 14** members, exact name=value, placed after `ResolverActions` (1d)
- [ ] `REACTION_ADD` distinctness note present (`comment.reaction_add` ≠ `reaction.add`)
- [ ] New `AdditionalSaveEventConfig` type added (1e)
- [ ] `CommentAnnotationVisibilityConfig`: `organizationIds` row + tightened `userIds` description (STORED type only; input type 265 untouched) (1f)
- [ ] eventType widening SKIPPED; recorder type at line 5441 untouched
- [ ] comments.mdx: async headers + credentials documented (1), `<Tabs>` React-first
- [ ] comments.mdx: additionalSaveEvents nuances (dedup bypass; annotation omits commentId/targetComment vs reaction includes) documented (2)
- [ ] comments.mdx: targetComment on `### save` documented; webhook targetComment block (719-759) untouched (3)
- [ ] Sibling pages: light-touch note only (no full duplication); permission endpointConfig auto-covered
- [ ] Agent-4 / Agent-5: confirmed N/A
- [ ] No upgrade-guide.mdx edit; no breaking-change entry in changelog
- [ ] Cross-branch flags (node-docs overlap; v5.0.3 dependency) surfaced
- [ ] Terminology exact: `additionalSaveEvents`, `AdditionalSaveEventConfig`, `CommentResolverSaveEvent`, `targetComment`, `ResolverEndpointConfig`, `credentials`, `organizationIds`
- [ ] Counts verified: 14 enum members; 6 data-models edits (not 7); the 5 fixed write-paths named in bug-fix bullet
- [ ] Log written to `.claude/logs/agent-2-planning-v5.0.4.md`

## Counts to verify (Agent-7)
- `CommentResolverSaveEvent`: **14** members.
- data-models.mdx type edits: **6** (1a ResolverEndpointConfig, 1b ResolverConfig, 1c SaveCommentResolverRequest, 1d new CommentResolverSaveEvent, 1e new AdditionalSaveEventConfig, 1f CommentAnnotationVisibilityConfig). NOT 7 — eventType widening removed (no owning type).
- Bug-fix item 6 names **5** fixed write-paths: addComment private mode; saveComment V2 dialog regular path; updateVisibility; addCommentAnnotation; V2 composer inline/temp path. Shared `buildStoredVisibilityConfig(visibility, authorUserId)`. Doc impact = item 1f only; no separate page beyond the changelog note.
