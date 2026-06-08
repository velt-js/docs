# Release Update Plan for v5.0.2-beta.25

## Overview
- Release Type: Patch (beta)
- Key Changes: New `accessModes` filter on sidebar; WIREFRAME_VARIABLE_MAP extended to V2 primitives; new CommentService public methods; privacy routing through `visibilityConfig`; several sidebar/DOM-filter behavior changes worth documenting
- Breaking Changes: No

---

## Areas Requiring Updates

### 1. Data Models — `accessModes` field on `CommentSidebarFilters`
- **File:** `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- **Section:** `#### CommentSidebarFilters` (line ~2352)
- **Change:** Add new row to the existing table:
  ```
  | `accessModes` | `CommentAccessMode[]` | No | Filter by access mode. Values: `'public'` \| `'private'`. Recognizes both legacy `iam.accessMode` and new `visibilityConfig` (restricted, organizationPrivate → private; public → public). |
  ```
  Also add a new type definition block after `CommentSidebarFilters`:
  ```
  #### CommentAccessMode
  ---
  `type CommentAccessMode = 'public' | 'private'`
  ```
- **Agent:** 3
- **Priority:** High

### 2. API Methods — `setCommentSidebarFilters()` signature
- **File:** `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- **Section:** `#### setCommentSidebarFilters()` (line ~1640)
- **Change:** Update the Params line to include `accessModes?: CommentAccessMode[]`. Current text omits it entirely. New params line:
  `filters: CommentSidebarFilters` (link to data model) — no inline expansion needed since the data model now covers it.
- **Agent:** 3
- **Priority:** High

### 3. Customize Behavior — `setCommentSidebarFilters` section
- **File:** `/Users/yoenzhang/Downloads/docs/async-collaboration/comments-sidebar/customize-behavior.mdx`
- **Section:** `#### setCommentSidebarFilters` (line ~1183)
- **Change:** Add `accessModes: ['private']` (and `['public']`) to both React and Other Frameworks code examples. Add a brief note: "Use `accessModes` to filter by privacy. Accepts `'public'` and/or `'private'`. Works with both legacy `iam.accessMode` and the new `visibilityConfig` field."
- **Agent:** 4
- **Priority:** High

### 4. Customize Behavior — `setCommentSidebarData()` behavior changes
- **File:** `/Users/yoenzhang/Downloads/docs/async-collaboration/comments-sidebar/customize-behavior.mdx`
- **Section:** Step 2 "Update sidebar data based on custom logic" (line ~167) and nearby
- **Changes (three separate notes):**
  1. **Sidebar button filter count:** Add a note that the sidebar button filter count now correctly reflects counts from `setCommentSidebarData()` (previously the count was not reduced when custom sidebar data limited the annotation set).
  2. **Dedup behavior:** Add a note: "`setCommentSidebarData()` is a no-op when called with the same annotation id set as the current state — prevents unnecessary re-renders."
  3. **DOM filter dual-gate:** Add a note under or near `filterCommentsOnDom` (which lives in `/async-collaboration/comments/customize-behavior.mdx`): "When `filterCommentsOnDom` is enabled, annotations must satisfy *both* the active sidebar filter criteria *and* the id list from `setCommentSidebarData()`. Draft annotations bypass the id-list gate."
- **Agent:** 4
- **Priority:** Medium

### 5. Customize Behavior — `filterCommentsOnDom` behavior clarification
- **File:** `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
- **Section:** `#### filterCommentsOnDom` (line ~6304)
- **Change:** Extend the existing description to note the dual-gate AND logic: "When `setCommentSidebarData()` is also active, `filterCommentsOnDom` applies an AND — annotations must satisfy both the sidebar filter criteria and the custom id list. Draft annotations bypass the id-list gate."
- **Agent:** 4
- **Priority:** Medium

