# Release Update Plan for v5.0.2-beta.4

## Overview
- Release Type: Minor (new feature + improvements + breaking changes)
- Key Changes: Comment Visibility Banner replaces Visibility Dropdown; new `CommentVisibilityOptionType`; `AddCommentRequest.visibility` field; `VisibilityOptionClickedEvent` and `CommentSaveTriggeredEvent` updated; three breaking renames
- Breaking Changes: Yes
  1. `enableVisibilityOptionDropdown()` → `enableVisibilityOptions()`
  2. `disableVisibilityOptionDropdown()` → `disableVisibilityOptions()`
  3. `visibilityOptionDropdown` prop → `visibilityOptions` / `visibility-options`
  4. `velt-comment-dialog-visibility-dropdown-*` wireframe family removed → `velt-comment-dialog-visibility-banner-*`
  5. `VisibilityOptionClickedEvent.visibility` type widened from `'public' | 'private'` to `CommentVisibilityOptionType`

---

## Areas Requiring Updates

### 1. Data Models (`/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`)
- Priority: High

**Changes needed:**

a. **Add `CommentVisibilityOptionType`** — new union type for the UI-facing visibility option. Insert after the existing `CommentVisibilityType` block (line ~128). Content:
```typescript
type CommentVisibilityOptionType = 'personal' | 'selected-people' | 'org-users' | 'public';
```
Add a table with four values and descriptions matching the four banner options.

b. **Add `VisibilityOptionClickedEvent`** — new event interface. Does not yet exist in data-models.mdx. Add in the `# Comments` section under a `### Visibility` sub-section (or alongside the existing event types). Fields:
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `visibility` | `CommentVisibilityOptionType` | Yes | Selected visibility level |
| `users` | `User[]` | No | Populated only when `visibility === 'selected-people'` |
| `metadata` | `VeltEventMetadata` | No | Event metadata |

c. **Add `CommentSaveTriggeredEvent`** — new event interface. Does not yet exist. Add alongside other Thread events. Fields:
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `commentAnnotation` | `CommentAnnotation` | Yes | Full annotation at save time |
| `metadata` | `VeltEventMetadata` | No | Event metadata |

d. **Update `AddCommentRequest` (Messages section, line ~735)** — add optional `visibility` field:
| `visibility` | `CommentVisibilityConfig` | No | Set visibility at comment creation time |

e. **Update ENUMs table** in the appropriate section — add entries for:
- `VISIBILITY_OPTION_CLICKED` / `visibilityOptionClicked`
- `COMMENT_SAVE_TRIGGERED` / `commentSaveTriggered` (verify exact enum name against SDK)

---

### 2. API Methods (`/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`)
- Priority: High

**Changes needed:**

a. **Rename `enableVisibilityOptionDropdown()` → `enableVisibilityOptions()`** — search for existing entry. Based on codebase search, these methods do NOT currently exist in api-methods.mdx (only `enablePrivateMode`/`disablePrivateMode`/`updateVisibility` are present). Add two new entries after `disablePrivateMode()` (line ~157):

```
#### enableVisibilityOptions()
Enable the Comment Visibility Banner, allowing users to set per-comment visibility.
- Params: none
- Returns: `void`
- React Hook: `n/a`
- [Full Documentation →](/async-collaboration/comments/customize-behavior#enablevisibilityoptions)

#### disableVisibilityOptions()
Disable the Comment Visibility Banner.
- Params: none
- Returns: `void`
- React Hook: `n/a`
- [Full Documentation →](/async-collaboration/comments/customize-behavior#enablevisibilityoptions)
```

b. **Update `addComment()` entry** — all six `addComment()` entries (lines ~220–450) link to `AddCommentRequest`. The Messages-section `AddCommentRequest` (line ~735) needs the new `visibility` field (covered in Data Models above); no change to the api-methods.mdx method signature line itself, but verify the linked anchor resolves correctly after data-models update.

---

### 3. Comments Customize Behavior (`/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`)
- Priority: High

**Changes needed:**

a. **Add `enableVisibilityOptions` / `disableVisibilityOptions` section** in the `# Private Comments` section (after `disablePrivateMode`, line ~2748). Include:
- Description: enables the Visibility Banner on the comment composer
- Prop: `visibilityOptions` / `visibility-options` on `<VeltComments>` / `<velt-comments>`
- API methods: `commentElement.enableVisibilityOptions()` / `disableVisibilityOptions()`
- Four visibility levels: `public`, `org-users`, `personal`, `selected-people`
- Code examples in React/Next.js and Other Frameworks tabs

b. **Add `visibilityOptionClicked` event row** to the Event Subscription table (line ~3094). New row:
```
| Visibility | `visibilityOptionClicked` | Triggered when user selects a visibility option | [VisibilityOptionClickedEvent](/api-reference/sdk/models/data-models#visibilityoptionclickedevent) |
```

c. **Add `commentSaveTriggered` event row** to the Event Subscription table. New row:
```
| Threads | `commentSaveTriggered` | Triggered when comment save is initiated | [CommentSaveTriggeredEvent](/api-reference/sdk/models/data-models#commentsavetriggeredevent) |
```

d. **`AddCommentRequest.visibility` usage example** — add a note or example under the `# Private Comments` section showing how to pass `visibility` at comment creation time (mirrors the example in the changelog).

---

### 4. UI Customization — Comment Dialog Components (`/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`)
- Priority: High

**Changes needed:**

a. **Add `## Visibility Banner` section** — new top-level wireframe section documenting the 24+ primitive components in the `VeltCommentDialogWireframe.VisibilityBanner.*` / `velt-comment-dialog-visibility-banner-*` family. Place after the existing `## Composer` section (line ~3194).

