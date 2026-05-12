## QA Summary for v5.0.2-beta.13

### Issues Found: 2

1. **release-notes/version-5/sdk-changelog.mdx** (line 102) — `### Breaking Changes` section heading present in changelog. Per pipeline conventions, breaking changes exist only in upgrade-guide.mdx; the changelog must not have a Breaking Changes section.
   - Fix: Renamed `### Breaking Changes` to `### Removals` so the entry stays in the 5.0.2-beta.13 Update block without violating the convention.

2. **api-reference/sdk/api/api-methods.mdx** (line 2281) and **ai-copilot/design/setup.mdx** (line 128) — Both link to `#rewriteraskairquest` (missing the final `e`). The actual anchor generated from `#### RewriterAskAiRequest` in data-models.mdx is `#rewriteraskairequest`.
   - Fix: Corrected both links to `#rewriteraskairequest`.

### Terminology Scan Results (No Issues Found)

All key terms verified clean across the repo:
- `addUser()` / `removeUser()` — correct in all files; no `addPresenceUser` / `removePresenceUser` variants found
- `localOnly` — correct; no `local_only` or `isLocalOnly` variants found
- `PresenceUser` — consistent across data-models.mdx, api-methods.mdx, customize-behavior.mdx
- `on('textSelected')` — consistent; no `text-selected` or `onTextSelected` variants found
- `askAi()` — consistent; no `askAI` or `ask_ai` variants found
- `replaceText()` / `addComment()` — consistent; no snake_case variants found
- `TextSelectedEvent`, `RewriterAskAiRequest`, `RewriterAskAiResponse` — defined in data-models.mdx; linked correctly after fix
- `VeltCommentsSidebarV2` / `velt-comments-sidebar-v2` — consistent in changelog, upgrade-guide, and comments-sidebar/overview.mdx
- `version` prop — described as "removed" (not "deprecated") in all three locations
- `VeltCommentBubbleAvatar`, `VeltCommentBubbleCommentsCount`, `VeltCommentBubbleUnreadIcon` — React components documented with import statements in comment-dialog-primitives/overview.mdx; no remaining "HTML-only" limitation notes
- `defaultCondition` / `default-condition` — consistent; camelCase in React, kebab-case in HTML as expected

### Summary
- Files corrected: 3
- Critical issues: 1 (broken anchor in two files)
- Convention violations fixed: 1 (Breaking Changes section in changelog)
- Terminology inconsistencies: 0
