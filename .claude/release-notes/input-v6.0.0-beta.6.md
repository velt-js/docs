# Velt SDK Release Notes - v6.0.0-beta.6
Release Date: July 3, 2026

## Summary
| SDK | Files Changed | Insertions | Deletions |
|-----|--------------|------------|-----------|
| HTML/Vanilla (sdk) | 12 | +498 | -316 |
| React (sdk-react) | 3 | +4 | -4 |

> This release continues the **Comment Sidebar V2** (`<velt-comments-sidebar-v2>`) parity work with bug fixes and internal cleanup. There are **no new public APIs and no breaking changes**. The React SDK change is a version bump only.

## Bug Fixes

### 1. `page-mode` No Longer Hides Other Locations or Skews the Status Counts

**What:** With `page-mode="true"` on the sidebar, calling `setLocation()` now keeps every location in the list. The current location's group floats to the top and is expanded, and the other groups stay visible (just collapsed). The header Status dropdown counts also stay correct — they now always count every comment, not just the ones on the current location.

**Why:** V2 was treating `page-mode` as a hard filter tied to the current location. As soon as `setLocation()` ran, every other location group disappeared from the sidebar and the Status counts dropped to only the current location's comments (for example "Open 1" instead of "Open 36"). V1 never did this — there, `page-mode` is only a display flag.

**Impact:** `page-mode` now matches V1: it renders the page-level composer and nothing else. Setting a location organizes the list through grouping (current group on top and expanded, others collapsed but still there) instead of hiding comments, and the facet counts reflect all comments.

**API (React + HTML — unchanged, behavior fix only):**
```html
<velt-comments-sidebar-v2 page-mode="true"></velt-comments-sidebar-v2>
```

---

### 2. Setting a Location Always Re-Expands That Location's Group

**What:** When you call `setLocation()`, the sidebar now always expands the current location's group, even if that same group was collapsed in an earlier session and remembered across a reload.

**Why:** The sidebar remembers which groups a user collapsed (saved in session storage). After the `page-mode` fix above, the current location's group would float to the top but stay collapsed if the user had previously collapsed it. V1 always re-opens the current location's group on every `setLocation()` call, so V2 now does the same — while still keeping every other group's remembered expanded/collapsed state intact.

**Impact:** `setLocation()` reliably shows the current location's comments expanded, matching V1, without wiping the user's collapse choices for the other groups.

---

### 3. Sidebar Navigation Button Now Opens the Correct Comment in Long Lists

**What:** Clicking a comment's navigation button in the sidebar now always opens the correct comment, even in long, fast-scrolling lists.

**Why:** The sidebar reuses (recycles) row components as you scroll a large list. A recycled row would rebind to a new comment, but the navigation button was still using a cached id from the row's previous comment — so the click either did nothing or navigated to the wrong comment. The button now reads the row's current comment id first.

**Impact:** Navigation-button clicks in the virtualized sidebar list reliably open the comment you clicked on.

---
