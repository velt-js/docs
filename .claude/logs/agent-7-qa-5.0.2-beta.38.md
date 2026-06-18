## QA Summary for v5.0.2-beta.38

Final terminology/anchor/naming sweep for the Comment Sidebar V2 release (declarative filter/sort/group/search, primitive+wireframe decomposition, plural/singular rename, MinimalActionsDropdown removal). No git used.

### Issues Found & Fixed: 1 file

1. **async-collaboration/comments-sidebar/customize-behavior.mdx** (React/Next.js tab, ~L1458–1468) — JSX used kebab-case prop NAMES, which is invalid in React.
   - Fix: renamed 8 props to camelCase, values unchanged:
     `mini-filters`→`miniFilters`, `minimal-filters`→`minimalFilters`, `filter-operator`→`filterOperator`, `sort-by`→`sortBy`, `sort-order`→`sortOrder`, `group-config`→`groupConfig`, `search-placeholder`→`searchPlaceholder`, `full-screen`→`fullScreen`.

### Sweep (same error class, other 3 release files): no further fixes
- **comment-sidebar-v2-wireframes.mdx**, **comment-sidebar-structure-v2.mdx**: zero kebab attrs on JSX components.
- **comment-sidebar-v2-primitives.mdx**: kebab attrs at L55–60 / L168–175 are inside `<Tab title="Other Frameworks">` on lowercase `<velt-comments-sidebar-v2>` elements (correct HTML); matching React tabs already camelCase (`pageMode`, `focusedThreadMode`, `readOnly`, `forceClose`).
- customize-behavior.mdx L1479–1483 kebab attrs are the HTML tab (correct); L226 is prose backticks (correct).

### CHECK 2 — Singular/plural invariant: PASS (no edits)
- No stray PLURAL standalone V2 sub-primitive anywhere. PCRE2 lookahead `VeltCommentsSidebarV2(?!Wireframe|Props|MinimalActionsDropdown)[A-Z]` → none; kebab `velt-comments-sidebar-…-v2` (non-wireframe, non-root) → none.
- Singular standalone primitives present and consistent (`VeltCommentSidebarV2*` / `velt-comment-sidebar-…-v2`, primitives page).
- Wireframe forms remain PLURAL and were NOT over-singularized: no `VeltCommentSidebarV2Wireframe` (singular) and no singular `velt-comment-sidebar-…-v2-wireframe`.

### CHECK 3 — Removed-component scoping: PASS (correctly left untouched)
- `velt-comment-sidebar-minimal-actions-dropdown-v2`, `VeltCommentsSidebarV2MinimalActionsDropdown*`, `VeltCommentsSidebarV2Wireframe.MinimalActionsDropdown` appear ONLY in sdk-changelog.mdx (Breaking Changes bullet) and upgrade-guide.mdx (entry + Before/After). No live references elsewhere.
- Legitimately-separate components left intact: V1 `VeltCommentsSidebarWireframe.MinimalActionsDropdown` / `velt-comments-sidebar-minimal-actions-dropdown-wireframe` (plural `comments`, no `-v2`) in V1 sidebar pages; `VeltMultiThreadCommentDialogMinimalActionsDropdown*` in multithread-comments/*. Not the removed V2 component — untouched.

### CHECK 4 — Anchors / links: PASS
- All beta.38 targets resolve: `#v2-sidebar-behavior` (customize-behavior L1335), `#applycommentsidebarclientfilters` (api-methods L222), `#commentannotation` (data-models L5), `comment-sidebar-v2-primitives` page, `/self-host-data/overview`, `/release-notes/version-5/upgrade-guide`, `#veltcommentssidebarv2props` (data-models L2937).
- api-methods Full-Doc link → `#v2-sidebar-behavior` resolves; its param links `#commentsidebarfilters` (L2727) and `#commentannotation` resolve.
- Zero TODO/placeholder/empty `](`)`/`(#)` links introduced.
- Ellipsis: "Show N replies…" labels (beta.37 content) use real `…` consistently; beta.38 edits added no divider/label strings.

### CHECK 5 — -wireframe suffix forms: PASS
- group-header family correct: `velt-comments-sidebar-list-group-header-v2-<part>-wireframe` (`-v2-` before part); no malformed part-before-v2 typos.
- filter-container family correct: `velt-comments-sidebar-filter-container-v2-<part>-wireframe`; no malformed forms.

### Reported (not edited — intentional per task spec)
- **Changelog has a `### Breaking Changes` section** (sdk-changelog.mdx L46–50). Generic Velt guidance says changelog should have no Breaking Changes section, but Agent-2's plan and this release's REQUIRED CHECK 3 explicitly place the removed-component bullet in the changelog Breaking Changes section AND the upgrade-guide. Left as-is per the per-release instruction (overrides generic guidance). Flagging for Agent-1 awareness.

### Summary
- Files corrected: 1 (customize-behavior.mdx — 8 React prop renames)
- Critical issues: 1 (invalid kebab-case JSX props, now fixed)
- Naming invariant violations: 0
- Dangling anchors/links: 0
- Removed-component leaks: 0
- v5.0.2-beta.38 docs are internally consistent and link-clean. Ready for Agent-1 / next pipeline step.
