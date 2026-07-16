# Release Update Plan for v5.0.3

## Overview
- Release Type: Minor (fully additive; no breaking changes)
- Key Changes: Multi-org "Selected Teams" comment visibility — `organizationIds?: string[]` on `CommentVisibilityConfig`; `PrivateModeConfig` Omit widened; new `contactElement.updateOrgList()` API (+ `OrgContact`, `UpdateOrgListConfig` types); new `OrgPicker` primitive + matching wireframe component.
- Breaking Changes: No. No `upgrade-guide.mdx` edit. Omit change is additive (a previously-omitted field is now accepted).
- docs.json: No change. OrgPicker/updateOrgList land on existing pages already in nav (docs.json L399–401). Confirmed.
- Bug fixes (7): Behavioral visibility-correctness fixes. Covered by the changelog; no separate doc-API edits. Confirmed.

## Areas Requiring Updates

### 1. Data Models — Agent-3 — Priority: High
File: `api-reference/sdk/models/data-models.mdx`
- `#### CommentVisibilityConfig` table (L271–276): add row `organizationIds` | `string[]` | No | "Target multiple organizations when `type` is `'organizationPrivate'`. Merged and de-duplicated with `organizationId`." Keep `organizationId` row.
- `#### PrivateModeConfig` (L282–294): change Omit to `Omit<CommentVisibilityConfig, 'annotationId'>` (drop `| 'organizationId'`); update the prose at L282 (it currently says "excludes `annotationId` and `organizationId`"); add `organizationId` and `organizationIds` rows to the props table.
- New types: add `OrgContact` (`id: string`; `name?: string`) and `UpdateOrgListConfig` (`orgList: OrgContact[]`). Place near contact/visibility models; mirror existing table format (Property | Type | Required | Description).

