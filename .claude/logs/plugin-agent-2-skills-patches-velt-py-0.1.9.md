## Skills Patch Summary for velt-py-0.1.9

### Patches Applied: 9

1. **[UPDATED] rules/shared/core/core-python-sdk-setup.md** (velt-self-hosting-data-best-practices)
   - Trigger: delta-001 — VeltSdk/VeltSdkConfig class-based init → VeltSDK.initialize({}) dict-based; import is now `from velt_py import VeltSDK`; MongoDB config now optional
   - Action: Full rewrite of init sections. Replaced all `VeltSdk(VeltSdkConfig(...))` patterns with `VeltSDK.initialize({...})`. Added REST API-only init example. Updated "Incorrect" block to text-only description. Updated Custom Collection Names and User Schema sections to use new init pattern.
   - Confidence: High

2. **[UPDATED] rules/shared/core/core-python-sdk-setup.md** (velt-self-hosting-data-best-practices)
   - Trigger: delta-002 — Env var support (VELT_API_KEY, VELT_AUTH_TOKEN, VELT_WORKSPACE_ID, VELT_WORKSPACE_AUTH_TOKEN)
   - Action: Added env var section with table of four supported variables and correct empty-dict init example.
   - Confidence: High

3. **[UPDATED] rules/shared/core/core-python-sdk-setup.md** (velt-self-hosting-data-best-practices)
   - Trigger: delta-004 — Three new exception classes VeltValidationError, VeltTokenError, VeltApiError extending VeltSDKError
   - Action: Added Python exception class table and correct try/except code example to the Error Codes Reference section. Import path `from velt_py.exceptions import ...` verified against live python.mdx (line 2837).
   - Confidence: Medium → verified High after source check

4. **[CREATED] rules/shared/python-sdk/python-rest-api-backend.md** (velt-self-hosting-data-best-practices)
   - Trigger: delta-003 — sdk.api.* namespace with 16 services (rewriter excluded per policy), typed dataclass requests from velt_py.models.<domain>, camelCase methods, result/error response shape
   - Action: Created new rule file with impact HIGH, correct init + service call example, full service table, key points, verification checklist, and source pointer.
   - Confidence: High

5. **[UPDATED] rules/shared/python-sdk/python-attachments.md** (cross-skill rename audit)
   - Trigger: `from velt import VeltSdk, VeltSdkConfig` stale imports discovered in audit
   - Action: Replaced class-based init block with `VeltSDK.initialize({...})` dict pattern. Replaced `from velt import SaveAttachmentResolverRequest` and `DeleteAttachmentResolverRequest` with `from velt_py import`. Converted "Incorrect" code block to text-only description. Updated checklist item.

6. **[UPDATED] rules/shared/python-sdk/python-comments.md** (cross-skill rename audit)
   - Trigger: All `from velt import` stale imports
   - Action: Replaced all four `from velt import` occurrences with `from velt_py import`. Updated checklist item.

7. **[UPDATED] rules/shared/python-sdk/python-frameworks.md** (cross-skill rename audit)
   - Trigger: `VeltSdk(VeltSdkConfig(...))` and `from velt import` stale patterns in all three framework examples
   - Action: Updated Django, Flask, FastAPI examples to use `VeltSDK.initialize({...})`. Replaced `from velt import` → `from velt_py import`. Added env var comments.

8. **[UPDATED] rules/shared/python-sdk/python-users-reactions.md** (cross-skill rename audit)
   - Trigger: All `from velt import` stale imports
   - Action: Replaced all `from velt import` occurrences with `from velt_py import`. Updated checklist item.

9. **[UPDATED] SKILL.md + rules/shared/_sections.md** (velt-self-hosting-data-best-practices)
   - Trigger: delta-003 new rule creation requires Quick Reference and _sections updates
   - Action: Added `python-rest-api-backend` to SKILL.md Quick Reference under new "6. Python SDK (HIGH)" section. Added Python SDK row to Rule Categories table. Updated rule count from 15 to 16. Updated _sections.md section 7 description and added rules list.

### Files Modified: 7
### Files Created: 1
### TODOs Added: 0

---

### QA Results

**Re-Read Verification**: PASS — All modified files read back correctly; no broken markdown, orphaned code blocks, or mangled YAML frontmatter detected.

**Delta Completeness**: PASS — 4/4 deltas addressed. delta-004 confidence upgraded to High after verifying import path `from velt_py.exceptions import ...` on line 2837 of live python.mdx.

**Regression Check**: PASS — Error Codes Reference table, Custom Collection Names, and User Schema sections preserved in core-python-sdk-setup.md. All pre-existing self-hosting patterns retained in python-attachments.md, python-comments.md, python-frameworks.md, python-users-reactions.md.

**Formatting Validation**: PASS — All files have required YAML frontmatter fields. Impact values are valid. Main headings match titles. Code blocks have language tags. Anti-patterns described in text only (no copyable deprecated code). Verification Checklists use checkbox format. Source Pointers use full https://docs.velt.dev/ URLs.

**Code Example Validation**: PASS — All examples use `from velt_py import VeltSDK`. No `VeltSdk` or `VeltSdkConfig` remain in any copyable code block. `VeltSDK.initialize({...})` dict pattern used throughout. No version numbers in rule content. No stale beta references.

**Cross-Reference Validation**: PASS — `_sections.md` section 7 updated with `python-rest-api-backend`. `SKILL.md` Quick Reference lists all 5 python-sdk rules under new section 6. Rule count updated from 15 to 16.

**Collateral Damage Check**: PASS — Only the 8 listed files were modified. Verified via grep: no `VeltSdk\|VeltSdkConfig\|from velt import` remain in any copyable code block across the entire skill tree.

**Cross-Skill Rename Audit**: PASS — Grepped `velt-self-hosting-data-best-practices` and confirmed no stale `VeltSdk`/`VeltSdkConfig`/`from velt import` remain in code blocks. The velt-backend-sdks-best-practices skill directory does not exist yet (not yet created), so no sibling audit required.

**Build Regeneration**: PASS — `npm run build` completed successfully. velt-self-hosting-data-best-practices AGENTS.md regenerated with 23 total rules.

### Final Verdict: PASS
