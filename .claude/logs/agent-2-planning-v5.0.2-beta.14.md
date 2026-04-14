# Release Update Plan for v5.0.2-beta.14

## Overview
- Release Type: Patch (beta)
- Key Changes: New `pinDrag` prop + `enablePinDrag()`/`disablePinDrag()` API methods on Comments; Recorder bug fix
- Breaking Changes: No

## Analysis Summary

**Feature 1 — Comments: Pin Drag Toggle**
New prop `pinDrag` / `pin-drag` (boolean, default `true`) on `<VeltComments>` / `<velt-comments>` component. Two new `CommentElement` API methods: `enablePinDrag()` and `disablePinDrag()`.

**Feature 2 — Recorder: getUserMedia bug fix**
Internal device selection logic changed (`ideal` → `exact`). No new types, props, or API signatures exposed to consumers. No documentation update required.

## Areas Requiring Updates

### 1. API Methods — new CommentElement methods
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Changes: Add `enablePinDrag()` and `disablePinDrag()` entries in the CommentElement section, following the same pattern as `enableCommentPinHighlighter()` / `disableCommentPinHighlighter()` (brief description, params: none, returns: void, link to customize-behavior).
- Anchor targets to use: `#enablepindrag` / `#disablepindrag`
- Priority: High

### 2. Customize Behavior — new feature section
- File: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
- Changes: Add a new `pinDrag` section (prop + API methods block) following the `enableCommentPinHighlighter` pattern:
  - Section heading: `#### pinDrag`
  - Default: `true`
  - React / Next.js tab: `<VeltComments pinDrag={false} />` + API methods using `client.getCommentElement()`
  - Other Frameworks tab: `<velt-comments pin-drag="false">` + API methods using `Velt.getCommentElement()`
  - Placement: near related pin behavior features (adjacent to `enableCommentPinHighlighter` section around line 5578)
- Priority: High

### 3. Comments Methods JSON Snippet
- File: `/Users/yoenzhang/Downloads/docs/snippets/comments-methods-json.mdx`
- Changes: Add two entries for `enablePinDrag` and `disablePinDrag` following the same JSON structure as `enableCommentPinHighlighter`/`disableCommentPinHighlighter`.
- Priority: Medium

## Files NOT Requiring Updates
- `data-models.mdx` — `pinDrag` is a component prop with a boolean type; no new model/interface added. The pattern for similar props (e.g., `commentPinHighlighter`) shows they are not listed in data-models.
- `upgrade-guide.mdx` — No breaking changes.
- UI Customization pages — No new wireframes or primitive components.

## Implementation Sequence
1. Update `api-methods.mdx` — add `enablePinDrag()` and `disablePinDrag()` entries with link to customize-behavior anchor.
2. Update `customize-behavior.mdx` — add `pinDrag` feature section with prop examples and API method tabs.
3. Update `comments-methods-json.mdx` — add JSON entries for both new methods.

## Quality Checklist
- [ ] `enablePinDrag()` / `disablePinDrag()` added to api-methods.mdx
- [ ] `pinDrag` section added to customize-behavior.mdx with React and Other Frameworks tabs
- [ ] Both component prop and API method usage shown in customize-behavior
- [ ] JSON snippet entries added for both methods
- [ ] No breaking changes documented (none exist)
- [ ] Log file written to `.claude/logs/agent-2-planning-v5.0.2-beta.14.md`
