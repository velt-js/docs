# Agent-3 Implementation Log — v6.0.0-beta.2 (comment sidebar events)

Branch: `v6.0.0-beta.2` (off `main`). Prior attempt blocked by OS permission issue; this run started fresh and made all edits.

## Scope (Agent-3 only)
data-models.mdx (§1), api-methods.mdx (§2 — verify/skip), comments/customize-behavior.mdx event table (§3), CREATE version-6/upgrade-guide.mdx (§4), docs.json nav (§5). Sidebar component/wireframe/primitive pages are owned by Agents 4 & 5 — NOT touched.

---

## 1. `api-reference/sdk/models/data-models.mdx`

### 1a. Removed 9 rows from `VeltCommentsSidebarV2Props` table (verified by prop NAME, not line number)
Deleted (all confirmed within the `VeltCommentsSidebarV2Props` table only):
- `onSidebarOpen`
- `onSidebarClose`
- `onCommentClick`
- `onCommentNavigationButtonClick`
- `sortData`
- `enableUrlNavigation`
- `openSidebar` (deprecated alias)
- `sidebarCommentClick` (deprecated alias)
- `onSidebarCommentClick` (deprecated alias)

KEPT (untouched, verified present): `onFullscreenClick`, `urlNavigation`, `sortBy`, `sortOrder`.

### 1b. Added 4 payload interfaces
Placed immediately after `CommentBubbleClickedEvent` (before `CommentSavedEvent`), in the comment-events cluster. Matched the existing `#### Name` + `---` + field-table pattern. Added a one-line "Subscribe via `commentElement.on(...)`" lead per interface (consistent with the JSDoc-style descriptions in the raw note).

- `#### SidebarOpenEvent` → `metadata?` only. Anchor: `#sidebaropenevent`
- `#### SidebarCloseEvent` → `metadata?` only. Anchor: `#sidebarcloseevent`
- `#### CommentClickEvent` → `documentId?`, `location?`, `targetElementId?`, `context?`, `annotation?`, `metadata?`. Anchor: `#commentclickevent`
- `#### CommentNavigationButtonClickEvent` → "Extends `CommentClickEvent` with no additional fields." Anchor: `#commentnavigationbuttonclickevent`

**Link handling for referenced types** (grep-confirmed anchors exist → linked, NO broken links):
- `Location` → `#location` (exists at `## Location` / `#### Location`). LINKED.
- `CommentAnnotation` → `#commentannotation` (exists at line 5). LINKED.
- `VeltEventMetadata` → `#velteventmetadata` (exists). LINKED.
- `CommentClickEvent` self-reference from `CommentNavigationButtonClickEvent` → `#commentclickevent`. LINKED.

### 1c. CommentEventTypesMap / CommentEventTypes
Grep-confirmed: NO `CommentEventTypesMap` / `CommentEventTypes` / `CommentEventType` section exists in data-models.mdx today (only `SuggestionEventTypesMap` exists, at ~line 7944). Per plan Flag #1 recommendation (b), did NOT fabricate an incomplete map. Added only the 4 payload interfaces + the customize-behavior table rows. **No map section created.**

---

## 2. `api-reference/sdk/api/api-methods.mdx`
NO edit. The `#### on()` entry (line ~745) does not enumerate individual events — it links out to `customize-behavior#on` for the event list and to `data-models#comment` for payload types. There is no per-event enumeration on this page to extend (plan §2 confirms "no per-event method entries are strictly required"). Returns/Params links unchanged and still resolve (no `CommentEventTypesMap` section was created, so the existing `#comment` link is untouched). V1 methods `onCommentClick()` / `enableSidebarUrlNavigation()` left intact (scope guard).

---

