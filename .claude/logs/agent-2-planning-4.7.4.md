# Release Update Plan for Version 4.7.4

## Overview
- **Release Date**: January 30, 2026
- **Release Type**: Minor (with Breaking Changes)
- **Key Changes**: Renamed prop/parameter, refactored API signatures, added new composer management methods, enhanced event data
- **Breaking Changes**: Yes - 2 breaking changes requiring migration

## Areas Requiring Updates

### 1. Data Models Documentation

**File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`

#### 1.1 Update CommentAnnotation Interface
- **Line**: ~40 (targetElementId property)
- **Change**: Clarify that `targetElementId` on `CommentAnnotation` is different from composer-specific `targetComposerElementId`
- **Priority**: Medium
- **Details**: Add deprecation notice or clarification that this field relates to annotation target elements, not composer identification

#### 1.2 Update VeltCommentComposerProps Interface
- **Line**: ~1702 (VeltCommentComposerProps section)
- **Change**: Rename `targetElementId` to `targetComposerElementId`
- **Priority**: High
- **Details**:
  ```typescript
  // OLD
  | `targetElementId` | `string` | No | Unique identifier for programmatic submission via submitComment()  |

  // NEW
  | `targetComposerElementId` | `string` | No | Unique identifier for programmatic submission via submitComment()  |
  ```

#### 1.3 Add New Type: SubmitCommentRequest
- **Section**: Component Props or Request/Response Types
- **Change**: Add new interface definition
- **Priority**: High
- **Details**:
  ```typescript
  #### SubmitCommentRequest
  ---

  | Property | Type | Required | Description |
  |----------|------|----------|-------------|
  | `targetComposerElementId` | `string` | Yes | Unique identifier of the composer to submit |
  ```

#### 1.4 Add New Type: ClearComposerRequest
- **Section**: Component Props or Request/Response Types
- **Change**: Add new interface definition
- **Priority**: High
- **Details**:
  ```typescript
  #### ClearComposerRequest
  ---

  | Property | Type | Required | Description |
  |----------|------|----------|-------------|
  | `targetComposerElementId` | `string` | Yes | Unique identifier of the composer to clear |
  ```

#### 1.5 Add New Type: GetComposerDataRequest
- **Section**: Component Props or Request/Response Types
- **Change**: Add new interface definition
- **Priority**: High
- **Details**:
  ```typescript
  #### GetComposerDataRequest
  ---

  | Property | Type | Required | Description |
  |----------|------|----------|-------------|
  | `targetComposerElementId` | `string` | Yes | Unique identifier of the composer to query |
  ```

#### 1.6 Update ComposerTextChangeEvent
- **Line**: ~1438-1443
- **Change**: Add new fields to event interface
- **Priority**: High
- **Details**:
  ```typescript
  // Add these fields:
  | `annotation` | `CommentAnnotation` | Yes | Full draft annotation object with attachments, recordings, tagged users |
  | `targetComposerElementId` | `string` | Yes | Unique identifier of the composer that triggered the event |
  ```

### 2. API Methods Documentation

**File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`

#### 2.1 Update submitComment() Method
- **Line**: ~96-101
- **Change**: Update parameter signature from string to request object
- **Priority**: High
- **Details**:
  ```markdown
  // OLD
  - Params: `targetElementId: string`

  // NEW
  - Params: [SubmitCommentRequest](/api-reference/sdk/models/data-models#submitcommentrequest)
  ```

#### 2.2 Add clearComposer() Method
- **Section**: After submitComment()
- **Change**: Add new method entry
- **Priority**: High
- **Details**:
  ```markdown
  #### clearComposer()
  Reset composer state including text, attachments, recordings, tagged users, assignments, and custom lists.
  - Params: [ClearComposerRequest](/api-reference/sdk/models/data-models#clearcomposerrequest)
  - Returns: `void`
  - React Hook: `n/a`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior#clearcomposer)
  ```

#### 2.3 Add getComposerData() Method
- **Section**: After clearComposer()
- **Change**: Add new method entry
- **Priority**: High
- **Details**:
  ```markdown
  #### getComposerData()
  Fetch current composer state on-demand. Returns the same data structure as the composerTextChange event.
  - Params: [GetComposerDataRequest](/api-reference/sdk/models/data-models#getcomposerdatarequest)
  - Returns: [ComposerTextChangeEvent](/api-reference/sdk/models/data-models#composertextchangeevent)
  - React Hook: `n/a`
  - [Full Documentation →](/async-collaboration/comments/customize-behavior#getcomposerdata)
  ```

