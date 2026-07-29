# Release Update Plan for velt-py v0.1.12

## Overview
- Release Type: Patch (one breaking attribute rename + two backward-compatible bug fixes)
- Key Changes: `PartialReactionAnnotation.user` → `from_` (wire key `from`); `from_dict()` read shim accepts legacy `user` (`from` wins); `RecorderService`/`NotificationService`/`ActivityService` now exported from `velt_py.services.self_hosting` (all seven services reachable)
- Breaking Changes: Yes (Python-only) — constructing `PartialReactionAnnotation(user=...)` must switch to `from_=...`. No data migration (read shim is backward compatible)
- Backend REST API (`sdk.api.*`): Unchanged
- docs.json: No change — `backend-sdks/python` page already exists

## Areas Requiring Updates

### 1. Data Models — SKIP `/api-reference/sdk/models/data-models.mdx`
Per v0.1.9/v0.1.10 precedent, Python dataclasses must NOT be added to the shared Web/React SDK reference. Document `PartialReactionAnnotation` inline on `python.mdx` only.

### 2. API Methods — SKIP `/api-reference/sdk/api/api-methods.mdx`
Python-only types/services must NOT be added there. REST backend (`sdk.api.*`) is unchanged this release.

### 3. Primary Documentation: `/Users/yoenzhang/Downloads/docs/backend-sdks/python.mdx`
- File: `/Users/yoenzhang/Downloads/docs/backend-sdks/python.mdx`

**3a. New `### PartialReactionAnnotation` in `## Data Models`**
- Insertion point: immediately after `### PartialCommentAnnotation`'s **Field notes** block (ends line ~3711), before `### PartialTargetTextRange` (line ~3712). Comment-family models stay grouped.
- Mirror the `### PartialCommentAnnotation` format exactly: one-line intro → `@dataclass` python block → **Field notes** bullets → short `from_dict`/`to_dict` example.
- Intro: state the field rename and wire key. Reference: "Starting in **v0.1.12**, the reaction-author field is `from_` (Python attribute), serialized under the wire key `from` (was `user`), aligning with `PartialComment`/`PartialCommentAnnotation`."
- `@dataclass` block: show `from_: Optional[PartialUser] = None  # 'from' on the wire; from_ avoids Python keyword.` plus other existing fields (Agent-3: verify field set against PyPI 0.1.12 `velt_py.models.reaction`; if uncertain, document only `from_` and note the rest are unchanged).
- **Field notes** bullets:
  - `from_` — Python alias for JSON key `from` (reserved keyword). `to_dict()` always emits `from`.
  - Breaking: code constructing with `user=` must switch to `from_=`.
  - Read shim: `from_dict()` accepts `from` OR legacy `user`; `from` wins when both present; both populate `from_`. No data migration.
- Example: include the `from_dict`/`to_dict` round-trip from the release note showing legacy `user` read → `from_` populated → `to_dict` emits `from`.
- Priority: High

**3b. Self-hosting service exports note in `## Self-Hosting Backend`**
- Lightest touch: add a brief note (not a full subsection) at the end of the `### Reactions` content / before `### Users` (line ~378), OR a short callout under the `## Self-Hosting Backend` intro (line ~233). Recommend the intro callout — it applies to all services, not just reactions.
- Content: all seven self-hosting services are importable from `velt_py.services.self_hosting` (`__all__`): `BaseService`, `CommentService`, `ReactionService`, `AttachmentService`, `RecorderService`, `NotificationService`, `ActivityService`, `UserService`. Note `RecorderService`/`NotificationService`/`ActivityService` are newly exported in v0.1.12.
- Keep it a 2–3 line note; the page documents resolver *methods*, not service *classes*, so do not add per-class subsections.
- Priority: Medium

### 4. UI Customization — Wireframes — N/A
Backend-only Python SDK release. No wireframes.

### 4b. UI Customization — Primitives — N/A
Backend-only Python SDK release. No primitive components.

### 5. Upgrade Guide — SKIP `/Users/yoenzhang/Downloads/docs/release-notes/version-5/upgrade-guide.mdx`
- Verified: this file is the JS/React **v4→v5** SDK migration guide (CSS element-name renames, comment dialog primitives). A Python-SDK patch-level breaking change does not belong there.
- Per v0.1.10 precedent (Python behavioral notes kept out of the JS upgrade guide), the velt-py changelog Breaking Changes section + the `python.mdx` `PartialReactionAnnotation` migration note (`user=` → `from_=`) is sufficient.
- Recommendation: Do NOT add an entry to the JS upgrade guide.

## Implementation Sequence
1. Add `### PartialReactionAnnotation` to `## Data Models` after `### PartialCommentAnnotation` (intro + `@dataclass` + Field notes + `from_dict`/`to_dict` example). Effort: Medium.
2. Add 2–3 line services-export note under `## Self-Hosting Backend` intro listing all seven services. Effort: Low.
3. Agent-3: verify `velt_py.models.reaction` field set against PyPI 0.1.12 before finalizing the dataclass block.

## Quality Checklist
- [ ] `### PartialReactionAnnotation` added after `### PartialCommentAnnotation`, mirroring its format
- [ ] `from_` documented as alias for wire key `from`; `to_dict()` always emits `from`
- [ ] Breaking migration note: `user=` → `from_=`
- [ ] Read shim documented: `from_dict()` accepts `from` or legacy `user`; `from` wins; no data migration
- [ ] `from_dict`/`to_dict` example included
- [ ] Services-export note lists all seven services importable from `velt_py.services.self_hosting`
- [ ] No Python types added to `/api-reference/sdk/models/data-models.mdx`
- [ ] No Python breaking change added to the JS `upgrade-guide.mdx`
- [ ] docs.json unchanged
- [ ] Log written to `.claude/logs/agent-2-planning-velt-py-0.1.12.md`
