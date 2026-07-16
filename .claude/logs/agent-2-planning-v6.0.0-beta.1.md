# Release Update Plan for v6.0.0-beta.1

## Overview
- Release Type: Major (modular SDK; lazy feature chunks)
- Key Changes: New `featureAllowList` modular semantics; 19 `preload*()` facade methods; 16 `getXElement()` accessors now return non-blocking lazy facades; new `Features.CRDT='crdt'` enum value; Transcription folded into recorder chunk; 2 bug fixes.
- Breaking Changes: No hard API break — existing code compiles/runs as-is (lazy facades cast to public element types; `featureAllowList` default = preload all = pre-modular behavior). Behavior change only. Upgrade-guide narrative already authored by Agent-1.
- Scope: Pure SDK infrastructure. No new UI components, primitives, or wireframes.

## Areas Requiring Updates

### 1. Data Models — `api-reference/sdk/models/data-models.mdx`
File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`

- UPDATE `#### Config` → `featureAllowList` row (line 4584). Do NOT add a duplicate row. Rewrite description to cover modular behavior: default `undefined` ⇒ preloads ALL lazy chunks (pre-modular behavior); passing it preloads ONLY the listed feature chunks (others deferred until `preloadX()`/`getXElement()`); allow-list auto-extends when an omitted feature's accessor/preload is called.
- ADD to `#### Features` enum (table at lines 4594–4607): one new row `CRDT | 'crdt' | No | CRDT feature (lazy chunk velt-crdt.js)` in correct alphabetical position (between `AUDIO_HUDDLE` and `COMMENT`, i.e. after `COMMENT`? — alphabetical by Property: CRDT sorts before COMMENT? No: "CRDT" < "COMMENT"? compare char 2: R vs O → O<R, so COMMENT precedes CRDT). Insert CRDT AFTER `COMMENT`, before `CURSOR`. Priority: High.
- FeatureType/Features decision: `FeatureType` has NO standalone `####` heading in data-models.mdx (only referenced by the `featureAllowList` row and `disableFeatures()` params). `#### Features` enum IS the canonical doc for these keys. Recommendation: document `CRDT` in `#### Features`; do NOT create a new `#### FeatureType` heading.
- LazyXElement classes: DO NOT document (internal — "no change to your code"; consumers use public element types behind a cast). Confirmed stance.
- Priority: High.

### 2. API Methods — `api-reference/sdk/api/api-methods.mdx`
File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`

Structure found (relevant regions):
- `# Core` → `### Client` (line 3046): `initConfig()` 3047, `getVeltInitState()` 3054, `get Velt Client` 3060.
- `### Feature Utilities` (line 3583): getXElement accessors — getPresenceElement 3584, getCursorElement 3591, getCommentElement 3598, getSelectionElement 3605, getRecorderElement 3612, getRewriterElement 3626, getLiveStateSyncElement 3633, getArrowElement 3640. (getContactElement, getSuggestionElement also here.)
- getCrdtElement 3308 (under CRDT `### Element Access`); getActivityElement 1857 (under Activity `### Element Access`). Accessors are NOT all colocated.
- `### Feature Gating` (line 3655): isUserAllowed$ 3656, disableFeatures 3663 (`features: Array<FeatureType>`), isPlanExpired$ 3670.
- Method entry format: `#### name()` + 1-line description + `- Params:` + `- Returns:` + `- React Hook:` (+ optional `- [Full Documentation →]`).