### 2. API Methods — Agent-3 — Priority: High
File: `api-reference/sdk/api/api-methods.mdx`
- New `#### updateOrgList()` immediately after `updateContactList()` (ends L676) / before `updateContactListScopeForOrganizationUsers()` (L678). Mirror the `updateContactList()` block format:
  - Params: [`config: UpdateOrgListConfig`](/api-reference/sdk/models/data-models#updateorglistconfig)
  - Returns: `void`; React Hook: `useContactUtils()`
  - Note full-replace semantics (every call replaces the list; `{ orgList: [] }` clears); exposed on `contactElement` only.
- `updateVisibility()` (L138–143) and `enablePrivateMode()` (L145–150): add a one-line `organizationIds: string[]` note (multi-org target; merged + de-duped with `organizationId`).
- `addCommentAnnotation()` (L9): note `visibility` accepts `organizationIds`.
File: `async-collaboration/comments/customize-behavior.mdx`
- `updateVisibility` full section (L2884–2964): add `organizationIds` to the `CommentVisibilityConfig` param bullets (after L2892) and add an `organizationPrivate` example using `organizationIds: ['org-1','org-2']` in BOTH tabs (React L2898+, Other Frameworks L2932+).
- `enablePrivateMode` full section: add the same `organizationIds` mention/example.
- Optional: add a brief `updateOrgList` mention near the `updateContactList` full section (L2115) if Agent-3 deems the picker needs a behavior anchor; otherwise the api-methods entry suffices.

### 4a. UI Customization — Wireframe — Agent-4 — Priority: Medium
The wireframe `OrgPicker` is the team analogue of `UserPicker`. Mirror UserPicker's structure (container + Search/Header/Item sub-tree) ONLY IF the SDK ships those sub-parts; the release spec describes the picker as a single component analogue, so default to the container component plus the same sub-children pattern as UserPicker and confirm against the SDK. At minimum add the container entry.
- File: `ui-customization/features/async/comments/comment-dialog-structure.mdx`
  - React tree: in `##### VeltCommentDialogWireframe.VisibilityBanner.Dropdown.Content` (L270–272), add `- VeltCommentDialogWireframe.VisibilityBanner.Dropdown.Content.OrgPicker` directly after the `...Content.UserPicker` line (L272). Add its own `#####` subsection after the UserPicker subsection (after L294) if sub-children are documented, mirroring L278–294.
  - HTML tree: after the user-picker wireframe block (L578, L584–600), add `velt-comment-dialog-visibility-banner-dropdown-content-org-picker-wireframe` entry mirroring the user-picker entry exactly.
- File: `ui-customization/features/async/comments/comment-dialog/wireframes.mdx`
  - In `#### Content (Visibility Banner Dropdown)` (L4264–4293): add `<VeltCommentDialogWireframe.VisibilityBanner.Dropdown.Content.OrgPicker />` (React, after L4275) and `<velt-comment-dialog-visibility-banner-dropdown-content-org-picker-wireframe>` (HTML, after L4288).
  - Add a new `##### **OrgPicker (Visibility Banner Dropdown Content)**` subsection immediately after the UserPicker subsection (UserPicker starts L4360; its block ends ~L4591). Mirror the UserPicker subsection format exactly: bold h5 title, React/Other Frameworks `<Tabs>`, `<VeltWireframe>` wrapper. If documenting sub-children, mirror UserPicker's `**Search/Header/Item ...**` bold sub-entries with `(Visibility Banner Dropdown Content OrgPicker)` parenthetical suffixes.
- File: `ui-customization/features/async/comments/comment-dialog/wireframe-variables.mdx`
  - Grep for the user-picker wireframe element here; add the analogous `OrgPicker` wireframe-variable entry only if UserPicker has one (mirror it). If UserPicker is absent from this file, no edit.

### 4b. UI Customization — Primitive — Agent-5 — Priority: Medium
- File: `ui-customization/features/async/comments/comment-dialog/primitives.mdx`
- New entry `### VeltCommentDialogVisibilityBannerDropdownContentOrgPicker` placed immediately after the UserPicker container entry `### VeltCommentDialogVisibilityBannerDropdownContentUserPicker` (L3545–3564) — i.e. insert after L3564 / before the `...UserPickerSearch` entry (L3568).
- Mirror the UserPicker container entry exactly (L3545–3564):
  - One-line description (team analogue): "Team picker for selecting specific organizations/teams when visibility is set to `selected-teams`."
  - React tab: `<VeltCommentDialogVisibilityBannerDropdownContentOrgPicker annotationId="abc123" />`
  - Other Frameworks tab: `<velt-comment-dialog-visibility-banner-dropdown-content-org-picker annotation-id="abc123"></velt-comment-dialog-visibility-banner-dropdown-content-org-picker>`
  - Props/Attributes: "Common inputs only (see [Common Inputs](#common-inputs) section)." — the primitive's three props (`annotationId`, `defaultCondition`, `inlineCommentSectionMode`) are already the documented Common Inputs (L62–70). Do NOT add a separate props table; match the sibling.
- Primitives belong ONLY here, NEVER in a wireframes/components page.

## Name-Mirror Spec (QA will diff exact strings)
| Surface | React / dotted name | HTML element |
| --- | --- | --- |
| Primitive | `VeltCommentDialogVisibilityBannerDropdownContentOrgPicker` | `velt-comment-dialog-visibility-banner-dropdown-content-org-picker` |
| Wireframe | `VeltCommentDialogWireframe.VisibilityBanner.Dropdown.Content.OrgPicker` | `velt-comment-dialog-visibility-banner-dropdown-content-org-picker-wireframe` |

Mirror rule: wireframe path = primitive name segment-by-segment. Primitive `...VisibilityBannerDropdownContentOrgPicker` ↔ wireframe `VisibilityBanner.Dropdown.Content.OrgPicker`; HTML wireframe = primitive HTML + `-wireframe` suffix. UserPicker is the exact sibling template for every entry. UI-customization headings use the full parent-path component name; wireframes.mdx h5 titles are bold.

## Implementation Sequence
1. Agent-3: data-models.mdx (`organizationIds`, `PrivateModeConfig` Omit, `OrgContact`, `UpdateOrgListConfig`) then api-methods.mdx (`updateOrgList()` + notes) then customize-behavior.mdx examples.
2. Agent-4: wireframe OrgPicker in comment-dialog-structure.mdx + wireframes.mdx (+ wireframe-variables.mdx if UserPicker present). Mirror UserPicker.
3. Agent-5: OrgPicker primitive in comment-dialog/primitives.mdx, after UserPicker container entry. Mirror UserPicker, "Common inputs only".
4. Agent-6: align terminology ("Selected Teams", OrgPicker, updateOrgList, organizationIds) repo-wide.
5. Agent-7: QA — diff primitive vs wireframe name strings; confirm no breaking-change content leaked into the changelog.

## Quality Checklist
- [ ] `organizationIds` added to `CommentVisibilityConfig` (data-models.mdx); `organizationId` retained.
- [ ] `PrivateModeConfig` Omit widened to `Omit<CommentVisibilityConfig, 'annotationId'>`; prose + table updated.
- [ ] `OrgContact` + `UpdateOrgListConfig` added to data-models.mdx.
- [ ] `updateOrgList()` documented in api-methods.mdx after `updateContactList()`; full-replace + `contactElement`-only noted.
- [ ] `organizationIds` notes added to `updateVisibility`/`enablePrivateMode`/`addCommentAnnotation` (api-methods + customize-behavior).
- [ ] OrgPicker wireframe added to comment-dialog-structure.mdx (React + HTML trees) and wireframes.mdx, mirroring UserPicker; h5 titles bold.
- [ ] OrgPicker primitive added to comment-dialog/primitives.mdx after UserPicker container; "Common inputs only".
- [ ] Primitive/wireframe name strings mirror segment-by-segment (per Name-Mirror Spec).
- [ ] All code examples include React / Next.js and Other Frameworks tabs.
- [ ] No breaking-change content in the changelog; no upgrade-guide edit.
- [ ] No docs.json change (verified pages already in nav).
- [ ] Log written to `.claude/logs/agent-2-planning-5.0.3.md`.
