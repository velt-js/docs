# Release Update Plan for v4.5.8-beta.1

## Overview
- **Release Type**: Minor (Beta)
- **Release Date**: October 29, 2025
- **Key Changes**:
  1. New Feature - Recorder: Video editor timeline image preview capability
  2. Improvement - Comments: Enhanced `selectCommentByAnnotationId()` API behavior for closing annotations
- **Breaking Changes**: No

## Analysis Summary

### Release Note Content
The release contains two main updates:

1. **Recorder - Video Editor Timeline Image Preview**
   - Adds `videoEditorTimelinePreview` prop to `VeltRecorderNotes` and `VeltRecorderControlPanel` components
   - Displays frame snapshots in the video editor timeline
   - Requires both `videoEditorTimelinePreview` and `videoEditor` props to be true
   - Helps users navigate to specific scenes without scrubbing through the entire video

2. **Comments - Enhanced selectCommentByAnnotationId() API**
   - API now closes the selected comment annotation when called with no arguments or an invalid ID
   - Previously only supported opening annotations by ID
   - Now supports both opening and closing annotations programmatically

## Areas Requiring Updates

### 1. Recorder - Main Feature Documentation
**Files to Update**: `/Users/yoenzhang/Downloads/docs/async-collaboration/recorder/customize-behavior.mdx`

**Changes Needed**:
- Add new section under "Editor" heading for `videoEditorTimelinePreview` prop
- Document the prop on both `VeltRecorderNotes` and `VeltRecorderControlPanel` components
- Include requirement that both `videoEditorTimelinePreview` and `videoEditor` must be true
- Follow existing pattern with React/Next.js and Other Frameworks tabs
- Include both prop-based and API-based examples (if API methods exist)
- Place after the `videoEditor` section for logical grouping

**Priority**: High (New feature requiring documentation)

**Section Structure**:
```
#### videoEditorTimelinePreview
- Controls whether to display frame snapshots in the video editor timeline.
- This helps users quickly navigate to specific scenes without scrubbing through the entire video.
- Available in `Velt Recorder Notes` and `Velt Recorder Control Panel` components.

Default: `false`

<Info>The timeline preview only works when both `videoEditorTimelinePreview` and `videoEditor` are set to `true`.</Info>

[Code examples for React/Next.js and Other Frameworks]
```

### 2. Comments - Main Feature Documentation
**Files to Update**: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`

**Changes Needed**:
- Update the existing `selectCommentByAnnotationId` section (currently at line ~4040)
- Enhance description to document the new closing behavior
- Add code examples showing how to close annotations
- Include both hook-based and API method examples in React tab
- Update usage description to reflect both opening and closing capabilities

**Priority**: High (API behavior change requiring documentation update)

**Updated Section Content**:
```
#### selectCommentByAnnotationId
- Use this to programmatically select a comment annotation by its ID.
- When called without arguments or with an invalid ID, it will close the currently selected annotation.
- Example: If the user opens a comment URL from an email notification, you can use this to open the comment dialog after your page has finished rendering.

<Tabs>
<Tab title="React / Next.js">

// Using Hooks
const commentElement = useCommentUtils();

// Open a specific annotation
commentElement.selectCommentByAnnotationId('COMMENT_ANNOTATION_ID');

// Close the currently selected annotation
commentElement.selectCommentByAnnotationId();
commentElement.selectCommentByAnnotationId('invalid-id');

// Using API methods
const commentElement = client.getCommentElement();

// Open a specific annotation
commentElement.selectCommentByAnnotationId('COMMENT_ANNOTATION_ID');

// Close the currently selected annotation
commentElement.selectCommentByAnnotationId();
commentElement.selectCommentByAnnotationId('invalid-id');

</Tab>

<Tab title="Other Frameworks">
const commentElement = Velt.getCommentElement();

// Open a specific annotation
commentElement.selectCommentByAnnotationId('COMMENT_ANNOTATION_ID');

