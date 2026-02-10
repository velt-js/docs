# Release Update Plan for Version 4.7.3

## Overview
- Release Type: Patch
- Release Date: January 29, 2026
- Key Changes: Three new Comment features - submitComment() method, placeholder prop, composerTextChange event
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models - NEW TYPE AND PROP ADDITIONS
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes:
  - Add `placeholder` property to `VeltCommentComposerProps` interface (line ~1692-1701)
  - Add `targetElementId` property to `VeltCommentComposerProps` interface (if not already present)
- Priority: High
- Effort: 5 minutes

### 2. API Methods - METHOD ALREADY DOCUMENTED
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Current State: `submitComment()` method already documented at lines 96-101
- Changes: No changes needed
- Priority: N/A

### 3. Comment Composer Props - NEW PLACEHOLDER PROP
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/standalone-components/comment-composer.mdx`
- Current State: Placeholder prop already documented at lines 105-119
- Changes: No changes needed
- Priority: N/A

### 4. Comment Composer Customize Behavior - ADD TARGET ELEMENT ID
- File: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/standalone-components/comment-composer/customize-behavior.mdx`
- Changes: Add documentation for `targetElementId` prop (enables submitComment() method integration)
- Priority: High
- Location: Add new section after existing props (context, documentId, folderId, locationId)
- Effort: 10 minutes

### 5. Comments Main Documentation - METHODS AND EVENTS
- File: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
- Current State:
  - `submitComment()` method documented at line 766
  - `composerTextChange` event documented in events table at line 2733
- Changes: No changes needed
- Priority: N/A

## Areas NOT Requiring Updates

### Already Documented Features
- `submitComment()` method - fully documented in both api-methods.mdx and customize-behavior.mdx
- `placeholder` prop - fully documented in comment-composer.mdx UI customization
- `composerTextChange` event - already in events table at line 2733 with ComposerTextChangeEvent type link

### Event Type Already Exists
- `ComposerTextChangeEvent` interface defined in data-models.mdx at lines 1438-1443
- Event subscription pattern already documented with examples

## Implementation Sequence

1. **Data Models** (High Priority)
   - Add `placeholder: string` to VeltCommentComposerProps (line ~1697)
   - Add `targetElementId: string` to VeltCommentComposerProps (line ~1698)
   - Effort: 5 minutes

2. **Comment Composer Props Documentation** (High Priority)
   - Add `targetElementId` prop section to comment-composer/customize-behavior.mdx
   - Include React and Other Frameworks examples
   - Link to submitComment() method documentation
   - Effort: 10 minutes

## Quality Checklist
- [ ] `placeholder` property added to VeltCommentComposerProps in data-models.mdx
- [ ] `targetElementId` property added to VeltCommentComposerProps in data-models.mdx
- [ ] `targetElementId` prop documented in comment-composer/customize-behavior.mdx
- [ ] Code examples include React/Next.js and Other Frameworks tabs
- [ ] Cross-reference link to submitComment() method included
- [ ] No breaking changes flagged
- [ ] Planning log written to `.claude/logs/agent-2-planning-4.7.3.md`

## Documentation Patterns to Follow

### VeltCommentComposerProps Pattern (data-models.mdx)
```markdown
| Property        | Type     | Required | Description                                    |
|-----------------|----------|----------|------------------------------------------------|
| `placeholder`   | `string` | No       | Custom placeholder text for the composer input |
| `targetElementId` | `string` | No     | Unique identifier for programmatic submission  |
```

### Component Prop Pattern (customize-behavior.mdx)
```markdown
## targetElementId
Set a unique identifier for the composer to enable programmatic submission via the submitComment() method.

<Tabs>
<Tab title="React / Next.js">
```jsx
<VeltCommentComposer targetElementId="composer-1" />
```
</Tab>
<Tab title="Other Frameworks">
```html
<velt-comment-composer target-element-id="composer-1"></velt-comment-composer>
```
</Tab>
</Tabs>

[Learn more about submitComment() →](/async-collaboration/comments/customize-behavior#submitcomment)
```

## Specific Documentation Updates

### 1. VeltCommentComposerProps (data-models.mdx, line ~1692-1701)
Add two new properties to the table:
- `placeholder`: string | No | Custom placeholder text for the composer input
- `targetElementId`: string | No | Unique identifier for programmatic submission via submitComment()

### 2. targetElementId Prop (comment-composer/customize-behavior.mdx)
Add new section after `locationId` (after line 73):
- Description: Enables programmatic submission via submitComment() method
- Show React and HTML examples with targetElementId="composer-1"
- Add cross-reference link to submitComment() documentation
- Reference the release note example showing button integration

## Notes for Agent-3

### Minimal Changes Required
Most documentation already exists:
- submitComment() method: fully documented in two locations
- placeholder prop: documented in UI customization section
- composerTextChange event: documented in events table with type definition

### Only Two Updates Needed
1. Add two properties to VeltCommentComposerProps type definition
2. Document targetElementId prop in comment-composer customize-behavior

### Cross-Reference Strategy
Link targetElementId documentation to submitComment() method for complete integration story.

### Pattern Consistency
Follow existing prop documentation patterns in comment-composer/customize-behavior.mdx (context, documentId, folderId, locationId sections).
