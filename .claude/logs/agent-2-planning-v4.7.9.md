# Release Update Plan for v4.7.9

## Overview
- **Release Version**: v4.7.9
- **Release Type**: Minor
- **Key Changes**: Read-only mode for comment components, edit composer wireframe, page mode composer enhancements, resolved-by user tracking, assignment configuration interface
- **Breaking Changes**: Yes - `setAssignToType` API signature changed to accept `AssignToConfig` object

## Areas Requiring Updates

### 1. Data Models
**Status**: UPDATE REQUIRED

**Priority**: HIGH

**Files to Update**:
1. `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`

**Changes Needed**:

#### 1.1 Add PageModeComposerConfig Interface
**Location**: Component Props section (around line 800-1000)
**Change**: Add new interface definition
**Details**:
```markdown
#### PageModeComposerConfig
---

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `context` | `any` | Yes | Custom context data to set in the page mode composer |
| `targetElementId` | `string` | No | ID of the target element for the comment annotation |
```

#### 1.2 Add AssignToConfig Interface
**Location**: Component Props section (after PageModeComposerConfig)
**Change**: Add new interface definition
**Details**:
```markdown
#### AssignToConfig
---

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `assignToType` | `'dropdown' \| 'checkbox'` | Yes | UI mode for assignment functionality. `dropdown` for menu navigation, `checkbox` for quick self-assignment |
```

#### 1.3 Update CommentAnnotation Interface
**Location**: Comments > Threads > CommentAnnotation (line ~6-43)
**Change**: Add new property to existing interface
**Details**: Add row to CommentAnnotation table:
```markdown
| `resolvedByUser` | [`User`](#user) | No | User object who resolved this comment annotation |
```

#### 1.4 Update CommentToolClickEvent Interface
**Location**: Comments > Threads > CommentToolClickEvent (line ~1552-1557)
**Change**: Add new property to existing interface
**Details**: Add row to CommentToolClickEvent table:
```markdown
| `targetElementId` | `string` | No | ID of the target element if available |
```

### 2. API Methods
**Status**: UPDATE REQUIRED

**Priority**: HIGH

**Files to Update**:
1. `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`

**Changes Needed**:

#### 2.1 Update setContextInPageModeComposer() Method
**Location**: Comments > DOM Controls section
**Change**: Update method signature and parameters
**Details**:
```markdown
#### setContextInPageModeComposer()
Set context data for the page mode composer programmatically, with optional target element binding.
- Params: `config:` [PageModeComposerConfig](/api-reference/sdk/models/data-models#pagemodecomposerconfig) `- Configuration object with context and optional targetElementId`
- Returns: `void`
- React Hook: `n/a`
- [Full Documentation →](/async-collaboration/comments/customize-behavior#setcontextinpagemodecomposer)
```

#### 2.2 Update setAssignToType() Method (Breaking Change)
**Location**: Comments section
**Change**: Update method signature to accept config object
**Details**:
```markdown
#### setAssignToType()
Configure the assignment UI mode. **Breaking change in v4.7.9**: Now accepts a config object instead of string literal.
- Params: `config:` [AssignToConfig](/api-reference/sdk/models/data-models#assigntoconfig) `- Configuration object specifying assignment type`
- Returns: `void`
- React Hook: `n/a`
- [Full Documentation →](/async-collaboration/comments/customize-behavior#customize-assignment)
```

### 3. Component Props Documentation
**Status**: UPDATE REQUIRED

**Priority**: HIGH

**Files to Update**:
1. `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/standalone-components/comment-composer/customize-behavior.mdx`
2. `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/setup/inline-comments.mdx`

**Changes Needed**:

#### 3.1 Add readOnly Prop to VeltCommentComposer
**File**: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/standalone-components/comment-composer/customize-behavior.mdx`
**Location**: Props table section
**Change**: Add new prop documentation
**Details**: Add row to props table:
```markdown
| `readOnly` | `boolean` | No | When true, makes the composer read-only and prevents user input |
```

#### 3.2 Add readOnly Prop to VeltInlineCommentsSection
**File**: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/setup/inline-comments.mdx`
**Location**: Props table section
**Change**: Add new prop documentation
**Details**: Add row to props table:
```markdown
| `readOnly` | `boolean` | No | When true, makes all composers in the inline section read-only |
```