## 3. `async-collaboration/comments/customize-behavior.mdx` — Event Subscription table
Appended 4 rows under the existing `Comment Sidebar` category (after `commentSidebarDataInit` / `commentSidebarDataUpdate`), matching the exact `| Category | \`event\` | Description | [PayloadEvent](anchor) |` format:
- `sidebarOpen` → `#sidebaropenevent`
- `sidebarClose` → `#sidebarcloseevent`
- `commentClick` → `#commentclickevent`
- `commentNavigationButtonClick` → `#commentnavigationbuttonclickevent`

Subscribe example block: LEFT AS-IS. The block uses `addCommentAnnotation` as the canonical generic "how to subscribe to any event" demo for the whole table (both React `useCommentEventCallback` and HTML `commentElement.on().subscribe`). It is not per-event; rewriting the canonical example to `commentClick` would diverge from the established convention without benefit. The 4 new events are fully documented via the table + payload links. Decision noted.

---

## 4. CREATE `release-notes/version-6/upgrade-guide.mdx`
Did not exist on this branch. Created beta.2-specific (no beta.1 modular-SDK / Approval Engine content). Mirrored beta.1 structure:
- Frontmatter: `title: Upgrade Guide` + the required `description`.
- `## Overview` (bulleted)
- `## Breaking Changes` with `[**Area**]` bullets (3 changes)
- `## How to Upgrade` with numbered subsections, each using `<Tabs>` (React / Next.js first, Other Frameworks second), Before/After per the raw note's literal snippets.

Three breaking changes documented:
1. V2 sidebar events → `on()` bus (removed-props list, `onFullscreenClick`-remains note, React + HTML before/after).
2. `sortData` / `sort-data` removed → `sortBy` / `sortOrder` (React + HTML before/after).
3. `enableUrlNavigation` / `enable-url-navigation` removed → `urlNavigation` / `url-navigation` (React + HTML before/after).

Breaking changes live ONLY in the upgrade guide (not the changelog).

---

## 5. `docs.json` navigation
Added `Version 6.0.0` group as the FIRST child of `tab: "Release Notes"` → `group: "Release Notes"` → `pages`, immediately above `Version 5.0.0`, mirroring beta.1 exactly:
```json
{
  "group": "Version 6.0.0",
  "pages": [
    "release-notes/version-6/upgrade-guide",
    "release-notes/version-6/sdk-changelog"
  ]
}
```
No existing entries reordered/removed. Validated: `python3 -m json.tool docs.json > /dev/null` → VALID.

---

## Anchor slugs for downstream agents (4/5/6/7)
- `/api-reference/sdk/models/data-models#sidebaropenevent`
- `/api-reference/sdk/models/data-models#sidebarcloseevent`
- `/api-reference/sdk/models/data-models#commentclickevent`
- `/api-reference/sdk/models/data-models#commentnavigationbuttonclickevent`

## Canonical event keys / replacements (unchanged from plan)
- Event keys: `sidebarOpen`, `sidebarClose`, `commentClick`, `commentNavigationButtonClick`
- `sortData` → `sortBy` + `sortOrder`; `enableUrlNavigation` / `enable-url-navigation` → `urlNavigation` / `url-navigation`
- Removed V2 props: `onSidebarOpen`, `openSidebar`, `onSidebarClose`, `onCommentClick`, `onSidebarCommentClick`, `sidebarCommentClick`, `onCommentNavigationButtonClick`, `sortData`, `enableUrlNavigation`
- Retained: `onFullscreenClick`

## Files changed
- `api-reference/sdk/models/data-models.mdx` (9 rows removed; 4 interfaces added)
- `async-collaboration/comments/customize-behavior.mdx` (4 table rows added)
- `release-notes/version-6/upgrade-guide.mdx` (CREATED)
- `docs.json` (Version 6.0.0 nav group added; validated)

## Handoff
Agent-4: V2 sidebar behavior page (`comments-sidebar/v2/customize-behavior.mdx`) event/prop migration + wireframe verify. Agent-5: V2 primitives prop cleanup. Both link to the 4 anchors above.
