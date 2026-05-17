## Skills Patch Summary for docs-commit-8410e1c1 (v2)

### Patches Applied: 8

1. **[UPDATED] rules/shared/python-sdk/python-comments.md** (delta-001)
   - Trigger: "SaveCommentResolverRequest field is commentAnnotations (list[dict]), not comments"
   - Action: Replaced `comments=[...]` with `comment_annotations=[...]` in the save example; updated inner shape to use `annotationId`/`commentData` structure matching the spec
   - Confidence: High

2. **[UPDATED] rules/shared/python-sdk/python-comments.md** (delta-002)
   - Trigger: "DeleteCommentResolverRequest requires annotation_id (str) and comment_id (int)"
   - Action: Added `annotation_id="annotation_1"` to the delete example; changed `comment_id="comment_1"` to `comment_id=1` (int type); updated key points and verification checklist
   - Confidence: High

3. **[UPDATED] rules/shared/python-sdk/python-attachments.md** (delta-003)
   - Trigger: "DeleteAttachmentResolverRequest has no comment_id; fields are organizationId, documentId, attachmentId"
   - Action: Removed `comment_id="comment_1"` from DeleteAttachmentResolverRequest example
   - Confidence: High

4. **[UPDATED] rules/shared/python-sdk/python-users-reactions.md** (delta-004)
   - Trigger: "DeleteReactionResolverRequest has no comment_id; fields are organizationId, documentId, reactionId"
   - Action: Removed `comment_id="comment_1"` from DeleteReactionResolverRequest example
   - Confidence: High

5. **[UPDATED] rules/shared/python-sdk/python-users-reactions.md** (delta-005)
   - Trigger: "GetReactionResolverRequest has no comment_id; fields are organizationId, documentId only"
   - Action: Removed `comment_id="comment_1"` from GetReactionResolverRequest example
   - Confidence: High

6. **[UPDATED] rules/shared/python-sdk/python-users-reactions.md** (delta-006)
   - Trigger: "SaveReactionResolverRequest has no comment_id; fields are organizationId, documentId, reactions"
   - Action: Removed `comment_id="comment_1"` from SaveReactionResolverRequest example
   - Confidence: High

7. **[UPDATED] python-comments.md, python-attachments.md, python-users-reactions.md, python-frameworks.md** (delta-007)
   - Trigger: "VeltSelfHostingResponse is a plain dict with camelCase keys (statusCode, errorCode)"
   - Action: APPLIED. Replaced all attribute-style access (`response.success`, `response.data`, `response.error`, `response.error_code`, `response.status_code`) with dict-style access (`response['success']`, `response['data']`, `response['error']`, `response['errorCode']`, `response.get('statusCode', 200)`) across all four python-sdk rule files. Added explicit Response format section to python-comments.md.
   - Confidence: Medium → CONFIRMED HIGH. The data-models.mdx shows VeltSelfHostingResponse as a plain Python dict literal with camelCase keys. The python.mdx framework examples consistently use `result.get('statusCode', 200)` dict access throughout. The docs explicitly state "Field details below mirror the dataclass definitions in velt-py" — but the shape shown is a plain dict, not a dataclass with attributes. Attribute-style access would produce AttributeError at runtime.

8. **[COLLATERAL FIX] rules/shared/python-sdk/python-attachments.md** (sibling grep catch)
   - Trigger: Sibling occurrence grep found `SaveAttachmentResolverRequest` using `comment_id="comment_1"`. Docs spec (data-models.mdx) shows SaveAttachmentResolverRequest fields are: organizationId, documentId, attachmentId, metadata — no comment_id.
   - Action: Replaced `comment_id="comment_1"` with `attachment_id="attachment_789"` in the SaveAttachmentResolverRequest example
   - Confidence: High (verified directly in data-models.mdx)

### Files Modified: 4
### Files Created: 0
### TODOs Added: 0

---

### QA Results

**Re-Read Verification**: PASS — All 4 rule files read back and verified structurally sound
**Delta Completeness**: PASS — 7/7 deltas addressed; delta-007 applied after confirmation from python.mdx and data-models.mdx
**Regression Check**: PASS — Pre-existing sections intact; only targeted fields/access patterns changed
**Formatting Validation**: PASS — YAML frontmatter intact, code blocks tagged with python, checklists use - [ ] format, Source Pointers retained
**Code Example Validation**: PASS — No deprecated patterns introduced; all examples show correct dict access
**Cross-Reference Validation**: N/A — No new rule files created; no _sections.md or SKILL.md updates needed
**Collateral Damage Check**: PASS — One additional fix applied to SaveAttachmentResolverRequest (confirmed correct by docs spec); python-rest-api-backend.md has no selfHosting response access patterns

**Sibling Grep Findings:**
- `python-frameworks.md`: 6 occurrences of attribute-style response access — fixed under delta-007
- `python-attachments.md`: `SaveAttachmentResolverRequest` using `comment_id` — fixed as collateral fix
- All remaining `comment_id` grep hits are intentional: either `comment_id=1` (correct required field in DeleteCommentResolverRequest) or explanatory prose stating reactions/attachments have no comment_id

**Build**: PASS — `npm run build` completed successfully; AGENTS.full.md regenerated for velt-self-hosting-data-best-practices

### Final Verdict: PASS
