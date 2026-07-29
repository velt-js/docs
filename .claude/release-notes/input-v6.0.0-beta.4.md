# Velt SDK Release Notes - v6.0.0-beta.4
Release Date: July 02, 2026

## Summary
| SDK | Files Changed | Insertions | Deletions |
|-----|--------------|------------|-----------|
| HTML/Vanilla (sdk) | 15 | +2054 | -202 |
| React (sdk-react) | 3 | +4 | -4 |

> This release is focused entirely on the **Comment Sidebar V2** (`<velt-comments-sidebar-v2>`): a set of grouping, filtering, and counting behavior fixes that bring V2 to parity with the V1 comment sidebar. There are no new public API methods and no breaking changes to the public API surface. The React SDK change is a version bump only (see Internal).

## Improvements

### 1. Sidebar List Group Expand/Collapse: Current-Page-First Defaults + Persistent Overrides

**What:** When the Comment Sidebar V2 list is grouped by **location** or **document**, only the current page's (or current document's) group is now expanded by default; all other groups start collapsed — matching V1. Additional locations (set via multiple locations / `addLocation`) also default to expanded. Every other grouping (e.g. status, priority, a custom field) still defaults to all groups expanded. On top of the defaults, the sidebar now tracks both user **collapse** and user **expand** actions independently and persists them to `sessionStorage`, so a group you explicitly opened or closed stays that way across reloads.

**Why:** Previously the sidebar only tracked collapsed groups, so it could not represent "a default-collapsed group the user explicitly expanded," and grouping by location/document always started fully expanded — a long list of pages opened all at once instead of focusing on the current page (V1 behavior).

**Impact:** Grouped lists open focused on the page/document the user is on. Expand/collapse choices survive a reload. A **real** location switch (page A → page B) resets the toggles so the new current page auto-expands (V1 parity), but a reload's baseline-establishing location emission (undefined → the same page) preserves the restored toggles instead of wiping them. Group expansion is resolved with a stable precedence everywhere: user-expanded override → user-collapsed override → per-grouping default.

---

### 2. Default Status Filter Selection (Open + In Progress)

**What:** On first load, the Comment Sidebar V2 Status filter now starts with **Open** (the default status) and every **In Progress** (ongoing) status pre-selected, so resolved/terminal comments are hidden by an explicit, visible, clearable selection rather than an invisible preset — matching V1's `setDefaultStatuses`.

**Why:** V2 previously hid resolved comments through an implicit "all" quick-filter preset, which was neither visible nor clearable in the filter UI and diverged from V1's behavior of showing the active status selection as checked options.

**Impact:** The Status section shows Open + In Progress as checked on load. The seed is skipped when `sessionStorage` state was restored, when the client provided a status filter via `setCommentSidebarFilters`, or once the user has touched the selection. If the status catalog loads late (e.g. console-configured statuses), an untouched seed refreshes to the new catalog's default/ongoing ids. Clearing the selection (see Bug Fix #4) reveals resolved comments.

---

### 3. `setCommentSidebarFilters` Now Applies as Clearable Selected Filters (with Stable Facet Counts)

**What:** Client-provided sidebar filters — the `setCommentSidebarFilters(...)` API and the V1-shape `filters` input — now map onto the sidebar's own **selected filter state** (V1 `mergeClientFilters` parity) instead of being applied as a separate hard "system filter" stage. The passed values render as **checked options** in the filter panel, are cleared by **Reset**, and merge per key (a later call with only `location` keeps the existing `involved` selection; a present-but-empty array clears just that field; an empty object `{}` clears all selections).

**Why:** As a hard system stage, client filters silently shrank the facet-count universe, so filter option counts shifted based on what the integration had pushed and the applied filters were invisible/unclearable in the UI. V1 instead surfaces client filters as ordinary selected options.

