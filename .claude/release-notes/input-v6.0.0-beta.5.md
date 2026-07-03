# Velt SDK Release Notes - v6.0.0-beta.5
Release Date: July 03, 2026

## Summary
| SDK | Files Changed | Insertions | Deletions |
|-----|--------------|------------|-----------|
| HTML/Vanilla (sdk) | 14 | +696 | -32 |
| React (sdk-react) | 3 | +4 | -4 |

> This release continues the **Comment Sidebar V2** (`<velt-comments-sidebar-v2>`) parity work: four bug fixes covering client-data (custom-actions) grouping, the first-load filter badge, free-text search, and the Public/Private filter — plus a global hotkey fix for the shadow-DOM sidebar search. There are **no new public API methods and no breaking changes** to the public consumer API surface. One new function is exported from the sidebar-v2 model module — `isClientGroupCurrentPage` (see API Changes) — which powers the "(This page)" suffix behavior in Bug Fix #1; it is a module-level export consumed within the SDK and is not re-exported from the public package entry point. The React SDK change is a version bump only (see Internal).

## API Changes

### 1. `isClientGroupCurrentPage(...)` — new exported helper (sidebar-v2 model module)

**What:** A new function, `isClientGroupCurrentPage`, is exported from the Comment Sidebar V2 model module (`comment-sidebar-v2.model.ts`). Given a group's **first annotation**, the group's label, and the current Velt location, it returns whether that client-provided sidebar group (from `setCommentSidebarData`) represents the **current page** — the decision that drives the **"(This page)"** header suffix in custom-actions (client-data) mode.

```ts
export function isClientGroupCurrentPage(
  firstAnnotation: CommentAnnotation | null | undefined,
  groupLabel: string,
  currentLocation: {
    locationId?: unknown;
    location?: { id?: unknown; locationName?: unknown } | null;
  } | null | undefined,
): boolean;
```

It applies the same 4-clause V1-parity match used by the `comment-sidebar-list-item-group-name` template (all OR'd, first match wins):
1. current `location.id` matches the annotation's `location.id`;
2. an id-less current location matches by `location.locationName`;
3. the current location hash (`currentLocation.locationId`) matches the annotation's `locationId`;
4. with no current location at all, the `'Others'` catch-all group is treated as current.

It returns `false` on any error or when no clause matches. It belongs to the module's "location identity" helper family (alongside `getLocationKey` / `getAnnotationLocationKey` / `normalizeLocationValue`), extending that single-source-of-truth "which page is this" logic to client-data groups.

**Why:** The "(This page)" suffix that V1 computes live in its group-name template was never derived on client-provided rows in V2. Extracting this decision into one exported, independently-testable function keeps the location-matching logic in sync with the rest of the sidebar-v2 location-identity family (rather than being re-implemented at the call site) and lets the sibling `CommentSidebarCoreV2Service` and the feature's spec suite import it directly. It is the mechanism behind Bug Fix #1's "(This page)" / single-winner behavior.

**Impact:** This is a module-level export, not a public SDK-consumer API — integrators using `setCommentSidebarData` do not call it directly; they observe its effect (the correct "(This page)" group labeling in custom-actions mode) as described in Bug Fix #1. It is imported by the sidebar-v2 core service and its specs, and is **not** re-exported from the SDK's public package entry point (`@veltdev/*`). No public consumer API method, prop, event, or type was added or changed, and there are no breaking changes.

---

## Bug Fixes

### 1. Custom-Actions (Client-Data) Sidebar: Correct Group Toggling, "(This page)" Suffix, and Location-Change Preservation

**What:** When the Comment Sidebar V2 runs in custom-actions mode (rows supplied by the client via `setCommentSidebarData`), grouped rows now behave with V1 parity:
- The current page's group shows the **"(This page)"** header suffix. The current-page group is resolved from the group's **first annotation** against the current location using four OR'd clauses (matching V1's `comment-sidebar-list-item-group-name` template): current `location.id` matches the annotation's `location.id`; an id-less current location matches by `locationName`; the current location hash (`locationId`) matches the annotation's `locationId`; or, with no current location at all, the "Others" catch-all group is treated as current. At most **one** group is marked as the current page — if several client groups carry annotations stamped with the same Velt location (e.g. path-keyed groups), only the first matching group gets the suffix.
- **Toggling a group flips only that clicked group in place.** The client payload owns the expansion state, so the internal grouping defaults/overrides (`collapsedGroupIds` / `expandedGroupIds`, the current-location default) are no longer consulted or re-applied to the other groups, and nothing is persisted to `sessionStorage` (the next `setCommentSidebarData` re-send wins, exactly like V1).
- **A location change no longer replaces client rows with internally-grouped rows.** It only re-derives the `isCurrentPage` flag on the existing groups, preserving each group's `isExpanded` (both the payload's value and any user toggle).
- With `options.grouping === false`, no group rows are emitted (flat list), and both the toggle and the location-change refresh no-op safely instead of throwing on an empty groups array.

**Why:** V2's custom-actions path reused the internal grouping engine's expansion resolution. Toggling one group re-resolved **all** groups against the internal location-grouping defaults, so groups whose id did not match the current location snapped collapsed on any toggle. A location change re-ran internal grouping and discarded the client-provided rows entirely, and the "(This page)" suffix — which V1 computes live in the group-name template — was never derived on client rows.

