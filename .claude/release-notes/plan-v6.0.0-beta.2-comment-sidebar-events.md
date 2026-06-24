# Release Update Plan for v6.0.0-beta.2

## Overview
- **Release Type:** Major prerelease (v6.0.0-beta.2), frontend Comments SDK (HTML/Vanilla #4418 + React #2037).
- **Key Changes:** V2 comment sidebar open/close/comment-click/nav-click events moved from `@Output()`/React props to the `commentElement.on()` bus (React: `useCommentEventCallback`). Removed V2 sidebar inputs `sortData`/`sort-data` and `enableUrlNavigation`/`enable-url-navigation`. 4 new event keys + 4 new payload interfaces. Filter-count + dropdown CSS improvements. 4 bug fixes (no API change).
- **Breaking Changes:** YES — 3 breaking changes (events bus migration + removed props; `sortData` removal; `enableUrlNavigation` removal).
- **Branch:** `v6.0.0-beta.2` (off `main`). No `version-6/upgrade-guide.mdx` and no version-6 nav exist yet on this branch — must be created.

### Canonical terms (for Agents 6/7 — exact strings)
- New event keys: `sidebarOpen`, `sidebarClose`, `commentClick`, `commentNavigationButtonClick`.
- New payload interfaces: `SidebarOpenEvent`, `SidebarCloseEvent`, `CommentClickEvent`, `CommentNavigationButtonClickEvent` (latter `extends CommentClickEvent {}`).
- New constant entries: `CommentEventTypes.SIDEBAR_OPEN`, `.SIDEBAR_CLOSE`, `.COMMENT_CLICK`, `.COMMENT_NAVIGATION_BUTTON_CLICK`.
- Canonical replacements: `sortData` → `sortBy` + `sortOrder`; `enableUrlNavigation`/`enable-url-navigation` → `urlNavigation`/`url-navigation`.
- REMOVED props (V2 sidebar ONLY): `onSidebarOpen`, `openSidebar`, `onSidebarClose`, `onCommentClick`, `onSidebarCommentClick`, `sidebarCommentClick`, `onCommentNavigationButtonClick`, `sortData`, `enableUrlNavigation`.
- RETAINED prop: `onFullscreenClick` stays an `@Output()` callback on the V2 sidebar.

### Scope guard (do NOT touch — these `onCommentClick` uses are V1 / other components)
- `async-collaboration/comments-sidebar/v1/customize-behavior.mdx` (V1 sidebar).
- `api-reference/sdk/api/api-methods.mdx#onCommentClick` (V1 sidebar method → links to v1 page).
- `async-collaboration/comments/setup/video-player-setup/custom-video-player-setup.mdx`, `.../lottie-player-setup.mdx`, `.../standalone-components/comment-thread/customize-behavior.mdx` (VeltCommentsSidebar V1 / timeline / comment-thread).
- `ui-customization/.../comment-sidebar-wireframe-variables.mdx#sortData` — generic wireframe template var (`sort-data` velt-data), NOT the V2 component input. Leave as-is.
- `release-notes/3-0-0.mdx`, `release-notes/archive/*` — historical, never edit.
- All reaction-tool-wireframe / `reactionId` doc refs — bug fix is internal rendering; no doc change (see §E).

---

## Areas Requiring Updates

### 1. Data Models — `api-reference/sdk/models/data-models.mdx`
**Priority: High.** Per project convention these are React/SDK types → belong here.

**1a. Add 4 payload interfaces** in the comment events area (mirror `CommentBubbleClickedEvent` at line 118; use existing `VeltEventMetadata`, `CommentAnnotation`, `Location` anchors). Place near other UI/sidebar comment events (e.g. after `CommentBubbleClickedEvent` / near `CommentSidebarDataInitEvent` ~line 2477):
- `#### SidebarOpenEvent` — `metadata?: VeltEventMetadata` (No).
- `#### SidebarCloseEvent` — `metadata?: VeltEventMetadata` (No).
- `#### CommentClickEvent` — `documentId?: string | null` (No), `location?: Location | null` (No), `targetElementId?: string | null` (No), `context?: { [key: string]: any }` (No), `annotation?: CommentAnnotation` (No), `metadata?: VeltEventMetadata` (No).
- `#### CommentNavigationButtonClickEvent` — note "Extends `CommentClickEvent` with no additional fields."

**1b. `CommentEventTypesMap` / `CommentEventTypes` / `CommentEventType`** — these are NOT defined as sections today (only referenced at api-methods.mdx:748). Add the 4 keys. If a `CommentEventTypesMap` section is created, mirror the `SuggestionEventTypesMap` block style (lines 7912-7956): map `sidebarOpen→SidebarOpenEvent`, `sidebarClose→SidebarCloseEvent`, `commentClick→CommentClickEvent`, `commentNavigationButtonClick→CommentNavigationButtonClickEvent`; add the 4 `CommentEventTypes` constants (`SIDEBAR_OPEN`/`SIDEBAR_CLOSE`/`COMMENT_CLICK`/`COMMENT_NAVIGATION_BUTTON_CLICK`). FLAG: a full `CommentEventTypesMap` constant block does not currently exist; if Agent-3 cannot find one, only add the 4 interfaces + reference them from the customize-behavior event table (§3) and do NOT fabricate an incomplete map. See "Flags".

**1c. `VeltCommentsSidebarV2Props` table (lines 3006-3068)** — REMOVE these rows: `onSidebarOpen` (3020), `onSidebarClose` (3021), `onCommentClick` (3022), `onCommentNavigationButtonClick` (3023), `sortData` (3038), `enableUrlNavigation` (3063), `openSidebar` (3066), `sidebarCommentClick` (3067), `onSidebarCommentClick` (3068). KEEP `onFullscreenClick` (3065), `urlNavigation` (3062), `sortBy` (3036), `sortOrder` (3037).

### 2. API Methods — `api-reference/sdk/api/api-methods.mdx`
**Priority: High.**
- Under `### Event Subscription` → `#### on()` (line 745): events are enumerated by link to customize-behavior, so no per-event method entries are strictly required. Verify the `on()` entry's "list of events" link still resolves; no signature change.
- Do NOT remove `#### onCommentClick()` (line 1589) or `#### enableSidebarUrlNavigation()` (1596) — these are V1 sidebar methods (link to `comments-sidebar/v1/`).
- Optional (Low): if Agent-3 created a `CommentEventTypesMap` section in data-models, ensure the `on()` Returns link still points there.

### 3. Documentation — Comment event tables — `async-collaboration/comments/customize-behavior.mdx`
**Priority: High.** Add the 4 new events to the `# Event Subscription` table (the `| Category | Event Type | Description | Event Object |` table starting line 3552). Append 4 rows under the existing `Comment Sidebar` category (rows 3581-3582):
- `Comment Sidebar | sidebarOpen | Triggered when the comment sidebar opens | SidebarOpenEvent`
- `Comment Sidebar | sidebarClose | Triggered when the comment sidebar closes | SidebarCloseEvent`
- `Comment Sidebar | commentClick | Triggered when a comment is clicked in the sidebar list | CommentClickEvent`
- `Comment Sidebar | commentNavigationButtonClick | Triggered when the navigation ("go to") button on a sidebar comment is clicked | CommentNavigationButtonClickEvent`
- Use anchor links `/api-reference/sdk/models/data-models#sidebaropenevent` etc.

### 4. Sidebar V2 behavior page — `async-collaboration/comments-sidebar/v2/customize-behavior.mdx`
**Priority: High.** This file OWNS the prose docs for the removed inputs/events. Changes:
- **`#### sortData` block (lines 490-504):** REMOVE entirely. (Canonical `sortBy`/`sortOrder` already documented above it, lines 456-488.)
- **`#### onCommentClick` block (lines 530-556):** REWRITE to use the `commentClick` event via `commentElement.on('commentClick')` / `useCommentEventCallback('commentClick')`. Keep the navigation use-case prose; payload now `CommentClickEvent` (`.location`, `.annotation`).
- **`#### onCommentNavigationButtonClick` block (lines 558-581):** REWRITE to `commentNavigationButtonClick` event via `on()` / `useCommentEventCallback`.
- **`<Note>` re `enableUrlNavigation` (lines 609-611):** REMOVE the note (alias is gone); keep `#### urlNavigation` block (583-607) intact.
- **`# Events` → `#### onSidebarOpen` (1136-1151) and `#### onSidebarClose` (1153-1168):** REWRITE both to `sidebarOpen` / `sidebarClose` events via `commentElement.on(...)` / `useCommentEventCallback(...)`. Use the migration code from the release note (React `useEffect` + HTML `.on().subscribe()`).
- KEEP `onFullscreenClick` usage in `#### fullScreen` (873, 887) — unchanged.
- Maintain `<Tabs>` order: `React / Next.js` first, `Other Frameworks` second.
- **Owner: Agent-4** (behavior page, event migration).

### 4a. UI Customization — Wireframes (Sidebar V2)
**Priority: Low — NO removed-prop edits needed.**
- `ui-customization/features/async/comments/comment-sidebar-structure-v2.mdx` — pure component tree, no props. NO CHANGE.
- `ui-customization/.../comment-sidebar/comment-sidebar-v2-wireframes.mdx` — verified clean (no removed prop strings). NO CHANGE.
- **Owner: Agent-4** — verify only; report no-op.

### 4b. UI Customization — Primitives (Sidebar V2) — `ui-customization/features/async/comments/comment-sidebar/comment-sidebar-v2-primitives.mdx`
**Priority: High.** The `VeltCommentsSidebarV2` root-primitive doc carries the removed props in 3 places:
- **Pattern 1 (lines 38-49):** remove `onSidebarOpen`/`onSidebarClose`/`onCommentClick`/`onCommentNavigationButtonClick` from the React example.
- **`### VeltCommentsSidebarV2` example (lines 131-144):** remove the same 4 props from the React example.
- **Props table (lines 160-163):** remove the 4 callback rows `onSidebarOpen`/`onSidebarClose`/`onCommentClick`/`onCommentNavigationButtonClick`.
- HTML examples (52-62, 166-176) already omit them — leave as-is.
- Optionally add a one-line cross-link/note that sidebar open/close/click events now use `commentElement.on()` (link to comments customize-behavior event table). Keep concise.
- **Owner: Agent-5** (primitives prop tables).
- NOTE: primitives/component props live ONLY here, never in wireframe pages.

### 5. Upgrade Guide — CREATE `release-notes/version-6/upgrade-guide.mdx`
**Priority: High.** Does NOT exist on this branch. Create beta.2-specific guide (do NOT copy beta.1 modular-SDK / Approval Engine content). Mirror beta.1 structure: frontmatter (`title: Upgrade Guide`, beta.2 description) → `## Overview` → `## Breaking Changes` → `## How to Upgrade` with `<Tabs>` (React/Next.js first, Other Frameworks second). Document the 3 breaking changes with before/after:
1. **V2 sidebar events → `on()` bus.** List removed props (`onSidebarOpen`, `openSidebar`, `onSidebarClose`, `onCommentClick`, `onSidebarCommentClick`, `onCommentNavigationButtonClick`). Before/after from release note lines 23-56 (React `useCommentEventCallback` + HTML `commentElement.on(...).subscribe`). State `onFullscreenClick` is unaffected.
2. **`sortData`/`sort-data` removed → `sortBy`/`sortOrder`.** Before/after from release note lines 60-66.
3. **`enableUrlNavigation`/`enable-url-navigation` removed → `urlNavigation`/`url-navigation`.** Before/after from release note lines 70-75.
- Breaking changes belong ONLY here — NOT in the changelog.
- **Owner: Agent-3.**

### 6. Navigation — `docs.json`
**Priority: High.** No version-6 entry exists. Add a `Version 6.0.0` group as the FIRST child of the `Release Notes` group's `pages` array (before `Version 5.0.0` at line 1064), mirroring beta.1's nav (which placed version-6 immediately above version-5). Minimal entries:
```json
{
  "group": "Version 6.0.0",
  "pages": [
    "release-notes/version-6/upgrade-guide",
    "release-notes/version-6/sdk-changelog"
  ]
}
```
- Exact location: inside `tab: "Release Notes"` → `group: "Release Notes"` → `pages` (docs.json line ~1062), as the first array element.
- **Owner: Agent-3.**

---

## Implementation Sequence
1. **Agent-3** — data-models.mdx: add 4 payload interfaces + `CommentEventTypes` keys (§1a/1b); remove 9 rows from `VeltCommentsSidebarV2Props` (§1c). (Medium effort.)
2. **Agent-3** — comments/customize-behavior.mdx: add 4 event rows to subscription table (§3). (Low effort.)
3. **Agent-3** — CREATE version-6/upgrade-guide.mdx (§5) + add version-6 nav to docs.json (§6). (Medium effort.)
4. **Agent-4** — comments-sidebar/v2/customize-behavior.mdx: remove `sortData` block, rewrite 4 event blocks to `on()`/`useCommentEventCallback`, remove `enableUrlNavigation` note (§4). Verify wireframes/structure no-op (§4a). (Medium effort.)
5. **Agent-5** — comment-sidebar-v2-primitives.mdx: remove 4 props from 2 examples + 4 table rows (§4b). (Low effort.)
6. **Agent-6** — align terminology/anchors across docs using §"Canonical terms"; respect §"Scope guard". (Medium.)
7. **Agent-7** — safe repo-wide QA pass for the removed/renamed names within allowed paths; diff name strings, not just counts. (Low.)

### Agent reality check
- **Agent-4: REAL work** — V2 behavior page has documented removed props/events to migrate.
- **Agent-5: REAL work** — V2 primitives root doc lists the 4 removed callback props (2 examples + table).

---

## Quality Checklist
- [ ] 4 new payload interfaces added to data-models.mdx (`SidebarOpenEvent`, `SidebarCloseEvent`, `CommentClickEvent`, `CommentNavigationButtonClickEvent`).
- [ ] 4 `CommentEventTypes` keys added (or flagged if no map section exists).
- [ ] 9 removed rows deleted from `VeltCommentsSidebarV2Props`; `onFullscreenClick`/`urlNavigation`/`sortBy`/`sortOrder` retained.
- [ ] 4 new event rows added to comments/customize-behavior subscription table.
- [ ] V2 behavior page: `sortData` block removed; 4 event blocks migrated to `on()`/`useCommentEventCallback`; `enableUrlNavigation` note removed.
- [ ] V2 primitives: 4 callback props removed from 2 examples + props table.
- [ ] `version-6/upgrade-guide.mdx` created (beta.2-specific, 3 breaking changes, before/after, Tabs React-first).
- [ ] docs.json `Version 6.0.0` nav group added above Version 5.0.0.
- [ ] Code examples include React/Next.js + Other Frameworks tabs in correct order.
- [ ] Breaking changes in upgrade-guide ONLY, not the changelog.
- [ ] Scope guard respected: V1 sidebar, timeline, comment-thread, wireframe-variables `sortData`, and historical release notes left untouched.
- [ ] Log file written to `.claude/release-notes/plan-v6.0.0-beta.2-comment-sidebar-events.md`.

---

## Flags for the human
1. **`CommentEventTypesMap` / `CommentEventTypes` not defined in data-models.mdx today** (only referenced at api-methods.mdx:748). Decide: (a) create a full `CommentEventTypesMap`/`CommentEventTypes` section listing ALL comment events (large, out of scope for one release), or (b) add only the 4 new payload interfaces + the 4 customize-behavior table rows and defer the map. Recommend (b) for this release to avoid fabricating an incomplete map. Confirm.
2. **`Location` type anchor** — `CommentClickEvent.location` uses `Location | null`. Confirm a `Location` anchor exists in data-models or link to the appropriate location/annotation type; if absent, render as plain `Location` without a link rather than a broken anchor.
3. **No-API-change items confirmed NO doc change:** improvements (absolute filter counts, dropdown CSS) and bug fixes (restricted-comments recipients P1, reaction pin/tool render, sidebar full-height/CDK portal, notification-resolver org-id). These go in the changelog only (Agent-1 done), not in feature docs or upgrade guide. The CDK-portal change preserves the documented `default-condition="false"` escape hatch — no doc change.
