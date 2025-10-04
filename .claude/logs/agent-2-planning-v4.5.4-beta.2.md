# Release Update Plan for v4.5.4-beta.2

## Overview
- **Release Type**: Beta/Patch
- **Release Date**: September 25, 2025
- **Key Changes**: New FilterDropdown wireframe for inline comments, three new attachment-related APIs/properties
- **Breaking Changes**: No
- **Already Documented in beta.1**: HideReply and ThreadCard.Reply wireframes (SKIP THESE)

## Release Content Analysis

### New Features in v4.5.4-beta.2:

1. **Comment dialog hide reply wireframe** (VeltCommentDialogWireframe.HideReply)
   - Status: ALREADY DOCUMENTED IN BETA.1 - SKIP THIS

2. **Thread card reply wireframe** (VeltCommentDialogWireframe.ThreadCard.Reply)
   - Status: ALREADY DOCUMENTED IN BETA.1 - SKIP THIS

3. **Filter dropdown for inline comments section** (NEW)
   - Complete wireframe hierarchy: FilterDropdown → Trigger (Arrow, Name) → Content → List → Item (Label, Checkbox) → ApplyButton
   - Location: Inline comments section, below sorting dropdown
   - Status: NEW - REQUIRES FULL DOCUMENTATION

4. **allowedFileTypes property** (NEW)
   - Limits file types in comment attachments
   - Available as: Component prop + API method
   - Type: Array of file extensions (e.g., ['jpg', 'png'])
   - Status: NEW - REQUIRES DOCUMENTATION

5. **attachmentNameInMessage property** (NEW)
   - Shows attachment filename in message when file selected
   - Available as: Component prop
   - Type: Boolean
   - Status: NEW - REQUIRES DOCUMENTATION

6. **setComposerFileAttachments() API method** (NEW)
   - Programmatically adds file attachments to comment composer
   - Parameters: { files: File[], annotationId?: string, targetElementId?: string }
   - Requires new data model: UploadFileData interface
   - Status: NEW - REQUIRES DOCUMENTATION

### Improvements:
- **SVG sanitization**: Internal security improvement, no documentation needed

### Bug Fixes:
- **Floating mode prop issue**: Fixed in React/embed mode, no API changes, no documentation needed

---

## Areas Requiring Updates

### 1. Data Models
**Files to Update:**
- `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`

**Changes Needed:**
- Add new `UploadFileData` interface definition for the setComposerFileAttachments() method
- Structure based on release note:
  ```typescript
  interface UploadFileData {
    files: File[];           // Required: Array of files to attach
    annotationId?: string;   // Optional: Target annotation ID
    targetElementId?: string; // Optional: Target element ID
  }
  ```

**Priority**: HIGH (Required for API method documentation)

**Implementation Notes:**
- Place in Comments section of data models
- Follow existing interface documentation patterns
- Include JSDoc-style descriptions for each property
- Specify which properties are required vs optional

---

### 2. API Methods
**Files to Update:**
- `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`

