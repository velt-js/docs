# Release Update Plan for v5.0.2-beta.8

## Overview
- Release Type: Minor
- Key Changes: Six new CrdtElement message-stream methods; new Recorder self-host data provider; new RECORDER_RESOLVER event types; provider methods (get/save/delete) made optional; new UploadFileOptions.attachmentScope field; RecorderAnnotation gains two new fields; ResolverActions gains three new enum values; VeltDataProvider gains recorder field
- Breaking Changes: No

---

## Areas Requiring Updates

### 1. Data Models
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Priority: High

**a. Add CRDT Unified Message Stream query/data types** (new section — none of these types exist)

Insert a new section under the existing CRDT block (after `CrdtUpdateDataPayload` at line 4521). Add the following eight types as table-based entries:

- **`CrdtPushMessageQuery`** — fields: `id: string`, `data: number[]`, `yjsClientId?: number`, `messageType?: string`, `source?: string`
- **`CrdtOnMessageQuery`** — fields: `id: string`, `callback: (msg: CrdtMessageData) => void`
- **`CrdtMessageData`** — fields: `id: string`, `data: number[]`, `timestamp: number`, `yjsClientId?: number`, `messageType?: string`, `source?: string`
- **`CrdtGetMessagesQuery`** — fields: `id: string`, `afterTs?: number`
- **`CrdtGetSnapshotQuery`** — fields: `id: string`
- **`CrdtSnapshotData`** — fields: `id: string`, `state: number[]`, `vector?: number[]`, `timestamp: number`, `source?: string`
- **`CrdtSaveSnapshotQuery`** — fields: `id: string`, `state: number[]`, `vector?: number[]`, `source?: string`
- **`CrdtPruneMessagesQuery`** — fields: `id: string`, `beforeTs: number`

Use the same table column pattern (`Property | Type | Required | Description`) as existing CRDT types.

**b. Add RecorderAnnotationDataProvider type** (new type — does not exist)

Insert after the existing `AttachmentDataProvider` block (around line 3585). Fields:
- `get?: (request: GetRecorderResolverRequest) => Promise<ResolverResponse<PartialRecorderAnnotation>>`
- `save?: (request: SaveRecorderResolverRequest) => Promise<ResolverResponse<SaveRecorderResolverData>>`
- `delete?: (request: DeleteRecorderResolverRequest) => Promise<ResolverResponse<undefined>>`
- `config?: ResolverConfig`
- `uploadChunks?: boolean`
- `storage?: AttachmentDataProvider`

**c. Add Recorder resolver request/response types** (new types — none exist)

Insert after `RecorderAnnotationDataProvider`. Add:
- **`GetRecorderResolverRequest`** — fields: `annotationId: string`, `metadata?: BaseMetadata`
- **`SaveRecorderResolverRequest`** — fields: `annotation: PartialRecorderAnnotation`, `metadata?: BaseMetadata`, `event?: ResolverActions`
- **`SaveRecorderResolverData`** — fields: (return data structure; note as "Verify exact fields against SDK source")
- **`DeleteRecorderResolverRequest`** — fields: `annotationId: string`, `metadata?: BaseMetadata`, `event?: ResolverActions`
- **`PartialRecorderAnnotation`** — fields: `annotationId: string`, `from?: PartialUser`, `transcription?: RecorderDataTranscription`, `attachments?: PartialAttachment[]`
- **`PartialRecorderAnnotationEditVersion`** — note as "Verify fields against SDK source"
- **`PartialRecorderAnnotationResult`** — note as "Verify fields against SDK source"

**d. Update `VeltDataProvider` table** (existing type, line 3464)

Add row: `| recorder | RecorderAnnotationDataProvider | No | Provider for recording annotation PII data |`

**e. Update `ResolverConfig` table** (existing type, line 3484)

Add row: `| additionalFields | string[] | No | Custom fields to include in resolver payloads |`

**f. Update `CommentAnnotationDataProvider` table** (existing type, line 3536)

Change `get`, `save`, `delete` Required column from `Yes` → `No`.

**g. Update `ReactionAnnotationDataProvider` table** (existing type, line 3547)

Change `get`, `save`, `delete` Required column from `Yes` → `No`.

**h. Update `AttachmentDataProvider` table** (existing type, line 3577)

Change `save`, `delete` Required column from `Yes` → `No`.