The section must cover (in React/Other Frameworks tabs throughout):
- `VisibilityBanner` (root)
- `VisibilityBanner.Icon`
- `VisibilityBanner.Text`
- `VisibilityBanner.Dropdown`
  - `VisibilityBanner.Dropdown.Trigger`
    - `VisibilityBanner.Dropdown.Trigger.Label`
    - `VisibilityBanner.Dropdown.Trigger.AvatarList`
      - `VisibilityBanner.Dropdown.Trigger.AvatarList.Item`
      - `VisibilityBanner.Dropdown.Trigger.AvatarList.RemainingCount`
    - `VisibilityBanner.Dropdown.Trigger.Icon`
  - `VisibilityBanner.Dropdown.Content`
    - `VisibilityBanner.Dropdown.Content.Item` (type: `public` | `org-users` | `personal` | `selected-people`)
      - `VisibilityBanner.Dropdown.Content.Item.Icon`
      - `VisibilityBanner.Dropdown.Content.Item.Label`
    - `VisibilityBanner.Dropdown.Content.UserPicker`
      - `VisibilityBanner.Dropdown.Content.UserPicker.Search`
        - `VisibilityBanner.Dropdown.Content.UserPicker.Search.Icon`
        - `VisibilityBanner.Dropdown.Content.UserPicker.Search.Input`
      - `VisibilityBanner.Dropdown.Content.UserPicker.Header`
        - `VisibilityBanner.Dropdown.Content.UserPicker.Header.Count`
        - `VisibilityBanner.Dropdown.Content.UserPicker.Header.UnselectAll`
      - `VisibilityBanner.Dropdown.Content.UserPicker.Item`
        - `VisibilityBanner.Dropdown.Content.UserPicker.Item.Avatar`
        - `VisibilityBanner.Dropdown.Content.UserPicker.Item.Info`
        - `VisibilityBanner.Dropdown.Content.UserPicker.Item.Check`

b. **Update the root `VeltCommentDialogWireframe` overview snippet** (lines ~18–55) to add `<VeltCommentDialogWireframe.VisibilityBanner />` to the component tree. Add between `AssigneeBanner` and `Header` (or after Composer — match actual render order).

---

### 5. Migration Guide (`/Users/yoenzhang/Downloads/docs/release-notes/version-5/upgrade-guide.mdx`)
- Priority: High (breaking changes already added by Agent-1 — VERIFY completeness only)

Agent-1 has already written the upgrade guide entries. Verify:
- `enableVisibilityOptionDropdown()` → `enableVisibilityOptions()` rename is present with before/after code
- `visibilityOptionDropdown` prop → `visibilityOptions` rename is present with before/after code
- `velt-comment-dialog-visibility-dropdown-*` → `velt-comment-dialog-visibility-banner-*` wireframe migration is present
- `VisibilityOptionClickedEvent.visibility` type change (`'private'` → `'personal'`) is documented
- The `#TODO-confirm-doc-link` placeholder in sdk-changelog.mdx line 231 for `CommentVisibilityOptionType` must be replaced with `/api-reference/sdk/models/data-models#commentvisibilityoptiontype` after data-models is updated

---

## Implementation Sequence

1. **data-models.mdx** — Add `CommentVisibilityOptionType`, `VisibilityOptionClickedEvent`, `CommentSaveTriggeredEvent`; update `AddCommentRequest` (Messages). [High effort — 4 additions]
2. **api-methods.mdx** — Add `enableVisibilityOptions()` / `disableVisibilityOptions()` entries. [Low effort — 2 entries]
3. **customize-behavior.mdx** — Add `enableVisibilityOptions` section; add two event rows to the subscription table; add `AddCommentRequest.visibility` example. [Medium effort]
4. **comment-dialog-components.mdx** — Add full `## Visibility Banner` wireframe section with 24+ sub-components; update root overview snippet. [High effort — large wireframe tree]
5. **sdk-changelog.mdx** — Fix `#TODO-confirm-doc-link` anchor on line 231 after step 1 is done. [Trivial — single link fix]

---

## Anchor Pattern Reference

| Type | Anchor |
|------|--------|
| `CommentVisibilityOptionType` | `#commentvisibilityoptiontype` |
| `VisibilityOptionClickedEvent` | `#visibilityoptionclickedevent` |
| `CommentSaveTriggeredEvent` | `#commentsavetriggeredevent` |
| `enableVisibilityOptions` in customize-behavior | `#enablevisibilityoptions` |
| `visibilityOptionClicked` event subscription | `#on` (existing anchor) |

---

## Quality Checklist
- [ ] `CommentVisibilityOptionType` added to data-models.mdx with 4-value table
- [ ] `VisibilityOptionClickedEvent` added to data-models.mdx with `visibility` (required) and `users` (optional) fields
- [ ] `CommentSaveTriggeredEvent` added to data-models.mdx with `commentAnnotation` field
- [ ] `AddCommentRequest` (Messages section) updated with optional `visibility: CommentVisibilityConfig` field
- [ ] `enableVisibilityOptions()` and `disableVisibilityOptions()` added to api-methods.mdx
- [ ] `enableVisibilityOptions` / `visibilityOptions` prop section added to customize-behavior.mdx under `# Private Comments`
- [ ] `visibilityOptionClicked` and `commentSaveTriggered` rows added to Event Subscription table in customize-behavior.mdx
- [ ] `## Visibility Banner` section added to comment-dialog-components.mdx with all 24+ sub-components
- [ ] Root `VeltCommentDialogWireframe` overview snippet updated to include `VisibilityBanner`
- [ ] `#TODO-confirm-doc-link` placeholder in sdk-changelog.mdx fixed
- [ ] All code examples include React/Next.js and Other Frameworks tabs
- [ ] Breaking changes already present in upgrade-guide.mdx (verify completeness)
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.4.md`
