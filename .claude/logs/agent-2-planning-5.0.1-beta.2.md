# Release Update Plan for 5.0.1-beta.2

## Overview
- Release Type: Patch
- Key Changes: New attachment download control API (2 methods, 1 prop, 1 event + interface); wireframe nesting change for resolve/unresolve buttons; new conditional CSS classes for composer attachments and assign-to menu
- Breaking Changes: No — download is enabled by default; wireframe structural change is additive

---

## Areas Requiring Updates

### 1. Data Models
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Anchor: `#attachments` (line 824)
- Change: Add `AttachmentDownloadClickedEvent` interface table after `DeleteAttachmentEvent` (line 945) and add `ATTACHMENT_DOWNLOAD_CLICKED` row to the Attachments ENUMs table (line 827).

  New ENUM row to add to the table at line 827:

  | `ATTACHMENT_DOWNLOAD_CLICKED` | `attachmentDownloadClicked` | Fired on every attachment click regardless of download setting |

  New interface table to insert after `DeleteAttachmentEvent` (after line 954):

  #### AttachmentDownloadClickedEvent

  | Property            | Type                | Required | Description                                         |
  |---------------------|---------------------|----------|-----------------------------------------------------|
  | `annotationId`      | `string`            | Yes      | ID of the annotation containing the attachment      |
  | `commentAnnotation` | `CommentAnnotation` | Yes      | Comment annotation object                           |
  | `attachment`        | `Attachment`        | Yes      | The attachment that was clicked                     |
  | `metadata`          | `VeltEventMetadata` | No       | Event metadata                                      |

- Priority: High

### 2. API Methods — api-methods.mdx (Attachments section)
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Anchor: `#attachments` (line 558)
- Change: Add two new method entries after `enableAttachments()` (line 560) and before `enableScreenshot()` (line 567):

  #### enableAttachmentDownload()
  Allow clicking an attachment to trigger a file download.
  - Params: none
  - Returns: `void`
  - React Hook: `n/a`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior#enableattachmentdownload)

  #### disableAttachmentDownload()
  Prevent clicking an attachment from triggering a file download; `attachmentDownloadClicked` still fires.
  - Params: none
  - Returns: `void`
  - React Hook: `n/a`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior#enableattachmentdownload)

- Priority: High

### 3. API Methods — customize-behavior.mdx (on() event table + new section)
- File: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`

  **Change A — on() event table** (line 2976–2977, Attachments rows):
  Add a new row after `deleteAttachment`:

  | Attachments | `attachmentDownloadClicked` | Fired on every attachment click regardless of download setting | [AttachmentDownloadClickedEvent](/api-reference/sdk/models/data-models#attachmentdownloadclickedevent) |

  **Change B — new `enableAttachmentDownload` section** after the `enableAttachments` section (line 3068):
  Add a new `#### enableAttachmentDownload` subsection following the same pattern as `#### enableAttachments` (lines 3033–3068). Include:
  - Description: Controls whether clicking an attachment triggers a file download. Default: `true`. The `attachmentDownloadClicked` event fires on every click regardless of this setting.
  - `attachmentDownload` prop on `<VeltComments>` / `<velt-comments>`
  - `enableAttachmentDownload()` / `disableAttachmentDownload()` API methods
  - `useCommentEventCallback('attachmentDownloadClicked')` hook (React) and `commentElement.on('attachmentDownloadClicked').subscribe(...)` (Other Frameworks)
  - Both React / Next.js and Other Frameworks tabs with code examples matching the release note

- Priority: High

### 4. UI Customization — Wireframe Structure (comment-dialog-structure.mdx)
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-structure.mdx`
- Anchor: `#velt-comment-dialog-assignee-banner-wireframe` (line 285)
- Change: Add `velt-comment-dialog-assignee-banner-unresolve-button-wireframe` as a leaf child of `velt-comment-dialog-assignee-banner-wireframe`. Currently only `velt-comment-dialog-assignee-banner-resolve-button-wireframe` is listed; the unresolve variant was always absent from docs but is now a first-class wireframe.

  Current:
  ```
  ### `velt-comment-dialog-assignee-banner-wireframe`
  - `velt-comment-dialog-assignee-banner-resolve-button-wireframe` **(Leaf)**
  - `velt-comment-dialog-assignee-banner-user-avatar-wireframe` **(Leaf)**
  - `velt-comment-dialog-assignee-banner-user-name-wireframe` **(Leaf)**
  ```

  Updated (add unresolve-button after resolve-button):
  ```
  ### `velt-comment-dialog-assignee-banner-wireframe`
  - `velt-comment-dialog-assignee-banner-resolve-button-wireframe` **(Leaf)**
  - `velt-comment-dialog-assignee-banner-unresolve-button-wireframe` **(Leaf)**
  - `velt-comment-dialog-assignee-banner-user-avatar-wireframe` **(Leaf)**
  - `velt-comment-dialog-assignee-banner-user-name-wireframe` **(Leaf)**
  ```