### 4. Wireframe Documentation
**Status**: UPDATE REQUIRED

**Priority**: MEDIUM

**Files to Update**:
1. `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`

**Changes Needed**:

#### 4.1 Add VeltCommentDialogThreadCardEditComposer Component
**Location**: Add to wireframe components list
**Change**: Document new wireframe component
**Details**:
```markdown
#### VeltCommentDialogThreadCardEditComposer
Wireframe component for the edit composer within a comment thread card.

**Usage**:
```jsx
<VeltCommentDialogThreadCardEditComposer />
```

**Description**: Renders the composer interface when editing an existing comment in the thread card. This allows full customization of the edit mode UI.

**Related Components**:
- VeltCommentDialogThreadCard - Parent component containing the edit composer
- VeltCommentDialogThreadCardComposer - New comment composer (separate from edit)
```

### 5. Feature Documentation
**Status**: UPDATE REQUIRED

**Priority**: HIGH

**Files to Update**:
1. `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`

**Changes Needed**:

#### 5.1 Update setContextInPageModeComposer Section
**Location**: Find existing setContextInPageModeComposer documentation
**Change**: Update to include targetElementId parameter
**Details**: Update code examples to show new API signature:

<Tabs>
<Tab title="React / Next.js">
```jsx
const commentElement = useCommentUtils();

// Set context only
commentElement.setContextInPageModeComposer({
  context: { customData: "value" }
});

// Set context with target element
commentElement.setContextInPageModeComposer({
  context: { customData: "value" },
  targetElementId: "element-id"
});
```
</Tab>

<Tab title="Other Frameworks">
```javascript
const commentElement = client.getCommentElement();

// Set context only
commentElement.setContextInPageModeComposer({
  context: { customData: "value" }
});

// Set context with target element
commentElement.setContextInPageModeComposer({
  context: { customData: "value" },
  targetElementId: "element-id"
});
```
</Tab>
</Tabs>

#### 5.2 Update setAssignToType Section
**Location**: Find existing assignment customization documentation
**Change**: Update method signature and add migration note
**Details**: Update code examples and add breaking change note:

**Breaking Change in v4.7.9**: This method now accepts a configuration object instead of a string literal.

**Migration**:
```jsx
// Before v4.7.9
commentElement.setAssignToType('checkbox');

// v4.7.9 and later
commentElement.setAssignToType({
  assignToType: 'checkbox'
});
```

<Tabs>
<Tab title="React / Next.js">
```jsx
const commentElement = useCommentUtils();

// Dropdown mode (default)
commentElement.setAssignToType({
  assignToType: 'dropdown'
});

// Checkbox mode (quick self-assignment)
commentElement.setAssignToType({
  assignToType: 'checkbox'
});
```
</Tab>

<Tab title="Other Frameworks">
```javascript
const commentElement = client.getCommentElement();

// Dropdown mode (default)
commentElement.setAssignToType({
  assignToType: 'dropdown'
});

// Checkbox mode (quick self-assignment)
commentElement.setAssignToType({
  assignToType: 'checkbox'
});
```
</Tab>
</Tabs>

### 6. Migration Guide
**Status**: UPDATE REQUIRED

**Priority**: HIGH

**Files to Update**:
1. Create or update v4.7.x migration section in `/Users/yoenzhang/Downloads/docs/release-notes/version-4/upgrade-guide.mdx`

**Changes Needed**:

#### 6.1 Add v4.7.9 Breaking Changes Section
**Location**: Top of document or appropriate version section
**Change**: Document breaking change
**Details**:
```markdown
## v4.7.9 Breaking Changes

### setAssignToType API Change

The `setAssignToType()` method now accepts a configuration object instead of a string literal.

**Before v4.7.9**:
```jsx
commentElement.setAssignToType('checkbox');
```

**v4.7.9 and later**:
```jsx
commentElement.setAssignToType({
  assignToType: 'checkbox'
});
```

**Impact**: Low - Simple object wrapper around existing string value

**Action Required**: Update all calls to `setAssignToType()` to pass configuration object
```