**Impact:** Client-supplied grouped sidebars now behave like V1: the current page's group is labeled "(This page)", expanding/collapsing one group leaves the others exactly as the client sent them (or as the user last toggled them), and navigating between pages keeps the client's rows and expansion state while moving the "(This page)" suffix to the newly-current group.

**API (React + HTML — identical, unchanged in this release — behavior fix only):**
```ts
const commentElement = client.getCommentElement();
commentElement.setCommentSidebarData({
  data: [
    { groupId: '/a', groupName: '/a', isExpanded: true,  annotations: [/* ... */] },
    { groupId: '/b', groupName: '/b', isExpanded: false, annotations: [/* ... */] },
  ],
  options: { grouping: true },
});
```

---

### 2. First-Load Filter Badge / DOM Pin Gate No Longer Falls Back to All Annotations

**What:** On the sidebar's first data emission, the filtered list is now published to `CommentService.commentsFromSidebarMap` with the **real** filtered comments. The skeleton-loading flag is now cleared **before** the synchronous first-emission pipeline run, so the publish carries the actual list rather than `undefined`.

**Why:** Previously the synchronous first-emission pipeline ran while `skeletonLoading` was still `true`, so `publishCommentsFromSidebarMap` published `comments: undefined` — leaving `commentsFromSidebarMap` effectively empty. Both consumers of that map (the sidebar-button `count-type='filter'` badge and the filter-comments-on-DOM pin gate) fell back to counting/showing **all** annotations for roughly 300ms, until the debounced pipeline re-published. (Regression fixed per Bugbot, PR #4429.)

**Impact:** On first load, the `count-type='filter'` badge and the DOM pin gate immediately reflect the real filtered sidebar list instead of briefly flashing the full annotation count. The clear-skeleton-first change only runs once data has actually arrived, so it does not affect the empty/loading states.

---

### 3. Sidebar Search: Matches All Comments + Replies + Author Names, Adds `#N` Index Search, Drops HTML False Positives

**What:** The Comment Sidebar V2 free-text search was rewritten to match V1 (`filterAnnotationsByInput`):
- A query of the form **`#N`** (e.g. `#22`) searches by `annotationNumber` **exactly**. `#0` correctly matches an annotation numbered `0` (falsy-but-valid, not treated as unset). A bare `#` with no digits, or a plain number like `22`, falls through to a normal text search.
- Otherwise the query matches when **any** comment in the thread — **replies included**, not just the first comment — contains the text in its `commentText` **or** its author's name (`from.name`), case-insensitively.
- Search **no longer** matches `commentHtml`. Markup and attribute strings inside the HTML previously produced false positives (e.g. a query matching a CSS class or `data-*` attribute).

**Why:** V2 only searched the **first** comment's `commentText` and `commentHtml`. That missed matches in replies and in comment author names, while the `commentHtml` scan surfaced results that matched only the underlying markup — both diverging from V1.

**Impact:** Searching the sidebar now finds threads by any comment's or reply's text, by any comment/reply author's name, and by exact comment number via `#N`. Queries no longer match hidden HTML markup, eliminating the false positives.

---

### 4. Comment Type (Public/Private) Filter Detects New-Style Private Comments

**What:** The sidebar's **Comment Type** filter (Public / Private) now determines privacy through the unified `isAnnotationPrivate` helper (and the `CommentAccessMode` enum for the option ids) instead of an inline `accessMode`/`iam.accessMode` check.

**Why:** New-style private comments carry `visibilityConfig.type` (`'restricted'` or `'organizationPrivate'`) and **no** `iam.accessMode`. The old inline check only recognized the legacy `accessMode === 'private'` / `iam.accessMode === 'private'` shape, so new-style private comments were counted as **Public** — the Private option read "Private (0)" even when private comments existed.

**Impact:** Both legacy (`iam.accessMode: 'private'`) and new-style (`visibilityConfig.type: 'restricted' | 'organizationPrivate'`) private comments now match the **Private** filter option; annotations with no private marker, or an explicit `visibilityConfig.type: 'public'`, match **Public**. The Private/Public counts and filtering are correct (V1 parity).

---

### 5. Hotkeys No Longer Trigger While Typing in the Shadow-DOM Sidebar Search

**What:** The global hotkey guard (`HotkeyService.isNoInputFocused`) now descends through nested shadow roots to find the **real** focused element, and walks the ancestor chain **across** shadow boundaries (continuing from a shadow root's host when `parentElement` is `null`) to detect an `INPUT`, `TEXTAREA`, or `contentEditable` wrapper.

**Why:** When focus is inside a shadow root (such as the shadow-wrapped comment sidebar's search box), `document.activeElement` reports only the shadow **host**, not the focused input. The guard walked the host's ancestor chain, found no input, and treated the page as "nothing focused" — so typing a hotkey letter (e.g. `c`) in the sidebar search input toggled comment mode.

**Impact:** Typing in the sidebar search input (or any input/textarea/contentEditable inside one or more shadow roots) no longer fires global hotkeys. Non-input focus inside a shadow root still allows hotkeys, and a `contentEditable` wrapper outside the shadow boundary correctly gates them.

---