- Priority: Medium

### 5. UI Customization — Wireframe Components (comment-dialog-components.mdx)
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`
- Anchor: `#resolve-button-assignee-banner` (line 128)
- Change: Add an "Unresolve Button (Assignee Banner)" section immediately after the "Resolve Button (Assignee Banner)" section (after line 147), following the identical pattern. Both React and Other Frameworks tabs:

  React tab:
  ```jsx
  <VeltWireframe>
      <VeltCommentDialogWireframe.AssigneeBanner.UnresolveButton />
  </VeltWireframe>
  ```

  Other Frameworks tab:
  ```html
  <velt-wireframe>
      <velt-comment-dialog-assignee-banner-unresolve-button-wireframe></velt-comment-dialog-assignee-banner-unresolve-button-wireframe>
  </velt-wireframe>
  ```

- Priority: Medium

### 6. UI Customization — Conditional CSS Classes (styling.mdx)
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/styling.mdx`
- Anchor: `#component-specific-css-classes` (line 412)
- Change: Expand the "Component-Specific CSS Classes" section to list the five new classes with a one-line description each. Add after the existing `velt-assign-dropdown-checkbox--selected` example (after line 440):

  New classes to document:
  - `.velt-composer-attachment-container` — wrapper element for each attachment in the composer
  - `.velt-composer-attachment--loading` — applied while attachment is uploading
  - `.velt-composer-attachment--edit-mode` — applied when the attachment is in edit mode
  - `.s-comment-dialog-assign-to-menu` — targets the assign-to menu in comment dialog for custom styling
  - `.velt-thread-card--assign-to-menu` — targets the assign-to menu in thread card for custom styling

  Include a CSS code example in both tabs showing `.velt-composer-attachment--loading` with a sample style, following the existing tab pattern.

- Priority: Medium

---

## Areas Confirmed NOT Requiring Updates

### Bug Fixes (all internal)
- iframe pin placement (`NON_NESTABLE_ELEMENTS`) — internal list change, no API surface change
- Draft auto-save regression on back navigation — internal guard, no prop or method changed
- Sidebar annotation deselection on back navigation — internal state management fix
- Thread card `isTemplateEmpty()` detection — internal wireframe rendering logic
- Edit composer fallback (`hasEditComposerWireframe`) — internal rendering fallback

None of the above altered developer-facing APIs, props, events, or wireframe component names.

---

## Implementation Sequence

1. Add `AttachmentDownloadClickedEvent` interface and ENUM row to `data-models.mdx` (High, ~10 min)
2. Add `enableAttachmentDownload()` / `disableAttachmentDownload()` entries to `api-methods.mdx` Attachments section (High, ~5 min)
3. Add `attachmentDownloadClicked` row to the `on()` event table in `customize-behavior.mdx` (High, ~5 min)
4. Add `enableAttachmentDownload` section with prop + method + event examples to `customize-behavior.mdx` (High, ~15 min)
5. Add `velt-comment-dialog-assignee-banner-unresolve-button-wireframe` leaf to `comment-dialog-structure.mdx` (Medium, ~5 min)
6. Add "Unresolve Button (Assignee Banner)" wireframe section to `comment-dialog-components.mdx` (Medium, ~10 min)
7. Add five new conditional CSS classes to `styling.mdx` Component-Specific CSS Classes section (Medium, ~10 min)

---

## Quality Checklist
- [ ] `AttachmentDownloadClickedEvent` interface added to `data-models.mdx` under `#attachments`
- [ ] `ATTACHMENT_DOWNLOAD_CLICKED` ENUM row added to `data-models.mdx` Attachments ENUMs table
- [ ] `enableAttachmentDownload()` / `disableAttachmentDownload()` added to `api-methods.mdx`
- [ ] `attachmentDownloadClicked` added to `on()` event table in `customize-behavior.mdx`
- [ ] `enableAttachmentDownload` full section added to `customize-behavior.mdx` (prop + methods + event)
- [ ] Code examples include React and Other Frameworks tabs
- [ ] `velt-comment-dialog-assignee-banner-unresolve-button-wireframe` added to structure doc
- [ ] Unresolve Button (Assignee Banner) component section added to components doc
- [ ] Five new CSS classes documented in `styling.mdx`
- [ ] No breaking changes declared (download enabled by default)
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.1-beta.2.md`
