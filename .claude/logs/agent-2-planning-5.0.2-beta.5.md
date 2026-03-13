# Release Update Plan for v5.0.2-beta.5

## Overview
- Release Type: Minor
- Key Changes: 13 new autocomplete primitive components, new autocomplete panel props, new CommentVisibilityOption enum, expanded AccessRequestEvent/SEMEvent fields, new analytics events
- Breaking Changes: Yes — visibility option type strings renamed; 10 visibility user-picker sub-components removed

## Areas Requiring Updates

### 1. Data Models
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Priority: High

**Changes needed:**

**a. Add `CommentVisibilityOption` enum section** (new type — does not exist yet)
Insert before or after the existing `CommentVisibilityType` section (line 122):
```
#### CommentVisibilityOption
---
Enum for comment visibility levels.

```typescript
export declare enum CommentVisibilityOption {
  RESTRICTED_SELF = "restrictedSelf",
  RESTRICTED_SELECTED_PEOPLE = "restrictedSelectedPeople",
  ORGANIZATION_PRIVATE = "organizationPrivate",
  PUBLIC = "public"
}
```

| Value                       | Description                                        |
|-----------------------------|----------------------------------------------------|
| `RESTRICTED_SELF`           | Visible only to the comment author                 |
| `RESTRICTED_SELECTED_PEOPLE`| Visible only to specifically selected users        |
| `ORGANIZATION_PRIVATE`      | Visible to users in the organization               |
| `PUBLIC`                    | Visible to all users                               |
```

**b. Add `CommentVisibilityOptionType` type section** immediately after `CommentVisibilityOption`:
```
#### CommentVisibilityOptionType
---
String union type derived from `CommentVisibilityOption` enum values.

```typescript
export type CommentVisibilityOptionType = `${CommentVisibilityOption}`;
// = 'restrictedSelf' | 'restrictedSelectedPeople' | 'organizationPrivate' | 'public'
```
```

**c. Update `AccessRequestEvent` table** (line 2565) — add 3 new fields:
```
| `totalUsers`               | `number`   | No | Total number of users currently present on the document. |
| `presenceSnippylyUserIds`  | `string[]` | No | Velt internal user IDs of currently present users.       |
| `presenceClientUserIds`    | `string[]` | No | Client-provided user IDs of currently present users.     |
```

**d. Update `SEMEvent` table** (line 2576) — add the same 3 new fields:
```
| `totalUsers`               | `number`   | No | Total number of users currently present on the document. |
| `presenceSnippylyUserIds`  | `string[]` | No | Velt internal user IDs of currently present users.       |
| `presenceClientUserIds`    | `string[]` | No | Client-provided user IDs of currently present users.     |
```

**e. Add analytics event models section** (new section — does not exist yet)
Add a new `# Analytics Events` section. Include the following models:

- `CommentAnalyticsEvent` — fields: `eventType` (`'COMMENT_ADDED' | 'COMMENT_STATUS_CHANGED'`), `annotationId`, `commentId`, `commentAnnotationCreatedAt`, `taggedClientUserIds`, `taggedSnippylyUserIds`
- `ReactionAnalyticsEvent` — fields: `eventType` (`'REACTION_ADDED' | 'REACTION_DELETED'`), `annotationId`, `commentId`, `reactionId`, `commentMode`
- `CrdtAnalyticsEvent` — fields: `eventType` (`'CRDT_DATA_UPDATED'`), plus relevant CRDT identifiers

Note: Verify exact field names and types against SDK source before writing. Use the release note description as the source of truth for field names.

---

