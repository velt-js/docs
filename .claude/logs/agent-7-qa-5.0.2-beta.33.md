## QA Summary for v5.0.2-beta.33

### Issues Found: 1

1. **api-reference/sdk/api/api-methods.mdx** line 1894 — broken anchor link: `#enablereadnotificationsontheforyoutab` (stray "the") should be `#enablereadnotificationsonforyoutab`.
   - Target heading in `async-collaboration/notifications/customize-behavior.mdx` line 320: `#### enableReadNotificationsOnForYouTab` → slug `enablereadnotificationsonforyoutab`.
   - Fix: Replaced `#enablereadnotificationsontheforyoutab` → `#enablereadnotificationsonforyoutab`.

### Verified Clean (no changes needed)

**Casing/spelling scan — no violations found:**
- No `enableCrossOrganizations`, `enableCrossOrg`, `enableCrossOrganisation`, `disableCrossOrg`, `disableCrossOrganisation`, `enable-cross-org`, or `crossOrganizationConfig` (lowercase c, used where Type is meant) anywhere in repo.
- All React contexts use camelCase `enableCrossOrganization`; all HTML contexts use kebab `enable-cross-organization`. No cross-context mixing.
- All 8 banner custom elements are correctly hyphenated across `primitives.mdx` and `wireframes.mdx`: `velt-comment-dialog-agent-suggestion-banner`, `...-avatar`, `...-avatar-user-image`, `...-avatar-status-icon`, `...-label`, `...-separator`, `...-resolver-user-name`, `...-timestamp`. No malformed variants detected.

**Anchor resolution — all resolve:**
- `data-models.mdx#crossorganizationconfig` → heading `#### CrossOrganizationConfig` at line 3317. ✓
- `customize-behavior.mdx#enablecrossorganization` → heading `#### enableCrossOrganization` at line 384. ✓
- `customize-behavior.mdx#disablecrossorganization` → heading `#### disableCrossOrganization` at line 542. ✓
- `customize-behavior.mdx#getcrossorganizationconfig` → heading `#### getCrossOrganizationConfig` at line 571. ✓ (covers both `getCrossOrganizationConfig` and `getCrossOrganizationConfig$` links)
- `primitives.mdx#veltcommentdialogagentsuggestionbanner` → heading `### VeltCommentDialogAgentSuggestionBanner` at line 4702. ✓

**Banner name parity across files (all 8, byte-identical):**
- `api-methods.mdx`: 8 banner component headings present (lines 1362–1404). ✓
- `primitives.mdx`: 8 banner `###` sections present (lines 4702–4877). ✓
- `wireframes.mdx`: dot-path namespace `VeltCommentDialogWireframe.AgentSuggestion.Banner[.*]` present for all 8 primitives; custom element `-wireframe` suffixes correct. ✓
- No divergence in React names, custom element names, or wireframe namespace.

**Component names:**
- `VeltNotificationsPanel` and `VeltNotificationsTool` used correctly throughout notifications files. ✓
- `CrossOrganizationConfig` type referenced with correct casing in all three files (`api-methods.mdx`, `data-models.mdx`, `customize-behavior.mdx`). ✓

**Docs validation:**
- No build/link-check scripts found in `package.json` (empty scripts object). No tooling to run.

### Summary
- Files corrected: 1 (`api-reference/sdk/api/api-methods.mdx`)
- Critical issues: 0
- Broken links fixed: 1 (stray "the" in anchor slug)
- Terminology alignments: 0 (all clean)
- Banner parity: confirmed across all 3 files, all 8 primitives