**Impact:** Facet option counts are now **absolute within the page-scoped universe** and no longer shrink when client filters are applied — every option keeps showing (with the client-applied ones checked). The Main Filter badge count reflects the applied client selections, and Reset clears them. Filter values map correctly: locations by identity key (id, falling back to name), people/assigned/tagged/involved by `userId` (email fallback), status/priority/category verbatim, `accessModes` onto comment type, `version` by id, and custom field keys (strings or `{id,name}` objects).

**API (React + HTML — identical):**

Declared signature (unchanged in this release — behavior fix only):
```ts
setCommentSidebarFilters(filters: CommentSidebarFilters): void;
```

Usage:
```ts
const commentElement = client.getCommentElement();

// Applied as selected (checked) filter options; Reset clears them.
commentElement.setCommentSidebarFilters({
  status: ['OPEN'],
  involved: [{ userId: 'user-123' }],
  location: [{ id: 'locationA', locationName: 'Location A' }],
});

// A present-but-empty array clears just that field:
commentElement.setCommentSidebarFilters({ location: [] });

// An empty object clears ALL selections:
commentElement.setCommentSidebarFilters({});
```

---

## Bug Fixes

### 1. Name-Only Locations Now Scope Sidebar Grouping, Filtering, and Page Mode

**What:** A single source of truth for location identity was introduced (`getLocationKey` / `getAnnotationLocationKey` / `getAnnotationLocationLabel` / `normalizeLocationValue`) and every "which page is this" consumer in the sidebar — grouping, the location filter's options + matching, page mode (`page-mode="true"`), and client filters — now derives its key through it. A location's identity is its `id`, **falling back to `locationName`** for id-less locations (name-only `setLocation` / `documentParams` pages). Annotation `location.id`s that are numeric are coerced to strings so they compare equal to the string group keys.