### 2. UI Customization — Autocomplete Primitives
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`
- Priority: High

**Changes needed:**

**a. Add `VeltAutocomplete` panel props section** — new section documenting the 5 new props on the `<VeltAutocomplete>` / `<velt-autocomplete>` panel component:

| Prop | React | HTML attr | Type | Description |
|---|---|---|---|---|
| multiSelect | `multiSelect` | `multi-select` | `boolean` | Allows selecting multiple contacts |
| selectedFirstOrdering | `selectedFirstOrdering` | `selected-first-ordering` | `boolean` | Shows selected items first in the list |
| readOnly | `readOnly` | `read-only` | `boolean` | Disables user interaction |
| inline | `inline` | `inline` | `boolean` | Renders autocomplete inline rather than as a panel |
| contacts | `contacts` | — | `User[]` | Overrides the default contact list |

Include React/Other Frameworks code example matching the changelog pattern.

**b. Add standalone autocomplete primitive components section** — document the 13 new primitive components. These are standalone (non-wireframe) components independently importable without `<velt-autocomplete>`.

Document each with its React/HTML names, and for those with inputs:
- `VeltAutocompleteChip` / `velt-autocomplete-chip`: props `type`, `email`, `userObject`, `userId`
- `VeltAutocompleteOption` / `velt-autocomplete-option`: props `userObject`, `userId`
- `VeltAutocompleteOptionDescription` / `velt-autocomplete-option-description`: prop `field`

**c. Add `VeltAutocompleteEmptyWireframe` section** — document empty-state customization wireframe with React and Other Frameworks examples (use changelog code block verbatim).

---

### 3. UI Customization — Comment Dialog Components (Breaking Change Cleanup)
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`
- Priority: High

**Changes needed:**

Remove any documentation of `VeltCommentDialogVisibilityBannerDropdownContentUserPicker*` components and their HTML wireframe equivalents (`velt-comment-dialog-visibility-banner-dropdown-content-user-picker-*-wireframe`). These 10 components are no longer exported.

Search the file for `UserPicker` to confirm presence before removing. (Current grep shows these do NOT appear in this file — they are only in changelog/upgrade-guide — so this task may be a no-op. Verify.)

---

### 4. UI Customization — Wireframe Type Values (Breaking Change)
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`
- Priority: High

**Changes needed:**

Any existing usage of `VeltCommentDialogWireframe.VisibilityBanner.Dropdown.Content.Item` with `type` values `"personal"`, `"selected-people"`, or `"org-users"` must be updated to `"restrictedSelf"`, `"restrictedSelectedPeople"`, and `"organizationPrivate"` respectively.

Search the file for these old type string values. (Current grep shows these do NOT appear in this file — they are only in changelog/upgrade-guide — so this task may be a no-op. Verify before skipping.)

---

### 5. Migration Guide (Breaking Changes — already in upgrade-guide.mdx)
- File: `/Users/yoenzhang/Downloads/docs/release-notes/version-5/upgrade-guide.mdx`
- Status: ALREADY COMPLETE — Agent-1 has written the breaking changes for this version.
- No additional edits needed.

---

## Implementation Sequence
1. `data-models.mdx`: Add `CommentVisibilityOption` enum and `CommentVisibilityOptionType` type (new types, referenced by upgrade-guide links).
2. `data-models.mdx`: Add `totalUsers`, `presenceSnippylyUserIds`, `presenceClientUserIds` to `AccessRequestEvent` and `SEMEvent`.
3. `data-models.mdx`: Add analytics event models section (`CommentAnalyticsEvent`, `ReactionAnalyticsEvent`, `CrdtAnalyticsEvent`).
4. `comment-dialog-components.mdx`: Add `VeltAutocomplete` panel props section.
5. `comment-dialog-components.mdx`: Add standalone autocomplete primitive components section (13 components).
6. `comment-dialog-components.mdx`: Add `VeltAutocompleteEmptyWireframe` section.
7. `comment-dialog-components.mdx`: Verify and remove any `UserPicker` sub-component docs if present.
8. `comment-dialog-components.mdx`: Verify and update any old visibility type string values if present.

## Quality Checklist
- [ ] `CommentVisibilityOption` enum added to `data-models.mdx` with anchor `#commentvisibilityoption`
- [ ] `CommentVisibilityOptionType` type added to `data-models.mdx` with anchor `#commentvisibilityoptiontype`
- [ ] `AccessRequestEvent` updated with 3 new fields
- [ ] `SEMEvent` updated with 3 new fields
- [ ] Analytics event models section added to `data-models.mdx`
- [ ] `VeltAutocomplete` panel props (multiSelect, selectedFirstOrdering, readOnly, inline, contacts) documented
- [ ] 13 standalone autocomplete primitive components documented with React/HTML tabs
- [ ] `VeltAutocompleteEmptyWireframe` empty-state customization section added
- [ ] `UserPicker` sub-components verified absent from comment-dialog-components.mdx (or removed)
- [ ] Old visibility type strings verified absent from comment-dialog-components.mdx (or updated)
- [ ] Code examples follow React/Next.js first, Other Frameworks second tab order
- [ ] `upgrade-guide.mdx` breaking changes confirmed complete — no edits needed
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.5.md`
