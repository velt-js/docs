# Release Update Plan for Release — 21 May 2026 — Approval Engine v1

## Overview
- Release Type: Backend/REST-API minor (merged into SDK entry 5.0.2-beta.31, May 22 2026)
- Key Changes: Inbound webhook Cloud Function (`approvalwebhookhandler`), `listAgentExecutions` paginated endpoint with status+message, per-tenant `storeDbId` routing, Approval Engine reliability hardening
- Breaking Changes: No

## Internal-Only Items — NO DOCUMENTATION CHANGE NEEDED

The following were filtered from the changelog and require zero documentation action:

- `__mock__` synthetic-agent escape hatch (internal test tooling only)
- Stripe multi-production-key fan-out fix (internal billing plumbing)
- `FirestoreService.updateDocument` FieldValue sentinel fix (internal)
- `WorkflowService.createTestRun` isolation fix (internal)
- `console.warn → console.error` on agent config-resolution failures (internal)
- Firestore path standardization to `apiKey/{apiKey}/...` (internal)

Do NOT create or update any documentation for the above items.

---

## Areas Requiring Updates

### 1. Approval Engine Overview — Inbound Webhook Section (Agent-3)
- File: `/Users/yoenzhang/Downloads/docs/ai/approval-engine/overview.mdx`
- Changes: Add a section or callout explaining the `approvalwebhookhandler` inbound webhook endpoint. External senders (Salesforce, Stripe, GitHub) POST raw JSON to a stable URL; cover bearer-token validation and the signed callback token pattern. Cross-link from the existing "Events and webhooks" section at line 133.
- Priority: High
- Note: This is a new capability not mentioned anywhere in the existing overview. The current webhook section (line 133) only covers outbound delivery; inbound reception is absent.

### 2. Agents REST API — listAgentExecutions Endpoint (Agent-3)
- File: NEW — `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/agents/list-agent-executions.mdx`
- Changes: Create endpoint reference page documenting `listAgentExecutions`: method, path, pagination params (page/limit), response shape (`status` + `message` per execution). Follow the pattern of sibling endpoint pages in `api-reference/rest-apis/v2/`.
- Priority: High
- Note: The `/api-reference/rest-apis/v2/agents/` directory exists but is empty. This is a new public endpoint with no existing doc.

### 3. docs.json Navigation — Agents Group (Agent-3)
- File: `/Users/yoenzhang/Downloads/docs/docs.json`
- Changes: Add a navigation entry for the new `list-agent-executions.mdx` page under the v2 agents group. If no agents group exists yet in the nav, create one following the pattern of the approval-engine group.
- Priority: High (page won't appear in sidebar without this)

### 4. Approval Engine Overview — Tenant Isolation Note (Agent-3)
- File: `/Users/yoenzhang/Downloads/docs/ai/approval-engine/overview.mdx`
- Changes: Add a brief note in the "What you get" or deployment section that per-tenant `storeDbId` routing is now active, ensuring Approval Engine reads/writes are isolated per tenant. One sentence is sufficient.
- Priority: Low

### 5. Approval Engine Overview — Reliability Hardening Note (Agent-3)
- File: `/Users/yoenzhang/Downloads/docs/ai/approval-engine/overview.mdx`
- Changes: No structural change required. The `invalid_type` validation error fix (restored `for <path>` suffix in structured payload) may be noted as a bug fix if the overview references error response shapes. If not, skip.
- Priority: Low — check during implementation; skip if overview has no error-shape reference.

---

## Items with NO Documentation Change

- Data models (`data-models.mdx`): No new SDK types — SKIP
- API methods / React hooks (`api-methods.mdx`, `react-hooks.mdx`): REST-only release — SKIP
- Wireframes (Agent-4): No new UI components or wireframes — SKIP
- Primitives (Agent-5): No new primitive components or props — SKIP
- Upgrade guide: No breaking changes — SKIP

---

## Implementation Sequence
1. (Agent-3) Add `approvalwebhookhandler` inbound webhook section to `ai/approval-engine/overview.mdx` — highest user impact.
2. (Agent-3) Create `api-reference/rest-apis/v2/agents/list-agent-executions.mdx` endpoint reference page.
3. (Agent-3) Add navigation entry in `docs.json` for the new agents page.
4. (Agent-3) Add per-tenant storeDbId note in `ai/approval-engine/overview.mdx` (low — can be one sentence).
5. (Agent-6) Alignment pass: verify inbound webhook section doesn't duplicate or contradict existing outbound webhook content at line 133 of overview.mdx.
6. (Agent-7) QA: confirm `list-agent-executions.mdx` renders, sidebar nav shows agents group, and all links resolve.

## Quality Checklist
- [ ] `approvalwebhookhandler` inbound webhook documented in approval-engine overview
- [ ] `listAgentExecutions` endpoint page created at `api-reference/rest-apis/v2/agents/list-agent-executions.mdx`
- [ ] docs.json updated with agents nav entry
- [ ] Internal-only items have zero documentation changes
- [ ] data-models.mdx left unchanged
- [ ] api-methods.mdx and react-hooks.mdx left unchanged
- [ ] No wireframe or primitives changes
- [ ] No upgrade guide entry (no breaking changes)
- [ ] Log file written to `.claude/logs/agent-2-planning-21-may-2026-approval-engine-v1.md`