// Close the currently selected annotation
commentElement.selectCommentByAnnotationId();
commentElement.selectCommentByAnnotationId('invalid-id');
</Tab>
</Tabs>
```

### 3. UI Customization - Video Editor Wireframes
**Files to Update**: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/recorder/video-editor.mdx`

**Changes Needed**:
- NO UPDATES REQUIRED
- The existing Timeline wireframe section already documents all timeline-related wireframes
- The `videoEditorTimelinePreview` prop controls the display of image previews within the existing timeline structure
- No new wireframe components are being introduced
- Image previews are rendered within the existing `<velt-video-editor-player-timeline-container-wireframe>` structure

**Priority**: N/A (No updates needed)

**Rationale**:
The new feature adds visual content (frame snapshots) to the existing timeline component but does not introduce new wireframe components that require customization. The timeline wireframes are already fully documented.

### 4. Data Models
**Files to Update**: None required

**Analysis**:
- The `videoEditorTimelinePreview` prop is a boolean prop, not a new data type
- The `selectCommentByAnnotationId()` API signature remains the same (accepts optional string parameter)
- No new types, interfaces, or schemas are introduced in this release

**Priority**: N/A (No updates needed)

### 5. API Methods Documentation
**Files to Update**: None required

**Analysis**:
- No new API methods are introduced
- The `selectCommentByAnnotationId()` method signature has not changed (still accepts optional string parameter)
- Only the behavior when called with no arguments or invalid ID has been enhanced
- This behavior change is documented in the main feature documentation (Comments customize-behavior)

**Priority**: N/A (No updates needed)

### 6. Code Examples in Release Notes
**Files to Update**: None required

**Analysis**:
- Release notes already contain complete code examples for both features
- Examples follow the established pattern with React/Next.js and Other Frameworks tabs
- No additional examples needed

**Priority**: N/A (Already complete)

### 7. Migration & Upgrade Guides
**Files to Update**: None required

**Analysis**:
- No breaking changes in this release
- The enhanced `selectCommentByAnnotationId()` behavior is backward compatible
- Users already calling the method with a valid ID will see no change in behavior
- The new timeline preview feature is opt-in via prop

**Priority**: N/A (No breaking changes)

### 8. Cross-references and Internal Links
**Files to Update**: None required

**Analysis**:
- No feature name changes requiring link updates
- No new pages being created requiring cross-reference updates
- The new `videoEditorTimelinePreview` prop will be documented in the existing customize-behavior page
- No impact on existing cross-references

**Priority**: N/A (No updates needed)

## Implementation Sequence

### Phase 1: Recorder Documentation (High Priority)
1. **Update Recorder Customize Behavior** (`/Users/yoenzhang/Downloads/docs/async-collaboration/recorder/customize-behavior.mdx`)
   - Add `videoEditorTimelinePreview` section under "Editor" heading
   - Place after the `videoEditor` section
   - Follow existing documentation patterns
   - Include Info callout about requiring both props
   - Estimated effort: 15-20 minutes

### Phase 2: Comments Documentation (High Priority)
2. **Update Comments Customize Behavior** (`/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`)
   - Enhance existing `selectCommentByAnnotationId` section
   - Update description to include closing behavior
   - Add code examples for closing annotations
   - Include both hook and API method examples
   - Estimated effort: 15-20 minutes

## Quality Assurance Checklist

### Documentation Accuracy
- [x] Release note version matches planning document (v4.5.8-beta.1)
- [x] All new props documented with correct default values
- [x] API behavior changes clearly explained
- [x] Requirements and dependencies documented (videoEditor + videoEditorTimelinePreview)
- [x] No breaking changes requiring migration guidance

### Code Examples
- [x] Code examples include both React and Other Frameworks tabs
- [x] React examples show both hook-based and API method approaches where applicable
- [x] Code syntax is correct and follows existing patterns
- [x] Examples demonstrate both opening and closing behavior for selectCommentByAnnotationId