### 6. API Methods — new `CommentService` methods
- **File:** `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- **Section:** Comments → Custom Data subsection (near `setCommentSidebarData`)
- **Change:** Add two new method entries:
  ```
  #### getCustomSidebarDataAnnotationIds()
  Returns the current set of annotation ids supplied via setCommentSidebarData().
  - Params: none
  - Returns: `Set<string> | null`
  - React Hook: `n/a`

  #### getCustomSidebarDataAnnotationIds$()
  Returns an Observable that emits the current set of annotation ids supplied via setCommentSidebarData(); re-emits on every setCommentSidebarData() call and null on clearCache().
  - Params: none
  - Returns: `Observable<Set<string> | null>`
  - React Hook: `n/a`
  ```
  Mark both with an `<Note>Advanced / internal — prefer setCommentSidebarData() for most use cases.</Note>`.
- **Agent:** 3
- **Priority:** Low

### 7. Wireframe Variables — Notifications Panel: `isDefault` per-iteration alias
- **File:** `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/notifications/notifications-panel/wireframe-variables.mdx`
- **Section:** Context-Specific Variables / iteration table (line ~89)
- **Change:** Add `isDefault` row to the per-notification iteration table:
  ```
  | `isDefault` | `boolean` | `<velt-notifications-panel-content-list-...>` notification-item descendants | `velt-class="'default': {isDefault}"` |
  ```
  Add a note: "`isDefault` is `true` when the notification setting option is the default value for that settings accordion row."
- **Agent:** 5
- **Priority:** Medium

### 8. Wireframe Variables — Reactions: `reaction` per-iteration alias on tooltip user
- **File:** `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/reactions-wireframe-variables.mdx`
- **Section:** Context-Specific Variables / reaction-pin section (line ~77)
- **Change:** The `user` alias is already documented. Add `reaction` as a per-iteration alias inside `<velt-reaction-pin-tooltip-user-wireframe>`:
  ```
  | `reaction` | `ReactionAnnotation` | `<velt-reaction-pin-tooltip-user-wireframe>` and children | `<velt-data field="reaction.emoji" />` |
  ```
- **Agent:** 5
- **Priority:** Medium

### 9. Wireframe Variables — Inline Comments Section: `filteredComments` and `sortedComments` aliases
- **File:** `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/inline-comments-section/wireframe-variables.mdx`
- **Section:** Data State table (line ~49)
- **Change:** The release note names `filteredComments` and `sortedComments` as new V2 aliases alongside the existing `annotations` variable. Add two rows:
  ```
  | `filteredComments` | `CommentAnnotation[]` | Alias for `annotations` — filtered list for the section (V2 alias). | `<velt-data field="filteredComments.length" />` |
  | `sortedComments` | `CommentAnnotation[]` | Filtered + sorted list after sort order is applied (V2 alias). | `<velt-data field="sortedComments.length" />` |
  ```
- **Agent:** 5
- **Priority:** Medium

### 10. Wireframe Variables — Comment Bubble: `globalConfigSignal` alias note
- **File:** `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-bubble/wireframe-variables.mdx`
- **Section:** Global Config / Feature State table (line ~78)
- **Change:** `globalConfigSignal` is already documented as the access path. The release note confirms it is a new V2 global alias root registered in `NESTED_ACCESS_VARIABLES`. No new variable rows needed — verify that the existing `globalConfigSignal.*` entries are marked as available in V2 wireframes. If a V1/V2 distinction note is missing, add: "Available in both V1 and V2 Comment Bubble wireframes."
- **Agent:** 5
- **Priority:** Low

### 11. Primitives — Comment Dialog: `VeltCommentDialogPrivateBanner` and composer private badge suppression note
- **File:** `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog/primitives.mdx`
- **Sections:**
  - `### VeltCommentDialogPrivateBanner` (line ~2945)
  - Search for `VeltCommentDialogComposerPrivateBadge` (if it exists)
- **Change:** Below the existing usage block for `VeltCommentDialogPrivateBanner`, add a behavior note: "This banner is automatically hidden when `visibilityOptions` is active on `<VeltComments>` — the dropdown UI replaces the legacy banner. To keep the banner visible alongside the dropdown, do not render both simultaneously."  
  Apply the same note to `VeltCommentDialogComposerPrivateBadge` if that primitive is documented.
- **Agent:** 6
- **Priority:** Medium

### 12. Primitives — Comment Dialog: Make Private / Make Public items recognize `visibilityConfig`
- **File:** `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog/primitives.mdx`
- **Sections:**
  - `### VeltCommentDialogOptionsDropdownContentMakePrivate` (line ~1710)
  - `### VeltCommentDialogOptionsDropdownContentMakePrivateEnable` (line ~1730)
  - `### VeltCommentDialogOptionsDropdownContentMakePrivateDisable` (line ~1753)
- **Change:** Add a behavior note to all three: "These items now recognize `visibilityConfig.type` (`'restricted'` or `'organizationPrivate'`) as private states in addition to the legacy `iam.accessMode`. They are automatically suppressed (not rendered) when `visibilityOptions` is active on `<VeltComments>` — the dropdown replaces these items."
- **Agent:** 6
- **Priority:** Medium

