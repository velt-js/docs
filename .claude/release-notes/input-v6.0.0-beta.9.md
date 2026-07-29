# Velt SDK Release Notes - v6.0.0-beta.9
Release Date: July 10, 2026

## Summary
| SDK | Files Changed | Insertions | Deletions |
|-----|--------------|------------|-----------|
| HTML/Vanilla (sdk) | 74 | +1297 | -134 |
| React (sdk-react) | 3 | +4 | -4 |

> This release is another round of **Comment Sidebar V2** (`<velt-comments-sidebar-v2>`) parity and contract fixes, driven by an audit of the sidebar test harness. It fixes open/close events, filtering behavior, cross-page navigation, and a few input attributes. There is **one new public event (`fullscreenClick`)** and **no breaking changes**. The React SDK change is a version bump only.

## API Changes

### 1. New `fullscreenClick` Event on the Comment Sidebar

**What:** The sidebar fullscreen toggle now emits a public `fullscreenClick` event in addition to the existing component `onFullscreenClick` output. `fullScreen` is the new state after the toggle.

**Why:** Integrations need a way to react to the fullscreen toggle through the standard event API, not only the component-level output.

**Impact:** You can now react to fullscreen toggles through the standard event API — `commentElement.on('fullscreenClick')` or `useCommentEventCallback('fullscreenClick')` — without wiring up the component-level `onFullscreenClick` output.

**Type:**
```ts
interface FullscreenClickEvent {
  fullScreen: boolean;
  metadata?: VeltEventMetadata;
}
```

**HTML:**
```ts
const commentElement = client.getCommentElement();
commentElement.on('fullscreenClick').subscribe((event) => {
  console.log(event.fullScreen); // true = now fullscreen
});
```

**React:**
```tsx
const fullscreenEvent = useCommentEventCallback('fullscreenClick');
useEffect(() => {
  if (fullscreenEvent) {
    console.log(fullscreenEvent.fullScreen);
  }
}, [fullscreenEvent]);
```

---

## Bug Fixes

### 1. The `sidebarClose` Event Now Fires Every Time the Sidebar Closes

**What:** The `sidebarClose` event now fires once whenever the sidebar goes from open to closed — no matter how it was closed (the close button, an outside click, or the `closeCommentSidebar()` / `toggleCommentSidebar()` APIs).

**Why:** Closing the sidebar from code (`closeCommentSidebar()` / `toggleCommentSidebar()`) used to emit nothing — only the UI close button did. The event was also emitted from two different places, which risked firing it twice.

**Impact:** You get exactly one `sidebarClose` event on every close, whether the user or your code closed it.

```ts
const commentElement = client.getCommentElement();
commentElement.on('sidebarClose').subscribe(() => {
  // fires once for UI closes AND API closes
});
```

---

### 2. Reopening the Sidebar Starts Fresh

**What:** When the sidebar is closed and opened again, it no longer keeps the previously selected comment open. It reopens with no comment selected and the focused-thread view cleared. Expanded/collapsed groups are kept as they were.

**Why:** The selected-comment state from the previous session was carried over, so the sidebar could reopen with an old thread still expanded.

**Impact:** Each time the sidebar opens it shows a clean list, matching V1.

---

### 3. The "Resolved" Quick Filter Now Reveals Resolved Comments Instead of Hiding Everything Else

**What:** The built-in **Resolved** quick filter is now additive. Turning it on shows resolved comments **on top of** the currently visible statuses (by default Open and In Progress) instead of switching the list to show only resolved comments. Explicitly unchecking a status in the Status dropdown still hides it. The same applies to `default-minimal-filter="resolved"`.

**Why:** The old behavior filtered the list down to only terminal (resolved) comments, which didn't match how the Status dropdown selections are meant to combine.

**Impact:** "Resolved" now works as a reveal toggle — you see open, in-progress, and resolved comments together, which matches V1.

---

### 4. `dialog-selection="false"` Makes a Sidebar Comment Click Event-Only

**What:** With `dialog-selection="false"`, clicking a comment in the sidebar list now emits the `commentClick` event only — it does not select the comment, expand it inline, or open the focused-thread view.

