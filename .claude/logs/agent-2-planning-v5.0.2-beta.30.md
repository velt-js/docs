# Release Update Plan for v5.0.2-beta.30

## Overview
- Release Type: Patch (beta)
- Key Changes: New `basicAnchorData` field on `CommentAnnotation` (client-facing); new optional `optimisticPermissions` field on `SetDocumentsRequestOptions`; permission-aware org access gating (behavioral, no API)
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models — CommentAnnotation
- File: `api-reference/sdk/models/data-models.mdx` (line ~5–44, `CommentAnnotation` table)
- Change: Add `basicAnchorData` optional row after `visibilityConfig`.
  - Property: `basicAnchorData`
  - Type: `{ xpath: string; topPercentage: number; leftPercentage: number }`
  - Required: No
  - Description: Anchor position data returned on the cleaned client annotation. `xpath` is the element's full xpath; `topPercentage` and `leftPercentage` default to `0`. Field is omitted entirely when no xpath is available.
- Priority: High
- Note: Agent-1 edited the velt-comments skill file (`data-comment-annotations.md`) directly. That edit may belong to the Plugin/skills agents (Agent-6), not Agent-3. Flag for Agent-6 review; Agent-3 should update `data-models.mdx` independently.

### 2. Data Models — SetDocumentsRequestOptions
- File: `api-reference/sdk/models/data-models.mdx` (line ~4256, `SetDocumentsRequestOptions` table)
- Status: `optimisticPermissions` row already present at line 4256 with correct description.
- Action: No update needed — already documented.
- Priority: N/A

### 3. API Methods
- No new methods or changed method signatures on the customer-facing surface.
- `getCommentAnnotationForClient` is an internal/SDK utility, not a documented SDK method.
- Action: No update needed.

### 4a. UI Customization — Wireframes
- No new wireframes. No update needed.

### 4b. UI Customization — Primitives
- No new primitive components or props. No update needed.

### 5. Upgrade Guide
- No breaking changes. No update needed.

## Agent Assignments

### Agent-3 (data-models.mdx + api-methods.mdx)
- Task: Add `basicAnchorData` optional field to the `CommentAnnotation` table in `api-reference/sdk/models/data-models.mdx`.
- Insert after the `visibilityConfig` row (line 44).
- Row content:
  `| \`basicAnchorData\` | \`{ xpath: string; topPercentage: number; leftPercentage: number }\` | No | Anchor position data on the cleaned client annotation. \`xpath\` is the element's full xpath; percentages default to \`0\`. Omitted when no xpath is present. |`
- No changes needed to `api-methods.mdx`.

### Agent-4 (feature docs / new pages)
- No new feature documentation pages needed. Skip.

### Agent-5 (UI customization docs)
- No wireframe or primitive changes. Skip.

### Agent-6 (skills/plugin sync)
- Review: Agent-1 added `basicAnchorData?` to the velt-comments skill file `data-comment-annotations.md`. Verify this addition is correct and consistent with the `data-models.mdx` entry Agent-3 will write. No additional skill rules needed for the permission gating change (behavioral, no API surface).

## Implementation Sequence
1. Agent-3: Add `basicAnchorData` row to `CommentAnnotation` table in `data-models.mdx` (single-row insert, no dependencies).
2. Agent-6: Verify velt-comments skill `data-comment-annotations.md` entry matches `data-models.mdx` after Agent-3 completes.

## Quality Checklist
- [ ] `basicAnchorData` added to `CommentAnnotation` table in `data-models.mdx`
- [ ] `optimisticPermissions` in `SetDocumentsRequestOptions` confirmed already present (no duplicate)
- [ ] No API method signatures changed — `api-methods.mdx` not touched
- [ ] No wireframe/primitive pages modified
- [ ] No upgrade guide entry (no breaking changes)
- [ ] Agent-6 cross-checks skill file edit from Agent-1
- [ ] Log written to `.claude/logs/agent-2-planning-v5.0.2-beta.30.md`