**i. Update `RecorderAnnotation` table** (existing type, line 2285)

Add two rows:
- `| isRecorderResolverUsed | boolean | No | True while PII is being fetched from the recorder resolver; use for loading states |`
- `| isUrlAvailable | boolean | No | True once the recording URL is available (not a local blob); use for upload progress indicator |`

**j. Update `ResolverActions` enum table** (existing type, line 3337)

Add three rows:
- `| RECORDER_ANNOTATION_ADD | 'recorder_annotation.add' | Triggered when a recorder annotation is added |`
- `| RECORDER_ANNOTATION_UPDATE | 'recorder_annotation.update' | Triggered when a recorder annotation is updated |`
- `| RECORDER_ANNOTATION_DELETE | 'recorder_annotation.delete' | Triggered when a recorder annotation is deleted |`

**k. Add RecorderResolverSource, RecorderResolverModuleName, RecorderResolverEventType** (new types — none exist)

Insert after existing `ReactionResolverModuleName` section (around line 3396). Add:

- **`RecorderResolverSource`** (enum) — values representing the recorder resolver source (verify exact values from SDK; expected: `'request_formed'`, `'triggered'`, `'result'`, `'error'`)
- **`RecorderResolverModuleName`** (enum) — values identifying recorder resolver modules (verify exact values; expected: `GET_RECORDER_ANNOTATION`, `SAVE_RECORDER_ANNOTATION`, `DELETE_RECORDER_ANNOTATION`)
- **`RecorderResolverEventType`** (type) — union type for recorder resolver lifecycle events

**l. Add `UploadFileOptions` type** (new type — does not currently exist in data-models.mdx)

Insert near the attachment types section. Fields:
- `attachmentScope?: string` — Routes upload to the named AttachmentDataProvider scope (e.g., `'default'`, `'recorder'`). Defaults to `'default'`.

---

### 2. API Methods
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Priority: High

**a. Add six CrdtElement message-stream methods** (new methods on CrdtElement — none exist)

Insert after `getCrdtElement()` entry (line 2684). Add a new subsection `### Message Stream` under the CRDT section:

- **`pushMessage()`** — Params: `CrdtPushMessageQuery`, Returns: `Promise<void>`, React Hook: `n/a`, Full Documentation: `/realtime-collaboration/crdt/setup/core#message-stream`
- **`onMessage()`** — Params: `CrdtOnMessageQuery`, Returns: `() => void` (unsubscribe), React Hook: `n/a`, Full Documentation: `/realtime-collaboration/crdt/setup/core#message-stream`
- **`getMessages()`** — Params: `CrdtGetMessagesQuery`, Returns: `Promise<CrdtMessageData[]>`, React Hook: `n/a`, Full Documentation: `/realtime-collaboration/crdt/setup/core#message-stream`
- **`getSnapshot()`** — Params: `CrdtGetSnapshotQuery`, Returns: `Promise<CrdtSnapshotData | null>`, React Hook: `n/a`, Full Documentation: `/realtime-collaboration/crdt/setup/core#message-stream`
- **`saveSnapshot()`** — Params: `CrdtSaveSnapshotQuery`, Returns: `Promise<void>`, React Hook: `n/a`, Full Documentation: `/realtime-collaboration/crdt/setup/core#message-stream`
- **`pruneMessages()`** — Params: `CrdtPruneMessagesQuery`, Returns: `Promise<void>`, React Hook: `n/a`, Full Documentation: `/realtime-collaboration/crdt/setup/core#message-stream`

---

### 3. CRDT Core Documentation
- File: `/Users/yoenzhang/Downloads/docs/realtime-collaboration/crdt/setup/core.mdx`
- Priority: High

**a. Add "Message Stream" section** (new feature section — does not exist)

Insert after the existing `### Webhook Methods` section (end of file, line 1039). New section heading: `### Message Stream`.

Include:
- Brief explanation: low-level y-redis pattern for Yjs-backed collaborative editing using a single Firebase RTDB channel per document
- Code examples in both React/Next.js and Other Frameworks tabs (use the code blocks verbatim from the CRDT release note)
- Method signatures for all six methods referencing their data-models anchor links

Anchor to use: `#message-stream` (keep consistent with api-methods.mdx links above).

---

### 4. Self-Host Data Documentation
- File: `/Users/yoenzhang/Downloads/docs/self-host-data/overview.mdx`
- Priority: Medium