**Why:** The `dialog-selection="false"` setting was not being honored on sidebar list clicks.

**Impact:** You can use the sidebar purely as a navigation/notification list and handle the click yourself, with no built-in selection side effects.

---

### 5. `embed-mode="false"` No Longer Embeds the Sidebar

**What:** Setting `embed-mode="false"` now correctly means "not embedded." Previously any value (including the literal string `"false"`) turned embed mode on.

**Why:** The attribute was treated as "on" whenever it had any non-empty value, so the string `"false"` was read as true.

**Impact:** `embed-mode="false"` behaves as expected. `embed-mode="true"` or an element id still embeds; a bare `embed-mode` with no value stays not-embedded.

---

### 6. `removeLocation()` With No Argument Now Clears the Current Location

**What:** Calling `removeLocation()` with no arguments now clears the current location. It used to do nothing.

**Why:** With no location passed, the public API path silently did nothing.

**Impact:** `removeLocation()` is now a simple way to clear the active location. Passing a specific location still removes only that one, and internal callers are unaffected.

```ts
Velt.removeLocation(); // clears the current location
```

---

### 7. Unknown Sidebar Filter Keys Are Ignored Instead of Emptying the List

**What:** When you pass filters through `setCommentSidebarFilters`, a key that doesn't correspond to any real filter field is now silently ignored. A valid filter that simply matches nothing still shows an empty list, as before.

**Why:** An unknown/typo filter key used to zero out the whole list instead of being skipped.

**Impact:** A stray or outdated filter key no longer blanks the sidebar — only real, meaningful filters affect the results.

---

### 8. The Default Filter Dropdown Hides When It Has Nothing to Show

**What:** The default filter (funnel) dropdown in the sidebar header no longer appears when it has no sections to display — for example when the status filter is turned off and no `mini-filters` are configured.

**Why:** The trigger was always rendered, so it could open an empty popover.

**Impact:** No empty filter dropdown. If you configure `mini-filters` or leave the status filter on, the dropdown shows as usual.

---

### 9. Custom-Data Sidebars Now Update When Filters Change

**What:** For sidebars powered by client-provided data, changing a quick filter, a category filter, or the client data now correctly emits a `commentSidebarDataUpdate` event with the filtered list.

**Why:** The update was being de-duplicated away because the snapshot used for change detection was taken before filters were applied, so filter changes looked like "no change."

**Impact:** The documented `setCommentSidebarFilters` → `commentSidebarDataUpdate` flow now works in V2, matching V1.

---

### 10. Clicking a Comment That Lives on Another Page Now Navigates to It

**What:** Selecting a comment whose pin is on a different page now navigates to that page, opens the sidebar, selects the comment (opening its thread), and scrolls the page to the comment's pin. If the comment can't be found within 15 seconds (for example it was deleted), the pending navigation is dropped so it can't hijack a later page load.

**Why:** This cross-page hand-off existed in V1 but was missing in Sidebar V2.

**Impact:** Cross-page comment navigation works again, and won't get "stuck" on a comment that never loads.

---

### 11. Resolved Comments No Longer Show Pins When They're Filtered Out

**What:** When the sidebar restores a saved filter state on load, the page pins are now kept in sync with that filter right away. With filter-comments-on-page enabled, resolved comments that are filtered out of the list no longer show pins on the page.

**Why:** On load with a restored filter, the pin filter was never applied, so every comment (resolved ones included) rendered a pin.

**Impact:** The pins shown on the page match the sidebar's filters immediately on load.

---

### 12. Comment Dialog Actions Always Target the Right Comment

**What:** Comment dialog actions (reply, edit, delete, resolve, assign, attachments, and so on) now consistently resolve which comment they act on the same way across every button, always preferring the comment the dialog is currently showing.

**Why:** Different dialog buttons resolved the comment id in slightly different orders. In reused/recycled dialogs — such as the virtual-scrolled sidebar list — a button could act on a stale comment id left over from a previous row.

**Impact:** Actions inside a comment dialog always apply to the comment you're looking at, even in fast-scrolling sidebar lists.

---
