# Release Update Plan for v5.0.2-beta.7

## Overview
- Release Type: Minor
- Key Changes: New ActivityElement API (real-time activity feed), activity action type constants, new `setActivityDebounceTime()` on CrdtElement, new ActivityMetadata class
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Priority: High

**Changes needed:**

**a. Add new `# Activity` top-level section** after the existing `# Notifications` section (line 2456).

Add the following types in order:

**`ActivitySubscribeConfig`** — config object passed to `getAllActivities()`:

| Property | Type | Required | Description |
|---|---|---|---|
| `documentIds` | `string[]` | No | Filter activities to specific document IDs |
| `featureTypes` | `ActivityFeatureType[]` | No | Filter by feature type (e.g., `'comment'`, `'reaction'`) |
| `actionTypes` | `string[]` | No | Filter by action type; use the exported action type constants |

**`ActivityFeatureType`** — string union type:
```
'comment' | 'reaction' | 'recorder' | 'crdt' | 'custom'
```

**`ActivityRecord`** — the core activity object returned from the feed:

| Property | Type | Required | Description |
|---|---|---|---|
| `id` | `string` | Yes | Unique activity ID |
| `featureType` | `ActivityFeatureType` | Yes | Feature that generated the activity |
| `actionType` | `string` | Yes | Specific action that occurred |
| `actionUser` | `User` | No | User who performed the action |
| `timestamp` | `number` | No | Unix timestamp of the activity |
| `targetEntityId` | `string` | No | ID of the entity the activity targets |
| `displayMessage` | `string` | No | Resolved display message |
| `displayMessageTemplate` | `string` | No | Template string with `{{variable}}` placeholders |
| `displayMessageTemplateData` | `object` | No | Data to fill the template |
| `documentId` | `string` | No | Document the activity belongs to |
| `organizationId` | `string` | No | Organization the activity belongs to |
| `metadata` | `ActivityMetadata` | No | Feature-specific extensible metadata |

**`ActivityChanges`** — wrapper type returned from subscription:

| Property | Type | Required | Description |
|---|---|---|---|
| `added` | `ActivityChange[]` | No | Newly added activity records |
| `modified` | `ActivityChange[]` | No | Modified activity records |
| `removed` | `ActivityChange[]` | No | Removed activity records |

**`ActivityChange`** — single change entry:

| Property | Type | Required | Description |
|---|---|---|---|
| `activity` | `ActivityRecord` | Yes | The activity record |
| `changeType` | `'added' \| 'modified' \| 'removed'` | Yes | Type of change |

**`CreateActivityData`** — payload for `createActivity()`:

| Property | Type | Required | Description |
|---|---|---|---|
| `featureType` | `ActivityFeatureType` | Yes | Feature type for the activity; use `'custom'` for non-Velt events |
| `actionType` | `string` | Yes | Action identifier; use `'custom'` for non-Velt events |
| `targetEntityId` | `string` | No | ID of the target entity |
| `displayMessageTemplate` | `string` | No | Template string with `{{variable}}` placeholders |
| `displayMessageTemplateData` | `object` | No | Data to fill the template |
| `metadata` | `ActivityMetadata` | No | Optional feature-specific metadata |

**`ActivityMetadata`** — extends `BaseMetadata` with open index signature:

| Property | Type | Required | Description |
|---|---|---|---|
| `apiKey` | `string` | No | Inherited from BaseMetadata |
| `documentId` | `string` | No | Inherited from BaseMetadata |
| `organizationId` | `string` | No | Inherited from BaseMetadata |
| `folderId` | `string` | No | Inherited from BaseMetadata |
| `[key: string]` | `any` | No | Feature-specific extension fields |

**b. Add Activity Action Type Constants section** immediately after the types above, still within `# Activity`:

Document the 4 exported constant objects. Each is a plain object whose values are string literals used as `actionType` values:

- `CommentActivityActionTypes` — e.g., `ANNOTATION_ADD`, `STATUS_CHANGE` (exact members: verify from SDK source)
- `RecorderActivityActionTypes`
- `ReactionActivityActionTypes`
- `CrdtActivityActionTypes`

Also document their corresponding union types:
- `CommentActivityActionType`
- `RecorderActivityActionType`
- `ReactionActivityActionType`
- `CrdtActivityActionType`

Note: Verify exact member names from SDK source before writing. Use the release note as naming guidance.

---

### 2. API Methods
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Priority: High

**Changes needed:**

**a. Add new `# Activity` top-level section** after the existing `# Notifications` section (line 1578) and before `# Recorder` (line 1728).

Structure it with two subsections: `### Data` and `### Actions`, mirroring the Notifications section pattern.

**`### Data`**

```
#### getAllActivities()
Subscribe to the real-time activity feed, optionally filtered by document or feature type.
- Params: `config?: ActivitySubscribeConfig`
- Returns: `Observable<ActivityRecord[]>`
- React Hook: `useAllActivities(config?)`
- [Full Documentation →](/async-collaboration/activity/customize-behavior#getallactivities)
```

**`### Actions`**

```
#### createActivity()
Create a custom activity record for non-Velt events.
- Params: `data: CreateActivityData`
- Returns: `Promise<void>`
- React Hook: `activityElement?.createActivity(data)` via `useActivityUtils()`
- [Full Documentation →](/async-collaboration/activity/customize-behavior#createactivity)
```

**`### Element Access`**

```
#### getActivityElement()
Get the ActivityElement instance from the Velt client.
- Params: `none`
- Returns: `ActivityElement`
- React Hook: `n/a`
- [Full Documentation →](/async-collaboration/activity/setup)
```

**`### React Hooks`**