### 13. Customize Behavior — smooth-scroll compatibility note (troubleshooting)
- **File:** `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
- **Section:** Add under a new subsection or an existing troubleshooting area
- **Change:** Add a note: "**Smooth-scroll library compatibility.** Velt includes an internal scroll shield that prevents smooth-scroll libraries (Lenis, GSAP ScrollSmoother, Locomotive Scroll, Divi smooth scroll) from interfering with comment pin placement. No configuration is required — this works automatically."
- **Agent:** 4
- **Priority:** Low

---

## Items with No Doc Update Required

- **Bug fix 1 (iPhone WKWebView CORS):** Internal Firebase auth change — no public API.
- **Bug fix 3 (Sidebar button filter count stability across open/close):** Internal rendering fix — no observable behavior change for integrators.
- **WIREFRAME_VARIABLE_MAP V2 extension (global aliases for Activity Log V2, Text Comment V2, Multi-thread Comment Dialog V2, Inline Comments Section V2, Comment Bubble V2):** All global variables (`isEnabled`, `allActivities`, `filteredActivities`, `groupedActivities`, `virtualScrollItems`, `activeFilter`, `availableFilters`, `expandedGroups`, `defaultVisibleCount`, `filterDropdownOpen`, `loading` for Activity Log; `showAdder`, `selectedWordsCount`, `position` for Text Comment; `filteredAnnotations`, `isSelected` for Multi-thread Comment Dialog; `composerCommentAnnotation`, `filterState`, `composerVariant` for Inline Comments Section) are already documented in their respective wireframe-variables pages. The V2 map extension is an implementation detail making existing docs accurate for V2 users — no new variables to add.
- **Per-iteration `dateGroup`, `activityRecord`, `filterOption`, `isActive`, `isExpanded` for Activity Log:** Already documented in activity-logs-wireframe-variables.mdx.
- **Per-iteration `filter`, `sortOption`, `sortOptionText`, `isAscending` for Inline Comments Section:** Already documented in inline-comments-section/wireframe-variables.mdx.
- **Per-iteration `isSelected` for Multi-thread Comment Dialog:** Already documented in multithread-comments/wireframe-variables.mdx.
- **Per-iteration `option` for Autocomplete:** Already documented in autocomplete-wireframe-variables.mdx.
- **velt-if iteration variable fix across 36 templates (Bug fix 9):** This is a runtime bug fix — the variables were already documented; no new rows needed.
- **Comment pin and dialog privacy routing through `isAnnotationPrivate()` / `visibilityConfig` (pin styling):** Internal routing change, no new public API or new props. The pin color change for private pins is covered by existing `isAnnotationPrivate` behavior. No new doc.

---

## Implementation Sequence

1. **Agent 3** — data-models.mdx (`CommentSidebarFilters` + `CommentAccessMode` type) + api-methods.mdx (`setCommentSidebarFilters` signature + two new `getCustomSidebarDataAnnotationIds` methods). No dependencies.
2. **Agent 4** — comments-sidebar/customize-behavior.mdx (`setCommentSidebarFilters` example + three `setCommentSidebarData` behavior notes) + comments/customize-behavior.mdx (`filterCommentsOnDom` dual-gate note + smooth-scroll troubleshooting note). Depends on Agent 3 completing data-models so links resolve.
3. **Agent 5** — four wireframe-variables files (notifications-panel `isDefault`, reactions `reaction` alias, inline-comments-section `filteredComments`/`sortedComments`, comment-bubble V2 note). Independent of Agents 3/4.
4. **Agent 6** — comment-dialog/primitives.mdx (private-banner suppression note + Make Private/Public `visibilityConfig` notes). Independent of Agents 3/4/5.

---

## Quality Checklist
- [ ] `CommentAccessMode` type added to data-models.mdx
- [ ] `CommentSidebarFilters.accessModes` row added to data-models.mdx
- [ ] `setCommentSidebarFilters()` params updated in api-methods.mdx
- [ ] `getCustomSidebarDataAnnotationIds()` and `$()` added to api-methods.mdx with advanced note
- [ ] `accessModes` example added to comments-sidebar/customize-behavior.mdx
- [ ] `setCommentSidebarData()` dedup + filter-count + dual-gate notes added to sidebar customize-behavior
- [ ] `filterCommentsOnDom` dual-gate AND clarification added to comments/customize-behavior.mdx
- [ ] Smooth-scroll compatibility note added to comments/customize-behavior.mdx
- [ ] `isDefault` added to notifications-panel wireframe-variables
- [ ] `reaction` alias added to reactions wireframe-variables
- [ ] `filteredComments` / `sortedComments` added to inline-comments-section wireframe-variables
- [ ] Comment Bubble V2 note verified / added
- [ ] `VeltCommentDialogPrivateBanner` suppression note added to primitives
- [ ] Make Private/Public `visibilityConfig` + suppression notes added to primitives
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.25.md`
