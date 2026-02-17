# Release Update Plan for v5.0.1-beta.4

## Overview
- Release Type: Patch
- Key Changes: Private Mode API (2 new methods + 2 new types); `commentSaved` event (1 new type); `CommentVisibilityType` value renames
- Breaking Changes: Yes — `CommentVisibilityType` values `'organization'` → `'organizationPrivate'` and `'self'` → `'restricted'`

---

## Areas Requiring Updates

### 1. Data Models
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Anchors to update/add:
  - `#commentvisibilitytype` (line 113–125): Update type string to `'public' | 'organizationPrivate' | 'restricted'`; rename table rows `'organization'` → `'organizationPrivate'` and `'self'` → `'restricted'`
  - `#commentvisibilityconfig` (line 127–135): Update `type` column description to reference new value names; the `annotationId` `Required` column should remain `Yes` per existing doc
  - Add new section `#### PrivateModeConfig` after `CommentVisibilityConfig`: one-line description + TypeScript type alias showing `Omit<CommentVisibilityConfig, 'annotationId' | 'organizationId'>`; note it accepts `type` and `userIds` only
  - Add new section `#### CommentSavedEvent` near the existing `AddCommentAnnotationEvent` block (around line 53): table with `annotationId: string (Yes)`, `commentAnnotation: CommentAnnotation (Yes)`, `metadata: VeltEventMetadata (Yes)`
- Priority: High

### 2. API Methods
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Changes:
  - Add `#### enablePrivateMode()` entry in the Comments section (near `updateVisibility()` at line 138): `Params: PrivateModeConfig`, `Returns: void`, `React Hook: n/a`, link to customize-behavior anchor `#enableprivatemode`
  - Add `#### disablePrivateMode()` entry directly after: `Params: none`, `Returns: void`, `React Hook: n/a`, link to `#disableprivatemode`
  - Update `#### updateVisibility()` param link to `CommentVisibilityConfig` — no signature change needed, but verify the description still reads correctly after the `CommentVisibilityType` rename
- Priority: High

### 3. Comments Customize Behavior Doc
- File: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/customize-behavior.mdx`
- Changes:
  - Under `# Private Comments` (around line 2552), add new subsections `#### enablePrivateMode` and `#### disablePrivateMode` before or after `updateVisibility`. Each subsection must include: description, params table (for `enablePrivateMode`: `type`, `userIds`), and React/Other Frameworks code tabs.
  - Update the existing `updateVisibility` section (lines 2556–2616): rename `'organization'` → `'organizationPrivate'` and `'self'` → `'restricted'` in both prose descriptions and all code examples (6 call sites at lines 2571–2614).
  - Add `commentSaved` row to the Event Subscription table (line 2964–2999) under a new or existing category (e.g., "Threads"): event type `commentSaved`, description "Triggered after a comment is successfully persisted to the database", event object `CommentSavedEvent` with link to `#commentsavedevent`.
- Priority: High

### 4. Migration Guide
- File: `/Users/yoenzhang/Downloads/docs/release-notes/version-5/upgrade-guide.mdx`
- Changes: Add a new breaking-change entry for `CommentVisibilityType` rename. Format: two-column table mapping old values to new values (`'organization'` → `'organizationPrivate'`, `'self'` → `'restricted'`). Direct users to update any `updateVisibility()` calls and any conditional logic that checks the `type` field.
- Priority: High

---

## Areas Confirmed NOT Requiring Updates

- **Assign Dropdown CDK Overlay** — internal rendering change; no API or wireframe surface change.
- **Auto-resolution of `organizationId`** — internal behavior; no new API params.
- **Bug Fixes (4 items)** — dark mode toggle, composer placeholder, emoji SVG, priority dropdown — all internal; no API changes.
- **UI Customization docs** — no new wireframes or component primitives introduced.

---

## Implementation Sequence

1. Update `data-models.mdx`: rename `CommentVisibilityType` values; update `CommentVisibilityConfig` description; add `PrivateModeConfig` type; add `CommentSavedEvent` type. (High effort anchor: lines 113–135)
2. Update `api-methods.mdx`: add `enablePrivateMode()` and `disablePrivateMode()` method entries near `updateVisibility()`.
3. Update `customize-behavior.mdx`: rename old type values in `updateVisibility` section; add `enablePrivateMode`/`disablePrivateMode` subsections with code tabs; add `commentSaved` row to the event subscription table.
4. Update `upgrade-guide.mdx`: add `CommentVisibilityType` rename entry under Breaking Changes.

---

## Quality Checklist
- [ ] `CommentVisibilityType` updated to `'public' | 'organizationPrivate' | 'restricted'` in `data-models.mdx`
- [ ] `CommentVisibilityConfig` description updated to use new value names in `data-models.mdx`
- [ ] `PrivateModeConfig` type alias added to `data-models.mdx`
- [ ] `CommentSavedEvent` interface added to `data-models.mdx`
- [ ] `enablePrivateMode()` and `disablePrivateMode()` added to `api-methods.mdx`
- [ ] `enablePrivateMode` and `disablePrivateMode` subsections with React/Other Frameworks tabs added to `customize-behavior.mdx`
- [ ] Old `'organization'` / `'self'` values renamed throughout `customize-behavior.mdx` `updateVisibility` section
- [ ] `commentSaved` row added to event subscription table in `customize-behavior.mdx`
- [ ] Breaking change entry added to `release-notes/version-5/upgrade-guide.mdx`
- [ ] Code examples follow React / Next.js first, Other Frameworks second tab order
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.1-beta.4.md`