Add **Recordings** to the bullet list of supported self-hosted data types (currently: Comments, Attachments, In-app notifications, Reactions, Users). New bullet: `**Recordings**: Store recording annotation PII (user identity, transcription, attachment URLs) on your infrastructure`.

---

### 5. New Self-Host Data Page for Recordings
- File: `/Users/yoenzhang/Downloads/docs/self-host-data/recordings.mdx` (new file)
- Priority: Medium

Create a new page following the same structure as `/Users/yoenzhang/Downloads/docs/self-host-data/attachments.mdx` and `comments.mdx`. Cover:
- Overview of what PII is stripped (identity, transcription, attachment URLs)
- Setup via `setDataProviders({ recorder: RecorderAnnotationDataProvider })`
- Code example with React/Next.js and Other Frameworks tabs (use release note code blocks)
- Fields: `isRecorderResolverUsed` for loading state, `isUrlAvailable` for upload progress
- Debugging section referencing `RecorderResolverModuleName` enum

Verify link target: `/self-host-data/recordings` (ensure it matches docs.json nav config — update nav if needed).

---

## Implementation Sequence

1. `data-models.mdx`: Update `CommentAnnotationDataProvider`, `ReactionAnnotationDataProvider`, `AttachmentDataProvider` — change get/save/delete to optional. (Prerequisite: none)
2. `data-models.mdx`: Add `additionalFields` to `ResolverConfig` and `recorder` to `VeltDataProvider`. (Prerequisite: none)
3. `data-models.mdx`: Add `isRecorderResolverUsed` and `isUrlAvailable` to `RecorderAnnotation`. (Prerequisite: none)
4. `data-models.mdx`: Add three new `ResolverActions` enum values. (Prerequisite: none)
5. `data-models.mdx`: Add `UploadFileOptions` type with `attachmentScope` field. (Prerequisite: none)
6. `data-models.mdx`: Add `RecorderAnnotationDataProvider` and all recorder resolver request/response types. (Prerequisite: steps 1–5 complete for cross-reference accuracy)
7. `data-models.mdx`: Add `RecorderResolverSource`, `RecorderResolverModuleName`, `RecorderResolverEventType` enums. (Prerequisite: step 6)
8. `data-models.mdx`: Add eight CRDT message stream types after `CrdtUpdateDataPayload`. (Prerequisite: none)
9. `api-methods.mdx`: Add six CrdtElement message stream methods under CRDT section. (Prerequisite: step 8 — data-model anchors must exist)
10. `realtime-collaboration/crdt/setup/core.mdx`: Add `### Message Stream` section with code examples. (Prerequisite: step 9)
11. `self-host-data/overview.mdx`: Add Recordings bullet to supported types list. (Prerequisite: none)
12. `self-host-data/recordings.mdx`: Create new page for recorder self-host setup. (Prerequisite: step 6 — types must exist in data-models)

---

## Quality Checklist
- [ ] All new CRDT types (8) added to `data-models.mdx` under existing CRDT section
- [ ] Six new CrdtElement methods added to `api-methods.mdx` with correct param/return type links
- [ ] `core.mdx` Message Stream section added with dual-tab code examples
- [ ] `RecorderAnnotationDataProvider` and all associated types added to `data-models.mdx`
- [ ] `RecorderResolverSource`, `RecorderResolverModuleName`, `RecorderResolverEventType` added to `data-models.mdx`
- [ ] `VeltDataProvider` updated with `recorder` field
- [ ] `ResolverConfig` updated with `additionalFields` field
- [ ] `CommentAnnotationDataProvider` get/save/delete marked optional
- [ ] `ReactionAnnotationDataProvider` get/save/delete marked optional
- [ ] `AttachmentDataProvider` save/delete marked optional
- [ ] `RecorderAnnotation` updated with `isRecorderResolverUsed` and `isUrlAvailable`
- [ ] `ResolverActions` updated with three new RECORDER_ANNOTATION_* values
- [ ] `UploadFileOptions` type added with `attachmentScope` field
- [ ] `self-host-data/overview.mdx` updated to include Recordings
- [ ] `self-host-data/recordings.mdx` created with setup, code examples, and debugging sections
- [ ] Code examples use React/Next.js first, Other Frameworks second tab order
- [ ] data-models anchor patterns verified before linking from api-methods and core.mdx
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.8.md`