**Changes Needed:**
1. Add `setComposerFileAttachments()` to the Attachments section (line ~407-438)
   - Method name: `setComposerFileAttachments()`
   - Description: "Programmatically add file attachments to the comment composer from your application instead of requiring users to select files from the file system."
   - Params: [UploadFileData](/api-reference/sdk/models/data-models#uploadfiledata)
   - Returns: `void`
   - React Hook: `n/a`
   - Full Documentation link: `/async-collaboration/comments/customize-behavior#setcomposerfileattachments`

2. Add `setAllowedFileTypes()` to the Attachments section
   - Method name: `setAllowedFileTypes()`
   - Description: "Limit file types in comment attachments by specifying allowed file extensions."
   - Params: `string[]` (array of file extensions)
   - Returns: `void`
   - React Hook: `n/a`
   - Full Documentation link: `/async-collaboration/comments/customize-behavior#allowedfiletypes`

**Priority**: HIGH (Core API reference)

**Implementation Notes:**
- Insert in Attachments section after `getAttachment()` and before Reactions section
- Follow existing API method index format exactly
- Include both hook and API method indicators
- Link to data models and full documentation

---

### 3. Documentation - Customize Behavior (Main Feature Docs)
**Files to Update:**
- `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`

**Changes Needed:**
1. Add new section `## allowedFileTypes` in the Attachments area (after enableAttachments section, around line 2149-2180)
   - Heading: `#### allowedFileTypes`
   - Description: Full explanation of limiting file types in attachments
   - Default: Not specified (all supported types allowed)
   - Usage examples for both component prop and API method
   - Both React/Next.js and Other Frameworks tabs
   - Explain security benefits
   - List default supported file types (.png, .jpg, .gif, .svg up to 15MB)

2. Add new section `## attachmentNameInMessage` in the Attachments area (after allowedFileTypes)
   - Heading: `#### attachmentNameInMessage`
   - Description: Shows attachment filename in message when file selected
   - Default: `false`
   - Usage examples for component prop only
   - Both React/Next.js and Other Frameworks tabs
   - Explain UX benefit of immediate visual confirmation

3. Add new section `## setComposerFileAttachments` in the Attachments area (after attachmentNameInMessage)
   - Heading: `#### setComposerFileAttachments`
   - Description: Programmatically add file attachments to composer
   - Use cases: screenshots, generated reports, files from storage system
   - Full API method examples with UploadFileData interface
   - Both React/Next.js and Other Frameworks tabs
   - Show examples with all parameters (files, annotationId, targetElementId)
   - Explain when to use annotationId vs targetElementId

**Priority**: HIGH (Primary user-facing documentation)

**Implementation Notes:**
- Follow existing customize-behavior.mdx patterns
- Use Tabs component for React vs Other Frameworks
- Include code examples matching release note format
- Reference UploadFileData data model with link
- Place all three sections together in Attachments area
- Maintain consistent formatting with existing sections

---

### 4. UI Customization - Wireframes
**Files to Update:**
- `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/inline-comments-section.mdx`

**Changes Needed:**
Add new FilterDropdown wireframe section after SortingDropdown section (after line 196, before CommentCount section).

**New Section Structure:**
```markdown
#### FilterDropdown
![IMAGE_PATH_NEEDED]
<Tabs>
<Tab title="React / Next.js">
```jsx
<VeltWireframe>
  <VeltInlineCommentsSectionWireframe.FilterDropdown>
    <VeltInlineCommentsSectionWireframe.FilterDropdown.Trigger />
    <VeltInlineCommentsSectionWireframe.FilterDropdown.Content />
  </VeltInlineCommentsSectionWireframe.FilterDropdown>
</VeltWireframe>
```
</Tab>
<Tab title="Other Frameworks">
```html
<velt-wireframe style="display:none;">
  <velt-inline-comments-section-filter-dropdown-wireframe>
    <velt-inline-comments-section-filter-dropdown-trigger-wireframe></velt-inline-comments-section-filter-dropdown-trigger-wireframe>
    <velt-inline-comments-section-filter-dropdown-content-wireframe></velt-inline-comments-section-filter-dropdown-content-wireframe>
  </velt-inline-comments-section-filter-dropdown-wireframe>
</velt-wireframe>
```
</Tab>
</Tabs>

##### **Trigger**
![IMAGE_PATH_NEEDED]
<Tabs>
<Tab title="React / Next.js">
```jsx
<VeltWireframe>
  <VeltInlineCommentsSectionWireframe.FilterDropdown.Trigger>
    <VeltInlineCommentsSectionWireframe.FilterDropdown.Trigger.Arrow />
    <VeltInlineCommentsSectionWireframe.FilterDropdown.Trigger.Name />
  </VeltInlineCommentsSectionWireframe.FilterDropdown.Trigger>
</VeltWireframe>
```
</Tab>
<Tab title="Other Frameworks">
```html
<velt-wireframe style="display:none;">
  <velt-inline-comments-section-filter-dropdown-trigger-wireframe>
    <velt-inline-comments-section-filter-dropdown-trigger-arrow-wireframe></velt-inline-comments-section-filter-dropdown-trigger-arrow-wireframe>
    <velt-inline-comments-section-filter-dropdown-trigger-name-wireframe></velt-inline-comments-section-filter-dropdown-trigger-name-wireframe>
  </velt-inline-comments-section-filter-dropdown-trigger-wireframe>
</velt-wireframe>
```
</Tab>
</Tabs>

##### **Arrow**
![IMAGE_PATH_NEEDED]
<Tabs>
<Tab title="React / Next.js">
```jsx
<VeltWireframe>
  <VeltInlineCommentsSectionWireframe.FilterDropdown.Trigger.Arrow />
</VeltWireframe>
```
</Tab>
<Tab title="Other Frameworks">
```html
<velt-wireframe style="display:none;">
  <velt-inline-comments-section-filter-dropdown-trigger-arrow-wireframe></velt-inline-comments-section-filter-dropdown-trigger-arrow-wireframe>
</velt-wireframe>
```
</Tab>
</Tabs>

##### **Name**
![IMAGE_PATH_NEEDED]
<Tabs>
<Tab title="React / Next.js">
```jsx
<VeltWireframe>
  <VeltInlineCommentsSectionWireframe.FilterDropdown.Trigger.Name />
</VeltWireframe>
```
</Tab>
<Tab title="Other Frameworks">
```html
<velt-wireframe style="display:none;">
  <velt-inline-comments-section-filter-dropdown-trigger-name-wireframe></velt-inline-comments-section-filter-dropdown-trigger-name-wireframe>
</velt-wireframe>
```
</Tab>
</Tabs>

##### **Content**
![IMAGE_PATH_NEEDED]
<Tabs>
<Tab title="React / Next.js">
```jsx
<VeltWireframe>
  <VeltInlineCommentsSectionWireframe.FilterDropdown.Content>
    <VeltInlineCommentsSectionWireframe.FilterDropdown.Content.List />
    <VeltInlineCommentsSectionWireframe.FilterDropdown.Content.ApplyButton />
  </VeltInlineCommentsSectionWireframe.FilterDropdown.Content>
</VeltWireframe>
```
</Tab>
<Tab title="Other Frameworks">
```html
<velt-wireframe style="display:none;">
  <velt-inline-comments-section-filter-dropdown-content-wireframe>
    <velt-inline-comments-section-filter-dropdown-content-list-wireframe></velt-inline-comments-section-filter-dropdown-content-list-wireframe>
    <velt-inline-comments-section-filter-dropdown-content-apply-button-wireframe></velt-inline-comments-section-filter-dropdown-content-apply-button-wireframe>
  </velt-inline-comments-section-filter-dropdown-content-wireframe>
</velt-wireframe>
```
</Tab>
</Tabs>

##### **List**
![IMAGE_PATH_NEEDED]
<Tabs>
<Tab title="React / Next.js">
```jsx
<VeltWireframe>
  <VeltInlineCommentsSectionWireframe.FilterDropdown.Content.List>
    <VeltInlineCommentsSectionWireframe.FilterDropdown.Content.List.Item />
  </VeltInlineCommentsSectionWireframe.FilterDropdown.Content.List>
</VeltWireframe>
```
</Tab>
<Tab title="Other Frameworks">
```html
<velt-wireframe style="display:none;">
  <velt-inline-comments-section-filter-dropdown-content-list-wireframe>
    <velt-inline-comments-section-filter-dropdown-content-list-item-wireframe></velt-inline-comments-section-filter-dropdown-content-list-item-wireframe>
  </velt-inline-comments-section-filter-dropdown-content-list-wireframe>
</velt-wireframe>
```
</Tab>
</Tabs>

##### **Item**
![IMAGE_PATH_NEEDED]
<Tabs>
<Tab title="React / Next.js">
```jsx
<VeltWireframe>
  <VeltInlineCommentsSectionWireframe.FilterDropdown.Content.List.Item>
    <VeltInlineCommentsSectionWireframe.FilterDropdown.Content.List.Item.Label />
    <VeltInlineCommentsSectionWireframe.FilterDropdown.Content.List.Item.Checkbox />
  </VeltInlineCommentsSectionWireframe.FilterDropdown.Content.List.Item>
</VeltWireframe>
```
</Tab>
<Tab title="Other Frameworks">
```html
<velt-wireframe style="display:none;">
  <velt-inline-comments-section-filter-dropdown-content-list-item-wireframe>
    <velt-inline-comments-section-filter-dropdown-content-list-item-label-wireframe></velt-inline-comments-section-filter-dropdown-content-list-item-label-wireframe>
    <velt-inline-comments-section-filter-dropdown-content-list-item-checkbox-wireframe></velt-inline-comments-section-filter-dropdown-content-list-item-checkbox-wireframe>
  </velt-inline-comments-section-filter-dropdown-content-list-item-wireframe>
</velt-wireframe>
```
</Tab>
</Tabs>

##### **Label**
![IMAGE_PATH_NEEDED]
<Tabs>
<Tab title="React / Next.js">
```jsx
<VeltWireframe>
  <VeltInlineCommentsSectionWireframe.FilterDropdown.Content.List.Item.Label />
</VeltWireframe>
```
</Tab>
<Tab title="Other Frameworks">
```html
<velt-wireframe style="display:none;">
  <velt-inline-comments-section-filter-dropdown-content-list-item-label-wireframe></velt-inline-comments-section-filter-dropdown-content-list-item-label-wireframe>
</velt-wireframe>
```
</Tab>
</Tabs>

##### **Checkbox**
![IMAGE_PATH_NEEDED]
<Tabs>
<Tab title="React / Next.js">
```jsx
<VeltWireframe>
  <VeltInlineCommentsSectionWireframe.FilterDropdown.Content.List.Item.Checkbox />
</VeltWireframe>
```
</Tab>
<Tab title="Other Frameworks">
```html
<velt-wireframe style="display:none;">
  <velt-inline-comments-section-filter-dropdown-content-list-item-checkbox-wireframe></velt-inline-comments-section-filter-dropdown-content-list-item-checkbox-wireframe>
</velt-wireframe>
```
</Tab>
</Tabs>

##### **ApplyButton**
![IMAGE_PATH_NEEDED]
<Tabs>
<Tab title="React / Next.js">
```jsx
<VeltWireframe>
  <VeltInlineCommentsSectionWireframe.FilterDropdown.Content.ApplyButton />
</VeltWireframe>
```
</Tab>
<Tab title="Other Frameworks">
```html
<velt-wireframe style="display:none;">
  <velt-inline-comments-section-filter-dropdown-content-apply-button-wireframe></velt-inline-comments-section-filter-dropdown-content-apply-button-wireframe>
</velt-wireframe>
```
</Tab>
</Tabs>
```

**Priority**: HIGH (New wireframe hierarchy)

**Implementation Notes:**
- Insert after SortingDropdown section, before CommentCount section
- Follow exact pattern of existing SortingDropdown documentation
- Include VeltWireframe parent wrapper in all examples
- Use consistent heading levels (#### for main, ##### for subcomponents)
- Placeholder images needed (marked as IMAGE_PATH_NEEDED) - images will be created by design team
- Follow the established pattern: show parent first, then drill down into each subcomponent
- Complete hierarchy: FilterDropdown → Trigger (Arrow, Name) → Content (List → Item (Label, Checkbox), ApplyButton)

---

### 5. UI Customization - Parent Panel Update
**Files to Update:**
- `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/inline-comments-section.mdx`

**Changes Needed:**
Update the Panel section (lines 54-81) to include the new FilterDropdown component in the wireframe hierarchy.

**Current Panel Section:**
```jsx
<VeltInlineCommentsSectionWireframe.Panel>
  <VeltInlineCommentsSectionWireframe.ComposerContainer />
  <VeltInlineCommentsSectionWireframe.SortingDropdown />
  <VeltInlineCommentsSectionWireframe.CommentCount />
  <VeltInlineCommentsSectionWireframe.List />
</VeltInlineCommentsSectionWireframe.Panel>
```

**Updated Panel Section (add FilterDropdown line):**
```jsx
<VeltInlineCommentsSectionWireframe.Panel>
  <VeltInlineCommentsSectionWireframe.ComposerContainer />
  <VeltInlineCommentsSectionWireframe.SortingDropdown />
  <VeltInlineCommentsSectionWireframe.FilterDropdown />
  <VeltInlineCommentsSectionWireframe.CommentCount />
  <VeltInlineCommentsSectionWireframe.List />
</VeltInlineCommentsSectionWireframe.Panel>
```

**Priority**: MEDIUM (Structural update for consistency)

**Implementation Notes:**
- Add FilterDropdown line after SortingDropdown in both React and Other Frameworks tabs
- Maintain proper indentation and formatting
- Update both code blocks in Panel section (React and Other Frameworks)

---

### 6. Code Examples
**Files Potentially Affected:**
- No standalone code example files identified
- All code examples are embedded in the documentation files listed above

**Changes Needed:**
- Ensure all code examples in customize-behavior.mdx follow the two-tab pattern (React/Next.js first, Other Frameworks second)
- Verify examples match release note format exactly
- Include both component prop and API method usage where applicable

**Priority**: MEDIUM (Part of main documentation updates)

---

### 7. Migration & Upgrade Guides
**Files to Update:**
- None required

**Changes Needed:**
- No breaking changes in this release
- No migration guide needed

**Priority**: N/A

---

## Implementation Sequence

### Phase 1: Foundation (Data Models & API Reference)
1. **Add UploadFileData interface to data-models.mdx** (HIGH priority)
   - Required before API method documentation
   - Clear interface definition with all properties
   - Estimated effort: 10 minutes

2. **Add setComposerFileAttachments() to api-methods.mdx** (HIGH priority)
   - Add to Attachments section
   - Follow existing format with data model link
   - Estimated effort: 5 minutes

3. **Add setAllowedFileTypes() to api-methods.mdx** (HIGH priority)
   - Add to Attachments section
   - Follow existing format
   - Estimated effort: 5 minutes

### Phase 2: Primary Documentation (Customize Behavior)
4. **Add allowedFileTypes section to customize-behavior.mdx** (HIGH priority)
   - Full feature documentation with examples
   - Both component prop and API method usage
   - Security benefits explanation
   - Estimated effort: 20 minutes

5. **Add attachmentNameInMessage section to customize-behavior.mdx** (HIGH priority)
   - Component prop documentation with examples
   - UX benefits explanation
   - Estimated effort: 15 minutes

6. **Add setComposerFileAttachments section to customize-behavior.mdx** (HIGH priority)
   - Full API method documentation with examples
   - Use case explanations
   - Parameter details
   - Estimated effort: 25 minutes

### Phase 3: UI Customization (Wireframes)
7. **Update Panel section in inline-comments-section.mdx** (MEDIUM priority)
   - Add FilterDropdown to component hierarchy
   - Both React and Other Frameworks tabs
   - Estimated effort: 5 minutes

8. **Add FilterDropdown wireframe section to inline-comments-section.mdx** (HIGH priority)
   - Complete wireframe hierarchy documentation
   - All subcomponents with examples
   - Follow SortingDropdown pattern
   - Estimated effort: 45 minutes
   - Note: Placeholder images needed (to be created by design team)

### Total Estimated Effort: ~2.5 hours

---

## Quality Assurance Checklist

- [ ] UploadFileData interface added to Data Models page
- [ ] setComposerFileAttachments() added to API Methods index
- [ ] setAllowedFileTypes() added to API Methods index
- [ ] allowedFileTypes documentation added to customize-behavior.mdx with both prop and API method examples
- [ ] attachmentNameInMessage documentation added to customize-behavior.mdx with prop examples
- [ ] setComposerFileAttachments documentation added to customize-behavior.mdx with full API examples
- [ ] FilterDropdown wireframe hierarchy fully documented in inline-comments-section.mdx
- [ ] Panel section updated to include FilterDropdown in hierarchy
- [ ] All code examples include both React/Next.js and Other Frameworks tabs
- [ ] All wireframe examples include parent VeltWireframe wrapper tags
- [ ] Cross-references and links are correct (data model links, full documentation links)
- [ ] No breaking changes or migration steps needed
- [ ] Terminology consistent with Velt standards ("comment attachments", "file types")
- [ ] Version accuracy validated - all content matches v4.5.4-beta.2 exactly
- [ ] HideReply and ThreadCard.Reply wireframes SKIPPED (already in beta.1)
- [ ] Placeholder image paths marked for design team (IMAGE_PATH_NEEDED)

---

## Dependencies and Cross-References

### Data Model Dependencies
- `UploadFileData` interface must be created before API method documentation can reference it
- Link format: `[UploadFileData](/api-reference/sdk/models/data-models#uploadfiledata)`

### API Method Dependencies
- API methods index must be updated before customize-behavior.mdx can link to them
- Link format: `[Full Documentation →](/async-collaboration/comments/customize-behavior#sectionname)`

### Wireframe Dependencies
- Panel section should be updated before or concurrently with FilterDropdown section
- FilterDropdown follows same pattern as SortingDropdown for consistency

### Image Dependencies
- UI customization wireframe section requires placeholder images
- Images to be created by design team showing:
  - Overall FilterDropdown component
  - Trigger section (with Arrow and Name)
  - Content section (with List and ApplyButton)
  - List with Items (Label and Checkbox)
  - Individual subcomponents

---

## Files Summary

### Files to Update (5 files):
1. `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
   - Add UploadFileData interface

2. `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
   - Add setComposerFileAttachments() method
   - Add setAllowedFileTypes() method

3. `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
   - Add allowedFileTypes section
   - Add attachmentNameInMessage section
   - Add setComposerFileAttachments section

4. `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/inline-comments-section.mdx`
   - Update Panel section to include FilterDropdown
   - Add complete FilterDropdown wireframe hierarchy section

### Files to Create:
- None - all updates are to existing files

---

## Agent-3 Instructions (Technical Documentation Updates)

Agent-3 should process the following updates in this order:

### Step 1: Data Models
Update `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`:
- Add UploadFileData interface in Comments section
- Properties: files (File[], required), annotationId (string, optional), targetElementId (string, optional)
- Include clear descriptions for each property

### Step 2: API Methods Index
Update `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`:
- Add setComposerFileAttachments() in Attachments section (after getAttachment, before Reactions)
- Add setAllowedFileTypes() in Attachments section
- Follow existing index entry format exactly

### Step 3: Customize Behavior Documentation
Update `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`:
- Add three new sections in Attachments area (after enableAttachments):
  1. allowedFileTypes - component prop + API method examples
  2. attachmentNameInMessage - component prop examples only
  3. setComposerFileAttachments - API method examples with full parameter details
- Each section needs React/Next.js and Other Frameworks tabs
- Reference UploadFileData data model with proper link

---

## Agent-4 Instructions (UI Customization Updates)

Agent-4 should process the following updates:

### Step 1: Panel Structure Update
Update `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/inline-comments-section.mdx`:
- Lines 54-81: Add FilterDropdown line to Panel section
- Update both React and Other Frameworks code blocks

### Step 2: FilterDropdown Wireframe Documentation
Update `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/inline-comments-section.mdx`:
- Insert complete FilterDropdown section after SortingDropdown (after line 196)
- Follow exact pattern of SortingDropdown documentation
- Include all subcomponents: Trigger (Arrow, Name), Content (List → Item (Label, Checkbox), ApplyButton)
- Use IMAGE_PATH_NEEDED placeholder for images
- Maintain VeltWireframe parent wrapper in all examples
- Follow heading hierarchy: #### for main, ##### for subcomponents

---

## Risk Assessment

### Low Risk Items:
- Adding new data model interface (non-breaking addition)
- Adding new API methods to index (reference only)
- Adding new sections to customize-behavior.mdx (new features)
- Adding new wireframe section (new functionality)

### Medium Risk Items:
- Updating Panel section structure (could affect existing customization)
  - Mitigation: This is additive only, existing implementations will continue to work

### No High Risk Items Identified

---

## Breaking Changes Assessment

**Result**: NO BREAKING CHANGES

All updates in v4.5.4-beta.2 are additive:
- New wireframe components (optional)
- New API methods (optional)
- New component properties (optional with sensible defaults)
- Internal improvements (transparent to users)
- Bug fixes (corrections only)

No migration guide or warning components needed.

---

## Terminology Alignment

### Correct Terminology:
- "comment attachments" (not "file uploads")
- "file types" (not "file formats")
- "inline comments section" (not "inline comments panel")
- "wireframe" (for UI customization components)
- "component prop" vs "API method" (clear distinction)

### Component Naming:
- VeltInlineCommentsSectionWireframe.FilterDropdown (React)
- velt-inline-comments-section-filter-dropdown-wireframe (Other Frameworks)
- VeltCommentDialogWireframe.HideReply (React) - ALREADY DOCUMENTED
- VeltCommentDialogWireframe.ThreadCard.Reply (React) - ALREADY DOCUMENTED

---

## Special Notes

### Items to SKIP (Already Documented in beta.1):
1. VeltCommentDialogWireframe.HideReply
2. VeltCommentDialogWireframe.ThreadCard.Reply

These were included in the beta.2 release note but were already fully documented in beta.1. Do NOT create duplicate documentation.

### Items Requiring Design Assets:
- FilterDropdown wireframe section needs placeholder images
- Marked as IMAGE_PATH_NEEDED in the documentation plan
- Design team will need to create screenshots showing:
  - Complete FilterDropdown UI
  - Individual component states and layouts
  - Interactive elements (buttons, checkboxes, etc.)

### Version-Specific Considerations:
- This is a beta release (v4.5.4-beta.2)
- All documentation should reflect the exact version number where applicable
- No deprecation notices needed
- All features are new additions, not replacements

---

## Completion Criteria

Documentation is complete when:
1. All 5 files have been updated with the specified changes
2. All code examples follow the two-tab pattern (React/Next.js, Other Frameworks)
3. All data model references link correctly
4. All API method index entries link to full documentation
5. FilterDropdown wireframe hierarchy is complete with all subcomponents
6. Panel section includes FilterDropdown in hierarchy
7. All placeholder images are marked IMAGE_PATH_NEEDED
8. No references to HideReply or ThreadCard.Reply (already documented)
9. QA checklist is fully satisfied
10. Agent-5 can proceed with alignment verification

---

## Log Metadata

- **Created**: 2025-10-01
- **Agent**: Agent-2 (Release Planning Specialist)
- **Release Version**: v4.5.4-beta.2
- **Release Date**: September 25, 2025
- **Files Analyzed**: 1 (sdk-changelog.mdx)
- **Files to Update**: 5
- **Files to Create**: 0
- **Estimated Total Effort**: ~2.5 hours
- **Breaking Changes**: No
- **Migration Guide Needed**: No
- **Ready for Agent-3**: Yes
- **Ready for Agent-4**: Yes
