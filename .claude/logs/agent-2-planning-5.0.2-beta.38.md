# Release Update Plan for v5.0.2-beta.38

## Overview
- Release Type: Minor (beta) — new features + breaking changes
- Key Changes: Comment Sidebar V2 declarative filter/sort/group/search; full primitive+wireframe decomposition of the filter UI; new public method `applyCommentSidebarClientFilters()`; new Sidebar V2 config types; new read-only annotation fields; fail-closed PII allowlist for self-host DB writes.
- Breaking Changes: Yes —
  1. `MinimalActionsDropdown` family removed (replaced by combined `actions` dropdown via `minimal-filters`).
  2. `VeltCommentsSidebarV2` `position` prop narrowed `string` → `'right' | 'left'`.

## Naming invariants (enforce everywhere)
- Root element PLURAL: `velt-comments-sidebar-v2` / `VeltCommentsSidebarV2`.
- Standalone sub-primitives SINGULAR: `velt-comment-sidebar-…-v2` / `VeltCommentSidebarV2*`.
- Wireframe forms PLURAL: `velt-comments-sidebar-…-v2-wireframe` / `VeltCommentsSidebarV2Wireframe.*`.

---

## Areas Requiring Updates

### 1. Data Models — `api-reference/sdk/models/data-models.mdx`
- Add read-only fields to existing tables (anchor `#commentannotation` already used by changelog):
  - `CommentAnnotation`: `involvedUserIds: string[]`, `mentionedUserIds: string[]` (after line 49).
  - `Comment` (line 952): `sourceType: string`, `agent: CommentAnnotationAgent`, `metadata: VeltEventMetadata`.
  - `ReactionAnnotation` (line 1630): `involvedUserIds: string[]`.
- Add new Sidebar V2 config types (new `#### ` blocks): `FilterField`, `SidebarMinimalFilterConfig`, `SidebarSortConfig`, `SidebarQuickFilterConfig`, `SidebarAnnotationGroup`, and `BUILT_IN_FILTER_FIELD_IDS`. Place under Comments → Threads grouping.
- Add/confirm `VeltCommentsSidebarV2Props` block (referenced from customize-behavior line 1379, anchor `#veltcommentssidebarv2props`); ensure `position` typed `'right' | 'left'`.
- Priority: High

### 2. API Methods — `api-reference/sdk/api/api-methods.mdx`
- Add `#### applyCommentSidebarClientFilters()` under `### Threads` (after line 215, before `### Slate`). Creates anchor `#applycommentsidebarclientfilters` used by changelog item 3.
- Use existing method format: one-line desc, Params, Returns, React Hook, Full Documentation link to `/async-collaboration/comments-sidebar/customize-behavior#v2-sidebar-behavior`.
- Priority: High

### 3. Documentation (behavior) — `async-collaboration/comments-sidebar/customize-behavior.mdx`
- Under `# V2 Sidebar Behavior` (line 1335), document: `filters`, `mini-filters`, `minimal-filters`, `filter-operator`, `sort-by`/`sort-order`/`sort-data`, `group-config`, search box, `full-screen`/`onFullscreenClick`, shadow DOM isolation.
- Anchor `#v2-sidebar-behavior` already resolves (heading exists) — confirm it stays.
- Add `position: 'right' | 'left'` already present in Props table (line 1370) — keep consistent.
- Priority: High

### 4a. UI Customization — Wireframes — `ui-customization/features/async/comments/comment-sidebar/comment-sidebar-v2-wireframes.mdx`
- REMOVE all `MinimalActionsDropdown` wireframe slots (lines ~131–243): `MinimalActionsDropdown`, `.Trigger`, `.Content`, `.Content.MarkAllRead`, `.Content.MarkAllResolved`. Replace header reference (line 93) with the new `actions` dropdown.
- ADD wireframe slots (PLURAL `VeltCommentsSidebarV2Wireframe.*`): filter button, full Main Filter container tree, decomposed search slots, list group header, fullscreen button, filter-dropdown sub-slots.
- Follow heading conventions: full parent-path names, bold h5 titles (per memory feedback).
- Priority: High

### 4b. UI Customization — Primitives — `ui-customization/features/async/comments/comment-sidebar/comment-sidebar-v2-primitives.mdx`
- REMOVE primitives (SINGULAR + the React plural-root composite): `VeltCommentsSidebarV2MinimalActionsDropdown` family (lines ~301–433) and `velt-comment-sidebar-minimal-actions-dropdown-v2`.
- ADD ~60 React prop/component interfaces for new primitives: filter button, Main Filter container tree, decomposed search, list group header, fullscreen button, filter-dropdown sub-slots. Props tables with React/Next.js + Other Frameworks tabs.
- Anchor `comment-sidebar-v2-primitives` (no fragment) used by changelog items 2/7/11 — page must keep resolving.
- Priority: High

### 5. Self-Hosting doc — `self-host-data/overview.mdx`
- Add a fail-closed PII allowlist note (after `## How it works` line 22, or in `## Excluding & extending fields` line 447): only allowlisted non-PII fields written to Velt DB when a resolver is configured; known-PII (`commentText`, `commentHtml`, `targetTextRange.text`) dropped; data to your own resolver never filtered. No `@veltdev/types` change.
- Anchor `/self-host-data/overview` used by changelog item 5 — already resolves.
- Priority: Medium

### 6. Upgrade Guide (breaking changes ONLY) — `release-notes/version-5/upgrade-guide.mdx`
- Insert under `## Breaking Changes` (after line 19, BEFORE `## How to Upgrade` line 21). Anchor `/release-notes/version-5/upgrade-guide` used by changelog items 14/15.
- See exact Before/After entries in the Agent-6 section below.
- Priority: High

### 7. Structure page (verify) — `ui-customization/features/async/comments/comment-sidebar-structure-v2.mdx`
- Verify removed `MinimalActionsDropdown` is gone and new filter/search/group/fullscreen slots are reflected in the structure tree.
- Priority: Medium

---

## Implementation Sequence
1. Agent-3: data-models.mdx (fields + config types + `VeltCommentsSidebarV2Props`) and api-methods.mdx (`applyCommentSidebarClientFilters()`). Anchors created first so links resolve. [Medium effort]
2. Agent-4: wireframes page (remove MinimalActionsDropdown, add filter/search/group/fullscreen slots) + customize-behavior V2 section. [High effort]
3. Agent-5: primitives page (remove MinimalActionsDropdown, add ~60 new interfaces). [High effort]
4. Agent-6: alignment + upgrade-guide breaking-change entries + self-host note. [Medium effort]
5. Agent-7: repo-wide QA terminology (plural/singular/wireframe naming, removed-component sweep). [Low effort]

## Quality Checklist
- [ ] New annotation fields added to data-models.mdx (`CommentAnnotation`, `Comment`, `ReactionAnnotation`)
- [ ] New Sidebar V2 config types + `BUILT_IN_FILTER_FIELD_IDS` added; `#commentannotation` anchor intact
- [ ] `applyCommentSidebarClientFilters()` documented; `#applycommentsidebarclientfilters` anchor resolves
- [ ] Code examples include React/Next.js + Other Frameworks tabs
- [ ] `MinimalActionsDropdown` removed from BOTH primitives and wireframes pages
- [ ] Breaking changes in upgrade-guide.mdx ONLY (NOT the changelog body beyond the link)
- [ ] Naming: plural-root vs singular-primitive vs plural-wireframe verified repo-wide
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.38.md`
</content>
</invoke>
