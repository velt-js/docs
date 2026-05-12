# Release Update Plan for v5.0.2-beta.18

## Overview
- Release Type: Patch (beta)
- Key Changes: Edit draft persistence (session-local, no API surface), `VeltInlineCommentsSection` message truncation props, `RewriterElement.enableDefaultUI()`/`disableDefaultUI()` methods, `RewriterAskAiRequest.model` typed to `AiModel` union
- Breaking Changes: No (open union on `AiModel` — no compile breakage)

---

## Areas Requiring Updates

### 1. Data Models
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes:
  - Update `RewriterAskAiRequest.model` column: change type from `string` to `AiModel` in the table row (line ~5018).
  - Add new `AiModel` union type definition after `RewriterAskAiRequest` section. Include subtypes: `OpenAiModel`, `AnthropicModel`, `GeminiModel`. Each is a string literal union of known model identifiers.
- Priority: High

### 2. API Methods — Rewriter
- File: `/Users/yoenzhang/Downloads/docs/ai/rewriter/customize-behavior.mdx`
- Changes: Add new section `# enableDefaultUI / disableDefaultUI` documenting `rewriterElement.enableDefaultUI()` and `rewriterElement.disableDefaultUI()`. Describe: suppresses the built-in rewriter toolbar while keeping rewriter events active. Include React/Next.js and Other Frameworks tabs with code examples.
- Priority: High

- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Changes: Add `enableDefaultUI()` and `disableDefaultUI()` entries under the Rewriter section (near `getRewriterElement()`). Format: method name, params `void`, returns `void`, React Hook `n/a`.
- Priority: High

### 3. Documentation — Inline Comments Section props
- File: `/Users/yoenzhang/Downloads/docs/async-collaboration/comments/setup/inline-comments.mdx`
- Changes: Add a new step or prop section documenting `messageTruncation` (boolean, default `false`) and `messageTruncationLines` (number, default `4`) props on `VeltInlineCommentsSection`. Include React and Other Frameworks tabs.
- Priority: High

### 4a. UI Customization — Wireframes (Inline Comments Section)
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/inline-comments-section/wireframes.mdx`
- Changes: Add new `ShowMore` and `ShowLess` wireframe sub-components under the `List` section (after line ~500). These appear inside the list item when truncation is active. Follow existing heading convention: `##### **ShowMore (List)**` / `##### **ShowLess (List)**`.
- Priority: High

### 4b. UI Customization — Primitives (Inline Comments Section)
- File: `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/inline-comments-section/primitives.mdx`
- Changes: Add `VeltInlineCommentsSectionShowMore` and `VeltInlineCommentsSectionShowLess` primitive entries with React/Other Frameworks tabs. Describe as toggle controls for truncated message content.
- Priority: High

### 5. Upgrade Guide
- Not applicable — no breaking changes.

---

## Implementation Sequence
1. (Agent-3) Update `data-models.mdx`: change `RewriterAskAiRequest.model` type, add `AiModel`/`OpenAiModel`/`AnthropicModel`/`GeminiModel` type definitions.
2. (Agent-3) Update `api-methods.mdx`: add `enableDefaultUI()` and `disableDefaultUI()` entries under Rewriter.
3. (Agent-3) Update `ai/rewriter/customize-behavior.mdx`: add `enableDefaultUI`/`disableDefaultUI` section with examples.
4. (Agent-3) Update `inline-comments.mdx`: document `messageTruncation` and `messageTruncationLines` props.
5. (Agent-4) Update inline-comments-section `wireframes.mdx`: add `ShowMore` and `ShowLess` wireframe sub-components.
6. (Agent-5) Update inline-comments-section `primitives.mdx`: add `VeltInlineCommentsSectionShowMore` and `VeltInlineCommentsSectionShowLess` primitives.
7. (Agents 6–7) QA: verify type names consistent across data-models, api-methods, and rewriter docs; verify truncation prop defaults match release note.

---

## Quality Checklist
- [ ] `RewriterAskAiRequest.model` updated to `AiModel` in data-models.mdx
- [ ] `AiModel` union type added with `OpenAiModel`, `AnthropicModel`, `GeminiModel` subtypes
- [ ] `enableDefaultUI()` and `disableDefaultUI()` documented in customize-behavior.mdx and api-methods.mdx
- [ ] `messageTruncation` (default: false) and `messageTruncationLines` (default: 4) documented in inline-comments.mdx
- [ ] `ShowMore` / `ShowLess` wireframes added to inline-comments-section/wireframes.mdx
- [ ] `VeltInlineCommentsSectionShowMore` / `VeltInlineCommentsSectionShowLess` added to inline-comments-section/primitives.mdx
- [ ] Code examples include React and Other Frameworks tabs
- [ ] No breaking changes — upgrade guide not modified
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.18.md`
