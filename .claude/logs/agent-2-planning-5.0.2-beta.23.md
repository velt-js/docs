# Release Update Plan for 5.0.2-beta.23

## Overview
- Release Type: Minor (new top-level feature)
- Key Changes: Suggestions API v1 (brand-new typed suggestions system); Comment Dialog accept/reject buttons redesigned to SVG icons; bug fixes (no API changes)
- Breaking Changes: No

---

## Areas Requiring Updates

### 1. New Documentation Section — Suggestions Feature
- **Files to create**:
  - `async-collaboration/suggestions/overview.mdx`
  - `async-collaboration/suggestions/setup.mdx`
  - `async-collaboration/suggestions/customize-behavior.mdx`
- **Changes**: Full new feature docs covering: enabling suggestion mode, tagging DOM elements with `data-velt-suggestion-target`, suggestion lifecycle (pending → approved/rejected/stale/apply_failed), event handling, React hooks, and HTML/Vanilla JS usage.
- **Priority**: High
- **Pattern**: Follow `async-collaboration/arrows/` structure (overview + setup + customize-behavior).

### 2. Data Models
- **File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- **Changes**:
  - Add new top-level section `## Suggestions` with the following types documented as tables:
    - `Suggestion<T>` — discriminated union (fields: `status`, `data`, `targetId`, plus variant-specific)
    - `SuggestionStatus` — enum (`pending`, `approved`, `rejected`, `stale`, `apply_failed`)
    - `SuggestionMode` — type
    - `SuggestionTargetType` — type
    - `PendingSuggestion` — variant of `Suggestion<T>`
    - `ApprovedSuggestion` — variant
    - `RejectedSuggestion` — variant
    - `StaleSuggestion` — variant
    - `SuggestionData` — fields stored on `CommentAnnotation.suggestion`
    - `RegisterTargetConfig<T>` — config for `registerTarget()`
    - `EnableSuggestionModeConfig` — config for `enableSuggestionMode()`
    - `CommitSuggestionConfig<T>` — config for `commitSuggestion()`
    - `TargetGetter<T>`, `TargetEditDetails<T>`, `TargetEditCommitResult`, `TargetEditStartResult` — handler types
    - `TargetEditStartHandler<T>`, `TargetEditCommitHandler<T>`, `TargetEditCommitBuilder` — callback types
    - `SuggestionGetSuggestionsFilter` — filter type for `getSuggestions()`
    - `SuggestionElement` — the element class returned by `client.getSuggestionElement()`
    - Event payload types: `SuggestionCreatedEvent`, `SuggestionApprovedEvent`, `SuggestionRejectedEvent`, `SuggestionStaleEvent`, `TargetEditStartEvent`, `TargetEditCommitEvent`
    - `SuggestionEventTypesMap`, `SuggestionEventTypes`, `SuggestionEventType` — event constants
    - `Unsubscribe` — return type of subscription methods
  - Add `suggestion?: SuggestionData` row to existing `CommentAnnotation` table with note: "Present only when `annotation.type === 'suggestion'`. SDK-managed; read via `SuggestionElement` API."
- **Priority**: High

### 3. API Methods
- **File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- **Changes**:
  - Add new section `### getSuggestionElement()` (under client-level methods) returning `SuggestionElement`.
  - Add new section `## Suggestions` (or `### SuggestionElement Methods`) with all `SuggestionElement` methods:
    - `enableSuggestionMode(config?: EnableSuggestionModeConfig): void`
    - `disableSuggestionMode(): void`
    - `isSuggestionModeEnabled(): boolean`
    - `isSuggestionModeEnabled$(): Observable<boolean>`
    - `startSuggestion(targetId: string): void`
    - `commitSuggestion(config: CommitSuggestionConfig<T>): void`
    - `registerTarget(config: RegisterTargetConfig<T>): Unsubscribe`
    - `unregisterTarget(targetId: string): void`
    - `getSuggestions(filter?: SuggestionGetSuggestionsFilter): Suggestion<T>[]`
    - `getSuggestions$(filter?: SuggestionGetSuggestionsFilter): Observable<Suggestion<T>[]>`
    - `getPendingSuggestion(): PendingSuggestion<T> | null`
    - `getPendingSuggestion$(): Observable<PendingSuggestion<T> | null>`
  - Add event listener section for `SuggestionElement.on(eventType, handler)` covering: `suggestionCreated`, `suggestionApproved`, `suggestionRejected`, `suggestionStale`, `targetEditStart`, `targetEditCommit`.
  - Note: Existing `enableSuggestionMode()` / `acceptCommentAnnotation()` / `rejectCommentAnnotation()` on `CommentElement` are the legacy path — add a note distinguishing them from the new v1 API.
  - Link all methods to `[Full Documentation →](/async-collaboration/suggestions/setup)`.
- **Priority**: High

