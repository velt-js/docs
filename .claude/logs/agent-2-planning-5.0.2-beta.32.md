# Release Update Plan for 5.0.2-beta.32

## Overview
- Release Type: Minor (beta)
- Key Changes: Agent Suggestion Comment Card UI with ~22 new primitives/wireframes; new `acceptSuggestion`/`rejectSuggestion` methods on `CommentActionsService` with 4 new request/event types.
- Breaking Changes: No

---

## Areas Requiring Updates

### 1. Data Models
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Section: After `#### RejectCommentAnnotationRequest` (line 1630) and after `#### RejectCommentAnnotationEvent` (line 1720)
- Changes:
  - Add `AcceptSuggestionRequest` — fields: `annotationId: string` (required), `options?: RequestOptions`
  - Add `RejectSuggestionRequest` — fields: `annotationId: string` (required), `rejectReason?: string`, `options?: RequestOptions`
  - Add `SuggestionAcceptEvent` — fields: `annotationId: string`, `commentAnnotation: CommentAnnotation`, `metadata: VeltEventMetadata`
  - Add `SuggestionRejectEvent` — fields: `annotationId: string`, `commentAnnotation: CommentAnnotation`, `rejectReason?: string`, `metadata: VeltEventMetadata`
  - These are DISTINCT from the existing `AcceptCommentAnnotationRequest` / `RejectCommentAnnotationRequest` (those are for suggestion-mode on human comments); the new types are agent-suggestion specific.
  - Insert under the `### Comment Dialog Primitives` section (line 1733): add prop types for the new agent suggestion primitives — `CommentDialogAgentSuggestionProps` (inherits `CommentDialogCommonProps`; no new unique props required unless Agent-3 identifies them from component signatures).
- Priority: High

### 2. API Methods
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Section A — new service methods: Insert after `#### enableSuggestionMode()` (line 1343), before `### Comment Read Status` (line 1350). Add a new sub-section `#### acceptSuggestion()` and `#### rejectSuggestion()` on `CommentActionsService`:

```
#### acceptSuggestion()
Accept an AI agent suggestion annotation.
- Params: `AcceptSuggestionRequest`, `source?: 'internal' | 'external'`
- Returns: `Promise<SuggestionAcceptEvent | null>`
- React Hook: `n/a`

#### rejectSuggestion()
Reject an AI agent suggestion annotation.
- Params: `RejectSuggestionRequest`, `source?: 'internal' | 'external'`
- Returns: `Promise<SuggestionRejectEvent | null>`
- React Hook: `n/a`
```

- Section B — new primitives: Insert after `#### VeltCommentDialogReplyAvatarsListItem` (line 1230), before `### Extra Information` (line 1237). Add ~22 entries for `VeltCommentDialogAgentSuggestion` and its sub-components, following the existing `#### ComponentName\nDescription\n- Params: ...\n- Returns: N/A\n- [Usage Examples →]()` pattern.

  Components to document (in hierarchy order):
  1. `VeltCommentDialogAgentSuggestion` — container for agent suggestion card
  2. `VeltCommentDialogAgentSuggestionHeader` — header with identity, timestamp, menu
  3. `VeltCommentDialogAgentSuggestionHeaderAgent` — agent-identity variant of header
  4. `VeltCommentDialogAgentSuggestionHeaderAuthor` — human-author variant of header
  5. `VeltCommentDialogAgentSuggestionHeaderAgentAvatar` — agent avatar with fallback icon
  6. `VeltCommentDialogAgentSuggestionHeaderAgentName` — agent display name
  7. `VeltCommentDialogAgentSuggestionHeaderAuthorAvatar` — human author avatar
  8. `VeltCommentDialogAgentSuggestionHeaderAuthorName` — human author name
  9. `VeltCommentDialogAgentSuggestionHeaderTimestamp` — relative timestamp
  10. `VeltCommentDialogAgentSuggestionHeaderMenu` — 3-dot overflow menu
  11. `VeltCommentDialogAgentSuggestionHeaderMenuTrigger` — menu trigger button
  12. `VeltCommentDialogAgentSuggestionHeaderMenuContent` — menu content container
  13. `VeltCommentDialogAgentSuggestionHeaderMenuContentItem` — individual menu item
  14. `VeltCommentDialogAgentSuggestionHeaderMenuContentItemIcon` — menu item icon
  15. `VeltCommentDialogAgentSuggestionHeaderMenuContentItemLabel` — menu item label
  16. `VeltCommentDialogAgentSuggestionBody` — bold title + comment body (truncated in sidebar)
  17. `VeltCommentDialogAgentSuggestionFooter` — footer container
  18. `VeltCommentDialogAgentSuggestionFooterOpenComment` — "Open Comment ↗" affordance
  19. `VeltCommentDialogAgentSuggestionActions` — accept/reject button group
  20. `VeltCommentDialogAgentSuggestionActionsActionAccept` — green check accept button
  21. `VeltCommentDialogAgentSuggestionActionsActionReject` — red ✕ reject button

  All use `CommentDialogCommonProps` params; link Usage Examples to `/ui-customization/features/async/comments/comment-dialog/primitives#veltcommentdialogagentsuggestion`.

- Priority: High

### 3. Documentation
- No new top-level feature pages needed. The agent suggestion card is a UI sub-feature of Comments, exposed entirely through primitives/wireframes.
- Priority: N/A

