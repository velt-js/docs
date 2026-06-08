## QA Summary for v5.0.2-beta.23

### Issues Found: 2

1. **async-collaboration/suggestions/customize-behavior.mdx** — Broken anchor `#targeteditorstartevent` (extra "or") for `TargetEditStartEvent` link in the lifecycle events table.
   - Fix: Corrected to `#targeteditestartevent` to match the actual `#### TargetEditStartEvent` heading in data-models.mdx.

2. **async-collaboration/suggestions/overview.mdx** — Ambiguous anchor `#enablesuggestionmode` resolves to legacy `CommentElement.enableSuggestionMode()` (line 1343 in api-methods.mdx) because it is the first occurrence. The overview documents the new Suggestions API and should link to the `SuggestionElement` version (second occurrence).
   - Fix: Updated link to `#enablesuggestionmode-1` (Mintlify suffix for duplicate headings).

### Issues Not Found (verified clean)

- No `useSuggestionElement` (wrong hook name) anywhere in docs — correct hook `useSuggestionUtils` used consistently.
- All method names spelled correctly across new pages: `enableSuggestionMode`, `disableSuggestionMode`, `isSuggestionModeEnabled`, `isSuggestionModeEnabled$`, `startSuggestion`, `commitSuggestion`, `registerTarget`, `unregisterTarget`, `getSuggestions`, `getSuggestions$`, `getPendingSuggestion`, `getPendingSuggestion$`, `getSuggestionElement`.
- All hook names consistent: `useSuggestionUtils`, `useSuggestionModeState`, `useSuggestions`, `usePendingSuggestion`, `useEnableSuggestionMode`, `useDisableSuggestionMode`, `useRegisterTarget`, `useUnregisterTarget`, `useStartSuggestion`, `useCommitSuggestion`, `useSuggestionEventCallback`.
- All event names consistent: `suggestionCreated`, `suggestionApproved`, `suggestionRejected`, `suggestionStale`, `targetEditStart`, `targetEditCommit`.
- Status values consistent: `'pending'`, `'approved'`, `'rejected'`, `'stale'`, `'apply_failed'` (underscore verified).
- `data-velt-suggestion-target` attribute consistently lowercase and hyphenated across all new pages.
- React tabs use `client` / `useSuggestionUtils()` pattern correctly; Other Frameworks tabs use `Velt.getSuggestionElement()`.
- All React imports from `@veltdev/react` in code examples.
- `CommentAnnotation.suggestion?: SuggestionData` row present in data-models.mdx.
- docs.json Suggestions nav group correctly registered with 3 pages.
- Legacy `CommentElement.enableSuggestionMode()` and new `SuggestionElement.enableSuggestionMode()` are in clearly separate sections with no cross-contamination.
- All other event type anchors verified: `#suggestioncreatedevent`, `#suggestionapprovedevent`, `#suggestionrejectedevent`, `#suggestionstaleevent`, `#targeteditcommitevent` all match headings in data-models.mdx.
- `#getsuggestionelement`, `#registertarget` links in overview.mdx are unique headings — no suffix needed.
- `SuggestionElement` (PascalCase) and `suggestionElement` (camelCase) casing consistent throughout.

### Summary
- Files corrected: 2
- Critical issues: 1 (duplicate-heading anchor resolving to wrong method)
- Broken anchor fixes: 1 (typo: `targeteditorstart` → `targeteditestart`)
- False positives skipped: 0
- No search/replace sweeps needed beyond the 2 targeted fixes above
