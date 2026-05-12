# Release Update Plan for 5.0.2-beta.10

## Overview
- Release Type: Minor (patch-level API changes with new fields)
- Key Changes: Activities API — `targetEntityId` now optional for non-custom feature types; new `id` field for idempotent Firestore writes; `featureType` enum validated server-side. Access Control — `getUserPermissions` response gains `accessType` on folder/document entries with folder inheritance.
- Breaking Changes: No

## Already Updated by Agent-1
- `release-notes/version-5/sdk-changelog.mdx` — merged into v5.0.2-beta.10 entry
- `api-reference/rest-apis/v2/activities/add-activities.mdx` — `id` field, `targetEntityId` conditionality, `featureType` enum values added
- `api-reference/rest-apis/v2/auth/get-permissions.mdx` — `accessType` added to response schema

## Areas Requiring Updates

### 1. Data Models — `CreateActivityData`
- File: `api-reference/sdk/models/data-models.mdx`
- Changes:
  - `id` field: add row `| \`id\` | \`string\` | No | Optional Firestore document ID; controls idempotent writes — existing record with this ID is overwritten. |`
  - `targetEntityId` field: change Required column from `Yes` to `No`; update Description to `ID of the entity this activity log targets. Required when \`featureType\` is \`'custom'\`; optional for all other feature types.`
- Anchor: `#createactivitydata`
- Priority: High

### 2. Data Models — `ActivityRecord`
- File: `api-reference/sdk/models/data-models.mdx`
- Changes:
  - `targetEntityId` field: change Required column from `Yes` to `No` to reflect that non-custom records may lack it.
- Anchor: `#activityrecord`
- Priority: Medium

### 3. Data Models — `UserPermissionInfo`
- File: `api-reference/sdk/models/data-models.mdx`
- Status: Already has `accessType` row (line 1790). No change needed.
- Priority: N/A — skip

### 4. API Methods — `createActivity()`
- File: `api-reference/sdk/api/api-methods.mdx`
- Changes: Update the `Params` reference to note that `targetEntityId` inside `CreateActivityData` is now optional for non-custom feature types. Add one-line note: "When `featureType` is not `'custom'`, `targetEntityId` is optional."
- Anchor: `#createactivity`
- Priority: Medium

## Areas NOT Requiring Updates
- `ActivityFeatureType` enum in `data-models.mdx` — already has all five values (`comment`, `reaction`, `recorder`, `crdt`, `custom`) at line 2682. No change needed.
- `getUserPermissions()` in `api-methods.mdx` — return type already links to `GetUserPermissionsResponse`; `UserPermissionInfo.accessType` already in data-models.mdx. No change needed.
- `GetUserPermissionsResponse` / `GetUserPermissionsRequest` in `data-models.mdx` — already accurate.
- UI Customization wireframes/primitives — no new components or props.
- Upgrade guide — no breaking changes.
- `get-activities.mdx`, `update-activities.mdx`, `delete-activities.mdx` REST docs — no field changes for these endpoints in this release.
- `getActivityForClient`, `getReactionAnnotationForClient`, `getRecorderAnnotationForClient` — internal server-side utilities; not exposed in the public SDK API surface.

## Implementation Sequence
1. `data-models.mdx` — Add `id` field to `CreateActivityData`; mark `targetEntityId` optional in both `CreateActivityData` and `ActivityRecord`. (One file, two tables, low risk.)
2. `api-methods.mdx` — Add one-line clarification to `createActivity()` about `targetEntityId` optionality.

## Quality Checklist
- [ ] `id` field added to `CreateActivityData` in `data-models.mdx`
- [ ] `targetEntityId` Required column updated to `No` in `CreateActivityData`
- [ ] `targetEntityId` Required column updated to `No` in `ActivityRecord`
- [ ] `createActivity()` in `api-methods.mdx` notes `targetEntityId` optionality for non-custom types
- [ ] No breaking changes added to changelog (none exist in this release)
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.10.md`
