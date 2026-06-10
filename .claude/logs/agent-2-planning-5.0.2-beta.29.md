# Release Update Plan for v5.0.2-beta.29

## Overview
- Release Type: Patch
- Key Changes: 7 bug fixes across Comments and Documents features
- Breaking Changes: No

## Per-Item Analysis

### Item 1 — [Comments] Thread-card action buttons disappearing
- Internal fix in `CommentDialogOptionsDropdownComponent` and `CommentDialogThreadCardSeenDropdownComponent` via `CommentDialogActionService.threadCardDropdownOpen()`.
- No API change, no new types, no UI surface change.
- **No docs updates needed.**

### Item 2 — [Comments] Visibility dropdown not editable when composing
- `isVisibilityDropdownAuthor()` helper added internally in `VisibilityBannerDropdown` components.
- No API change, no new public method or type.
- **No docs updates needed.**

### Item 3 — [Comments] Visibility banner not appearing in composer
- `registerTempContext` merge bug fix; internal only.
- No API change.
- **No docs updates needed.**

### Item 4 — [Comments] Page-mode comment visibility not persisted
- `savePageComment` now forwards `_setAccessFields` via `buildPageCommentContext()`. Internal only.
- No API change.
- **No docs updates needed.**

### Item 5 — [Documents] Spurious resetServicesCache() on setDocuments() refresh
- `DocService.setDocumentsImpl` comparison fix; `getOptionsFromDocumentPaths()` internal mapping fix.
- No API change.
- **No docs updates needed.**

### Item 6 — [Documents] Documents with folderId not attached to folder on creation
- `PermissionQuery.resource` gains optional `parentFolderId?: string` field (additive).
- `PermissionQuery` IS documented user-facing:
  - `/api-reference/sdk/models/data-models.mdx` line 5919 — inline type for `resource` field
  - `/key-concepts/overview.mdx` line 1473 — links to PermissionQuery anchor (no inline type, no update needed)
- **One doc update required.**

### Item 7 — [Comments] Assign-user overlay mispositioned in wireframe-injected DOM
- `resolveOverlayOrigin()` internal positioning fix; walks ancestor chain past `display:contents`.
- No new wireframe component, no new primitive, no API change.
- **No docs updates needed.**

---

## Areas Requiring Updates

### 1. Data Models — PermissionQuery.resource type
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Line: 5919
- Change: Add `parentFolderId?: string` to the inline type definition of the `resource` property, and update the Description column to note it is present when the document was created with a `folderId` and is used to attach the document to its folder.
- Priority: Medium

## Implementation Sequence
1. Update `PermissionQuery.resource` inline type in `data-models.mdx` to include `parentFolderId?: string` — small, isolated edit.

## Quality Checklist
- [x] All new types added to data-models.mdx (parentFolderId on PermissionQuery.resource)
- [x] No new API methods — api-methods.mdx not touched
- [x] No new UI customization wireframes or primitives
- [x] No breaking changes — upgrade-guide.mdx not touched
- [x] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.29.md`
- [x] Items 1–5 and 7 explicitly confirmed as no-docs-needed
