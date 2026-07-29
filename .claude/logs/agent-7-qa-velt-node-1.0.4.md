## QA Summary for @veltdev/node v1.0.4

### Issues Found: 0

No corrective edits required. Both files passed all checks; Agent-3 and Agent-6 output is accurate and complete.

### Verification Coverage

**release-notes/version-5/velt-node-changelog.mdx**
- `<Update label="1.0.4" description="June 16, 2026">` present; placed above v1.0.2 (1.0.3 gap intentional — separate branch).
- `### New Features` is the only category; exactly 2 bullets, both bold-title style (no bracket tags).
- Both bullets end with `[Learn more →](/backend-sdks/node#field-allowlist)`.
- `<Update>` open/close balanced (2/2). No new data-models links introduced.

**backend-sdks/node.mdx**
- `### Field Allowlist` section well-formed; heading slug `#field-allowlist` unique (single occurrence at L628).
- Behavior bullets present: opt-in/off-by-default, fail-open, top-level scoped (nested open-typed objects pass through whole).
- Inline `FieldFilterOptions` and `FilterSpec` ts blocks present; 8 method signatures listed; verbatim `addCommentAnnotations` example with dropped `internalId`.
- Primitives `filterRequest` / `pickKnownFields` documented; all 8 `*_SPEC` constants present.
- Per-endpoint allowlist table: 8 rows. Two comment-data key sets (`ANNOTATION_COMMENT_DATA_KEYS`, `COMMENT_DATA_KEYS`) documented.
- `<Note>` correctly states `isRead`/`isArchived` are EXCLUDED/unsupported by `/v2/notifications/update`. `<Note>` balanced (1/1).
- Code fences even (442 total). No new data-models links.

**8-method annotation scoping**
- Cross-ref bullet present on exactly the 8 add/update method headings: `addNotifications`, `updateNotifications`, `addCommentAnnotations`, `updateCommentAnnotations`, `addComments`, `updateComments`, `addActivities`, `updateActivities`.
- No get/delete/count/save method carries the bullet (verified per-heading).

**Link integrity**
- Changelog `#field-allowlist` anchor resolves to the unique L628 heading.
- All 8 in-page `See [Field Allowlist](#field-allowlist)` cross-refs resolve.

**No stray edits**
- Service count unchanged at 17 (v1.0.2 baseline, correct — not v1.0.3).
- No v1.0.3 content introduced.
- `data-models.mdx` unchanged relative to `main` (`git diff --stat main` empty) — untouched this release.
- `git diff --stat main` shows ONLY the two expected files (+116 lines).

### Out-of-Scope (intentional, not flagged)
- velt-py snake_case `filter_unknown_fields` vs node camelCase `filterUnknownFields` — deliberately distinct; not cross-aligned.
- Fully additive/opt-in — no Breaking Changes section (correct).

### Summary
- Files corrected: 0
- Critical issues: 0
- Overall: PASS — ready for Plugin Agent 1 / next release note.
