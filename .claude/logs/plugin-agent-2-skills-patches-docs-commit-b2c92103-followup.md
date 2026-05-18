## Skills Patch Summary — docs-commit-b2c92103 Follow-up (6-gap API-reference pass)

### Patches Applied: 6

1. **[UPDATED] rules/shared/rest/rest-steps.md** — Gap 1: resolve endpoint full rewrite
   - Trigger: resolve endpoint rewritten with action discriminator, new required fields, new response shape
   - Action: Full rewrite of the resolve section. Added `action` field (REQUIRED) with 6 values: `force-approve`, `force-reject`, `force-complete`, `force-fail`, `reviewer-approve`, `reviewer-reject`. Changed `actorId` to REQUIRED (1–256 chars). Changed `reason` limit to ≤ 2000 chars. Added reviewer-scoped auth note (`reviewer-approve`/`reviewer-reject` require `actorId ∈ step.reviewerIds`, else PERMISSION_DENIED). Added authority-of-record note (engine computes `decision`/`approved`/`approvalReply`; caller-supplied keys ignored). Added critical pitfall: reject actions do NOT populate `output.rejectedBy`/`output.rejectorMandatory` — default loop predicate won't fire. Updated response shape to `{ resolved, executionId, stepId, action }`. Added workspace-admin RBAC post-GA note. Updated Verification Checklist (8→12 items).
   - Confidence: High

2. **[UPDATED] rules/shared/rest/rest-steps.md** — Gap 2: cancel endpoint corrections
   - Trigger: cancel actorId now REQUIRED; new error matrix; executionId in response; RBAC note
   - Action: Changed `actorId` from optional to REQUIRED (1–256 chars). Added `executionId` to success response shape. Replaced error list with explicit matrix: `INVALID_ARGUMENT` / `FAILED_PRECONDITION` / `NOT_FOUND` (no PERMISSION_DENIED). Added workspace-admin RBAC post-GA note.
   - Confidence: High

3. **[UPDATED] rules/shared/rest/rest-steps.md** — Gap 3: recordReviewerDecision unknown-reviewer behavior (active contradiction fix)
   - Trigger: reviewerId not in declared reviewers does NOT throw INVALID_ARGUMENT — engine records as unknown responder
   - Action: Replaced "anyone else returns INVALID_ARGUMENT" with the correct behavior: unknown reviewer is silently recorded; aggregatorStatus reflects whether quorum shifted; no error thrown. Updated Verification Checklist item to match. Added note: enforce reviewer identity in application layer, not via this endpoint.
   - Confidence: High

4. **[UPDATED] rules/shared/rest/rest-definitions.md** — Gap 4: scope per-level required fields + server-namespaced IDs + triggers shape
   - Trigger: scope per-level required fields; server-namespaced ID caveat; triggers descriptive-only
   - Action: Added scope per-level required fields table: `organizationId` required for `organization` scope; both `organizationId` + `documentId` required for `document` scope. Added server-namespaced IDs caveat: echoed values are not client-supplied strings. Added triggers shape note: `{ triggerId, eventName?, filters? }` — descriptive metadata only in v1; engine does NOT auto-dispatch.
   - Confidence: High

5. **[UPDATED] rules/shared/rest/rest-executions.md** — Gap 5: list organizationId/documentId filter limitation
   - Trigger: v1 list endpoint does not accept organizationId or documentId filters
   - Action: Added explicit v1 filter limitation note under the List section. Corrected `limit` param name to `pageSize` and response shape (`items` not `executions`). Added guidance to filter client-side by definitionId for scoped queries.
   - Confidence: High

6. **[UPDATED] rules/shared/rest/rest-executions.md** — Gap 6: getEvents externally-visible event enumeration cross-reference
   - Trigger: get-execution-events now enumerates all externally-visible event types including loop events
   - Action: Expanded internal-only event list in the seq-gap note to include all 8 internal types from the docs. Added paragraph cross-referencing the full externally-visible event catalog (including `loop.iteration-started` and `loop.exhausted`) to the `webhooks-delivery` rule.
   - Confidence: High

7. **[UPDATED] rules/shared/concepts/concepts-workflow-model.md** — Cross-reference for Gap 1 loop-predicate caveat
   - Trigger: Same as Gap 1 (resolve reject actions do not populate rejectorMandatory)
   - Action: Added "Critical — loop predicate caveat" paragraph to the loops section: default `onIterationReject.when` predicate won't fire when step resolved via resolve reject actions; `recordReviewerDecision` with mandatory reviewer is required for loop iteration to trigger.
   - Confidence: High

8. **[UPDATED] SKILL.md** — Quick Reference updated for changed rule scopes
   - Action: Updated `rest-steps`, `rest-executions`, `rest-definitions`, and `concepts-workflow-model` bullets to reflect new content.
   - Confidence: High

9. **[REGENERATED] AGENTS.full.md** — rebuilt via `npm run build`
   - All new content verified present in generated output.

### Files Modified: 5 rule files + 1 generated file
### Files Created: 0
### TODOs Added: 0
### Cross-skill audit: velt-rest-apis-best-practices/rest-approval-engine.md — pointer-only, no inline content, no update needed

### QA Results

**Re-Read Verification**: PASS — all edits confirmed present in AGENTS.full.md spot-check
**Delta Completeness**: PASS — all 6 gaps addressed; loop-predicate cross-ref added to concepts-workflow-model as required
**Regression Check**: PASS — recordAgentResolution, SLA, group quorum, edge expressions, linter codes all intact
**Formatting Validation**: PASS — frontmatter fields present, impact/tags unchanged, code blocks have language tags
**Code Example Validation**: PASS — no deprecated API calls; code examples use correct json/bash tags
**Cross-Reference Validation**: PASS — SKILL.md Quick Reference updated; no new rule files (no _sections.md change needed)
**Collateral Damage Check**: PASS — only the 5 rule files listed above were modified; _sections.md and webhooks-delivery.md (unstaged from prior pass) were not touched
**Stale phrasing grep**: PASS — no "overridden: true" response shape, no "reviewerId not in declared reviewers → INVALID_ARGUMENT", no "force-complete only" framing found in rules tree after edits
**Validate**: PASS — velt-approval-engine-best-practices: Total 7 | Valid 7 | Invalid 0
**Build**: PASS — AGENTS.full.md regenerated successfully

### Final Verdict: PASS
