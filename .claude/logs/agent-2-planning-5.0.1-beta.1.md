# Release Update Plan for 5.0.1-beta.1

## Overview
- Release Type: Patch
- Key Changes: One API interface addition (`clearContext` on `PageModeComposerConfig`); breaking CSS class removal (`velt-composer-open`, `velt-composer-input-focused`); wireframe bug fixes (no API surface changes)
- Breaking Changes: Yes — `velt-composer-open` and `velt-composer-input-focused` CSS classes removed from Comment Dialog Composer host element

---

## Areas Requiring Updates

### 1. Data Models
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Anchor: `#pagemodecomposerconfig` (line 194)
- Change: Add `clearContext` row to the `PageModeComposerConfig` table.

  Current table has 2 rows (`context`, `targetElementId`). Add:

  | `clearContext` | `boolean` | No | When `false`, preserves context data after page mode composer submission. Defaults to `true` (context is cleared). |

- Priority: High

### 2. API Methods — setContextInPageModeComposer docs
- File: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
- Anchor: `#setcontextinpagemodecomposer` (line 2117)
- Change: Add a `clearContext: false` code example showing context preservation across submissions. Insert after the existing "Clear the context" example in both React and Other Frameworks tabs.

  Example to add (React tab):
  ```jsx
  // Preserve context after submission
  commentElement.setContextInPageModeComposer({
    context: { documentId: 'doc-123', section: 'intro' },
    targetElementId: 'element-1',
    clearContext: false
  });
  ```

  Example to add (Other Frameworks tab):
  ```js
  // Preserve context after submission
  commentElement.setContextInPageModeComposer({
    context: { documentId: 'doc-123', section: 'intro' },
    targetElementId: 'element-1',
    clearContext: false
  });
  ```

- Priority: High

### 3. Migration Guidance — Removed CSS Classes
- File: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
  - Search the file for any mention of `velt-composer-open` or `velt-composer-input-focused` as recommended CSS selectors. None found — no edit needed here.
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`
  - Search confirmed no references to `velt-composer-open` or `velt-composer-input-focused` outside release notes. No edit needed.
- Status: No live docs reference these classes. Breaking change is documented only in the release note. No further migration guide file is needed.
- Priority: Low (verified — no action required)

---

## Areas Confirmed NOT Requiring Updates

### Wireframe Bug Fixes (Comment Dialog, Comment Dialog Threads, Mark as Read/Unread)
- Bugs fixed: `dialogTemplate` forwarding, nested template extraction (`velt-comment-dialog-thread-card-wireframe`, `velt-comment-dialog-more-reply-wireframe`), Mark as Read/Unread HTML structure.
- These are internal rendering fixes. The wireframe APIs, component names, and usage patterns documented in:
  - `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-components.mdx`
  - `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog-structure.mdx`
  are unchanged. No documentation edits required.

### Button Service Internal Data Path Change
- `contextDataMapping.commentAnnotation.source` path change is internal to the SDK. No developer-facing API or prop changed. No documentation update needed.

### Test Coverage Additions
- Internal only. No documentation update needed.

---

## Implementation Sequence

1. Update `PageModeComposerConfig` table in `data-models.mdx` — add `clearContext` row (High, ~5 min)
2. Update `setContextInPageModeComposer` section in `customize-behavior.mdx` — add `clearContext: false` example in both tabs (High, ~10 min)

---

## Quality Checklist
- [x] All new types added to data-models.mdx (`clearContext` on `PageModeComposerConfig`)
- [x] Code examples include React and Other Frameworks tabs
- [x] Breaking changes documented (CSS class removal — verified no live docs need edits)
- [x] Wireframe fixes confirmed as internal — no doc updates needed
- [x] Log file written to `.claude/logs/agent-2-planning-5.0.1-beta.1.md`
- [x] No vague or generic statements
- [x] Task descriptions are concise
