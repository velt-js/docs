# Release Update Plan for 5.0.2-beta.37

## Overview
- Release Type: Patch (beta) — additive only
- Key Changes: Opt-in `collapsedRepliesPreview` flag (API method pair + attribute + React prop + wireframe variable); "More Reply" divider split into `VeltCommentDialogMoreReplyCount` / `VeltCommentDialogMoreReplyText` sub-primitives; new `australiaSouthEast1` Firebase region for `setEncryptedData`.
- Breaking Changes: No. Do NOT add any breaking-change/upgrade-guide content.

## Path corrections (verified against repo)
- Primitives live at `ui-customization/features/async/comments/comment-dialog/primitives.mdx` (NOT a `comment-dialog-primitives/overview.mdx` and NOT `comment-dialog-components.mdx` — neither exists here). Release note anchor `/ui-customization/features/async/comments/comment-dialog/primitives#veltcommentdialogmorereply` is correct.
- Wireframe slots → `wireframes.mdx`; wireframe variables → `wireframe-variables.mdx` (separate file).

## Areas Requiring Updates

### 1. Data Models
- Skip. The `FirebaseRegion` union gaining `'australiaSouthEast1'` is an internal type; the public region option is typed `string` with no published `.d.ts` shape change. No new consumer-facing type. No `data-models.mdx` edit.

### 2. API Methods
- File: `api-reference/sdk/api/api-methods.mdx`
- Changes: Add `enableCollapsedRepliesPreview()` and `disableCollapsedRepliesPreview()` under the "Toggle Comment Types" group (near `enablePopoverMode()`, ~line 1345). Params: none; Returns: `void`; React Hook: `n/a`. Mirror the existing enable/disable entry format. Anchor for `enablecollapsedrepliespreview` must exist for the changelog link to resolve.
- Priority: High

### 3. Documentation (customize-behavior)
- File: `async-collaboration/comments/customize-behavior.mdx`
- Changes: Add a `collapsedRepliesPreview` section documenting the opt-in flag and all four surfaces — `enableCollapsedRepliesPreview()` / `disableCollapsedRepliesPreview()`, `collapsed-replies-preview` attribute, `collapsedRepliesPreview` React prop, `collapsedRepliesPreview` wireframe variable. Default `false`. React/Next.js tab first, Other Frameworks second. This is the `customize-behavior` "Full Documentation →" target for the new methods.
- Priority: High

### 4a. UI Customization — Wireframes
- File: `ui-customization/features/async/comments/comment-dialog/wireframes.mdx`
- Changes: Under "MoreReply (Body Threads)" (~line 3018), add the two new sub-slots `VeltCommentDialogWireframe.MoreReply.Count` / `.Text` (web: `velt-comment-dialog-more-reply-count-wireframe` / `-text-wireframe`). React tab first, Other Frameworks second; match adjacent slot formatting.
- File: `ui-customization/features/async/comments/comment-dialog/wireframe-variables.mdx`
- Changes: (a) In `comment-dialog-more-reply` (~line 1469), add `collapsedRepliesPreview` to the variables table and note the two new child sub-slots. (b) Document the `collapsed-replies-preview` host attribute / `collapsedRepliesPreview` wireframe variable and its `shouldShow` interaction with the collapsed teaser.
- Priority: High

### 4b. UI Customization — Primitives
- File: `ui-customization/features/async/comments/comment-dialog/primitives.mdx`
- Changes: Under existing `VeltCommentDialogMoreReply` (~line 3862), add `VeltCommentDialogMoreReplyCount` and `VeltCommentDialogMoreReplyText` as standalone primitives (web tags `velt-comment-dialog-more-reply-count` / `velt-comment-dialog-more-reply-text`) and document the React `.Count` / `.Text` sub-properties of `VeltCommentDialogMoreReply`. React/Next.js tab first, Other Frameworks second; Props = Common inputs only, matching sibling entries.
- Priority: High

### 5. Upgrade Guide
- N/A. No breaking changes.

## Open item — needs human confirmation (do NOT fabricate)
- `setEncryptedData` `australiaSouthEast1` region: no existing MDX doc target anywhere in repo (`self-host-data/*` has no Firebase-region/cloud-function config page). The changelog `#TODO-confirm-doc-link` placeholder cannot be resolved to an existing anchor.
- Action: Verify whether a self-hosting region-config doc should be created or whether the bullet should drop the "Learn more" link. Until confirmed, leave the bullet as additive prose with no broken link. Flag to maintainer.

## Implementation Sequence
1. Agent-3: Add the two enable/disable methods to `api-methods.mdx` (anchor must match changelog link).
2. Agent-3/docs: Add `collapsedRepliesPreview` section to `customize-behavior.mdx` (link target for the new methods).
3. Agent-4: Add `.Count` / `.Text` wireframe sub-slots in `wireframes.mdx`; add `collapsedRepliesPreview` variable + attribute in `wireframe-variables.mdx`.
4. Agent-5: Add `VeltCommentDialogMoreReplyCount` / `VeltCommentDialogMoreReplyText` primitives + `.Count`/`.Text` sub-properties in `primitives.mdx`.
5. Agent-6/7: Resolve or remove the `setEncryptedData` TODO link; terminology pass on "Show N replies…" / "collapsed replies preview" naming.

## Quality Checklist
- [ ] `enableCollapsedRepliesPreview` / `disableCollapsedRepliesPreview` added to api-methods.mdx with matching anchor
- [ ] `collapsedRepliesPreview` documented across all four surfaces in customize-behavior.mdx
- [ ] `.Count` / `.Text` added to wireframes.mdx and primitives.mdx
- [ ] `collapsed-replies-preview` attribute + variable added to wireframe-variables.mdx
- [ ] Code examples include React/Next.js and Other Frameworks tabs (React first)
- [ ] No breaking-change content added anywhere
- [ ] `setEncryptedData` TODO link resolved or removed (no broken link shipped)
- [ ] Log written to `.claude/logs/agent-2-planning-5.0.2-beta.37.md`
