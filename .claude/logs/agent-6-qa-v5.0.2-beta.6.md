## QA Summary for v5.0.2-beta.6

### Issues Found: 2

1. **release-notes/version-4/sdk-changelog.mdx** - v5.0.2-beta.6 entry placed in the wrong file
   - Problem: Agent-1 wrote the release note entry into `version-4/sdk-changelog.mdx` instead of `version-5/sdk-changelog.mdx`. The version-4 changelog covers v4.x entries only; version-5 already has `5.0.2-beta.5` as its top entry.
   - Fix: Removed the entry from `version-4/sdk-changelog.mdx`; added it correctly to the top of `version-5/sdk-changelog.mdx` above the `5.0.2-beta.5` block.

2. **release-notes/version-5/sdk-changelog.mdx** (shadow DOM casing) - "Shadow DOM" used instead of "shadow DOM"
   - Problem: Line 24 of the original entry used "Shadow DOM" (capital S). The established changelog pattern uses "shadow DOM" (lowercase s) in 4 of 5 existing instances.
   - Fix: Corrected to "shadow DOM" in the entry moved to version-5.

### Terminology Verification

- `[**Comments**]:` prefix format - consistent with all surrounding entries (colon after closing bracket).
- `sessionStorage` - backtick-formatted, correct.
- `effectiveSidebarFilters$` / `commentSidebarFilters$` - internal implementation symbols, backtick-formatted, no public API docs to cross-reference.
- `mergeClientFilters` - internal function, backtick-formatted, no public API impact.
- `@mention` - consistent with existing changelog usage (lines 280, 8019 of version-4; version-5 line 1236 uses "mentioned" not the tag form, no conflict).
- `multi-thread` / `single-thread` (hyphenated) - consistent with existing changelog usage at version-4 lines 28, 3783, 7962 and version-5 line 1364.
- `\x00VELT_CUSTOM_n\x00` placeholder - no equivalent exists elsewhere in changelogs; retained as-is since it documents an internal implementation detail accurately within backticks.
- Section order: Bug Fixes only (no New Features / Improvements) - correct for an all-bugfix release.

### Summary

- Files corrected: 2
- Critical issues: 1 (entry in wrong versioned changelog file)
- Terminology alignments: 1 ("Shadow DOM" → "shadow DOM")
- No public API changes; no api-methods.mdx or data-models.mdx cross-reference needed.

### Agent-1 Readiness

Documentation is ready for next release note processing. The v5.0.2-beta.6 entry is correctly placed in `version-5/sdk-changelog.mdx` with consistent terminology.
