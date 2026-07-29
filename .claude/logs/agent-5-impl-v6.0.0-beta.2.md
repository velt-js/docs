# Agent-5 Implementation Log — v6.0.0-beta.2

**Branch:** `v6.0.0-beta.2`
**Date:** 2026-06-24
**Scope (plan §4b):** Comment Sidebar V2 PRIMITIVES page — remove deprecated/removed callback props.

## File touched (ONLY this one)
`ui-customization/features/async/comments/comment-sidebar/comment-sidebar-v2-primitives.mdx`

## Removed props (this release removed them from `VeltCommentsSidebarV2` / `velt-comments-sidebar-v2`)
Target set: `onSidebarOpen`, `openSidebar`, `onSidebarClose`, `onCommentClick`, `onSidebarCommentClick`,
`sidebarCommentClick`, `onCommentNavigationButtonClick`, `sortData`/`sort-data`,
`enableUrlNavigation`/`enable-url-navigation`.

Pre-edit grep found only 4 of them actually present in this file (the page documented only
`onSidebarOpen`/`onSidebarClose`/`onCommentClick`/`onCommentNavigationButtonClick`).
`openSidebar`, `onSidebarCommentClick`, `sortData`, `enableUrlNavigation` were NOT present here
(they live on the data-models props table + behavior page, owned by Agent-3/Agent-4 — out of my scope).

## Before / After (every removal)

### 1. Pattern 1: Drop-in Replacement — React/JSX example (was lines ~38-49)
Removed 4 prop lines from the `<VeltCommentsSidebarV2 ... />` example:
- `onSidebarOpen={(data) => console.log('sidebar opened', data)}`
- `onSidebarClose={(data) => console.log('sidebar closed', data)}`
- `onCommentClick={(data) => console.log('comment clicked', data)}`
- `onCommentNavigationButtonClick={(data) => console.log('nav button clicked', data)}`
Kept: `pageMode`, `focusedThreadMode`, `readOnly`, `position`, `variant`, `forceClose`.
HTML (Other Frameworks) example already omitted them — left as-is.

### 2. `### VeltCommentsSidebarV2` component — React/JSX example (was lines ~131-144)
Removed the same 4 prop lines from the `<VeltCommentsSidebarV2 ... />` example.
Kept: `pageMode`, `focusedThreadMode`, `readOnly`, `embedMode`, `floatingMode`, `position`, `variant`, `forceClose`.
HTML (Other Frameworks) example already omitted them — left as-is.

### 3. `### VeltCommentsSidebarV2` — Props table (was lines ~160-163)
Removed 4 table rows:
- `| `onSidebarOpen` | `(data: any) => void` | - | Callback fired when the sidebar opens |`
- `| `onSidebarClose` | `(data: any) => void` | - | Callback fired when the sidebar closes |`
- `| `onCommentClick` | `(data: any) => void` | - | Callback fired when a comment item is clicked |`
- `| `onCommentNavigationButtonClick` | `(data: any) => void` | - | Callback fired when the comment navigation button is clicked |`
Table now ends at the `version` row; header + separator + 9 data rows = well-formed.

Added one concise cross-link note (option (a)+light pointer) right after the React props table,
inside the React tab:
> The sidebar open/close, comment-click, and comment-navigation events are now delivered through
> the `commentElement.on()` event bus instead of props. See the
> [comment event subscription table](/async-collaboration/comments/customize-behavior#event-subscription)
> for `sidebarOpen`, `sidebarClose`, `commentClick`, and `commentNavigationButtonClick`.
> `onFullscreenClick` remains a prop callback.

Rationale: this is a structure/primitive page, not an event-subscription tutorial, so per the brief I
defaulted to minimal removal + a single pointer to the event table (which Agent-3 populated). No
`useCommentEventCallback` tutorial was added here (that belongs on the behavior page — Agent-4).

## Verification
- Final grep for ALL removed-prop names in the file → 0 matches (`grep` exit 1). No legitimate unrelated matches existed.
- Retained: `onFullscreenClick` present at the new cross-link note + existing prose
  ("emits `onFullscreenClick` when activated" on the FullscreenButton primitive). KEPT.
- `urlNavigation` / `sortBy` / `sortOrder` were never documented on this primitives page (root example
  carries only a prop subset); nothing to retain there and nothing was accidentally removed.
- Props table well-formed: `| Prop | Type | Default | Description |` header + separator + 9 rows, blank
  line before the cross-link note. Other Frameworks attributes table untouched and valid.
- Cross-link anchor verified: `# Event Subscription` heading exists at line 3546 of
  `async-collaboration/comments/customize-behavior.mdx` → resolves to `#event-subscription`.
- Tabs order preserved: `React / Next.js` first, `Other Frameworks` second.

## Scope guard respected
- Did NOT touch: data-models.mdx, api-methods.mdx, comments-sidebar/v2/customize-behavior.mdx,
  setup/wireframes pages, V1 sidebar, comment-sidebar-v2-wireframes.mdx, comment-sidebar-structure-v2.mdx.
- Only the one primitives file was modified.

## Notes for Agent-6 / Agent-7
- Canonical event keys to align on this page if QA touches it: `sidebarOpen`, `sidebarClose`,
  `commentClick`, `commentNavigationButtonClick` (camelCase, in the new cross-link note).
- The new cross-link points to `/async-collaboration/comments/customize-behavior#event-subscription`.
  Agent-6/7: if the canonical anchor slug for that table differs after Agent-3's edits, update this one
  link accordingly. Currently verified valid.
- No `sortData`/`enableUrlNavigation` ever existed on this primitives page — no canonical-rename work
  needed here (those renames `sortData→sortBy/sortOrder`, `enableUrlNavigation→urlNavigation` apply to
  data-models/behavior pages, not this file).
- Component count text ("56+", "All 56 primitives") unchanged — no primitives added/removed, only props.
