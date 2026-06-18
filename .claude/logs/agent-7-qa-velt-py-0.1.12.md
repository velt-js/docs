## QA Summary for velt-py v0.1.12

### Issues Found: 0

No corrective changes were required. Both touched files are consistent, well-formed, and correct.

### Scope Confirmation
`git diff --stat` confirms ONLY two files modified — nothing else attributed to this release:
- `release-notes/version-5/velt-py-changelog.mdx`
- `backend-sdks/python.mdx`

### Verification Coverage

**release-notes/version-5/velt-py-changelog.mdx**
- `<Update label="Python SDK (velt-py) v0.1.12" description="June 16, 2026">` correct; placed above v0.1.10.
- Section order `### Breaking Changes` → `### Bug Fixes` correct (first velt-py release with a Breaking Change — expected, not an anomaly).
- Exactly 3 bullets (1 breaking + 2 bug fixes), none combined; each ends with `[Learn more →](/backend-sdks/python)`.
- `<Update>`/`</Update>` balanced (3/3).
- Version order v0.1.12 → v0.1.10 → v0.1.9: the v0.1.11 gap is EXPECTED on `main` (v0.1.11 lives on a separate branch) — not flagged.

**backend-sdks/python.mdx — `PartialReactionAnnotation` (lines 3727–3761)**
- Heading `###`; placed between `PartialCommentAnnotation` and `PartialTargetTextRange`.
- Structure well-formed: intro → `@dataclass` python block → Field notes → legacy-read example → Before/After migration snippet.
- Documented fields `annotationId`, `metadata`, `icon`, `from_`, `extra_fields` all present.
- Shim semantics stated correctly: `from_dict()` accepts `from` or legacy `user` (`from` wins when both present); `to_dict()` emits `from`; no data migration required.
- Block does NOT link Python types to data-models.mdx anchors (correct — these are Python-only dataclasses).
- Code comments explain code (no doc-reference links). All `python` fences opened and closed.

**backend-sdks/python.mdx — services-export note (lines 235–248, under `## Self-Hosting Backend`)**
- Count matches: code block lists 8 names = `BaseService` + 7 resolver services (Comment, Reaction, Attachment, Recorder, Notification, Activity, User). Prose "plus seven resolver services" is accurate.
- WHY-claim accurate: previously wired into `SelfHostingBackend` but missing from the package `__all__` (NOT "available only via submodules").
- `RecorderService` / `NotificationService` / `ActivityService` correctly flagged as newly exported in v0.1.12.

**Code-fence balance**
- python.mdx: 414 ``` fences (even — balanced).

**Link integrity (changed regions)**
- All `[Learn more →]` resolve to `/backend-sdks/python` (page exists).
- No anchor links introduced inside the new Python dataclass block.

**No Python type leakage into api-reference/**
- `api-reference/sdk/models/data-models.mdx#PartialReactionAnnotation` (line 4628) is the TypeScript Web SDK interface — a Markdown property table (`string`, `PartialUser`, wire key `from`), NOT a Python dataclass. Distinct type; correctly left untouched.
- No `@dataclass` / `velt_py` / `from_` present anywhere under `api-reference/`.

**Repo-wide terminology sweep (release-notes/, backend-sdks/)**
- No stale "seven self-hosting service classes" phrasing surviving.
- No "available only via their submodules" claim surviving.
- Reaction `from_` / `from` / `user` usage consistent: canonical `from_` (attr) and `from` (wire) used throughout; `user` appears ONLY in legacy-read / Before-migration context — correct.

**MDX/JSX sanity**
- No broken tags in either file.

### Summary
- Files corrected: 0
- Critical issues: 0
- Terminology alignments: 0
- Scope confirmed: only the 2 expected files modified.
- Agent-6 alignment confirmed clean; no propagation needed.
- Overall: PASS.
