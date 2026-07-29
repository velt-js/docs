## QA Summary for v6.0.0-beta.1 (Modular SDK, frontend)

### Counts: preload 19/19 | accessors 16 expected (12 documented) | tag-only 3 | featureAllowList row 1 | LazyXElement public 0

### Per-check results (evidence)

1. **PASS** — Exactly 19 `#### preload*()` entries in api-methods.mdx (L3693–3805). Heading names diff against the required list = exact match, in the specified order.
2. **PASS** — `Features` enum: `CRDT='crdt'` row present (L4600); `LIVE_SELECTION='selection'` (L4608, NOT `'liveSelection'`); `LIVE_STATE_SYNC='liveStateSync'` unchanged (L4603). The only `liveSelection` in the diff is the removal (`-` line); zero occurrences remain in any changed/new file.
3. **PASS** — Unrelated `'crdt'` on `ActivityFeatureType` (data-models L3849) is untouched and NOT in the diff. Only new `'crdt'` is the `Features.CRDT` row.
4. **PASS** — `Config.featureAllowList` is a single row (count=1); description rewritten for modular behavior (set ⇒ only listed chunks preloaded; omit/default `undefined` ⇒ all preloaded in background; `preload*()`/`getXElement()` on an omitted feature auto-enables it).
5. **PASS** — `LazyXElement`/`LazyCommentElement` documented as public type: 0 in api-methods.mdx, 0 in data-models.mdx. Mentioned only as internal facade classes in changelog L30.
6. **PASS** — 19 chunks = 19 preload methods. Tag-only `userInvite`/`userRequest`/`videoPlayer` consistently described as having "no element accessor" in changelog (L20), upgrade-guide (L39), and api-methods intro (L3683). No `get{UserInvite,UserRequest,VideoPlayer}Element` accessor exists (no contradiction).
7. **PASS** — docs.json valid JSON (`python3 -m json.tool` ok). "Version 6.0.0" group is the immediate sibling above "Version 5.0.0" (idx 0 vs 1). Lists `release-notes/version-6/upgrade-guide` + `release-notes/version-6/sdk-changelog`; both files exist on disk.
8. **PASS** — `<Update label="6.0.0-beta.1" description="June 22, 2026">`. 8 separate bullets (New Features 2 / Improvements 4 / Bug Fixes 2); no merged items. Opens with the fully-backward-compatible note. No "Breaking Changes" section in changelog. All 3 distinct `[Learn more →]` targets resolve to real pages.
9. **PASS** — upgrade-guide has `## Overview` / `## Breaking Changes` (states "None — fully backward compatible") / `## How to Upgrade`. Covers featureAllowList, preload*(), and getXElement auto-extension (`ensureFeatureEnabled`). React tabs use `client.*`, Other Frameworks use `Velt.*` (correct per-context convention).
10. **PASS** — Case-exact: `featureAllowList`, `preload<Feature>`, `getCrdtElement` (api-methods L3308), `Features.CRDT`, `ensureFeatureEnabled` all correct. Chunk filenames `velt-comment.js`…`velt-live-state-sync.js` all correct (19 unique). Zero drift variants (`featureAllowlist`, `getCRDTElement`, `Features.Crdt`, etc. = 0).
11. **PASS** — `git status --short` shows ONLY the 5 expected paths + untracked logs. No Node/Python/velt-node/velt-py/version-5/wireframe/primitive edits.

### git status --short (final)
```
 M api-reference/sdk/api/api-methods.mdx
 M api-reference/sdk/models/data-models.mdx
 M docs.json
?? .claude/logs/agent-2-planning-v6.0.0-beta.1.md
?? release-notes/version-6/
```
`git diff --name-only`: api-methods.mdx, data-models.mdx, docs.json

### Fix applied (1)
1. **release-notes/version-6/sdk-changelog.mdx L28** — Changelog cited a non-existent `NotificationSource` enum when reassuring readers the unrelated `'crdt'` value is unchanged. `grep` confirmed `NotificationSource` exists nowhere in the repo; the unrelated `'crdt'` actually lives on `ActivityFeatureType` (data-models L3829/L3849, which the bullet links to).
   - Fix: `NotificationSource` → `ActivityFeatureType`. Makes the prose verifiable against the linked page.

### Re-flagged pre-existing gaps (NOT auto-resolved per instructions)
- **7 un-backfilled `Features` enum keys** — enum has 13 rows but 19 chunk features exist. Missing keys: `notification`, `reaction`, `activity`, `views`, `userInvite`, `userRequest`, `videoPlayer`. Pre-existing; out of this release's scope.
- **6 undocumented `getXElement()` accessors** — of 16 expected accessors (19 chunks − 3 tag-only), 6 are undocumented: `getAreaElement`, `getHuddleElement`, `getNotificationElement`, `getReactionElement`, `getTagElement`, `getViewsElement`. (12 accessors documented, incl. unrelated `contact`/`suggestion`.) Pre-existing.

### Issues found: 1