### 7. UI Customization - NO UPDATES REQUIRED (except wireframe)
**Status**: MINIMAL UPDATE

**Analysis**:
- Bug fixes (CSS classes, read-only state) don't require UI customization docs updates
- CSS class changes are internal implementation details
- Read-only props are covered in component prop documentation
- Only new wireframe component needs UI customization documentation (covered in section 4)

## Implementation Sequence

### Phase 1: Foundation (Agent-3)
**Priority**: HIGH
**Dependencies**: None

1. Update `CommentAnnotation` interface in data-models.mdx (add `resolvedByUser`)
   - Estimated effort: 2 minutes

2. Update `CommentToolClickEvent` interface in data-models.mdx (add `targetElementId`)
   - Estimated effort: 2 minutes

3. Add `PageModeComposerConfig` interface to data-models.mdx
   - Estimated effort: 3 minutes

4. Add `AssignToConfig` interface to data-models.mdx
   - Estimated effort: 3 minutes

5. Update `setContextInPageModeComposer()` method in api-methods.mdx
   - Estimated effort: 3 minutes
   - Depends on: Step 3

6. Update `setAssignToType()` method in api-methods.mdx (breaking change note)
   - Estimated effort: 3 minutes
   - Depends on: Step 4

7. Add `readOnly` prop to VeltCommentComposer documentation
   - Estimated effort: 2 minutes

8. Add `readOnly` prop to VeltInlineCommentsSection documentation
   - Estimated effort: 2 minutes

9. Update setContextInPageModeComposer feature documentation
   - Estimated effort: 8 minutes
   - Depends on: Step 3

10. Update setAssignToType feature documentation with migration guide
    - Estimated effort: 8 minutes
    - Depends on: Step 4

### Phase 2: UI Customization (Agent-4)
**Priority**: MEDIUM
**Dependencies**: Phase 1 complete

11. Add VeltCommentDialogThreadCardEditComposer wireframe documentation
    - Estimated effort: 10 minutes

### Phase 3: Migration Guide (Agent-3 or Agent-5)
**Priority**: HIGH
**Dependencies**: Phase 1 complete

12. Add v4.7.9 breaking changes to upgrade guide
    - Estimated effort: 8 minutes

### Phase 4: Alignment (Agent-5)
**Priority**: MEDIUM
**Dependencies**: Phase 1, 2, 3 complete

13. Verify all cross-reference links work
    - Estimated effort: 8 minutes

14. Validate terminology consistency
    - Estimated effort: 5 minutes

### Phase 5: Quality Assurance (Agent-6)
**Priority**: MEDIUM
**Dependencies**: All phases complete

15. Technical accuracy review
    - Estimated effort: 10 minutes

16. Documentation completeness check
    - Estimated effort: 10 minutes

**Total Estimated Effort**: 87 minutes

## Quality Checklist

### Data Models
- [ ] `PageModeComposerConfig` interface added to data-models.mdx
- [ ] `AssignToConfig` interface added to data-models.mdx
- [ ] `resolvedByUser` property added to CommentAnnotation interface
- [ ] `targetElementId` property added to CommentToolClickEvent interface
- [ ] Standard table format used for all interfaces
- [ ] Consistent with existing data model patterns

### API Methods
- [ ] `setContextInPageModeComposer()` method updated with new signature
- [ ] `setAssignToType()` method updated with breaking change note
- [ ] Links to new data model interfaces work
- [ ] Breaking change clearly marked
- [ ] Links to feature documentation sections work

### Component Props
- [ ] `readOnly` prop added to VeltCommentComposer documentation
- [ ] `readOnly` prop added to VeltInlineCommentsSection documentation
- [ ] Prop descriptions are clear and accurate
- [ ] Consistent with existing prop documentation patterns

