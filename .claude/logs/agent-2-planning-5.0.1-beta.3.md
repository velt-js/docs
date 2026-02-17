# Release Update Plan for v5.0.1-beta.3

## Overview
- Release Type: Patch
- Key Changes: V4 wireframe backward compatibility aliases for 4 props; edit composer reuses dialog-level composer wireframe; 6 behavioral bug fixes (nested wireframe propagation, CSS class names, mark-as-read, download button visibility, attachment spinner crash, sidebar deselection guard)
- Breaking Changes: No
- SDK Scope: HTML/Vanilla SDK only (Comments feature)

---

## Analysis: No New API Surface

This release contains zero new types, interfaces, methods, or hooks. Every change is either:
- A backward compatibility alias (props already in docs, mislabeled)
- A behavioral fix restoring v4 behavior with no API change

**Result: No updates required to `data-models.mdx` or `api-methods.mdx`.**

---

## Areas Requiring Updates

### 1. Data Models — Label Correction Only
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Anchor: `#optionsdropdownprops` (lines 1367–1380)
- Change: The `allowAssignment` and `allowEdit` rows are labeled "V1 alias" but the release note confirms these are v4→v5 compatibility aliases. Update description column from "V1 alias for X" to "V4 alias for X".
- Also: `allowToggleNotification` and `allowChangeCommentAccessMode` are named in the release note but are absent from the `OptionsDropdownProps` table entirely. These two props need to be added as new rows. Determine what their v5 equivalents map to (likely `enableNotifications` → `allowToggleNotification`, and `enablePrivateMode`/`enableChangeCommentAccessMode` → `allowChangeCommentAccessMode`) and insert matching rows.
- Priority: Medium
- Effort: ~5 min

### 2. UI Customization — Comment Dialog Primitives (allowAssignment label fix)
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-primitives/overview.mdx`
- Anchor: `#veltcommentdialogoptionsdropdown` (lines 1395–1407)
- Change: Same label fix as data-models — change "V1 alias" to "V4 alias" for `allowAssignment`, `allowEdit`, `allowNotifications`, `allowPrivateMode`, `allowMarkAsRead` in the props table. Add missing `allowToggleNotification` and `allowChangeCommentAccessMode` rows if they are confirmed props of this component.
- Priority: Medium
- Effort: ~5 min

---

## Areas Confirmed NOT Requiring Updates

### edit composer wireframe reuse
- `VeltCommentDialogWireframe.ThreadCard.EditComposer` and `velt-comment-dialog-thread-card-edit-composer-wireframe` are already documented in:
  - `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-structure.mdx` (lines 130, 150–151, 392, 412–413)
  - `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx` (lines 1556–1561, 1590, 2148–2167)
- The release note describes an internal rendering change (edit composer now reuses `velt-comment-dialog-composer-wireframe`) — the wireframe names and structure are unchanged. No doc update needed.

### Bug Fixes (all internal behavioral)
- Nested wireframe propagation — internal `querySelector` / signal passing; no wireframe names changed
- CSS class names restored (`velt-priority-dropdown-content-item`, etc.) — restores v4 names already in docs; no new classes added
- Mark-as-read in focused-thread/inline modes — internal state logic; no API change
- Download button visibility — internal access-control guard; no prop or method change
- Attachment spinner crash — internal `config.uiState` null guard; no API surface
- Sidebar deselection guard — internal state management; no API change

### No new data models, types, interfaces, hooks, or methods in this release.

---

## Implementation Sequence

1. In `data-models.mdx`, update "V1 alias" → "V4 alias" for the 5 existing `allow*` rows in `OptionsDropdownProps` (~2 min)
2. In `data-models.mdx`, add `allowToggleNotification` and `allowChangeCommentAccessMode` rows to `OptionsDropdownProps` with their v5 equivalents (~3 min)
3. In `comment-dialog-primitives/overview.mdx`, apply the same label correction and row additions to the props table in the `VeltCommentDialogOptionsDropdown` section (~5 min)

---

## Quality Checklist
- [ ] "V1 alias" corrected to "V4 alias" in `data-models.mdx` `OptionsDropdownProps` table
- [ ] `allowToggleNotification` row added to `data-models.mdx` `OptionsDropdownProps` table
- [ ] `allowChangeCommentAccessMode` row added to `data-models.mdx` `OptionsDropdownProps` table
- [ ] Same corrections applied to `comment-dialog-primitives/overview.mdx` props table
- [ ] No new documentation pages created (none required)
- [ ] No new wireframe structure entries (edit composer already documented)
- [ ] No migration guide created (no breaking changes)
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.1-beta.3.md`
