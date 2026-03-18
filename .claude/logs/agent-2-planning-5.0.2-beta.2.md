# Release Update Plan for 5.0.2-beta.2

## Overview
- Release Type: Minor (beta)
- Key Changes: New `commentSaveTriggered` event; past-tense aliases `commentToolClicked` and `sidebarButtonClicked`; Angular 20+ compatibility; boolean attribute fix for `comment-pin-selected` and `full-expanded`
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Priority: High

**Changes needed:**

**a. Add `CommentSaveTriggeredEvent` interface block** (after line ~97, after `CommentSavedEvent`):
```
#### CommentSaveTriggeredEvent
---

| Property | Type | Required | Description |
|---|---|---|---|
| `annotationId` | `string` | Yes | ID of the annotation whose save was triggered |
| `metadata` | `VeltEventMetadata` | Yes | Event metadata |
```

**b. Add `CommentToolClickedEvent` and `SidebarButtonClickedEvent` interface blocks** (after line ~1798, after `SidebarButtonClickEvent`):
```
#### CommentToolClickedEvent
---
Alias for `CommentToolClickEvent`. Identical payload shape.

```typescript
interface CommentToolClickedEvent extends CommentToolClickEvent {}
```

#### SidebarButtonClickedEvent
---
Alias for `SidebarButtonClickEvent`. Identical payload shape.

```typescript
interface SidebarButtonClickedEvent extends SidebarButtonClickEvent {}
```

**c. Add three new entries to the ENUMs table** at line ~1747 (the Comment Element ENUMs table):

| `COMMENT_SAVE_TRIGGERED` | `commentSaveTriggered` | Fires immediately when save button is clicked, before async save |
| `COMMENT_TOOL_CLICKED` | `commentToolClicked` | Past-tense alias for `commentToolClick` |
| `SIDEBAR_BUTTON_CLICKED` | `sidebarButtonClicked` | Past-tense alias for `sidebarButtonClick` |

---

### 2. API Methods / Event Subscription Table
- File: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
- Priority: High

**Changes needed:**

**a. Add three rows to the `on()` event table** (lines ~3097–3100):

```
| Threads | `commentSaveTriggered` | Fires before async save completes when user clicks save | [CommentSaveTriggeredEvent](/api-reference/sdk/models/data-models#commentsavetriggeredevent) |
| UI | `commentToolClicked` | Past-tense alias for `commentToolClick`, identical payload | [CommentToolClickedEvent](/api-reference/sdk/models/data-models#commenttoolclickedevent) |
| UI | `sidebarButtonClicked` | Past-tense alias for `sidebarButtonClick`, identical payload | [SidebarButtonClickedEvent](/api-reference/sdk/models/data-models#sidebarbuttonclickedevent) |
```

Insert `commentSaveTriggered` row adjacent to the existing `commentSaved` row (line 3100). Insert the two alias rows adjacent to `commentToolClick` and `sidebarButtonClick` rows (lines 3097–3098).

---

### 3. API Methods Reference (api-methods.mdx)
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Priority: Medium

**Changes needed:**

The `on()` entry (line ~683) references the customize-behavior event table. No signature change needed. No update required unless the reference note is updated to reflect new event types — this is handled by the customize-behavior.mdx update above.

No changes required to this file.

---

### 4. React Hooks (react-hooks.mdx)
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/react-hooks.mdx`
- Priority: Low

`useCommentEventCallback()` (line ~153) already links generically to the customize-behavior event table. No changes needed; the hook already works for all event types by string name.

---

### 5. UI Customization
- Not applicable. No new wireframes or UI components.

### 6. Migration Guides
- Not applicable. No breaking changes.

---

## Implementation Sequence
1. **data-models.mdx** — Add `CommentSaveTriggeredEvent` block after `CommentSavedEvent` (~line 97).
2. **data-models.mdx** — Add `CommentToolClickedEvent` and `SidebarButtonClickedEvent` blocks after `SidebarButtonClickEvent` (~line 1798).
3. **data-models.mdx** — Add `COMMENT_SAVE_TRIGGERED`, `COMMENT_TOOL_CLICKED`, `SIDEBAR_BUTTON_CLICKED` rows to ENUMs table (~line 1747).
4. **customize-behavior.mdx** — Add three rows to the `on()` event subscription table (~lines 3097–3100).

Steps 1–3 are independent of step 4 but step 4 anchor links depend on step 1–3 anchors being correct.

---

## Anchor Patterns
- New anchor for `CommentSaveTriggeredEvent`: `#commentsavetriggeredevent`
- New anchor for `CommentToolClickedEvent`: `#commenttoolclickedevent`
- New anchor for `SidebarButtonClickedEvent`: `#sidebarbuttonclickedevent`

All follow existing pattern: lowercase, no hyphens, concatenated interface name.

---

## Items Explicitly Not Requiring Doc Updates
- Angular 20+ compatibility: no new API surface, no doc change needed.
- Auto-exit focused thread mode: UX-only change.
- Window scroll position preserved: UX-only change.
- Boolean attribute fix (`comment-pin-selected`, `full-expanded`): bug fix with no API change; existing docs already show `'true'` as the value; no doc update needed.
- All internal refactors (triggerAddCommentEvent, filter methods, Set-based lookup, signal update, null guard): no public API impact.

---

## Quality Checklist
- [x] All new types added to data-models.mdx (3 new event interfaces)
- [x] Event table in customize-behavior.mdx updated with 3 new rows
- [x] No new API methods introduced — api-methods.mdx and react-hooks.mdx require no changes
- [x] No breaking changes to document
- [x] Anchor patterns verified against existing convention
- [x] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.2.md`