### Terminology and Consistency
- [x] Feature naming consistent with existing documentation ("video editor timeline")
- [x] Component names match exactly (VeltRecorderNotes, VeltRecorderControlPanel)
- [x] Prop naming follows kebab-case for HTML attributes and camelCase for React props
- [x] Terminology aligned across all documentation ("frame snapshots", "timeline preview")

### Documentation Structure
- [x] New sections placed in logical locations (videoEditorTimelinePreview after videoEditor)
- [x] Heading levels consistent with surrounding content
- [x] Info/Warning callouts used appropriately
- [x] Default values explicitly stated

### Completeness
- [x] All affected documentation areas identified
- [x] No missing documentation for new features
- [x] Existing related documentation reviewed for consistency
- [x] No unnecessary updates planned for unchanged features

### UI Customization
- [x] Verified no new wireframe components introduced
- [x] Confirmed existing wireframes cover the feature
- [x] No UI customization documentation updates needed

### Unnecessary Updates Avoided
- [x] Confirmed bug fixes don't require doc updates
- [x] Verified API signature hasn't changed (selectCommentByAnnotationId)
- [x] No new data models require documentation
- [x] No migration guides needed (backward compatible changes)

## Special Considerations

### 1. videoEditorTimelinePreview Feature
- This is a visual enhancement to an existing feature (video editor)
- Requires both `videoEditorTimelinePreview` and `videoEditor` to be true
- Should be documented near the `videoEditor` section for discoverability
- Info callout is appropriate to highlight the dual-prop requirement
- No API methods appear to exist for this feature (prop-only configuration)

### 2. selectCommentByAnnotationId Enhancement
- This is a behavior improvement, not a breaking change
- Existing usage (passing a valid ID) remains unchanged
- New capability (closing via empty call or invalid ID) is additive
- Examples should show both opening and closing use cases
- Both hook and API method patterns should be documented for React

### 3. Beta Release Considerations
- This is a beta release (v4.5.8-beta.1)
- Documentation should be complete and production-ready
- No special "beta" warnings are needed unless features are unstable
- Users expect beta features to be fully documented

## Dependencies and Related Documentation

### Related Sections
1. **Recorder - videoEditor section** (customize-behavior.mdx)
   - The new `videoEditorTimelinePreview` prop depends on `videoEditor` being enabled
   - Should be documented immediately after the `videoEditor` section

2. **Recorder - Video Editor Wireframes** (video-editor.mdx)
   - Timeline wireframes already documented
   - No updates needed (timeline preview uses existing structure)

3. **Comments - selectCommentByAnnotationId** (customize-behavior.mdx)
   - Existing section needs enhancement
   - No new sections required

### No Impact Areas
- Data Models documentation (no new types)
- API reference pages (no new methods)
- Setup guides (no setup changes)
- Migration guides (no breaking changes)
- UI customization wireframes (no new components)

## Agent-3 (Technical Documentation) Instructions

### Task 1: Update Recorder Documentation
**File**: `/Users/yoenzhang/Downloads/docs/async-collaboration/recorder/customize-behavior.mdx`

**Location**: Add new section under "Editor" heading, after the `videoEditor` section (after line ~696)

**Content to Add**:
```markdown
#### videoEditorTimelinePreview
- Controls whether to display frame snapshots in the video editor timeline.
- This helps users quickly navigate to specific scenes without scrubbing through the entire video.
- Available in `Velt Recorder Notes` and `Velt Recorder Control Panel` components.

Default: `false`

<Info>The timeline preview only works when both `videoEditorTimelinePreview` and `videoEditor` are set to `true`.</Info>

<Tabs>
<Tab title="React / Next.js">
**Using Props:**
```jsx
<VeltRecorderNotes videoEditorTimelinePreview={true} videoEditor={true} />
<VeltRecorderControlPanel videoEditorTimelinePreview={true} videoEditor={true} />
```
</Tab>
<Tab title="Other Frameworks">
**Using Props:**
```html
<velt-recorder-notes video-editor-timeline-preview="true" video-editor="true"></velt-recorder-notes>
<velt-recorder-control-panel video-editor-timeline-preview="true" video-editor="true"></velt-recorder-control-panel>
```
</Tab>
</Tabs>
```