### 3. Feature Documentation - Comments Customize Behavior

**File**: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`

#### 3.1 Update submitComment() Documentation
- **Line**: ~766-795
- **Change**: Update parameter signature and all code examples
- **Priority**: High
- **Details**:
  - Update parameter description from `targetElementId: string` to request object
  - Update all code examples in both React and Other Frameworks tabs
  - Example changes:
    ```jsx
    // OLD
    commentElement.submitComment('composer-1');

    // NEW
    commentElement.submitComment({ targetComposerElementId: 'composer-1' });
    ```

#### 3.2 Add clearComposer() Documentation
- **Section**: After submitComment()
- **Change**: Add new method documentation with examples
- **Priority**: High
- **Details**:
  ```markdown
  #### clearComposer

  Programmatically clear composer state including text, attachments, recordings, tagged users, assignments, and custom lists.

  - Params: [ClearComposerRequest](/api-reference/sdk/models/data-models#clearcomposerrequest)
  - Returns: `void`

  <Tabs>
  <Tab title="React / Next.js">
  ```jsx
  const commentElement = useCommentUtils();
  commentElement.clearComposer({ targetComposerElementId: 'composer-1' });

  // API Method
  const commentElement = client.getCommentElement();
  commentElement.clearComposer({ targetComposerElementId: 'composer-1' });
  ```
  </Tab>
  <Tab title="Other Frameworks">
  ```js
  const commentElement = Velt.getCommentElement();
  commentElement.clearComposer({ targetComposerElementId: 'composer-1' });
  ```
  </Tab>
  </Tabs>
  ```

#### 3.3 Add getComposerData() Documentation
- **Section**: After clearComposer()
- **Change**: Add new method documentation with examples
- **Priority**: High
- **Details**:
  ```markdown
  #### getComposerData

  Fetch current composer state on-demand. Returns same data structure as composerTextChange event.

  - Params: [GetComposerDataRequest](/api-reference/sdk/models/data-models#getcomposerdatarequest)
  - Returns: [ComposerTextChangeEvent](/api-reference/sdk/models/data-models#composertextchangeevent)

  <Tabs>
  <Tab title="React / Next.js">
  ```jsx
  const commentElement = useCommentUtils();
  const composerData = commentElement.getComposerData({
    targetComposerElementId: 'composer-1'
  });

  // API Method
  const commentElement = client.getCommentElement();
  const composerData = commentElement.getComposerData({
    targetComposerElementId: 'composer-1'
  });
  ```
  </Tab>
  <Tab title="Other Frameworks">
  ```js
  const commentElement = Velt.getCommentElement();
  const composerData = commentElement.getComposerData({
    targetComposerElementId: 'composer-1'
  });
  ```
  </Tab>
  </Tabs>
  ```

#### 3.4 Update composerTextChange Event Documentation
- **Line**: ~2734 (event table)
- **Change**: Update event description to mention new fields
- **Priority**: Medium
- **Details**: Update description to: "Triggered when text changes in any comment composer. Includes full draft annotation object and composer ID."

### 4. Component Documentation - VeltCommentComposer

**File 1**: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/standalone-components/comment-composer/customize-behavior.mdx`

#### 4.1 Update targetElementId Prop Documentation
- **Line**: ~75-92
- **Change**: Rename prop from `targetElementId` to `targetComposerElementId`
- **Priority**: High
- **Details**:
  - Update heading from `## targetElementId` to `## targetComposerElementId`
  - Update React example: `<VeltCommentComposer targetComposerElementId="composer-1" />`
  - Update HTML example: `<velt-comment-composer target-composer-element-id="composer-1"></velt-comment-composer>`
  - Update link reference to submitComment

**File 2**: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/standalone-components/comment-composer.mdx`

#### 4.2 Update Target Element ID Section
- **Line**: ~121-158
- **Change**: Rename prop in heading, description, and all code examples
- **Priority**: High
- **Details**:
  - Update heading from `### Target Element ID` to `### Target Composer Element ID`
  - Update description to reference `targetComposerElementId`
  - Update all React examples: `<VeltCommentComposer targetComposerElementId="composer-1" />`
  - Update all HTML examples: `<velt-comment-composer target-composer-element-id="composer-1"></velt-comment-composer>`
  - Update `submitComment()` call examples to use request object:
    ```jsx
    // OLD
    commentElement.submitComment('composer-1');

    // NEW
    commentElement.submitComment({ targetComposerElementId: 'composer-1' });
    ```

**File 3**: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`

#### 4.3 Update Composer Section
- **Line**: ~3593-3625
- **Change**: Rename prop in all code examples
- **Priority**: High
- **Details**: Same changes as 4.2 above for the composer section within comment dialog components

### 5. Setup Documentation Updates

**File 1**: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/setup/inline-comments.mdx`

#### 5.1 Update VeltInlineCommentsSection Examples
- **Line**: ~48-53
- **Change**: Verify `targetElementId` usage context (this refers to container binding, NOT composer ID)
- **Priority**: Low
- **Details**: No changes needed - this `targetElementId` is for section binding, not composer identification

**File 2**: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/setup/popover.mdx`

#### 5.2 Update VeltCommentTool Examples
- **Line**: ~70-72, ~87-91
- **Change**: Verify `targetElementId` usage context (this refers to element binding, NOT composer ID)
- **Priority**: Low
- **Details**: No changes needed - this `targetElementId` is for element binding, not composer identification

### 6. Migration Guide

**File**: Create `/Users/yoenzhang/Downloads/docs/release-notes/migration-guides/v4.7.4-migration.mdx`

#### 6.1 Create Migration Guide Document
- **Change**: Create new migration guide
- **Priority**: High
- **Details**:
  ```markdown
  ---
  title: "Migration Guide: v4.7.4"
  description: "Breaking changes and migration steps for Velt SDK v4.7.4"
  ---

  # Migrating to v4.7.4

  Version 4.7.4 introduces breaking changes to the Comment Composer API for improved clarity and consistency.

  ## Breaking Changes

  ### 1. VeltCommentComposer Prop Rename

  **Changed**: `targetElementId` → `targetComposerElementId`

  **Why**: Improved clarity to distinguish composer identification from element/annotation targeting.

  **Migration**:

  <Tabs>
  <Tab title="React / Next.js">
  ```jsx
  // Before
  <VeltCommentComposer targetElementId="my-composer" />

  // After
  <VeltCommentComposer targetComposerElementId="my-composer" />
  ```
  </Tab>
  <Tab title="Other Frameworks">
  ```html
  <!-- Before -->
  <velt-comment-composer target-element-id="my-composer"></velt-comment-composer>

  <!-- After -->
  <velt-comment-composer target-composer-element-id="my-composer"></velt-comment-composer>
  ```
  </Tab>
  </Tabs>

  ### 2. submitComment() API Signature Change

  **Changed**: `submitComment(string)` → `submitComment({ targetComposerElementId: string })`

  **Why**: Consistent with other SDK methods accepting request objects, enabling future extensibility.

  **Migration**:

  <Tabs>
  <Tab title="React / Next.js">
  ```jsx
  const commentElement = client.getCommentElement();

  // Before
  commentElement.submitComment('my-composer');

  // After
  commentElement.submitComment({ targetComposerElementId: 'my-composer' });
  ```
  </Tab>
  <Tab title="Other Frameworks">
  ```js
  const commentElement = Velt.getCommentElement();

  // Before
  commentElement.submitComment('my-composer');

  // After
  commentElement.submitComment({ targetComposerElementId: 'my-composer' });
  ```
  </Tab>
  </Tabs>

  ## New Features

  ### clearComposer()

  Reset composer state including text, attachments, recordings, tagged users, assignments, and custom lists.

  ```jsx
  const commentElement = client.getCommentElement();
  commentElement.clearComposer({ targetComposerElementId: 'my-composer' });
  ```

  [Learn more →](/async-collaboration/comments/customize-behavior#clearcomposer)

  ### getComposerData()

  Fetch current composer state on-demand. Returns same data structure as composerTextChange event.

  ```jsx
  const commentElement = client.getCommentElement();
  const composerData = commentElement.getComposerData({
    targetComposerElementId: 'my-composer'
  });
  ```

  [Learn more →](/async-collaboration/comments/customize-behavior#getcomposerdata)

  ### Enhanced composerTextChange Event

  Event now includes full draft annotation object and composer identifier.

  ```jsx
  commentElement.on('composerTextChange').subscribe((event) => {
    console.log('Text:', event.text);
    console.log('Annotation:', event.annotation); // NEW
    console.log('Composer ID:', event.targetComposerElementId); // NEW
  });
  ```

  [Learn more →](/async-collaboration/comments/customize-behavior#events)

  ## Search and Replace Guide

  Use these patterns to quickly update your codebase:

  ### React/TypeScript
  ```bash
  # Update prop name
  targetElementId="  →  targetComposerElementId="

  # Update submitComment calls
  .submitComment('  →  .submitComment({ targetComposerElementId: '
  .submitComment("  →  .submitComment({ targetComposerElementId: "
  # Add closing brace
  ');  →  ' });
  ");  →  " });
  ```

  ### HTML
  ```bash
  # Update attribute name
  target-element-id="  →  target-composer-element-id="

  # Update submitComment calls
  submitComment('  →  submitComment({ targetComposerElementId: '
  submitComment("  →  submitComment({ targetComposerElementId: "
  ```

  ## Type Updates

  If using TypeScript, update type imports:

  ```typescript
  // Add new types
  import type {
    SubmitCommentRequest,
    ClearComposerRequest,
    GetComposerDataRequest,
    ComposerTextChangeEvent // Updated interface
  } from '@veltdev/types';

  // IVeltCommentComposerProps updated
  interface IVeltCommentComposerProps {
    targetComposerElementId?: string; // Renamed from targetElementId
    // ... other props
  }
  ```
  ```

## Implementation Sequence

1. **Update Data Models** (High Priority, No Dependencies)
   - Add SubmitCommentRequest, ClearComposerRequest, GetComposerDataRequest types
   - Update VeltCommentComposerProps interface
   - Update ComposerTextChangeEvent interface
   - Effort: 30 min

2. **Update API Methods Index** (High Priority, Depends on #1)
   - Update submitComment() signature
   - Add clearComposer() method
   - Add getComposerData() method
   - Effort: 15 min

3. **Update Comments Customize Behavior** (High Priority, Depends on #1-2)
   - Update submitComment() section with new signature
   - Add clearComposer() section
   - Add getComposerData() section
   - Update composerTextChange event description
   - Effort: 45 min

4. **Update VeltCommentComposer Component Docs** (High Priority, Depends on #1-3)
   - Update standalone component customize-behavior.mdx
   - Update UI customization component page
   - Update comment-dialog-components.mdx composer section
   - Effort: 45 min

5. **Create Migration Guide** (High Priority, Standalone)
   - Create migration guide document
   - Document breaking changes
   - Provide search/replace patterns
   - Link from changelog
   - Effort: 30 min

6. **Verify Setup Documentation** (Low Priority, Final Check)
   - Verify inline-comments.mdx (no changes needed)
   - Verify popover.mdx (no changes needed)
   - Effort: 15 min

**Total Estimated Effort**: 3 hours

## Quality Checklist

- [ ] All new types (SubmitCommentRequest, ClearComposerRequest, GetComposerDataRequest) added to data-models.mdx
- [ ] VeltCommentComposerProps interface updated with `targetComposerElementId` (removed `targetElementId`)
- [ ] ComposerTextChangeEvent interface updated with `annotation` and `targetComposerElementId` fields
- [ ] submitComment() method signature updated in api-methods.mdx
- [ ] clearComposer() method added to api-methods.mdx
- [ ] getComposerData() method added to api-methods.mdx
- [ ] submitComment() documentation updated in customize-behavior.mdx with new signature
- [ ] clearComposer() documentation added to customize-behavior.mdx
- [ ] getComposerData() documentation added to customize-behavior.mdx
- [ ] composerTextChange event description updated
- [ ] All VeltCommentComposer component docs updated with new prop name
- [ ] All code examples include both React and Other Frameworks tabs
- [ ] All submitComment() code examples updated to use request object syntax
- [ ] Migration guide created at `/Users/yoenzhang/Downloads/docs/release-notes/migration-guides/v4.7.4-migration.mdx`
- [ ] Breaking changes clearly documented in migration guide
- [ ] Search/replace patterns provided for easy migration
- [ ] No updates to unrelated `targetElementId` usage (VeltCommentTool, VeltInlineCommentsSection use different context)
- [ ] Planning log written to `/Users/yoenzhang/Downloads/docs/.claude/logs/agent-2-planning-4.7.4.md`

## Notes

- **Context Disambiguation**: The term `targetElementId` appears in multiple contexts:
  - VeltCommentComposer: NOW `targetComposerElementId` (composer identification)
  - VeltCommentTool: STILL `targetElementId` (element binding for popover comments)
  - VeltInlineCommentsSection: STILL `targetElementId` (container binding)
  - CommentAnnotation: STILL `targetElementId` (annotation target reference)
  - Only VeltCommentComposer prop and related API calls are affected by this release

- **No New Wireframes**: No UI component wireframes affected by these changes

- **Event Enhancement**: ComposerTextChangeEvent is enhanced, not breaking - existing code accessing `text` field continues to work

- **API Consistency**: New methods follow established SDK patterns (request objects, consistent naming)
