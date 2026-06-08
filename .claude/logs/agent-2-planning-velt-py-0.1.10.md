# Release Update Plan for velt-py v0.1.10

## Overview
- Release Type: Patch (typed field additions + sentinel value; no breaking changes)
- Key Changes: `PartialCommentAnnotation` gains 4 first-class typed fields; new `PartialTargetTextRange` dataclass; `BaseMetadata` now preserves `sdkVersion`/`documentMetadata`; `UNSET` sentinel on `resolvedByUserId`
- Breaking Changes: No — `extra_fields` pass-through is removed but the promoted fields are now typed; existing call sites that read `extra_fields` will need to switch to named attributes (document as a behavioral note, not a migration step)

## Areas Requiring Updates

### 1. Data Models — SKIP
Per the v0.1.9 precedent, Python dataclasses must NOT be added to `/api-reference/sdk/models/data-models.mdx`. Document all new types inline on the Python SDK page only.

### 2. API Methods — SKIP
`/api-reference/sdk/` covers the Web/React SDK. Python-only types must NOT be added there.

### 3. Primary Documentation: `/Users/yoenzhang/Downloads/docs/backend-sdks/python.mdx`
- File: `/Users/yoenzhang/Downloads/docs/backend-sdks/python.mdx`
- Changes:
  - Locate the existing `PartialCommentAnnotation` reference section (imported from `velt_py` in the self-hosting handlers at lines ~270–274). Add or extend a dataclass reference block covering:
    - `PartialCommentAnnotation` — table of typed fields: `annotationId`, `metadata`, `comments`, plus the four newly promoted fields: `from_` (aliased from `from`; type `dict`), `assignedTo` (`dict | None`), `targetTextRange` (`PartialTargetTextRange | None`), `resolvedByUserId` (`str | None | UNSET`). Note the `UNSET` sentinel meaning vs explicit `None`.
    - `PartialTargetTextRange` — new dataclass, export path `from velt_py.models import PartialTargetTextRange`. Fields: document whatever the PyPI source exposes (minimally: `startIndex`, `endIndex`, `text` — note to Agent-3: verify exact fields against PyPI 0.1.10 source before publishing; use `str` for all if uncertain).
  - In the `BaseMetadata` reference block (if one exists on python.mdx — check; if not, add it): note that `sdkVersion` (`str | None`) and `documentMetadata` (`dict | None`) are now preserved in Mongo writes. They were previously silently dropped.
  - Add a short note under the `resolvedByUserId` field entry explaining the `UNSET` sentinel: "If absent from the incoming payload, `resolvedByUserId` is `UNSET` and Velt skips the Mongo write for that field. An explicit `null` from the frontend (unresolve action) arrives as `None` and writes `null` to Mongo."
  - Add an import snippet: `from velt_py.models import PartialTargetTextRange, UNSET`
- Priority: High

### 4. UI Customization / Wireframes / Primitives — N/A
Backend-only release. No frontend components affected.

### 5. Upgrade Guide — N/A
No breaking changes requiring migration steps. The `extra_fields` removal is behavioral — access promoted fields by name instead. No separate upgrade-guide.mdx entry needed.

## Implementation Sequence
1. Update `python.mdx` — add/extend `PartialCommentAnnotation` dataclass reference with 4 new fields, add `PartialTargetTextRange` dataclass reference, update `BaseMetadata` note for `sdkVersion`/`documentMetadata`, add `UNSET` sentinel explanation.
2. Verify `PartialTargetTextRange` field names against PyPI 0.1.10 before finalizing field table.

## Quality Checklist
- [ ] `PartialCommentAnnotation` table lists all 7 fields including `from_`, `assignedTo`, `targetTextRange`, `resolvedByUserId`
- [ ] `PartialTargetTextRange` dataclass documented with export path `from velt_py.models import PartialTargetTextRange`
- [ ] `UNSET` sentinel explained: absent → no Mongo write; `None` → writes null
- [ ] `BaseMetadata` note added: `sdkVersion` and `documentMetadata` now preserved
- [ ] Import snippet `from velt_py.models import PartialTargetTextRange, UNSET` included
- [ ] No Python types added to `/api-reference/sdk/models/data-models.mdx`
- [ ] No breaking changes in upgrade-guide.mdx
- [ ] Log written to `.claude/logs/agent-2-planning-velt-py-0.1.10.md`
