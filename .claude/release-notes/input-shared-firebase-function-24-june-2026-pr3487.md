# Velt SDK Release Notes - shared-firebase-function 24-June-2026 PR3487
Release Date: June 24, 2026

## Summary
| Repo | Files Changed | Insertions | Deletions |
|------|--------------|------------|-----------|
| shared-firebase-function | 102 | +9350 | -678 |

---

## Features

### 1. Scheduled (Cron) Triggers for Approval Workflows

**What:** Workflow definitions can now declare a `schedule` block on any trigger to start executions automatically on a cron cadence. A new dedicated cloud function (`approvalschedulehandler`, `onSchedule`, runs every minute) scans a cross-tenant index of enabled schedules and dispatches a fresh execution for each due trigger. The schedule index lives in the default plugin database so the sweeper queries across all workspaces in a single Firestore query without iterating individual API keys.

**Why:** Teams running recurring audit workflows (nightly content checks, periodic policy scans) previously had to build and maintain external cron infrastructure to drive the approval engine. This ships cron scheduling natively inside the engine so no external scheduler is needed.

**Impact:** Developers can configure a definition to fire on a regular cadence (e.g. `0 2 * * *` every night at 02:00 in a given timezone) by adding a `schedule` block to a trigger alongside or instead of an `inboundWebhook` block. Cron and timezone are validated at write time — a mis-typed schedule is rejected at the API boundary rather than silently never firing. A scheduled execution inherits the definition's org/document scope automatically.

**Type:**
```ts
interface ScheduleTriggerConfig {
  cron: string;       // Standard 5-field cron expression (minute hour dom month dow)
  timezone: string;   // IANA zone (e.g. "America/Los_Angeles"); DST handled by evaluator
  enabled: boolean;   // Only enabled schedules are indexed and fired; toggling false removes the index entry
  payloadTemplate?: Record<string, unknown>; // Static object merged into triggerContext under schedule.payload
}
```

**API — trigger definition:**
```json
{
  "triggerId": "nightly-audit",
  "schedule": {
    "cron": "0 2 * * *",
    "timezone": "America/Los_Angeles",
    "enabled": true,
    "payloadTemplate": { "source": "nightly" }
  }
}
```

**Dispatched execution context:**
The dispatched execution's `triggerContext.schedule` carries `{ triggerId, scheduledAt, payload }`.

**Scope inheritance:** A scheduled execution inherits the owning definition's `scope`. An organization- or document-scoped definition fires executions carrying the same `organizationId`/`documentId`. There is no separate per-trigger org/doc field — the definition `scope` is the single source of truth.

**At-most-once guarantee:** Missed runs are not replayed. Idempotency key is `sched:<definitionId>:<triggerId>:<nextRunAt>`.

**Validation error codes:** `APPROVAL_SCHEDULE_CRON_INVALID`, `APPROVAL_SCHEDULE_TIMEZONE_INVALID`.

---

### 2. Notification Nodes (Email / Slack) in Approval Workflows

**What:** A new `type: "notification"` node can be placed anywhere in a workflow graph to send a formatted email or Slack message directly from the workflow step — no extra cloud function required. It interpolates the predecessor step's output and the execution `triggerContext` into `{{dot.path}}` templates and delivers via email (SendGrid) or Slack (channel id or incoming-webhook URL). The node runs inside the existing approval-step task.

**Why:** Stakeholders need to be notified when an agent finishes a review or a human makes a decision. Previously developers had to implement external notification webhooks or subscribe to lifecycle events and build their own notification layer. The notification node ships this inline in the workflow.

**Impact:** Developers add a `notification` node after an agent or human node to send findings summaries, approval decisions, or any formatted message to email recipients or a Slack channel. Partial email delivery (at least 1 of N recipients reached) marks the step `completed`; zero deliveries makes it retryable `failed`. Config-class Slack failures (4xx, `channel_not_found`, `invalid_auth`) are terminal; 5xx/network/`rate_limited` are retryable.

The `NodeType` union in the workflow definition model has been extended: `export type NodeType = 'agent' | 'human' | 'webhook' | 'notification'`.