### Wireframe Documentation
- [ ] `VeltCommentDialogThreadCardEditComposer` component documented
- [ ] Usage example provided
- [ ] Related components referenced
- [ ] Placed in correct section of wireframe docs

### Feature Documentation
- [ ] setContextInPageModeComposer section updated with new API
- [ ] Code examples show both context and targetElementId usage
- [ ] setAssignToType section updated with config object syntax
- [ ] Migration guide embedded in feature docs
- [ ] Code examples include React/Next.js and Other Frameworks tabs

### Migration Guide
- [ ] v4.7.9 breaking changes section added to upgrade guide
- [ ] Breaking change clearly explained
- [ ] Before/after code examples provided
- [ ] Impact assessment included
- [ ] Action required is explicit

### Code Examples
- [ ] All code examples follow Velt standards
- [ ] Two-tab structure maintained (React + Other Frameworks)
- [ ] Code examples are accurate and runnable
- [ ] TypeScript types referenced where applicable

### Cross-references
- [ ] All internal links are correct
- [ ] Data model references are accurate
- [ ] API method links point to correct sections
- [ ] Feature documentation links are valid

### Breaking Changes
- [ ] Breaking change documented in api-methods.mdx
- [ ] Breaking change documented in feature docs
- [ ] Breaking change documented in migration guide
- [ ] Migration path is clear
- [ ] Impact is assessed

### Bug Fixes Documentation
- [ ] Verified bug fixes don't require documentation updates
- [ ] CSS class changes are internal and not user-facing
- [ ] Read-only state fixes covered by prop documentation

## Summary for Agent Pipeline

### Agent-3 (Technical Documentation) Tasks
**Status**: READY TO EXECUTE

