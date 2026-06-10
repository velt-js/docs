# Release Update Plan for v5.0.2-beta.27

## Overview
- Release Type: Patch
- Key Changes: Two bug fixes — duplicate draft comment on submit (custom-actions hosts) and enablePrivateCommentMode() privacy regression
- Breaking Changes: No

## Current Docs State
The "wins over the legacy flag" language referenced as needing correction does NOT currently exist in any committed doc file. The beta.25 docs updates either were not merged to main or were never written. The planning below addresses both: (1) ensuring no incorrect precedence language exists anywhere, and (2) adding correct precedence language where needed.

## Areas Requiring Updates

### 1. Data Models — Privacy Precedence Correction
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes:
  - `CommentAnnotation.visibilityConfig` field description (line 44): Current text says "Defaults to `{ type: 'public' }` for new annotations without explicit visibility." This is fine as-is; no precedence claim exists here — no change needed.
  - `CommentAnnotationVisibilityConfig` section (line 289–300): No precedence language present — add a note: legacy `iam.accessMode === 'private'` wins unconditionally; `visibilityConfig.type` only applies when legacy flag is absent.
  - `CommentAccessMode` value table (lines 2035, 2046, 2047): These rows describe event payload fields — no precedence claim present — no change needed.
  - `CommentSidebarFilters.accessModes`: This field does NOT currently exist in the table (lines 2352–2368) — no change needed.
- Priority: Medium
- Owner: Agent-3

### 2. API Methods — New Public Method (isSubmitInFlight)
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Changes: Add entry for `isSubmitInFlight(dialogInstanceId?: string): boolean` on `CommentDialogActionService`. Document as advanced/internal use — similar treatment to other low-level service methods. Params: optional `dialogInstanceId: string`. Returns `boolean` — true if a submit is currently in flight for that dialog instance (or any instance if omitted). Note: hosts using custom submit actions should avoid re-triggering submit while this returns true.
- Priority: Medium
- Owner: Agent-3

### 3. Customize Behavior — Privacy Precedence Note
- File: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
- Changes: In the `enablePrivateCommentMode()` section (or `enablePrivateMode()` section), add a note clarifying precedence: legacy `iam.accessMode = 'private'` (set by `enablePrivateCommentMode()`) wins unconditionally over `visibilityConfig.type`. Users of both APIs can rely on consistent behavior after v5.0.2-beta.27.
- Priority: Medium
- Owner: Agent-3

### 4. UI Customization — Wireframe Variables — Privacy Indicator Annotation
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-bubble/wireframe-variables.mdx`
- Changes: Line 51 — `annotation.iam.accessMode` description currently shows `'public' | 'private'`. Add a clarifying note: this field reflects the legacy access mode; a value of `'private'` indicates the annotation was created with `enablePrivateCommentMode()` and wins over `visibilityConfig.type` for all privacy-gating UI surfaces (pin styling, Private badge, sidebar filters, viewer access control).
- Priority: Low
- Owner: Agent-4

### 5. UI Customization — Comment Dialog Wireframe Variables
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog/wireframe-variables.mdx`
- Changes: Verify no "visibilityConfig wins" language exists (grep confirmed none). No change needed unless Agent-4 finds language during read.
- Priority: Low (verify only)
- Owner: Agent-4

### 6. UI Customization — Comment Dialog Primitives
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog/primitives.mdx`
- Changes: Verify no "visibilityConfig wins" language exists (grep confirmed none). No change needed unless Agent-4 finds language during read.
- Priority: Low (verify only)
- Owner: Agent-4

## Implementation Sequence
1. Agent-3: Add `isSubmitInFlight()` to api-methods.mdx (new method documentation)
2. Agent-3: Add privacy precedence note to `CommentAnnotationVisibilityConfig` in data-models.mdx
3. Agent-3: Add privacy precedence note to customize-behavior.mdx enablePrivateCommentMode section
4. Agent-4: Annotate `annotation.iam.accessMode` row in comment-bubble/wireframe-variables.mdx
5. Agent-4: Verify comment-dialog/wireframe-variables.mdx and primitives.mdx — correct if incorrect language found

## Quality Checklist
- [ ] `isSubmitInFlight()` added to api-methods.mdx with params, return type, and usage note
- [ ] `CommentAnnotationVisibilityConfig` in data-models.mdx notes legacy flag precedence
- [ ] customize-behavior.mdx enablePrivateCommentMode section notes precedence fix
- [ ] comment-bubble/wireframe-variables.mdx `annotation.iam.accessMode` row clarified
- [ ] comment-dialog/wireframe-variables.mdx verified clean (no incorrect precedence language)
- [ ] comment-dialog/primitives.mdx verified clean (no incorrect precedence language)
- [ ] No breaking changes added to changelog (none exist)
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.27.md`
