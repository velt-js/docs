# Release Update Plan for v4.7.11

## Overview
- Release Type: Patch
- Key Changes: Attachment download control with new event and methods, attachment loading indicator styling improvement
- Breaking Changes: Yes - CSS selector change for attachment loading indicator

## Areas Requiring Updates

### 1. API Methods
- Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Changes: Add three new API methods under the Attachments section
  - `enableAttachmentDownload()` - Enable automatic file downloads when clicking attachment download button
  - `disableAttachmentDownload()` - Disable automatic file downloads (default behavior allows custom handling)
  - Event subscription for `attachmentDownloadClicked` event (add to Event Subscription section)
- Priority: High

### 2. Data Models
- Files: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes: Add new event type and data structure
  - Add `attachmentDownloadClicked` to Event Enum table
  - Add `AttachmentDownloadClickedEvent` interface with properties:
    - `annotationId: string` (Required) - ID of the comment annotation
    - `commentAnnotation: CommentAnnotation` (Required) - Full comment annotation object
    - `attachment: Attachment` (Required) - The attachment that was clicked
    - `metadata: VeltEventMetadata` (Required) - Event metadata
- Priority: High

### 3. Documentation - Customize Behavior
- Files: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
- Changes: Add new subsection under Attachments section
  - Document `enableAttachmentDownload()` / `disableAttachmentDownload()` methods
  - Document `attachmentDownloadClicked` event subscription
  - Include React and Other Frameworks code examples showing:
    - Component prop usage: `<VeltComments attachmentDownload={false} />`
    - HTML attribute: `<velt-comments attachment-download="false"></velt-comments>`
    - API methods and event listener with example event handler
  - Explain use cases: custom download URLs, analytics tracking, access control
- Priority: High

### 4. UI Customization - CSS Update
- Files: Identify which UI customization docs reference attachment styling
- Changes: Document CSS class structure change for attachment loading states
  - Old pattern: `.loading` on `.velt-composer--selected-file` or `.velt-composer--other-attachment`
  - New pattern: `.velt-composer-attachment--loading` on parent `.velt-composer-attachment-container`
  - Add migration note for custom CSS targeting attachment loading states
- Priority: Medium

### 5. Migration Guides
- Files: Determine if standalone migration guide exists or if note should be in release note only
- Changes: Document breaking CSS change
  - Selectors targeting `.loading` class on attachment elements need updating
  - Provide before/after CSS selector examples
- Priority: Low (already documented in release note improvements section)

## Implementation Sequence
1. Add new event enum and `AttachmentDownloadClickedEvent` interface to data-models.mdx (foundational types)
2. Add three new API method entries to api-methods.mdx under Attachments section (API reference)
3. Add detailed documentation to customize-behavior.mdx with code examples (feature documentation)
4. Document CSS class change in relevant UI customization files if attachment styling docs exist
5. Review release note to ensure breaking change is clearly communicated

## Quality Checklist
- [ ] New event type `attachmentDownloadClicked` added to data-models.mdx Event Enum
- [ ] `AttachmentDownloadClickedEvent` interface added to data-models.mdx with all properties
- [ ] `enableAttachmentDownload()` method added to api-methods.mdx Attachments section
- [ ] `disableAttachmentDownload()` method added to api-methods.mdx Attachments section
- [ ] Event subscription documentation references added to api-methods.mdx
- [ ] Full feature documentation added to customize-behavior.mdx with use cases
- [ ] Code examples include React / Next.js and Other Frameworks tabs
- [ ] Component prop, HTML attribute, and API usage patterns documented
- [ ] Event handler example shows event structure with all properties
- [ ] CSS breaking change documented with old and new selector patterns
- [ ] Links between api-methods.mdx, data-models.mdx, and customize-behavior.mdx are valid
- [ ] Log file written to `/Users/yoenzhang/Downloads/docs/.claude/logs/agent-2-planning-v4.7.11.md`
