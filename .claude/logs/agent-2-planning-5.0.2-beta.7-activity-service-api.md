# Release Update Plan for v5.0.2-beta.7 — Activity Service API (REST)

## Overview
- Release Type: Minor (addendum to v5.0.2-beta.7 SDK release)
- Key Changes: 4 new REST API endpoints for Activity CRUD (`/v2/activities/get|add|update|delete`); new `triggerActivities` flag on `CommentData` in `POST /v2/commentannotations/add`
- Breaking Changes: No

**Scope note**: The prior `agent-2-planning-5.0.2-beta.7.md` covers the SDK (ActivityElement). This document covers only the REST API surface added in the same version.

---

## Areas Requiring Updates

### 1. New REST API MDX Files — Activity Endpoints
- Directory: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/activities/`
- Files to create (4 new files):
  - `get-activities.mdx`
  - `add-activities.mdx`
  - `update-activities.mdx`
  - `delete-activities.mdx`
- Priority: High

**Changes needed:**

Model each file after the notifications pattern at `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/notifications/`. Each file needs: frontmatter `title` + `api` fields, Endpoint section, Headers (`x-velt-api-key`, `x-velt-auth-token`), Body Params, Example Request(s), Success/Failure Response, and `<ResponseExample>` block.

**`get-activities.mdx`** — `POST https://api.velt.dev/v2/activities/get`
- Body params: `apiKey` (string, required), `organizationId` (string, required), `documentId` (string), `featureTypes` (string[], filter by feature e.g. `"comment"`), `actionTypes` (string[]), `userId` (string), `pageSize` (number, default 1000), `pageToken` (string), `order` (string, `"asc"` or `"desc"`, default `"desc"`)
- Example request from release note: `organizationId`, `documentId`, `featureTypes: ["comment"]`, `order: "desc"`, `pageSize: 50`
- Note: requires workspace `activityServiceConfig` enabled

**`add-activities.mdx`** — `POST https://api.velt.dev/v2/activities/add`
- Body params: `apiKey` (string, required), `organizationId` (string, required), `documentId` (string, required), `activities` (object[], required) with nested fields: `featureType` (string), `actionType` (string), `actionUser` (User object), `targetEntityId` (string), `changes` (object), `displayMessageTemplate` (string), `displayMessageTemplateData` (object)
- Example request from release note: activities array with one entry showing `featureType`, `actionType`, `actionUser`, `targetEntityId`, `displayMessageTemplate`
- Note: requires workspace `activityServiceConfig` enabled; activity creation gated by per-action trigger configuration

**`update-activities.mdx`** — `POST https://api.velt.dev/v2/activities/update`
- Body params: `apiKey` (string, required), `organizationId` (string, required), `activityIds` (string[], required), update fields (derive pattern from notifications `update-notifications.mdx`)
- Note: update specific activities by ID

**`delete-activities.mdx`** — `POST https://api.velt.dev/v2/activities/delete`
- Body params: `apiKey` (string, required), `organizationId` (string, required), one of: `documentId` (string), `targetEntityId` (string), or `activityIds` (string[]) — delete supports three filter strategies
- Note: pattern mirrors delete notifications

---

### 2. Existing REST API File — Add `triggerActivities` param
- File: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/comments-feature/comment-annotations/add-comment-annotations.mdx`
- Priority: High

**Change needed:**

Add `triggerActivities` as a new `<ParamField>` inside the `commentData` expandable (currently ends at `taggedUserContacts`, line 148). Insert after `triggerNotification` (line 113):

```
<ParamField body="triggerActivities" type="boolean">
  When enabled, adding this comment via the REST API will automatically create an
  activity record. Requires workspace-level `activityServiceConfig` to be enabled.
  Default: false.
