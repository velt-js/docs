# Release Update Plan for v5.0.2-beta.34

## Overview
- Release Type: Minor (Beta), June 08, 2026
- Key Changes: setPageInfo/clearPageInfo API + hooks; VeltMultiThreadCommentDialog root export; 5 new React primitives; notifications-panel list inputs; React prop parity; standalone primitive support.
- Breaking Changes: Yes — 26 `VeltCommentsSidebarV2*` sub-component exports renamed to `VeltCommentSidebarV2*` (root unchanged). Already in upgrade-guide.mdx.

## Areas Requiring Updates

### 1. Data Models (Agent-3) — Priority: High
File: `api-reference/sdk/models/data-models.mdx`
- `#PageInfo` (~line 4296): add `arrowUrl`, `areaUrl`, `commentUrl`, `tagUrl`, `recorderUrl`, `screenWidth` (number), `deviceInfo` (IDeviceInfo); mark all fields optional per new class definition.
- `IDeviceInfo` does not exist in data-models.mdx — add a definition (verify shape) or link note.
- Add note that page info is readable via `documentMetadata.pageInfo` at `setDocumentId`/`setDocuments` time.
- Note: `options.documentId` on set/clearPageInfo is reserved for future per-document scope; document inline with methods, not as a new type.

### 2. API Methods (Agent-3) — Priority: High
File: `api-reference/sdk/api/api-methods.mdx`
- Add `setPageInfo(pageInfo: PageInfo, options?: { documentId?: string }): void` and `clearPageInfo(options?): void` (Methods → Params → Return Type → Example; React/Next.js tab first, Other Frameworks second). Include "documentId reserved, not active" note.

File: `api-reference/sdk/api/react-hooks.mdx`
- Add `useSetPageInfo()` and `useClearPageInfo()` entries near `useSetDocuments()` (~line 583). Note useSetPageInfo defers call until client ready.

### 3. Documentation / Customize Behavior (Agent-3) — Priority: Medium
- Add "Set custom page info" customize-behavior section where `setDocuments`/document setup is documented (verify placement: key-concepts or relevant customize-behavior page; "Customize behavior" goes in main feature docs, NOT ui-customization). Cover opt-in semantics: affects only newly created data (comments, reactions, recordings, presence, cursors).
- No other new feature pages needed; remaining items are primitives/props (Agent-5) or behavioral fixes (changelog only).

### 4a. UI Customization — Wireframes (Agent-4) — NO UPDATES NEEDED
- No new wireframes in this release. Agent-4 should pass through to Agent-5.

### 4b. UI Customization — Primitives (Agent-5) — Priority: High
- `ui-customization/features/async/comments/multithread-comments/primitives.mdx`: add `VeltMultiThreadCommentDialog` root section (props: annotationId, multiThreadAnnotationId, annotation, readOnly=false, defaultCondition=true, variant, inboxMode=false, onSaveComment) + note `<velt-multi-thread-comment-dialog>` is now a standalone custom element.
- `ui-customization/features/async/comments/comment-dialog/primitives.mdx`:
  - Add `VeltCommentDialogThreadCardAssignButton` and `VeltCommentDialogThreadCardEditComposer` (props: annotationId, defaultCondition, inlineCommentSectionMode, commentObj, commentId, commentIndex) in the ThreadCard sequence (~lines 413–658).
  - Add `VeltCommentDialogThreadCardReactionPin` (props: annotationId, defaultCondition, inlineCommentSectionMode, reactionId, commentObj, commentIndex, index) near `VeltCommentDialogThreadCardReactionTool` (~line 450).
  - Add `VeltAutocompletePanel` near `VeltAutocomplete` (~line 2421); props: type ('contact'|'generic', default 'contact'), hideInput=false, placeholder, multiSelect=false, selectedFirstOrdering=false, readOnly=false, inline=false, enableOnFocus=false, position ('above'|'below'|'auto', default 'auto'), defaultCondition=true.
  - `VeltCommentDialogOptionsDropdownContent` (~line 1573): add 7 props — commentObj, commentIndex, enableAssignment, enableEdit, enableNotifications, enablePrivateMode, enableMarkAsRead.