**Type:**
```ts
export interface NotificationNodeConfig {
  channel: 'email' | 'slack';
  recipients?: string[];       // email: 1–50 email addresses (required for email channel)
  subjectTemplate?: string;    // email: subject line template ≤2000 chars
  slackTarget?: string;        // slack: channel id (e.g. "C0123") OR https incoming-webhook URL
  bodyTemplate: string;        // required: message body template 1–16000 chars
  format?: 'text' | 'html' | 'slack-blocks'; // default "text"; slack-blocks is Slack-only
}
```

**Templating context roots:** `input` (predecessor step's output), `execution` (`executionId`, `definitionId`, `correlationId`, `triggerContext`), `step`. Safe dot-path substitution only — no `eval`/`new Function`. Missing tokens render to empty string; object/array values are JSON-stringified.

**API — node definition:**
```json
{
  "nodeId": "notify-stakeholders",
  "type": "notification",
  "config": {
    "channel": "email",
    "recipients": ["lead@acme.dev", "pm@acme.dev"],
    "subjectTemplate": "Approval {{input.decision}} for {{execution.triggerContext.page.title}}",
    "bodyTemplate": "Findings: {{input.agentResultsSummary.summary}}",
    "format": "text"
  }
}
```

**Slack example:**
```json
{
  "nodeId": "slack-notify",
  "type": "notification",
  "config": {
    "channel": "slack",
    "slackTarget": "C0123ABC",
    "bodyTemplate": "Agent run completed with decision: {{input.decision}}",
    "format": "text"
  }
}
```

**Delivery prerequisites:**
- **Email:** The workspace must be on the SendGrid email service (Customer.io is template-only). `APPROVAL_NOTIFICATION_EMAIL_NOT_CONFIGURED` if not configured.
- **Slack (channel id):** Requires `workspace.slackConfig.botToken`. `APPROVAL_NOTIFICATION_SLACK_NOT_CONFIGURED` if not configured.
- **Slack (incoming-webhook URL):** Must be an `https` URL on an allowed host (SSRF-guarded at write + delivery time).

**Runtime error codes:** `notification-config-missing-channel`, `notification-email-no-recipients`, `notification-email-not-configured`, `notification-email-delivery-failed`, `notification-slack-no-target`, `notification-slack-ssrf-blocked:*`, `notification-slack-blocks-invalid-json`, `notification-slack-not-configured`, `notification-slack-api-error:*`.

---

### 3. Provider-Aware Inbound Webhook Triggers (GitHub, Vercel, Custom)

**What:** Inbound webhook triggers now support signature provider presets so external systems can drive approval engine executions using their native signature scheme — no translation proxy required. Supported presets: `github` (HMAC-SHA256, `x-hub-signature-256` header), `vercel` (HMAC-SHA1, `x-vercel-signature` header), and `custom` (caller-supplied header, algorithm, and prefix). The `velt` preset remains the default.

Additionally, the `apiKey` can now be supplied as an `?apiKey=` query parameter (in addition to the existing `x-velt-api-key` header), and `definitionId`/`triggerId` can be supplied as query parameters for non-velt providers. An optional `allowedEvents` gate lets operators filter which event types dispatch executions.

**Why:** External CI/CD systems (GitHub Actions, Vercel deployments) sign their webhook bodies with their own schemes and cannot inject the `x-velt-api-key` header or wrap their payload in the velt `{definitionId, triggerId, payload}` envelope without a relay. The provider preset system removes this obstacle.

**Impact:** Developers can point a GitHub webhook directly at `/v1/workflow/webhook-inbound/trigger?apiKey=…&definitionId=…&triggerId=…` with a `github` provider preset, and the engine verifies the `x-hub-signature-256` header natively. For non-velt providers, the entire request body becomes `triggerContext` (no `.payload` unwrap). Scope inheritance applies: an inbound-triggered execution inherits the definition's org/document scope.

**Trigger config fields (extended):**
```ts
interface InboundWebhookTriggerConfig {
  authMode: 'hmac' | 'bearer';
  secret: string;                  // 16–512 chars — the real authenticator
  provider?: 'velt' | 'github' | 'vercel' | 'custom'; // default: "velt"
  signatureHeader?: string;        // custom only: header carrying the hex signature
  signatureAlgorithm?: 'sha1' | 'sha256'; // custom only: HMAC digest algorithm
  signaturePrefix?: string;        // custom only: prefix stripped before hex compare
  allowedEvents?: string[];        // 1–50: event-name gate; non-matching events return HTTP 200 "event-ignored"
  eventNameHeader?: string;        // custom only: header carrying the event name
  idempotencyHeader?: string;
  idempotencyBodyPath?: string;
  payloadMapping?: 'pass-through' | 'wrap'; // velt only
}
```

The `InboundWebhookProvider` type is: `export type InboundWebhookProvider = 'velt' | 'github' | 'vercel' | 'custom'`.

**Provider preset table:**
| `provider` | Signature header | Algorithm | Prefix | Event-name source |
|------------|-----------------|-----------|--------|-------------------|
| `velt` (default) | `x-velt-signature` | HMAC-SHA256 | `sha256=` | body `type` |
| `github` | `x-hub-signature-256` | HMAC-SHA256 | `sha256=` | `x-github-event` header |
| `vercel` | `x-vercel-signature` | HMAC-SHA1 | _(none)_ | `x-vercel-deployment-event` header → body `type` |
| `custom` | `signatureHeader` (required) | `signatureAlgorithm` (required) | `signaturePrefix` (optional) | `eventNameHeader` (optional) |

**Schema validation codes:** `APPROVAL_INBOUND_CUSTOM_PROVIDER_REQUIRES_SIGNATURE_FIELDS`, `APPROVAL_INBOUND_SIGNATURE_FIELDS_CUSTOM_ONLY`, `APPROVAL_INBOUND_PROVIDER_REQUIRES_HMAC`.

**Example — GitHub webhook:**
```json
{
  "triggerId": "ci-build",
  "inboundWebhook": {
    "authMode": "hmac",
    "secret": "github-webhook-secret",
    "provider": "github",
    "allowedEvents": ["workflow_run", "push"],
    "idempotencyHeader": "x-github-delivery"
  }
}
```

---

## Improvements

### 1. Agent Node Accepts Static `url` in Addition to `urlPath`

**What:** Agent nodes now accept a static `url` field (a fixed absolute URL, ≤2000 chars) as an alternative or supplement to the payload-derived `urlPath`. When both are set, `url` takes precedence. Either `url` or `urlPath` must be present — definitions supplying neither are rejected at write time with `APPROVAL_AGENT_NODE_REQUIRES_URL_OR_URLPATH`. Additionally, `urlPath`-resolved values that lack an `http://` or `https://` scheme (e.g. Vercel's bare `my-app.vercel.app`) are automatically normalized to `https://` before dispatch.

**Why:** Previously every agent node required a `urlPath` pointing into the trigger payload. This was inconvenient for workflows that always scan a fixed production domain, and impossible when the payload provider (e.g. Vercel) delivers bare hostnames without a scheme.

**Impact:** Developers can pin a static URL directly in the workflow definition for fixed-target scans, and Vercel deployment webhooks can now drive agent nodes without a custom proxy to inject the scheme.

**Config change:**
```ts
// Before (urlPath was required):
{ agentId: "brand-tone-v3", urlPath: "documentUrl" }

// After (url or urlPath, or both):
{ agentId: "brand-tone-v3", url: "https://production.example.com" }
{ agentId: "brand-tone-v3", urlPath: "payload.deployment.url" }  // scheme-normalized if bare host
{ agentId: "brand-tone-v3", url: "https://prod.example.com", urlPath: "payload.url" }  // url wins
```

---

### 2. Human Node: `reviewerEmails` Field and Mandatory Reject-Path Validation

**What:** Human nodes now accept an optional `reviewerEmails[]` field (up to 50 valid email addresses) that is echoed onto `step.output.reviewerEmails` and used to address reviewers in the comment-resolution flow. Additionally, the definition linter now enforces that every `human` node has at least one outgoing `reject` edge (a forward route or a `reject` + `loop` back-edge), or the definition is rejected at create time with `APPROVAL_HUMAN_NODE_REQUIRES_REJECT_PATH`. This applies to group members too.

**Why:** Reviewer email addresses are needed to send notifications in the comment-resolution flow. The reject-path rule enforces complete workflow graphs — a human node with no reject route creates a dead end that blocks the workflow when a reviewer rejects, which was previously only caught at runtime.

**Impact:** Definitions with human nodes that lack a reject edge are now caught at write time. Developers must add either a `{ from, to, on: "reject" }` forward edge or a `reject+loop` back-edge for every human node.

---

### 3. Agent Execution `resultsSummary` Enhanced with Severity Counts and Findings Sample

**What:** The `ResultsSummary` stored on agent execution documents now includes two new fields: `severityCounts` (a per-severity breakdown of findings, incremented atomically per batch) and `findings` (a bounded sample of up to 50 top-severity `SummaryFinding` objects, accumulated via `arrayUnion` per batch and trimmed on completion by severity rank: CRITICAL > HIGH > MEDIUM > LOW > INFO).

**Why:** Callers polling agent execution status via `/v2/agents/execution/get` or reading the approval-engine step output needed to retrieve the full per-URL results subcollection to understand severity distribution and individual findings. The denormalized `findings` sample gives immediate access to the most important findings without an extra subcollection read, while keeping the execution document under Firestore's 1MB cap.

**Impact:** The `agentResultsSummary` projected onto the approval-engine step output now includes `severityCounts` and a `findings` array. Notification node `bodyTemplate` can reference `{{input.agentResultsSummary.findings}}` or `{{input.agentResultsSummary.severityCounts.high}}` directly.

**Types:**
```ts
interface SummaryFinding {
  title: string;
  description: string;
  severity: FindingSeverity;  // 'critical' | 'high' | 'medium' | 'low' | 'info'
  sourceUrl?: string;
  issueType?: string;
  url?: string;  // agent-specific target URL (e.g. the broken link's href)
}

interface ResultsSummary {
  // ... existing fields ...
  severityCounts?: Record<FindingSeverity, number>;  // NEW
  findings?: SummaryFinding[];                       // NEW — bounded to top-50 by severity
}
```

---

### 4. Broken Links Agent: Auth-Wall Detection

**What:** The broken links agent now detects authentication walls — pages that redirect or respond with a login prompt rather than the actual content. A new `auth_required` error type is added to `BrokenLinksErrorType`. The detection uses a word-boundary-aware pattern match to distinguish genuine auth pages from incidental mentions of auth-related terms.

**Why:** Without auth-wall detection, the broken links agent would follow redirects to login pages and report them as valid (non-broken) links, producing false negatives. Flagging auth walls as `auth_required` gives workflow authors signal to investigate whether the target requires authentication.

**Impact:** Broken link findings may now carry `errorType: "auth_required"` in addition to the existing `http_error`, `timeout`, `network_error`, and `unknown` types.

**Type change:**
```ts
// Before:
type BrokenLinksErrorType = 'http_error' | 'timeout' | 'network_error' | 'unknown';

// After:
type BrokenLinksErrorType = 'http_error' | 'timeout' | 'network_error' | 'auth_required' | 'unknown';
```

---

### 5. Definition Delete: Hard-Delete (`purge`) Option and Tombstone Reuse

**What:** The Delete Definition endpoint now accepts an optional `purge: boolean` field. When `purge: true`, the definition document and its entire `versions/*` snapshot subcollection are physically removed via `recursiveDelete`. The default (`purge: false` or omitted) remains a soft-delete (tombstone). The response now includes a `purged` field reflecting which path ran. Additionally, creating a definition over a previously tombstoned `definitionId` now succeeds — `ALREADY_EXISTS` is raised only for an active definition.

**Why:** Soft-deleted definitions occupied their `definitionId` permanently in the prior release, making it impossible to reuse an id after deletion. Hard-delete (`purge`) enables physical cleanup for compliance or data hygiene use cases.

**Impact:** After either soft or hard delete, the `definitionId` is immediately available for re-creation. Callers that previously received `ALREADY_EXISTS` when recreating over a tombstoned id will now succeed.

**API change:**
```json
// Request (new optional field):
{ "definitionId": "marketing-copy-approval", "purge": true }

// Response (new purged field):
{ "result": { "deleted": true, "purged": true, "definitionId": "marketing-copy-approval" } }
```

---

### 6. Memory API: `totalActivities` Count Cap Documented

**What:** The `POST /v2/memory/stats/get` response field `totalActivities` is now documented as capped at 10,000. Workspaces with more than 10,000 enriched activities report `10000`.

**Why:** The cap was already applied server-side but was not reflected in the API reference or the `getStats` response description, causing confusion for callers who expected an exact count.

**Impact:** Callers polling `totalActivities` should treat a returned value of `10000` as meaning "at least 10,000" rather than exactly 10,000.

---

### 7. Comment Annotations Delete: `agentId` Filter Added (V2 Only)

**What:** The `POST /v2/commentannotations/delete` endpoint now accepts a new optional `agentId` field alongside the existing `agentSuggestions` filter. When `agentId` is supplied, the delete is narrowed to annotations authored by that specific agent. When combined with `agentSuggestions: true`, only that agent's unaccepted suggestions are deleted (intersection). The underlying Firestore query has been refactored from a single `agentFields` flat array to an `agentFieldsGroups` array-of-arrays (AND across groups, OR within each group).

**Why:** Previously there was no way to delete all comments from a specific agent without also deleting comments from other agents. The `agentId` filter closes this gap.

**Impact:** Callers on the V2 delete path can now scope deletions to a specific agent by passing `agentId: "my-agent"`. Combining `agentId` + `agentSuggestions: true` produces a precise intersection delete. The `agentSuggestions`-only behavior is unchanged. V1 is not affected.

**API (new field):**
```json
// Delete all comments by a specific agent:
{ "documentId": "doc1", "agentId": "spell-check" }

// Delete only that agent's suggestions:
{ "documentId": "doc1", "agentId": "spell-check", "agentSuggestions": true }
```

---

## Bug Fixes

### 1. API Tests No Longer Gate Deploys on Known-Issue Tests

**What:** API test runs (Playwright, `tests/api`) now exclude tests tagged `@known-issue` from the gating run via `--grep-invert "@known-issue"`. Known-issue tests assert current buggy behaviour (e.g. granular-access inheritance) and were causing unstable gate failures against live staging.

**Why:** Known-issue tests are designed to track confirmed backend bugs without blocking deploys. Including them in the gating run caused intermittent deploy failures unrelated to the changes being deployed.

**Impact:** Deploy gates are now stable. Known-issue tests remain in the codebase and are still runnable locally with `npx playwright test tests/api` for tracking purposes.

---

### 2. Approval Schedule Index: Atomic Batch Replacement Prevents Partial State

**What:** When a definition is created or updated with schedule triggers, the cross-tenant schedule index is now rebuilt atomically via a single Firestore `WriteBatch` that deletes all existing docs for the definition and writes the new ones in one operation. Previously, a failed write could leave the index in a partially rebuilt state.

**Why:** A non-atomic two-phase (delete-then-write) update could leave the index empty or inconsistent if the write failed mid-way, causing schedules to silently stop firing or fire for stale triggers.

**Impact:** Schedule trigger index updates are now all-or-nothing — a failed commit leaves the index in its prior state, ensuring the scheduler never sees a partially rebuilt index.

---

### 3. Approval Schedule: Compensating Rollback on Sync Failure

**What:** If the schedule-sync step fails during a definition create/update, the engine now rolls back the definition write to avoid a state where the definition is persisted but its schedule index is inconsistent.

**Why:** Without the rollback, a partial failure could leave an active definition with no schedule index entry, causing its scheduled triggers to silently never fire.

**Impact:** Create/update requests that fail during the schedule sync step now return an error rather than silently persisting an inconsistent state.

---

### 4. Approval Schedule Index: Clear on Recreate-Over-Tombstone

**What:** When a definition is recreated over a tombstoned id, the engine now explicitly clears the old schedule index entries for the tombstoned definition before writing the new definition's schedules.

**Why:** Tombstoned definitions were not cleaning up their schedule index entries, so a recreated definition could inherit stale schedule docs from the old definition and fire on incorrect cadences.

**Impact:** Recreating a definition over a tombstoned id starts with a clean schedule index.

---

### 5. Approval Rollback: Does Not Revive a Concurrently Tombstoned Definition

**What:** The compensating rollback path in the definition service now checks whether the definition was concurrently tombstoned (e.g. by a delete call racing the create/update) before attempting to reverse the write. If the definition was tombstoned during the rollback window, the rollback is skipped rather than reviving it.

**Why:** A race between a create/update and a concurrent delete could cause the rollback to reverse the tombstone, leaving an active (and incorrect) definition where a deleted one was expected.

**Impact:** Concurrent delete + failed create/update sequences now leave the definition in the tombstoned state as intended.

---

### 6. Memory API: Ingest Status Response Shape Corrected

**What:** The documented response shape for `POST /v1/memory/ingest/status` has been corrected. The actual fields are `originalDownloadUrl` and `canonicalMdDownloadUrl` (not `originalUrl` and `canonicalMdUrl` as previously documented). Additional fields present on the live response — `startedAt`, `updatedAt`, `mimeType`, and `metadata` — are now documented. The `pending` status value has been removed from the documented `status` union (actual values are `processing | completed | failed`).

**Why:** The documentation did not match the actual response shape returned by the endpoint, causing client integrations to read fields that did not exist.

**Impact:** Clients polling ingest status should use `originalDownloadUrl` and `canonicalMdDownloadUrl` for download URLs.

---

## Breaking Changes

### Migration Guide

#### 1. Agent Node `urlPath` Is Now Optional — At Least One of `url` or `urlPath` Required

**Before:** Every agent node required `urlPath`:
```json
{
  "nodeId": "brand-check",
  "type": "agent",
  "config": { "agentId": "brand-tone-v3", "urlPath": "documentUrl" }
}
```

**After:** Either `url` or `urlPath` (or both) must be present. Providing neither is rejected at write time with error code `APPROVAL_AGENT_NODE_REQUIRES_URL_OR_URLPATH`:
```json
// Static URL (new):
{ "agentId": "brand-tone-v3", "url": "https://production.example.com" }

// Dynamic URL from payload (unchanged, urlPath now optional):
{ "agentId": "brand-tone-v3", "urlPath": "documentUrl" }
```

Existing definitions with `urlPath` set are unaffected — `urlPath` is still accepted.

#### 2. Every `human` Node Must Have at Least One Outgoing `reject` Edge

**Before:** Definitions with human nodes that had no outgoing `reject` edge were accepted at write time and only failed at runtime when a reviewer rejected.

**After:** The definition linter rejects such definitions at create/update time with `APPROVAL_HUMAN_NODE_REQUIRES_REJECT_PATH`.

**Migration:** Add a `reject` edge from every human node to a downstream node (or a `reject+loop` back-edge for revision loops):
```json
// Before (missing reject route):
{ "edges": [{ "from": "human-review", "to": "publish" }] }

// After (reject route added):
{ "edges": [
  { "from": "human-review", "to": "publish", "on": "approve" },
  { "from": "human-review", "to": "revise", "on": "reject" }
]}
```

#### 3. Delete Definition Response Now Includes `purged` Field

**Before:**
```json
{ "result": { "deleted": true, "definitionId": "my-def" } }
```

**After:**
```json
{ "result": { "deleted": true, "purged": false, "definitionId": "my-def" } }
```

Callers that parse the result shape strictly (e.g. with exact-match assertions) should update to expect the `purged` field. The `deleted` field is unchanged.

---
