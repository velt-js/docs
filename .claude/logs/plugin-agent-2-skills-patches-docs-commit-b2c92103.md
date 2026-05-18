## Skills Patch Summary for docs-commit-b2c92103

Source commit: b2c921036ed3bd166faaad61240ddc5da2d623bd (docs/main)
Skill set: velt-approval-engine-best-practices

### Patches Applied: 10

1. **[UPDATED] rules/shared/concepts/concepts-workflow-model.md** (delta-001)
   - Trigger: "Add reviewerEmails (string[], 0–50) to human node config shape; surfaces in output.reviewerEmails"
   - Action: Added `reviewerEmails` field to human node shape example and added explanatory prose. Updated frontmatter title, heading, and tags.
   - Confidence: High

2. **[UPDATED] rules/shared/concepts/concepts-workflow-model.md** (delta-002)
   - Trigger: "commentBody stored on step output only; engine does NOT auto-create Velt annotation in v1"
   - Action: Added prose paragraph clarifying `commentBody` semantics: stored on output, application is responsible for surfacing to reviewers and creating comment thread for legacy flow.
   - Confidence: High

3. **[UPDATED] rules/shared/concepts/concepts-workflow-model.md** (delta-003)
   - Trigger: "Per-human-node onReject shorthand (Form A: routeToNodeId; Form B: loopBack); strict-mode requirement; desugaring behavior; joinOnQuorum dead-code warning"
   - Action: Added full `onReject` shorthand section with both code examples, strict-mode documentation, desugaring note, and joinOnQuorum dead-code warning. Added onReject checklist item.
   - Confidence: High

4. **[UPDATED] rules/shared/concepts/concepts-workflow-model.md** (delta-004)
   - Trigger: "Loop regions — top-level loops[] field; body-shape constraints; previousAttempts payload; when to use loop vs. onReject"
   - Action: Added "Loop regions (loops[])" section before Edge shape with: full field reference table, body-shape constraint prose, previousAttempts payload example, and loop checklist items. Updated frontmatter title/heading/tags.
   - Confidence: High

5. **[UPDATED] rules/shared/rest/rest-definitions.md** (delta-005)
   - Trigger: "9 new loop-related linter codes (loop-duplicate-id through loop-group-bounded-quorum-must-equal-expected)"
   - Action: Added "Loop linter codes" subsection with all 9 codes. Updated linter count from 16 to 25 in section heading, frontmatter impactDescription, inline prose, and tags.
   - Confidence: High

6. **[UPDATED] rules/shared/webhooks/webhooks-delivery.md** (delta-006)
   - Trigger: "2 new event types: loop.iteration-started and loop.exhausted"
   - Action: Added two rows to the event catalog table: `loop.iteration-started` ({loopId, iteration, triggeredBy: 'rejection'}) and `loop.exhausted` ({loopId, iteration, lastRejectedBy?, lastRejectionReason?}). Updated tags frontmatter.
   - Confidence: High

7. **[UPDATED] rules/shared/rest/rest-steps.md** (delta-007)
   - Trigger: "/steps/resolve adds optional reason (≤500) + actorId (≤200)"
   - Action: Expanded resolve section with full JSON request/response block showing all three body fields; added prose documenting reason and actorId constraints. Updated tags and verification checklist.
   - Confidence: High

8. **[UPDATED] rules/shared/rest/rest-steps.md** (delta-008)
   - Trigger: "/steps/cancel adds optional actorId (≤200), surfaced on step.cancelled event"
   - Action: Expanded cancel section with full JSON request/response block; added prose documenting actorId. Updated verification checklist.
   - Confidence: High

9. **[UPDATED] SKILL.md** (cross-reference maintenance)
   - Action: Updated skill description, concepts bullet, rest-definitions bullet (16→25 rules + loop code list), rest-steps bullet (actorId/reason), webhooks bullet (new event types).

10. **[UPDATED] rules/shared/_sections.md** (cross-reference maintenance)
    - Action: Updated Concepts section description (onReject, loops[], reviewerEmails, commentBody), REST section (25-rule linter, actorId/reason), Webhooks section (loop events).

### Files Modified: 6 rule files + SKILL.md + _sections.md = 8 files
### Files Created: 0
### TODOs Added: 0

---

### QA Results

**Re-Read Verification**: PASS — All 6 rule files, SKILL.md, and _sections.md verified via Edit tool confirmation and AGENTS.full.md spot-check.

**Delta Completeness**: PASS — 8/8 deltas addressed. All were confidence: high. No deltas skipped.

**Regression Check**: PASS — Pre-existing sections (Agent node shape, Edge shape, when expressions, Group shape, quorum policies, SLA/breach, Step IDs, Status flows, all REST endpoint docs, HMAC verification code, retry schedule, idempotency section) verified intact in AGENTS.full.md grep output.

**Formatting Validation**: PASS
- [x] All modified files have required frontmatter fields (title, impact, impactDescription, tags)
- [x] impact values unchanged (HIGH throughout)
- [x] Main headings match titles (updated for concepts-workflow-model)
- [x] Code blocks have language tags (json, typescript, javascript, bash)
- [x] Anti-patterns described in text only; no copyable deprecated code
- [x] Verification Checklists use `- [ ]` format
- [x] Source Pointers use full https://docs.velt.dev/ URLs

**Code Example Validation**: PASS
- [x] No React/HTML framework examples in these rules (REST/JSON only — correct for approval engine skill)
- [x] API calls use correct endpoint paths
- [x] No deprecated API names introduced
- [x] No version numbers in rule content

**Cross-Reference Validation**: PASS
- [x] SKILL.md Quick Reference updated for all 4 affected rules
- [x] _sections.md descriptions updated for all 3 affected sections
- [x] velt-rest-apis-best-practices/rest-approval-engine.md is a pointer-only file — no update needed (confirmed: no new API names referenced there)
- [x] rest-object-views.md already had reviewerEmails + commentBody in human step output shape — pre-existing, consistent, no update needed

**Collateral Damage Check**: PASS
- Only these files modified: concepts-workflow-model.md, rest-definitions.md, rest-steps.md, webhooks-delivery.md, SKILL.md, _sections.md, AGENTS.md, AGENTS.full.md (last two generated by build)
- No files outside velt-approval-engine-best-practices were modified

**Build Regeneration**: PASS — `npm run build` exited 0. AGENTS.full.md contains all new content: reviewerEmails (line 91), onReject (line 93), loopId (line 148), loop-duplicate-id (line 552), actorId (lines 810, 816, 828, 834), loop.iteration-started (line 947), loop.exhausted (line 950). 25-rule count confirmed at line 516.

### Final Verdict: PASS