Changes:
- ADD a new subsection `### Modular SDK / Chunk Preloading` immediately AFTER `### Feature Gating` (insert after line 3675, before `### Localization` at 3678). Rationale: feature-gating semantics live here (disableFeatures/featureAllowList); keeps modular material in one discoverable block. Contents:
  - Intro note: featureAllowList modular behavior (default undefined ⇒ preload all chunks; passing it preloads only listed chunks; inert-tag/auto-upgrade — tags placed before chunk loads render as inert HTMLUnknownElement and silently no-op until the chunk lands then custom-elements lifecycle upgrades them in place; allow-list AUTO-EXTENSION via ensureFeatureEnabled when an omitted feature's accessor/preload is called; tag-only features note: userInvite/userRequest/videoPlayer have no getXElement accessor → must use featureAllowList or preloadX()). Link featureAllowList to `/api-reference/sdk/models/data-models#config`.
  - The 19 `preload*()` entries, each: `#### preload<Feature>()` + "Loads the <feature> lazy chunk and registers its custom elements on demand." + `- Params: void` + `- Returns: Promise<void>` + `- React Hook: n/a`. Note idempotent + non-throwing (logs on failure, resolves) once in the intro, not per-entry, to avoid 19× repetition. The 19: preloadComment, preloadCursor, preloadPresence, preloadHuddle, preloadRecorder, preloadNotification, preloadReaction, preloadArrow, preloadTag, preloadRewriter, preloadSelection, preloadArea, preloadActivity, preloadViews, preloadUserInvite, preloadUserRequest, preloadVideoPlayer, preloadCrdt, preloadLiveStateSync.
  - Priority: High.
- ADD lazy-facade behavior note to the `### Feature Utilities` accessor section (short addition, NOT a per-accessor rewrite — return types/method surfaces UNCHANGED). Place one explanatory note at the top of `### Feature Utilities` (after line 3583): getXElement() now returns a non-blocking lazy facade (cast to the real element type, so existing code is unaffected); void methods are queued and flushed once the chunk resolves; promise methods await chunk-load then delegate with original args; observable/on(...) methods return a per-call ReplaySubject(1)-backed proxy stream that bridges once the chunk loads; each accessor also calls ensureFeatureEnabled(...). Recommendation: short subsection note, not a new top-level section.
  - Priority: Medium.
- DO NOT add new `####` headings for getViewsElement/getNotificationElement/getReactionElement/getTagElement/getHuddleElement/getAreaElement — they are named in the release note's accessor list but have no existing entries. FLAG for orchestrator: confirm whether these accessors should be newly documented or are intentionally undocumented (see Open Questions). Do not fabricate.

### 3. Documentation (new feature docs)
- No new standalone feature doc page required. Modular/preload is an SDK-infrastructure concern documented in api-methods.mdx + data-models.mdx + the existing upgrade-guide. Priority: N/A.

### 4a. UI Customization — Wireframes
- N/A. No new wireframes. (Pure SDK infrastructure.)

### 4b. UI Customization — Primitives
- N/A. No new primitive components or props. (Pure SDK infrastructure.)

### 5. Upgrade Guide — `release-notes/version-6/upgrade-guide.mdx`
File: `/Users/yoenzhang/Downloads/docs/release-notes/version-6/upgrade-guide.mdx`
- Authored by Agent-1. No new breaking-change content from this planning pass (no hard break; default behavior is backward-compatible). If Agent-1's narrative needs the featureAllowList opt-in modular semantics, that already belongs here — NOT in the changelog. Priority: Low (verify only).

### Bug fixes (items 7, 8)
- Item 7 (video player ensures recorder chunk load to upgrade subtitle/transcription embeds): changelog-only. No reference-doc edit.
- Item 8 (`<velt-reaction-pin>` per-annotationId subscription so active-state highlight appears reliably): changelog-only. No reference-doc edit.
- Recommendation: behavior fixes, no API surface change → no data-models/api-methods edits.

## Implementation Sequence
1. data-models.mdx: update `featureAllowList` description; add `Features.CRDT` row (after COMMENT). Effort: Low.
2. api-methods.mdx: add `### Modular SDK / Chunk Preloading` section with intro + 19 preload entries. Effort: Medium.
3. api-methods.mdx: add lazy-facade behavior note atop `### Feature Utilities`. Effort: Low.
4. Verify upgrade-guide already carries modular opt-in narrative; no changelog breaking-change leakage. Effort: Low.

## Counts to verify downstream (Agent-6/7)
- 19 lazy chunks = 19 preload methods. CONSISTENT (preload list = 19; chunk list = 19).
- 16 getXElement accessors (3 tag-only features have none). CONSISTENT (19 features − 3 tag-only = 16).
- 3 tag-only features: userInvite, userRequest, videoPlayer. CONSISTENT.
- 1 new enum value: `Features.CRDT='crdt'`. CONSISTENT (only explicit new enum value).

## Terminology to keep EXACT (Agent-6/7)
`featureAllowList`, `preloadComment`…`preloadLiveStateSync` (19), `getCrdtElement`, `Features.CRDT`, `ensureFeatureEnabled`, `LazyXElement` (internal — do not surface), chunk filenames `velt-comment.js`/`velt-recorder.js`/`velt-crdt.js`/etc.

## Open Questions for Orchestrator (do NOT auto-resolve)
- DISCREPANCY: release note's featureAllowList key for Live Selection is `selection` (velt-selection.js), but `#### Features` enum documents `LIVE_SELECTION='liveSelection'`. Do not mass-rename. Confirm canonical key with user.
- Missing-key audit vs `#### Features` enum. Enum currently contains (12): AREA, ARROW, AUDIO_HUDDLE, COMMENT, CURSOR, HUDDLE, LIVE_STATE_SYNC, PRESENCE, TAG, RECORDER, REWRITER, LIVE_SELECTION. Release-note keys NOT present in enum: `crdt` (adding), `notification`, `reaction`, `activity`, `views`, `userInvite`, `userRequest`, `videoPlayer`. Only `CRDT` is the explicit new enum value in the release note → add ONLY CRDT now; flag the others for the user to confirm before adding (release note's simplified key column ≠ enum naming).
- getViewsElement/getNotificationElement/getReactionElement/getTagElement/getHuddleElement/getAreaElement named in accessor list but undocumented today — confirm whether to add entries.

## Quality Checklist
- [x] New type/enum value flagged for data-models.mdx (Features.CRDT)
- [x] All 19 new preload APIs scoped for api-methods.mdx (grouped section + format)
- [x] featureAllowList description update planned (no duplicate row)
- [x] Lazy-facade note planned for Feature Utilities (no per-accessor rewrite)
- [x] LazyXElement confirmed internal — not documented
- [x] Wireframes (Agent-4) and Primitives (Agent-5) confirmed N/A
- [x] Bug fixes (7, 8) = changelog-only
- [x] Breaking changes → upgrade-guide ONLY, never changelog
- [x] selection/liveSelection discrepancy + missing-key audit flagged, not auto-resolved
- [x] Counts confirmed internally consistent (19/16/3/1)
- [x] Log written to `.claude/logs/agent-2-planning-v6.0.0-beta.1.md`