### 4. React Hooks
- **File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/react-hooks.mdx`
- **Changes**: Add new section `## Suggestions` with all 11 hooks:
  - `useSuggestionUtils()` — returns `SuggestionElement`
  - `useSuggestionModeState()` — returns `boolean | undefined`
  - `useSuggestions(filter?)` — returns `Suggestion<T>[]`
  - `usePendingSuggestion()` — returns `PendingSuggestion<T> | null`
  - `useEnableSuggestionMode()` — returns callback
  - `useDisableSuggestionMode()` — returns callback
  - `useRegisterTarget(config)` — registers on mount, unregisters on unmount
  - `useUnregisterTarget()` — returns callback
  - `useStartSuggestion()` — returns callback
  - `useCommitSuggestion()` — returns callback
  - `useSuggestionEventCallback(eventType, handler)` — subscribes on mount, cleans up on unmount/change
- **Priority**: High

### 5. Navigation (docs.json)
- **File**: `/Users/yoenzhang/Downloads/docs/docs.json`
- **Changes**: Add `Suggestions` group inside `Async Collaboration` section (alongside Arrows, Recorder, etc.):
  ```json
  {
    "group": "Suggestions",
    "pages": [
      "async-collaboration/suggestions/overview",
      "async-collaboration/suggestions/setup",
      "async-collaboration/suggestions/customize-behavior"
    ]
  }
  ```
- **Priority**: High

### 6. UI Customization — Wireframes
- **File**: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog/wireframes.mdx`
- **Changes**: The accept/reject buttons in the comment dialog now render SVG icons instead of text labels. Check whether the existing wireframe examples at lines ~4603–4647 include text content or a description of the buttons' appearance. If so, update the description to reflect the icon-based redesign. No new wireframe components are introduced — the existing `velt-comment-dialog-suggestion-action-accept-wireframe` and `velt-comment-dialog-suggestion-action-reject-wireframe` remain unchanged.
- **Priority**: Medium

### 7. UI Customization — Primitives
- **File**: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog/primitives.mdx`
- **Changes**: The existing primitives `velt-comment-dialog-suggestion-action-accept` and `velt-comment-dialog-suggestion-action-reject` (lines ~3959–3994) display SVG icon content. Update any prose that describes these as "text labels" to reflect the new SVG icon rendering.
- **Priority**: Low (cosmetic prose update only)

### 8. No New Wireframe Pages for Suggestions
- The Suggestions API (v1) is a pure JavaScript/event-driven API with no Velt-rendered UI components. It does not introduce new Web Component wireframes. No new wireframe pages needed.

### 9. No New Primitive Pages for Suggestions
- All UI surfaces (accept/reject) are already covered by existing comment dialog primitives. No new primitive component pages needed.

### 10. Skill Libraries Requiring Updates

#### Comments skill (`velt-comments-best-practices`)
- `CommentAnnotation` now has an optional `suggestion?: SuggestionData` field. Update the skill's data model reference.
- `addComment` event payload fix (reply now included) may appear in best practices guidance around event listeners.

#### New Suggestions skill (to be created or flagged)
- A new `velt-suggestions-best-practices` skill should be created covering: registering targets, suggestion lifecycle, event handling pattern, and React hooks usage. This is new territory with no existing skill.

#### Self-Hosting Data skill (`velt-self-hosting-data-best-practices`)
- Suggestions are persisted as `CommentAnnotation` objects with `type === 'suggestion'` and a `suggestion` field. Customers self-hosting comment data will receive suggestion annotations through the same data provider hooks. Flag in skill: suggestion annotations are included in comment data streams and the `suggestion` field should be stored/returned as-is.

---

## Implementation Sequence

1. Create `async-collaboration/suggestions/overview.mdx`, `setup.mdx`, `customize-behavior.mdx` — new feature docs; all other links depend on these paths.
2. Update `docs.json` — register the new Suggestions nav group.
3. Update `data-models.mdx` — add `CommentAnnotation.suggestion` row and full Suggestions type section.
4. Update `api-methods.mdx` — add `getSuggestionElement()` and all `SuggestionElement` methods.
5. Update `react-hooks.mdx` — add all 11 Suggestions hooks.
6. Update `comment-dialog/wireframes.mdx` — update accept/reject button description for icon redesign.
7. Update `comment-dialog/primitives.mdx` — update prose describing accept/reject buttons.
8. Flag `velt-comments-best-practices` skill for `CommentAnnotation` update.
9. Flag creation of `velt-suggestions-best-practices` skill.
10. Flag `velt-self-hosting-data-best-practices` skill for suggestion annotation handling note.

---

## Quality Checklist
- [ ] All new types added to data-models.mdx under a new `## Suggestions` section
- [ ] `CommentAnnotation` table updated with `suggestion?: SuggestionData` row
- [ ] All new APIs documented in api-methods.mdx
- [ ] All 11 React hooks documented in react-hooks.mdx
- [ ] Code examples include React and Other Frameworks tabs
- [ ] New Suggestions feature docs created at `/async-collaboration/suggestions/`
- [ ] docs.json updated with Suggestions nav group
- [ ] Breaking changes: none — no upgrade-guide entry needed
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.23.md`