### 4a. UI Customization — Wireframes
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog/wireframes.mdx`
- Changes:
  1. In the Overview section (lines 14–57): add `<VeltCommentDialogWireframe.AgentSuggestion />` to the React tab and `<velt-comment-dialog-agent-suggestion-wireframe>` to the Other Frameworks tab, alongside the existing `SuggestionAction` entry.
  2. Add a new top-level `## Agent Suggestion` section after the existing `## Suggestion Action` section (after line 4691, before `## Styling`). Document the full component tree:
     - `## Agent Suggestion` (container)
     - `### Agent Suggestion Header`
     - `#### Agent (Agent Suggestion Header)` — VeltCommentDialogWireframe.AgentSuggestion.Header.Agent
     - `#### Author (Agent Suggestion Header)` — VeltCommentDialogWireframe.AgentSuggestion.Header.Author
     - `#### Avatar (Agent / Author)`, `#### Name (Agent / Author)`, `#### Timestamp`, `#### Menu`, `#### Menu Trigger`, `#### Menu Content`, `#### Menu Content Item`, `#### Icon (Menu Content Item)`, `#### Label (Menu Content Item)`
     - `### Agent Suggestion Body`
     - `### Agent Suggestion Footer`, `#### Open Comment (Agent Suggestion Footer)`
     - `### Agent Suggestion Actions`, `#### Accept (Agent Suggestion Actions)`, `#### Reject (Agent Suggestion Actions)`
  3. Each sub-section needs: `<Frame><img src="/images/customization/comments/comment-dialog/[Name].png" /></Frame>` + React/Other Frameworks `<Tabs>` code blocks.
  - NOTE: heading convention must use full parent path names per feedback (e.g. "Accept (Agent Suggestion Actions)" not just "Accept").
- Priority: High

### 4b. UI Customization — Primitives
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog/primitives.mdx`
- Changes:
  - Add a new `## VeltCommentDialogAgentSuggestion` section before the `## Notes` section (line 4211). Document all ~22 primitives with React + Other Frameworks tabs, following the pattern of existing sections (e.g. `VeltCommentDialogCustomAnnotationDropdown` at line 4187).
  - Add `VeltCommentDialogAgentSuggestion` and each sub-component with:
    - Usage example showing React JSX and HTML custom element
    - Props/Attributes: inherits `CommentDialogCommonProps`; note any unique props per component (e.g. `HeaderAgent`/`HeaderAuthor` selected by `annotation.sourceType`; `Actions` visible-when logic)
  - All prop types link to `/api-reference/sdk/models/data-models#commentdialogagentsuggestionprops` (new anchor to be created by Agent-3).
- Priority: High

### 5. Upgrade Guide
- Not applicable — no breaking changes.

---

## Implementation Sequence
1. Agent-3: Add `AcceptSuggestionRequest`, `RejectSuggestionRequest`, `SuggestionAcceptEvent`, `SuggestionRejectEvent` to `data-models.mdx` after existing `RejectCommentAnnotation*` entries; add `CommentDialogAgentSuggestionProps` to Comment Dialog Primitives section.
2. Agent-3: Add `acceptSuggestion()` and `rejectSuggestion()` to `api-methods.mdx` after `enableSuggestionMode()`; add ~22 primitive entries after `VeltCommentDialogReplyAvatarsListItem`.
3. Agent-4: Add `AgentSuggestion` wireframe tree to `wireframes.mdx` — update Overview code blocks, then add full `## Agent Suggestion` section before `## Styling`.
4. Agent-5: Add `## VeltCommentDialogAgentSuggestion` primitives section to `primitives.mdx` before `## Notes`.

---

## Key Anchors & Link Targets
- New data-models anchors: `#acceptsuggestionrequest`, `#rejectsuggestionrequest`, `#suggestionacceptevent`, `#suggestionrejectevent`, `#commentdialogagentsuggestionprops`
- New api-methods anchors: `#acceptsuggestion`, `#rejectsuggestion`, `#veltcommentdialogagentsuggestion`
- New primitives anchor: `#veltcommentdialogagentsuggestion`
- Custom element prefix: `velt-comment-dialog-agent-suggestion-*`
- Wireframe variant prefix: `VeltCommentDialogWireframe.AgentSuggestion.*`

---

## Quality Checklist
- [ ] `AcceptSuggestionRequest`, `RejectSuggestionRequest`, `SuggestionAcceptEvent`, `SuggestionRejectEvent` added to data-models.mdx
- [ ] `CommentDialogAgentSuggestionProps` type added to Comment Dialog Primitives section of data-models.mdx
- [ ] `acceptSuggestion()` and `rejectSuggestion()` documented in api-methods.mdx with correct param/return types
- [ ] All ~22 `VeltCommentDialogAgentSuggestion*` primitives listed in api-methods.mdx Comment Dialog Primitives section
- [ ] Wireframes Overview code blocks updated with `AgentSuggestion` entry
- [ ] Full `## Agent Suggestion` wireframe section added before `## Styling`
- [ ] Wireframe headings use full parent path convention (e.g. "Accept (Agent Suggestion Actions)")
- [ ] Primitives `## VeltCommentDialogAgentSuggestion` section added before `## Notes`
- [ ] All code examples include React / Next.js and Other Frameworks tabs
- [ ] No breaking changes in changelog (confirmed — N/A)
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.32.md`