</ParamField>
```

Add an example request block showing `triggerActivities: true` usage (mirrors the release note JSON example at changelog line 139–152).

---

### 3. Navigation — docs.json
- File: `/Users/yoenzhang/Downloads/docs/docs.json`
- Priority: High

**Change needed:**

Add a new `"Activities"` group in the v2 REST API navigation section after the existing `"Notifications"` group (currently ends around line 498). Insert:

```json
{
  "group": "Activities",
  "pages": [
    "api-reference/rest-apis/v2/activities/get-activities",
    "api-reference/rest-apis/v2/activities/add-activities",
    "api-reference/rest-apis/v2/activities/update-activities",
    "api-reference/rest-apis/v2/activities/delete-activities"
  ]
}
```

---

### 4. Existing Activity Feature Docs — `activityServiceConfig` Note
- File: `/Users/yoenzhang/Downloads/docs/async-collaboration/activity/setup.mdx`
- Priority: Medium

**Change needed:**

Add a `<Note>` or `<Warning>` block in the setup page noting that REST API activity creation (via `POST /v2/activities/add`) requires workspace-level `activityServiceConfig` to be enabled. Link to the new REST API reference page. This does not affect the SDK `ActivityElement` setup steps.

---

### 5. Skills — Agent-7 Deltas for Activity Service API
- File: `/Users/yoenzhang/Downloads/docs/.claude/logs/agent-7-skills-deltas-5.0.2-beta.7.json` (append new skillSet entry, or create `agent-7-skills-deltas-5.0.2-beta.7-activity-service-api.json`)
- Priority: Low

**Assessment**: The Activity Service API is a pure REST API addition. No existing SDK skill sets (crdt, comments, notifications) have rules governing REST API endpoint schemas at this level. The `triggerActivities` flag on `POST /v2/commentannotations/add` is adjacent to comments, but the existing `comments` skill already handles the `triggerNotification` flag pattern — the delta would be a new rule for `triggerActivities`. Flag this as a potential delta for Agent-7 review; do not create new skill rules without a confirmed skill delta.

**Recommendation**: Agent-7 should assess whether a `data-trigger-activities.md` rule is warranted in the comments skill, covering when and how `triggerActivities` differs from `triggerNotification` on comment add.

---

## Implementation Sequence

1. Create `/api-reference/rest-apis/v2/activities/` directory and 4 MDX files. (No dependencies; models on notifications pattern.)
2. Update `add-comment-annotations.mdx` to add `triggerActivities` param and example. (No dependencies.)
3. Update `docs.json` to add Activities nav group after Notifications. (Depends on step 1 files existing.)
4. Update `async-collaboration/activity/setup.mdx` with `activityServiceConfig` REST API note. (Depends on step 1 files for link target.)
5. Flag Agent-7 for `triggerActivities` delta assessment in comments skill. (Independent.)

---

## Quality Checklist
- [ ] 4 new MDX files created under `api-reference/rest-apis/v2/activities/`
- [ ] Each file has correct `title` and `api` frontmatter with full endpoint URL
- [ ] Each file includes Headers section with `x-velt-api-key` and `x-velt-auth-token`
- [ ] `get-activities.mdx` documents `featureTypes`, `actionTypes`, `userId`, `pageSize`, `pageToken`, `order` params
- [ ] `add-activities.mdx` documents `activities[]` with nested `featureType`, `actionType`, `actionUser`, `targetEntityId`, `displayMessageTemplate`
- [ ] `delete-activities.mdx` documents three deletion strategies: by `documentId`, `targetEntityId`, or `activityIds`
- [ ] `activityServiceConfig` prerequisite noted in `add-activities.mdx` and `get-activities.mdx`
- [ ] `triggerActivities` boolean added to `commentData` expandable in `add-comment-annotations.mdx` after `triggerNotification`
- [ ] Example request with `triggerActivities: true` added to `add-comment-annotations.mdx`
- [ ] `docs.json` Activities group added after Notifications group in v2 section with all 4 page paths
- [ ] `async-collaboration/activity/setup.mdx` updated with REST API `activityServiceConfig` note
- [ ] Agent-7 flagged for `triggerActivities` delta assessment in comments skill
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.7-activity-service-api.md`
