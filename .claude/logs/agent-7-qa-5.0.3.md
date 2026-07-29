# Agent-7 QA — core Velt SDK v5.0.3 (multi-org "Selected Teams" comment visibility)

Branch: `main` · Scope confirmed: exactly the 7 expected files modified. Backend changelogs (velt-node/velt-py) and `docs.json` untouched. `.claude/logs/agent-2-planning-5.0.3.md` is an untracked planning log, not a doc change.

## Issues Found: 1 (fixed)

1. **primitives.mdx** (`comment-dialog/primitives.mdx`, OrgPicker entry) — The new OrgPicker primitive prose claimed the picker appears "when visibility is set to `selected-teams`", mirroring the UserPicker sibling's `selected-people`. But `selected-teams` is NOT a real value: the `Content.Item` `type` enum (structure.mdx + wireframes.mdx) only lists `'public' | 'org-users' | 'personal' | 'selected-people'`, and the feature targets teams via `organizationPrivate` + `organizationIds` surfaced by `updateOrgList()` — not a new Item type (the brief confirms v5.0.3 adds the component, not an Item type). `selected-teams` appeared in NO other shipped doc.
   - Fix: Reworded to "scoping an `organizationPrivate` comment to specific teams (the 'Selected Teams' picker)… appears automatically once a team list is provided via `contactElement.updateOrgList()`." Now matches the changelog, customize-behavior, and the wireframe subsection. No invented enum value.

## Verification Coverage (per file)

- **sdk-changelog.mdx** — `<Update label="5.0.3" description="June 18, 2026">` sits above `5.0.2-beta.38`; `### New Features` (3) + `### Bug Fixes` (7), each a distinct `[**Comments**]` bullet (no merging); no code/wireframe blocks; all 4 learn-more anchors resolve; `<Update>` tags balanced (62/62 repo-wide); fences balanced.
- **data-models.mdx** — `CommentVisibilityConfig` has `organizationIds` row; `PrivateModeConfig = Omit<CommentVisibilityConfig, "annotationId">` (no longer omits `organizationId`) with `organizationId`/`organizationIds` rows; `OrgContact` + `UpdateOrgListConfig` sections well-formed; all `ts`/`typescript` fences balanced.
- **api-methods.mdx** — `updateOrgList()` present, mirrors `updateContactList()` format (no code examples — page convention; correct); `organizationIds` notes added to updateVisibility/enablePrivateMode/addCommentAnnotation.
- **customize-behavior.mdx** — `#### updateOrgList` section + React/Other Frameworks examples (React uses `client`, Other Frameworks uses `Velt` — correct); `organizationIds` examples added to updateVisibility/enablePrivateMode; fences balanced.
- **comment-dialog-structure.mdx** — `Content.OrgPicker` (React tree) + `…content-org-picker-wireframe` (HTML tree) added under VisibilityBanner.Dropdown.Content; consistent with existing tree.
- **wireframes.mdx** — OrgPicker added to both wireframe trees; new `##### **OrgPicker (Visibility Banner Dropdown Content)**` subsection (bold h5, mirrors UserPicker); `<velt-wireframe style="display:none;">` present; HTML uses separate open/close tags; fences balanced.
- **primitives.mdx** — OrgPicker entry mirrors UserPicker sibling (h3, "Common inputs only", no fabricated props table); primitive HTML has NO `-wireframe`; `#common-inputs` anchor resolves; fences balanced.

### Name mirror (exact strings, verified)
- Primitive: `VeltCommentDialogVisibilityBannerDropdownContentOrgPicker` / `velt-comment-dialog-visibility-banner-dropdown-content-org-picker` — no `-wireframe`.
- Wireframe: `VeltCommentDialogWireframe.VisibilityBanner.Dropdown.Content.OrgPicker` / `velt-comment-dialog-visibility-banner-dropdown-content-org-picker-wireframe` — has `-wireframe`.
- Segment-by-segment match, no casing drift. UserPicker siblings unchanged.

### Link integrity
All resolve: changelog → `#commentvisibilityconfig`, `#updateorglist`, `.../comment-dialog/primitives`; cross-doc → `#updateorglistconfig`, `#orgcontact`, `#privatemodeconfig`; customize-behavior anchor `#updateorglist`. Targets confirmed present in data-models.mdx (265/279/296/316), api-methods.mdx (681), customize-behavior.mdx (2159).

## Pre-existing flags (NOT fixed — out of scope)

- **Agent-6's reported `Content.Item` `type` enum drift could NOT be reproduced.** Agent-6 flagged a `selected-people` vs `selected-teams` split in structure.mdx's HTML tree. On inspection, structure.mdx uses `selected-people` consistently in BOTH the React tree (line 271) and the HTML tree (line 578); wireframes.mdx likewise uses `selected-people` throughout (lines 4274/4288/4299). The only `selected-teams` occurrence in shipped docs was the new OrgPicker primitive prose — which was a v5.0.3-introduced inaccuracy, now fixed above (Issue 1), not a pre-existing drift. No `selected-teams` Item type exists anywhere; flag is informational for the team in case the SDK ever introduces such a type.
- **Minor (note only, acceptable):** `CommentVisibilityConfig` prose lacks an explicit v5.0.3 sentence (`PrivateModeConfig` got one), but the `organizationIds` row is present and the anchor resolves. Optional, not fixed.

## Summary

- Files corrected: 1 (primitives.mdx)
- Genuine issues: 1 (fixed) — invented `selected-teams` enum value in OrgPicker prose
- Pre-existing flags: 1 reported by Agent-6 could not be reproduced (clarified above)
- Scope: 7/7 expected files; backend changelogs + docs.json untouched
- Name mirror, fences, MDX/JSX tags, anchors, headings: all pass
- **Overall: PASS.** Agent-1 ready for next release note.