**Why:** V2 read `location.id` directly in several places, so a location created with a name but no id (`setLocation({ locationName: 'Home' })`) produced no key — it silently broke that specific feature (page mode showed every page, the location filter had no option, the group didn't default-expand) while the rest kept working.

**Impact:** Name-only locations now behave identically to id-based ones: the location filter lists them and matches them, page mode scopes the list to them, and their group default-expands. Annotations with no location context at all fall into the catch-all "Others" bucket. Falsy-but-valid ids (`0`) are preserved; `null` / `undefined` / empty-string ids fall back to the name. When an annotation has both an id and a name, the id wins consistently across all consumers.

---

### 2. Duplicate People in the People / Involved / Assigned / Tagged Filters

**What:** Filter options for user fields (people, involved, assigned, tagged) are now keyed **strictly by `userId`**. Occurrences of a person that carry only an email (e.g. someone tagged by email before signing up, or an author record with only an email) no longer create a second option.

**Why:** Options were previously keyed by `userId || email`, so the same human referenced with a `userId` on some records and email-only on others produced **two** options — a userId-keyed one and an email-keyed twin — with diverging counts. The email-keyed twin could never count correctly because the assigned/tagged predicates match by `userId` only.

**Impact:** One option per person, keyed by `userId`, with counts and filtering that match V1. The option is labeled name-first with an email fallback (`name || email`). Email-only assignees/tagged contacts (with no `userId`) never become options — the same as V1.

---

### 3. Sidebar Button "filter" Count Badge Reflects the Actual Filtered List

**What:** The Comment Sidebar V2 now publishes its filtered list to `CommentService.commentsFromSidebarMap` on every pipeline run (V1 parity). This map is read by the sidebar-button's `count-type='filter'` badge and by the filter-comments-on-DOM pin gate.

**Why:** Without publishing, both consumers silently fell back to counting/showing **all** annotations — so the badge could read (e.g.) 129 while the sidebar itself was empty, and DOM pins were not gated by the sidebar's filter state.

**Impact:** With `setSidebarButtonCountType('filter')`, the badge count now matches the filtered sidebar list (including an empty list showing 0, and deletions decrementing the count). While the sidebar is skeleton-loading, the existing map is preserved (V1 parity). When the sidebar is destroyed, the map is reset so a removed sidebar stops gating the badge and DOM pins.

Declared signature (unchanged in this release — behavior fix only):
```ts
setSidebarButtonCountType(type: string): void;
// Evidenced call-site value: 'filter' (also settable via the count-type='filter' HTML attribute)
```

Usage:
```ts
const commentElement = client.getCommentElement();
commentElement.setSidebarButtonCountType('filter'); // badge now counts the filtered list
```

---

### 4. Clearing Filters / Selecting "All" on Status Now Shows Resolved Comments

**What:** Explicitly choosing **"All"** on the Status field, or hitting **Reset**, now shows resolved/terminal comments (V1 parity: `updateFilter('statuses', all=true)` → `resolvedCommentsOnDom = true`).

**Why:** V2's "all" quick-filter preset kept hiding terminal statuses even after the user cleared the status filter, so resolved comments stayed hidden when the user expected "show everything."

**Impact:** Clearing the Status selection or resetting all filters reveals resolved comments. Clearing a non-status field does not touch the resolved flag. Reset also clears any seeded/default status selection and does not re-trigger the Open + In Progress seed afterward.

---

### 5. Priority Filter Shows a "Not Set" Bucket

**What:** The default Priority section in the Main Filter panel now surfaces an **unset** bucket labeled **"Not set"** for comments that have no priority (V1's `unsetType { id: 'unset', name: 'Not set' }`).

**Why:** V2 built the default Priority field with `includeUnset: false`, so comments without a priority could not be filtered for and diverged from V1, which always shows the "Not set" option.

**Impact:** Comments without a priority are now filterable via the "Not set" option. The unset bucket is labeled "Not set" (not the generic "None"). Fields configured with `includeUnset: false` still omit the bucket.

---

### 6. Client Filters for Fields Not Shown in the Panel Now Filter

**What:** When `setCommentSidebarFilters` pushes a selection for a field that is **not** declared/displayed anywhere (e.g. a `version` filter when Version isn't a Main Filter panel section), the sidebar now synthesizes a field descriptor for it so the selection actually filters the list — V1 applies client filters regardless of what the panel displays.

**Why:** The V2 filter engine only ran predicates for declared/displayed fields, so a client filter on an undisplayed field was silently ignored.

**Impact:** Client filters on undisplayed fields now take effect. An undeclared field with an **empty** selection is not synthesized, and an already-declared field is never duplicated even when it also has an active selection.

---

### 7. `system-filters-operator` (AND/OR) Applied to the Sidebar Filter Engine

**What:** The cross-field AND/OR operator (`system-filters-operator`) is now applied directly to the sidebar's filter engine. A pre-init `'or'` set before the sidebar subscribed is picked up, and subsequent operator changes update the engine (the `BehaviorSubject`'s initial `'and'` replay is skipped so it does not clobber a `filter-operator` input applied just before subscription).

**Why:** V2 previously only re-ran the pipeline on operator changes **when client filters were active**, and did not otherwise apply the operator to the engine — so the cross-field AND/OR selection could be ignored.

**Impact:** The cross-field operator now consistently governs how different filter fields are combined (within-field remains OR), including when set before the sidebar initializes.

---

### 8. Sidebar List No Longer Scrolls Horizontally (V1 Parity)

**What:** The Comment Sidebar V2 virtual-scroll list now clips wide rows instead of scrolling sideways: `overflow-x: hidden` on the viewport and its content, and the CDK-generated content wrapper is capped to `max-width: 100%`. The group-header chevron container is also set to `display: flex`.

**Why:** Without capping the wrapper, the CDK virtual-scroll content grew to its widest child, forcing horizontal overflow — V1 clips wide rows.

**Impact:** Wide rows are clipped to the sidebar width (no sideways scrollbar), matching V1's layout.

---
