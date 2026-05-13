# Release Update Plan for v5.0.2-beta.21

## Overview
- Release Type: Patch
- Key Changes: One new public API method (`selectCommentByAnnotationId`); 7 bug fixes (internal refactors, no new types/interfaces)
- Breaking Changes: No

## Pre-Check: Already Documented

`selectCommentByAnnotationId()` already exists in both:
- `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx` (line 964)
- `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx` (line 5153)

Both entries are accurate and complete. No update needed to either file.

## Areas Requiring Updates

### 1. Data Models
- No new types or interfaces introduced.
- **No action required.**

### 2. API Methods (`api-methods.mdx`)
- `selectCommentByAnnotationId()` is already documented with correct params, return type, and link.
- **No action required.**

### 3. Feature Documentation (`customize-behavior.mdx`)
- `selectCommentByAnnotationId` section already exists with full React/Other Frameworks examples.
- **No action required.**

### 4a. UI Customization — Wireframes
- No new wireframe components introduced.
- **No action required.**

### 4b. UI Customization — Primitives

**Fix #4 — Options dropdown visibility in edit mode:**
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog/primitives.mdx`
- Affected primitives already exist: `VeltCommentDialogOptionsDropdown`, `VeltCommentDialogOptionsDropdownContentEdit`, `VeltCommentDialogOptionsDropdownContentDelete`
- No new primitive components added; visibility is now governed by internal logic, not a new prop.
- **No action required** — behavior change is internal only, no new props or attributes to document.

**Fix #5 — `velt-sidebar-button-unread-icon` wireframe template bug:**
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-sidebar-button/primitives.mdx`
- `VeltSidebarButtonUnreadIcon` already documented (line 52). No new props added.
- **No action required** — bug fix only, no API surface change.

### 5. Upgrade Guide
- No breaking changes.
- **No action required.**

## Implementation Sequence
No documentation updates required for this release. All relevant documentation was pre-existing and accurate.

## Quality Checklist
- [x] `selectCommentByAnnotationId` already in `api-methods.mdx` — no update needed
- [x] `selectCommentByAnnotationId` already in `customize-behavior.mdx` — no update needed
- [x] No new types to add to `data-models.mdx`
- [x] No new primitive components or props requiring primitives page updates
- [x] No breaking changes — upgrade guide not needed
- [x] Bug fixes #1–#7 are all internal; no customer-facing API surface changes
- [x] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.21.md`