- `ui-customization/features/async/comments/inline-comments-section/primitives.mdx`: add `VeltInlineCommentsSectionFilterDropdownContentApplyButton` (props: targetElementId, defaultCondition) after FilterDropdownContentListItemLabel (~line 309).
- `ui-customization/features/async/notifications/notifications-panel/primitives.mdx`: add `listType` ('all'|'for-you', default 'all') and `documentId` props to `VeltNotificationsPanelContentList` (~line 812) and `VeltNotificationsPanelContentLoadMore`; note both ignored when `[notifications]` bound directly.
- Standalone-support pass (Medium): verify standalone annotation-id usage notes in comment-bubble, comment-pin, comment-sidebar-button (uses shared 'default' context), multithread-comments (multi-thread-annotation-id), inline-comments-section (target-element-id) primitives pages; add brief notes only where missing.
- VeltCommentDialog ~31-prop React parity (Low): TypeScript parity only, no behavior change; verify whether a root props table exists in `async-collaboration/comments/customize-behavior.mdx`; update only if a props table already documents the root, otherwise changelog-only.

### 5. Upgrade Guide — Priority: High (verify only)
File: `release-notes/version-5/upgrade-guide.mdx`
- Agent-1 already added the rename entry. Verify all 26 before/after pairs present and root `VeltCommentsSidebarV2` explicitly marked unchanged. Breaking change stays out of the changelog.

### 6. Repo-Wide Rename Audit (Agent-6/Agent-7) — Priority: High
Rename ONLY exact matches of the 26 listed sub-component exports (`VeltCommentsSidebarV2Skeleton` … `VeltCommentsSidebarV2FilterDropdownContentListCategoryContent`) to `VeltCommentSidebarV2*`. Root `VeltCommentsSidebarV2` and HTML element names unchanged. Diff exact name strings, not counts.
Files with occurrences (counts include root usages — do not blind-replace):
- `ui-customization/features/async/comments/comment-sidebar/comment-sidebar-v2-primitives.mdx` (141)
- `ui-customization/features/async/comments/comment-sidebar/comment-sidebar-v2-wireframes.mdx` (76) — wireframe component names mirror primitive names segment-by-segment; rename only if a name exactly matches a listed export (with/without `Wireframe` suffix per release-note scope — release note covers React exports only; flag any `VeltCommentsSidebarV2*Wireframe` names for human confirmation rather than auto-renaming).
- `ui-customization/features/async/comments/comment-sidebar-structure-v2.mdx` (27)
- `async-collaboration/comments-sidebar/setup.mdx` (4)
- `async-collaboration/comments-sidebar/customize-behavior.mdx` (1)
- `api-reference/sdk/models/data-models.mdx` (1)
- `release-notes/version-5/sdk-changelog.mdx` / `upgrade-guide.mdx`: historical entries stay as-is; only the new entry uses new names.

### Changelog-Only Items (no doc updates)
- All 7 bug fixes (updateContactList, enableCrossOrganization hashing, inline assign menu, reaction pin standalone, sidebar-button context, autocomplete resolution, composer stability).
- People tab org-mode fix (behavioral, no API change).

## Implementation Sequence
1. Agent-3: data-models.mdx PageInfo + IDeviceInfo; api-methods.mdx set/clearPageInfo; react-hooks.mdx hooks; customize-behavior page-info section. (Medium effort)
2. Agent-4: no wireframe work — pass through. (None)
3. Agent-5: 5 new primitives + props additions across 4 primitives pages + standalone notes pass. (High effort)
4. Agent-6: alignment scan using Agent-1 release note + this plan. (Medium effort)
5. Agent-7: SidebarV2 rename audit per rules above; exact-string diff. (Medium effort, high care)

## Quality Checklist
- [ ] PageInfo new fields added to data-models.mdx; IDeviceInfo defined or linked
- [ ] setPageInfo/clearPageInfo in api-methods.mdx; useSetPageInfo/useClearPageInfo in react-hooks.mdx
- [ ] Code examples include React/Next.js and Other Frameworks tabs
- [ ] All 5 new primitives documented; props tables match release note exactly
- [ ] listType/documentId added to both notifications-panel list primitives
- [ ] Breaking change ONLY in upgrade-guide.mdx, not changelog
- [ ] Rename applied only to the 26 exact export names; root + HTML elements untouched
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.34.md`
