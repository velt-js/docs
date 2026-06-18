# Release Update Plan for Velt Node SDK @veltdev/node v1.0.4

## Overview
- Release Type: Patch (additive, opt-in; no breaking changes)
- Key Changes: New opt-in `FieldFilterOptions` second arg on 8 REST add/update methods (`activities`, `commentAnnotations` incl. comment-level, `notifications`). `{ filterUnknownFields: true }` narrows requests to backend-accepted fields, dropping unknown top-level keys. Off by default, fail-open, top-level scoped. New exported field-allowlist module: `filterRequest`, `pickKnownFields`, types `FilterSpec`/`FieldFilterOptions`, and 8 `*_SPEC` constants.
- Breaking Changes: No.
- Branch note: On `main` (v1.0.2 baseline, 17 REST services). All 8 affected methods already exist here. Do NOT touch service count or v1.0.3 material.

## Areas Requiring Updates

### 1. Data Models — SKIP (lean: do not touch data-models.mdx)
- See KEY DECISION below. `FieldFilterOptions`/`FilterSpec` documented inline in node.mdx, not as `(Node)` sections.

### 2. API Methods — `api-reference/sdk/api/api-methods.mdx` — SKIP (per instructions)

### 3. Documentation — `backend-sdks/node.mdx` (only file to edit; Agent-3 owns it)
- Change A — Add new `### Field Allowlist` section.
  - Slug must resolve to `#field-allowlist` (matches both changelog `Learn more →` links).
  - Placement: inside `## REST API Backend`, immediately after the REST intro (after node.mdx ~L626, before `### Organizations` at ~L628). Feature-wide scope spanning 3 services justifies a single shared section ahead of the per-service blocks.
  - Content: opt-in `FieldFilterOptions` behavior (off by default, fail-open, top-level scoped — nested open-typed objects like `actionUser`/`context` pass through whole); exported primitives `filterRequest` and `pickKnownFields`; the 8 `*_SPEC` constants; inline `ts` shapes for `FilterSpec` and `FieldFilterOptions`; the addCommentAnnotations `{ filterUnknownFields: true }` example from the release note; the per-endpoint allowlisted-fields reference table; the `UPDATE_NOTIFICATIONS_SPEC` excludes `isRead`/`isArchived` note.
  - Mirror python.mdx pattern (`<Note>` summary + bullet refs), expanded with the table and primitives since Node ships exported utilities.
  - Priority: High.
- Change B — Annotate the 8 affected `#### method` blocks.
  - Add one bullet after the existing `Returns:` line: notes the optional `options?: FieldFilterOptions` second arg and cross-links `#field-allowlist` (mirror python.mdx "see the note above").
  - Targets (baseline line refs): `addNotifications` ~L1232, `updateNotifications` ~L1294, `addCommentAnnotations` ~L1388, `updateCommentAnnotations` ~L1485, `addComments` ~L1526, `updateComments` ~L1587, `addActivities` ~L1634, `updateActivities` ~L1699.
  - Do NOT add the note to any get/delete/count method or any other service.
  - Priority: High.

### 4a. UI Customization — Wireframes — N/A (backend SDK; no UI surface)
### 4b. UI Customization — Primitives — N/A (no primitive components or props)

### 5. Upgrade Guide — N/A (additive, opt-in; no breaking changes; never add to changelog)

### docs.json — No change needed (`backend-sdks/node` already registered at L333; `#field-allowlist` is an in-page anchor).

## KEY DECISION — FieldFilterOptions / FilterSpec type placement
Decision: Document INLINE as `ts` blocks within the new `### Field Allowlist` section in node.mdx. Do NOT add `(Node)` sections to data-models.mdx.

Justification:
- These are not method request-payload models — `FieldFilterOptions` is an options arg and `FilterSpec` describes the exported utilities' filter spec. data-models.mdx holds request/response payload types; these do not fit that category.
- Parallel precedent: velt-py v0.1.11 documented the identical feature inline on python.mdx (`<Note>` + per-method bullet, `velt_py.models.field_allowlists`) with no data-model entries. Mirroring keeps Node and Python consistent.
- Self-containment: keeping the types, primitives, table, and example in one section makes the opt-in feature readable in place and avoids cross-file anchor churn.

## Implementation Sequence (Agent-3)
1. Add `### Field Allowlist` section after the REST API Backend intro (~after L626) with behavior, primitives, `*_SPEC` list, inline `FilterSpec`/`FieldFilterOptions` shapes, addCommentAnnotations example, allowlisted-fields table, and `isRead`/`isArchived` exclusion note. Effort: Medium.
2. Add the `options?: FieldFilterOptions` + `#field-allowlist` bullet to the 8 affected method blocks only. Effort: Low.
3. Confirm anchor resolves to `#field-allowlist`; do not alter service count or v1.0.3 content. Effort: Low.

## Quality Checklist
- [ ] `### Field Allowlist` section added; anchor resolves to `#field-allowlist` (matches both changelog links).
- [ ] Section covers: opt-in/off-by-default, fail-open, top-level scoped; `filterRequest`/`pickKnownFields`; all 8 `*_SPEC` constants; inline `FilterSpec` + `FieldFilterOptions` `ts` shapes; addCommentAnnotations example; per-endpoint allowlisted-fields table; `isRead`/`isArchived` exclusion note.
- [ ] Exactly the 8 named methods annotated; no get/delete/count or other-service methods touched.
- [ ] Types documented inline; data-models.mdx NOT modified.
- [ ] api-methods.mdx NOT modified.
- [ ] No UI/wireframe/primitive/upgrade-guide edits; breaking changes not added to changelog.
- [ ] Service count (17) and v1.0.3 material untouched; docs.json unchanged.
- [ ] Log file written to `.claude/logs/agent-2-planning-velt-node-1.0.4.md`.