**Files to Update**:
- `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/standalone-components/comment-composer/customize-behavior.mdx`
- `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/setup/inline-comments.mdx`
- `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
- `/Users/yoenzhang/Downloads/docs/release-notes/version-4/upgrade-guide.mdx`

**Key Tasks**:
1. Add PageModeComposerConfig and AssignToConfig interfaces
2. Update CommentAnnotation and CommentToolClickEvent interfaces
3. Update API method signatures with breaking change notes
4. Add readOnly props to component documentation
5. Update feature documentation with new API signatures
6. Add v4.7.9 migration guide

### Agent-4 (UI Customization) Tasks
**Status**: READY TO EXECUTE

**Files to Update**:
- `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`

**Key Tasks**:
1. Add VeltCommentDialogThreadCardEditComposer wireframe component documentation

### Agent-5 (Alignment) Tasks
**Status**: PENDING AGENT-3 & AGENT-4 COMPLETION

**Key Tasks**:
1. Verify cross-reference links for new interfaces
2. Validate breaking change documentation consistency
3. Check prop documentation alignment
4. Ensure migration guide matches feature docs

### Agent-6 (Quality Assurance) Tasks
**Status**: PENDING AGENT-3, AGENT-4, AGENT-5 COMPLETION

**Key Tasks**:
1. Verify technical accuracy of interface definitions
2. Check breaking change documentation completeness
3. Validate migration path clarity
4. Test all internal links
5. Final review of all updated documentation

## Notes and Considerations

### Design Decisions

1. **Breaking Change Visibility**
   - Document breaking change in THREE places: API methods, feature docs, migration guide
   - Ensures users encounter migration info regardless of entry point

2. **PageModeComposerConfig Object Structure**
   - Follows pattern established in other config interfaces
   - Makes API extensible for future enhancements
   - Separates required (context) from optional (targetElementId) parameters

3. **Read-Only Props Placement**
   - Document in component-specific customize-behavior or setup files
   - Not in centralized UI customization docs (these are behavioral props, not UI customization)

4. **Bug Fix Documentation**
   - Bug fixes generally don't require doc updates unless they expose new behavior
   - CSS class changes are internal and handled in release notes only
   - Fixes to existing behavior don't need new documentation

### Potential User Questions

1. **Q: Why did setAssignToType change to accept an object?**
   - A: Future extensibility - allows adding more assignment config options without breaking API again

2. **Q: What's the difference between VeltCommentDialogThreadCardComposer and VeltCommentDialogThreadCardEditComposer?**
   - A: One for new comments, one for editing existing comments

3. **Q: Does readOnly prevent all interaction or just text input?**
   - A: Just text input - document this clearly in prop description

4. **Q: Is resolvedByUser different from resolvedByUserId?**
   - A: Yes - resolvedByUser is full User object, resolvedByUserId is just the ID

### Risks and Mitigations

**Risk 1**: Breaking change might not be noticed by users
- **Mitigation**: Document in multiple locations, clear migration path

**Risk 2**: Confusion between edit composer and new comment composer wireframes
- **Mitigation**: Clear descriptions and related component references

**Risk 3**: Users might not understand when to use targetElementId
- **Mitigation**: Provide clear use case examples in feature docs

## Agent Handoff Information

### For Agent-3 (Technical Documentation)
**Input**: This planning document
**Expected Output**:
- Updated data models with new interfaces and properties
- Updated API methods with new signatures and breaking change notes
- Updated component props documentation
- Updated feature documentation with new examples
- Updated migration guide
- Log file: `.claude/logs/agent-3-completion-v4.7.9.md`

**Critical Requirements**:
- BREAKING CHANGE must be clearly marked in all relevant locations
- Migration guide must show before/after examples
- All new interfaces follow existing table format patterns
- Code examples maintain two-tab structure

### For Agent-4 (UI Customization)
**Input**: Planning document + Agent-3 completion
**Expected Output**:
- New wireframe component documented
- Log file: `.claude/logs/agent-4-ui-customization-v4.7.9.md`

**Critical Requirements**:
- Follow existing wireframe documentation patterns
- Include usage example and related components
- Place in correct section of comment-dialog-components.mdx

### For Agent-5 (Alignment)
**Input**: Agent-3 and Agent-4 completion
**Expected Output**:
- Verified cross-references
- Validated breaking change consistency
- Log file: `.claude/logs/agent-5-alignment-v4.7.9.md`

**Critical Requirements**:
- Breaking change documented consistently in all three locations
- All data model links work correctly
- Migration guide matches feature documentation

### For Agent-6 (Quality Assurance)
**Input**: Agent-3, Agent-4, and Agent-5 completion
**Expected Output**:
- Technical accuracy verification
- Breaking change migration clarity check
- Final approval
- Log file: `.claude/logs/agent-6-qa-v4.7.9.md`

**Critical Requirements**:
- Verify breaking change is clear and actionable
- Check migration examples are correct
- Validate all new interface definitions
- Ensure prop documentation is accurate

## Completion Criteria

This release documentation update will be considered complete when:

1. [ ] `PageModeComposerConfig` interface added to data-models.mdx
2. [ ] `AssignToConfig` interface added to data-models.mdx
3. [ ] `resolvedByUser` property added to CommentAnnotation
4. [ ] `targetElementId` property added to CommentToolClickEvent
5. [ ] `setContextInPageModeComposer()` method updated in api-methods.mdx
6. [ ] `setAssignToType()` method updated with breaking change note
7. [ ] `readOnly` prop documented for VeltCommentComposer
8. [ ] `readOnly` prop documented for VeltInlineCommentsSection
9. [ ] VeltCommentDialogThreadCardEditComposer wireframe documented
10. [ ] Feature documentation updated for setContextInPageModeComposer
11. [ ] Feature documentation updated for setAssignToType with migration
12. [ ] v4.7.9 migration guide added to upgrade-guide.mdx
13. [ ] All cross-references verified by Agent-5
14. [ ] Breaking change documented in three locations
15. [ ] Agent-6 approves all documentation
16. [ ] All agent log files completed

---

**Planning Log Generated**: 2026-02-06
**Agent-2 (Release Planning Specialist)**
**Ready for Agent-3 (Technical Documentation) Processing**