```
#### useAllActivities()
React Hook to subscribe to the activity feed.
- Params: `config?: ActivitySubscribeConfig`
- Returns: `ActivityRecord[] | null`
- React Hook: Yes
- [Full Documentation →](/async-collaboration/activity/customize-behavior#getallactivities)

#### useActivityUtils()
React Hook to access ActivityElement utility methods (e.g., createActivity).
- Params: none
- Returns: `ActivityElement | null`
- React Hook: Yes
- [Full Documentation →](/async-collaboration/activity/customize-behavior#createactivity)
```

**b. Add `setActivityDebounceTime()` to the CRDT section** (after `setWebhookDebounceTime()` at line 2677, within the existing CRDT method list):

```
#### setActivityDebounceTime()
Control how long CRDT editor keystrokes are batched before a single activity record is flushed. Default: 10 minutes. Minimum enforced: 10 seconds (10,000 ms).
- Params: `time: number` (milliseconds)
- Returns: `void`
- React Hook: `crdtUtils.setActivityDebounceTime()`
- [Full Documentation →](/realtime-collaboration/crdt/setup/core#activity-debounce)
```

---

### 3. New Feature Documentation Page
- File: `/Users/yoenzhang/Downloads/docs/async-collaboration/activity/customize-behavior.mdx` (new file)
- Additional files: `/Users/yoenzhang/Downloads/docs/async-collaboration/activity/overview.mdx` (new), `/Users/yoenzhang/Downloads/docs/async-collaboration/activity/setup.mdx` (new)
- Priority: High

**Changes needed:**

The Activity feature is entirely new — no existing documentation exists. Three new pages are needed, modeled on the Notifications feature structure at `/Users/yoenzhang/Downloads/docs/async-collaboration/notifications/`.

**`overview.mdx`**: Feature description, use cases (org-wide feed, per-document feed, custom activities), and link to setup.

**`setup.mdx`**: Steps to get `ActivityElement` (React: `useActivityUtils()` / Other Frameworks: `Velt.getActivityElement()`). Show basic subscription with both framework tabs.

**`customize-behavior.mdx`**: Document the following with React/Next.js and Other Frameworks tabs:
- `getAllActivities(config?)` with `ActivitySubscribeConfig` filter examples (`documentIds`, `featureTypes`, `actionTypes`)
- `createActivity(data)` with `CreateActivityData` payload example showing template syntax
- Activity action type constants usage (`CommentActivityActionTypes`, etc.) for type-safe filtering

All code examples must use `<Tabs>` with `React / Next.js` first, `Other Frameworks` second — match the code blocks verbatim from the release note MDX.

**`docs.json` navigation**: Add `async-collaboration/activity/overview`, `async-collaboration/activity/setup`, `async-collaboration/activity/customize-behavior` in the async-collaboration group, after notifications entries (around line 132).

---

### 4. CRDT Core Setup Doc
- File: `/Users/yoenzhang/Downloads/docs/realtime-collaboration/crdt/setup/core.mdx`
- Priority: Medium

**Changes needed:**

Add a new subsection `### Activity Debounce` within the `## Webhooks` section (after line 1003) documenting `setActivityDebounceTime()`:

- Explain it controls batching of CRDT edit keystrokes into activity records (distinct from webhook debounce).
- Default: 10 minutes. Minimum: 10 seconds.
- Show both React (`crdtUtils.setActivityDebounceTime(30000)`) and Other Frameworks (`crdtElement.setActivityDebounceTime(30000)`) tabs.
- Use the release note code blocks verbatim.

---

## Implementation Sequence
1. `data-models.mdx`: Add `# Activity` section with all 6 new types and 4 action type constant objects. (New types; referenced by api-methods links.)
2. `api-methods.mdx`: Add `# Activity` section with `getAllActivities()`, `createActivity()`, `getActivityElement()`, `useAllActivities()`, `useActivityUtils()`.
3. `api-methods.mdx`: Add `setActivityDebounceTime()` to the CRDT method list after `setWebhookDebounceTime()`.
4. Create `async-collaboration/activity/overview.mdx`, `setup.mdx`, `customize-behavior.mdx` (modeled on notifications structure).
5. `docs.json`: Add navigation entries for the 3 new activity pages in the async-collaboration group.
6. `realtime-collaboration/crdt/setup/core.mdx`: Add `### Activity Debounce` subsection.

## Quality Checklist
- [ ] `# Activity` section added to `data-models.mdx` with all 6 types: `ActivitySubscribeConfig`, `ActivityFeatureType`, `ActivityRecord`, `ActivityChanges`, `ActivityChange`, `CreateActivityData`
- [ ] `ActivityMetadata` added to `data-models.mdx` with inherited BaseMetadata fields plus open index signature
- [ ] Activity action type constants (`CommentActivityActionTypes`, `RecorderActivityActionTypes`, `ReactionActivityActionTypes`, `CrdtActivityActionTypes`) documented with their union types
- [ ] `# Activity` section added to `api-methods.mdx` with `getAllActivities()`, `createActivity()`, `getActivityElement()`, `useAllActivities()`, `useActivityUtils()`
- [ ] `setActivityDebounceTime()` added to CRDT section in `api-methods.mdx` after `setWebhookDebounceTime()`
- [ ] 3 new activity pages created (`overview.mdx`, `setup.mdx`, `customize-behavior.mdx`) under `async-collaboration/activity/`
- [ ] All code examples use `<Tabs>` with `React / Next.js` first, `Other Frameworks` second
- [ ] `docs.json` navigation updated with 3 new activity page paths
- [ ] `crdt/setup/core.mdx` updated with `### Activity Debounce` subsection
- [ ] Anchor `#getallactivities` and `#createactivity` in customize-behavior.mdx match links in api-methods.mdx
- [ ] Verify exact `CommentActivityActionTypes` member names from SDK source before finalizing constants table
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.7.md`
