# Agent-4 Implementation Log — v6.0.0-beta.2 (Comment Sidebar V2 events/props migration)

Branch: `v6.0.0-beta.2`
Scope: Behavior page + wireframes (NOT primitives, NOT data-models, NOT api-methods).
Date: 2026-06-24

## Files touched

### 1. async-collaboration/comments-sidebar/v2/customize-behavior.mdx — EDITED (5 changes)

**a) `#### sortData` block — REMOVED.**
- Before: `#### sortData` section with React `<VeltCommentsSidebarV2 sortData="comments.createdAt" />` + HTML `sort-data="..."` examples.
- After: removed entirely. Canonical `#### sortBy` and `#### sortOrder` blocks remain above it (unchanged) under `# Sorting`.

**b) `#### onCommentClick` → `#### commentClick` — REWRITTEN.**
- Before: `onCommentClick` prop on `<VeltCommentsSidebarV2>` (React) + `addEventListener('onCommentClick', ...)` reading `event.detail.location` (HTML).
- After: React `useCommentEventCallback('commentClick')` + `useEffect`; HTML `Velt.getCommentElement().on('commentClick').subscribe(...)`.
- Payload documented as [`CommentClickEvent`](#commentclickevent); shows reading `annotation`, `documentId`, `targetElementId`, and `location` (navigation use-case prose preserved).

**c) `#### onCommentNavigationButtonClick` → `#### commentNavigationButtonClick` — REWRITTEN.**
- Before: `onCommentNavigationButtonClick` prop (React) + `addEventListener('onCommentNavigationButtonClick', ...)` (HTML).
- After: React `useCommentEventCallback('commentNavigationButtonClick')`; HTML `commentElement.on('commentNavigationButtonClick').subscribe(...)`.
- Payload documented as [`CommentNavigationButtonClickEvent`](#commentnavigationbuttonclickevent) (extends `CommentClickEvent`).

**d) `enableUrlNavigation` `<Note>` — REMOVED.**
- Before: `<Note>` stating `enableUrlNavigation` is a deprecated alias for `urlNavigation`.
- After: removed. `#### urlNavigation` block (canonical) left intact directly above it.

**e) `# Events` → `#### onSidebarOpen` / `#### onSidebarClose` → `#### sidebarOpen` / `#### sidebarClose` — REWRITTEN.**
- Before: `onSidebarOpen` / `onSidebarClose` props (React) + `addEventListener('onSidebarOpen'|'onSidebarClose', ...)` (HTML).
- After: React `useCommentEventCallback('sidebarOpen'|'sidebarClose')` + `useEffect`; HTML `commentElement.on('sidebarOpen'|'sidebarClose').subscribe(...)`.
- Payloads documented as [`SidebarOpenEvent`](#sidebaropenevent) / [`SidebarCloseEvent`](#sidebarcloseevent).

### 2. async-collaboration/comments-sidebar/v2/setup.mdx — NO CHANGE NEEDED
- Grep for all removed props/inputs/event-callbacks returned zero matches. No code example or prop list contained any removed name.

### 3. ui-customization/features/async/comments/comment-sidebar/comment-sidebar-v2-wireframes.mdx — NO CHANGE NEEDED
- Grep returned zero matches. Pure wireframe component tree; no removed prop strings present. Matches plan §4a (verified clean, no-op).

### 4. ui-customization/features/async/comments/comment-sidebar-structure-v2.mdx — NO CHANGE NEEDED
- Grep returned zero matches. Pure component tree, no props. Matches plan §4a (no-op).

## Verification (post-edit greps on customize-behavior.mdx)
- Removed-prop scan (`onSidebarOpen|openSidebar|onSidebarClose|onCommentClick|onSidebarCommentClick|sidebarCommentClick|onCommentNavigationButtonClick|sortData|sort-data|enableUrlNavigation|enable-url-navigation`): **zero remaining**.
- `onFullscreenClick` (must be preserved): present at 3 locations (prose bullet + React prop example + HTML `addEventListener`) — **unchanged**.
- All 4 new event keys present via `useCommentEventCallback('<key>')` (React) and `commentElement.on('<key>').subscribe(...)` (HTML, using `Velt.getCommentElement()`).
- Tab ordering: React / Next.js first, Other Frameworks second in all 4 migrated sections — **confirmed**.

## Anchor links used (link in prose only, never in code)
- `/api-reference/sdk/models/data-models#commentclickevent`
- `/api-reference/sdk/models/data-models#commentnavigationbuttonclickevent`
- `/api-reference/sdk/models/data-models#sidebaropenevent`
- `/api-reference/sdk/models/data-models#sidebarcloseevent`
(Agent-3 owns adding these 4 payload interfaces to data-models.mdx — confirm anchors resolve.)

## Convention notes
- React code uses `client.getCommentElement()` for API methods elsewhere on this page; the new event examples use the `useCommentEventCallback` hook (no `client`/`Velt` needed in React tab). HTML tab uses `Velt.getCommentElement()` per convention.
- HTML examples use `const commentElement = Velt.getCommentElement(); commentElement.on(...)` per the release-note migration pattern.

## Handoffs
- **Agent-5 (primitives):** Plan §4b — `comment-sidebar-v2-primitives.mdx` still carries the 4 removed callback props (`onSidebarOpen`/`onSidebarClose`/`onCommentClick`/`onCommentNavigationButtonClick`) in 2 React examples + the props table. NOT touched by Agent-4 (out of scope). Agent-5 to remove them.
- **Agent-6 (alignment):** Canonical replacements to enforce repo-wide: `sortData`→`sortBy`+`sortOrder`; `enableUrlNavigation`/`enable-url-navigation`→`urlNavigation`/`url-navigation`; sidebar `@Output()` callbacks → `on()` bus event keys. Respect scope guard (V1 sidebar, timeline, comment-thread, wireframe-variables `sortData`, historical release notes).
- **Agent-7 (QA):** Verify zero remaining removed-prop strings in the 4 Agent-4 files; verify `onFullscreenClick` retained; verify 4 data-models anchors resolve once Agent-3's interfaces land.