**Verification**:
- Confirm section is placed after `videoEditor` section
- Verify Info callout mentions both props requirement
- Check code examples match release note format
- Ensure default value is stated

### Task 2: Update Comments Documentation
**File**: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`

**Location**: Update existing section at approximately line 4040

**Content to Replace**:

**OLD**:
```markdown
#### selectCommentByAnnotationId
- Use this to programatically select a comment annotation by its id.
- Example: If the user opens a comment url from an email notification,
you can use this open the comment dialog after your page has finished rendering.

<Tabs>
<Tab title="React / Next.js">

```jsx
const commentElement = client.getCommentElement();
commentElement.selectCommentByAnnotationId("COMMENT_ANNOTATION_ID");
```

</Tab>

<Tab title="Other Frameworks">
```jsx
const commentElement = Velt.getCommentElement();
commentElement.selectCommentByAnnotationId("COMMENT_ANNOTATION_ID");
```
</Tab>
</Tabs>
```

**NEW**:
```markdown
#### selectCommentByAnnotationId
- Use this to programmatically select a comment annotation by its ID.
- When called without arguments or with an invalid ID, it will close the currently selected annotation.
- Example: If the user opens a comment URL from an email notification, you can use this to open the comment dialog after your page has finished rendering.

<Tabs>
<Tab title="React / Next.js">

```jsx
// Using Hooks
const commentElement = useCommentUtils();

// Open a specific annotation
commentElement.selectCommentByAnnotationId('COMMENT_ANNOTATION_ID');

// Close the currently selected annotation
commentElement.selectCommentByAnnotationId();
commentElement.selectCommentByAnnotationId('invalid-id');

// Using API methods
const commentElement = client.getCommentElement();

// Open a specific annotation
commentElement.selectCommentByAnnotationId('COMMENT_ANNOTATION_ID');

// Close the currently selected annotation
commentElement.selectCommentByAnnotationId();
commentElement.selectCommentByAnnotationId('invalid-id');
```

</Tab>

<Tab title="Other Frameworks">
```jsx
const commentElement = Velt.getCommentElement();

// Open a specific annotation
commentElement.selectCommentByAnnotationId('COMMENT_ANNOTATION_ID');

// Close the currently selected annotation
commentElement.selectCommentByAnnotationId();
commentElement.selectCommentByAnnotationId('invalid-id');
```
</Tab>
</Tabs>
```

**Verification**:
- Confirm description includes closing behavior
- Verify React tab includes both hook and API method examples
- Check code comments clearly explain opening vs closing
- Ensure typo "programatically" is fixed to "programmatically"

## Agent-4 (UI Customization) Instructions

**No Actions Required**

The `videoEditorTimelinePreview` feature does not introduce new wireframe components. It adds visual content (frame snapshots) to the existing timeline structure which is already fully documented in `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/recorder/video-editor.mdx`.

## Agent-5 (Alignment & Cross-references) Instructions

**No Actions Required**

This release does not require:
- Updates to cross-references (no new pages created)
- Updates to internal links (no feature name changes)
- Updates to navigation (no new sections)
- Updates to related documentation (all changes localized to feature docs)

**Verification Steps**:
1. Confirm new `videoEditorTimelinePreview` section is findable via site search
2. Verify `selectCommentByAnnotationId` section still appears in search results
3. Check that both updated sections are properly indexed

## Summary for Agent-1

This release requires documentation updates in **2 files only**:
1. **Recorder customize-behavior**: Add new `videoEditorTimelinePreview` section
2. **Comments customize-behavior**: Enhance existing `selectCommentByAnnotationId` section

No other documentation areas require updates because:
- No new data models introduced (boolean prop, existing method signature)
- No new API methods (prop-only feature, behavior enhancement)
- No new wireframe components (uses existing timeline structure)
- No breaking changes (backward compatible enhancements)
- No migration needed (opt-in feature, additive behavior)

This is a clean, focused release with minimal documentation impact.
