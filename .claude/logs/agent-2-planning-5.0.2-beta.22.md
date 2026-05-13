# Release Update Plan for v5.0.2-beta.22

## Overview
- Release Type: Patch (beta)
- Key Changes: New `addCommentDraft` event for abandoned composer drafts; bug fixes to `addCommentAnnotation`, `addComment`, and `deleteCommentAnnotation` event firing correctness
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models — New Type
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes:
  - Add `ADD_COMMENT_DRAFT` → `addCommentDraft` row to the Threads enum table (around line 48–54, after `ADD_COMMENT_ANNOTATION_DRAFT`)
  - Add `AddCommentDraftEvent` interface block after `AddCommentAnnotationDraftEvent` (after line 74), with fields: `annotationId: string`, `commentAnnotation: CommentAnnotation`, `comment: Comment`, `metadata: VeltEventMetadata`
- Priority: High
- Anchor to use: `#addcommentdraftevent`

### 2. API Methods — Event Reference
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Changes: No signature changes needed. The `on()` / `useCommentEventCallback` section already covers all event types generically. No update required.
- Priority: None — skip

### 3. Documentation — Event Subscription Table
- File: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
- Changes:
  - Add `addCommentDraft` row to the Event Subscription table (around line 3552–3589), under the Threads category, after `addCommentAnnotation`:
    `| Threads | addCommentDraft | Triggered when user abandons a reply or edit composer without saving | AddCommentDraftEvent |`
  - Link Event Object to: `/api-reference/sdk/models/data-models#addcommentdraftevent`
- Priority: High

### 4a. UI Customization — Wireframes
- No changes needed. This release adds no new wireframes.

### 4b. UI Customization — Primitives
- No changes needed. This release adds no new primitive components or props.

### 5. Upgrade Guide
- No breaking changes. No update required.

## Implementation Sequence
1. Agent-3: Add `AddCommentDraftEvent` type + enum row to `data-models.mdx`
2. Agent-6: Add `addCommentDraft` row to the event subscription table in `customize-behavior.mdx`
3. Agent-4: No action
4. Agent-5: No action

## Quality Checklist
- [x] New type `AddCommentDraftEvent` flagged for data-models.mdx
- [x] Event subscription table in customize-behavior.mdx flagged for update
- [x] No API method signatures changed — api-methods.mdx needs no update
- [x] No wireframe or primitive changes
- [x] No breaking changes — upgrade-guide.mdx not touched
- [x] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.22.md`
