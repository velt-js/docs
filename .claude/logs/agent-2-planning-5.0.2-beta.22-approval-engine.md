# Release Update Plan for v5.0.2-beta.22 — Approval Engine REST API

## Overview
- Release Type: Minor (new REST-only feature)
- Key Changes: Approval Engine v1 REST API — 14 endpoints for workflow definitions, executions, steps, and webhook delivery
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models — SKIP
`data-models.mdx` is scoped to SDK-level TypeScript types (CommentAnnotation, Comment, User, etc.). Approval Engine types (`ExecutionView`, `StepView`, `DefinitionView`, `ApprovalEventView`, etc.) are REST-only contracts; they are already fully documented inline in the overview page. Do NOT add them to data-models.mdx.

### 2. API Methods — SKIP
Approval Engine is REST-only. No SDK methods to document.

### 3. Wireframes / Primitives — SKIP
REST-only feature, no UI components.

### 4. Broken Link Fix (Agent-3)
- File: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/approval-engine/overview.mdx`
- Line 26: Auth token link points to `/api-reference/rest-apis/v1/auth/generate-token` (v1 path).
- Correct v2 path exists at `api-reference/rest-apis/v2/auth/generate-token` (confirmed in docs.json line 635).
- Change: Update the link to `/api-reference/rest-apis/v2/auth/generate-token`.
- Priority: High

### 5. Webhook Docs Cross-Reference (Agent-3)
- Files: `/Users/yoenzhang/Downloads/docs/webhooks/basic.mdx` and `/Users/yoenzhang/Downloads/docs/webhooks/advanced.mdx`
- Neither file references Approval Engine webhooks at all.
- The Approval Engine overview page documents its own webhook contract inline, so no full section is needed here — but a brief cross-reference note should be added to `advanced.mdx` (which already covers CRDT and Recorder webhooks) mentioning that Approval Engine emits `approval_engine.*` events and linking to the overview page.
- Priority: Medium

### 6. Navigation Placement — Already Correct
docs.json places Approval Engine as a group under v2 REST APIs (lines 669–674), after Rewriter and before Workspace. Placement is sensible. No changes needed.

### 7. Auth Token Page — No Change Needed
The v1 auth generate-token page (`api-reference/rest-apis/v1/auth/generate-token`) exists and is registered in docs.json (line 818). The overview page's link is technically functional but points to v1; fix is captured in item 4 above.

### 8. Rate Limiting / Errors — No Shared Page Exists
No standalone rate-limits or error-codes page exists in the REST API section. Error codes are documented inline in the overview. No cross-reference needed.

## Implementation Sequence
1. (Agent-3) Fix broken auth token link in overview.mdx (line 26): change v1 path to v2 path.
2. (Agent-3) Add cross-reference note in `webhooks/advanced.mdx` for Approval Engine events.

## Quality Checklist
- [ ] Auth token link corrected from v1 to v2 in overview.mdx
- [ ] `webhooks/advanced.mdx` mentions Approval Engine webhook events with link
- [ ] data-models.mdx left unchanged (REST types do not belong there)
- [ ] No SDK methods documented (REST-only feature)
- [ ] No wireframes or primitives changes (REST-only feature)
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.22-approval-engine.md`
