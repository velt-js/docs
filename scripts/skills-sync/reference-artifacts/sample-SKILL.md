# Sample SKILL.md — `velt-comments-best-practices`

> **Status:** Verbatim copy from `agent-skills/skills/velt-comments-best-practices/SKILL.md` (Phase 1 verification). Use as a pattern reference — do not edit.

---

```markdown
---
name: velt-comments-best-practices
description: Velt Comments implementation patterns and best practices for React, Next.js, and web applications. Use when adding collaborative commenting features, comment modes (Freestyle, Popover, Stream, Text, Page), rich text editor comments (TipTap, SlateJS, Lexical), media player comments, or chart comments.
license: MIT
metadata:
  author: velt
  version: "1.0.0"
---

# Velt Comments Best Practices

Comprehensive implementation guide for Velt's collaborative comments feature in React and Next.js applications. Contains 71 rules across 12 categories, prioritized by impact to guide automated code generation and integration patterns.

## When to Apply

Reference these guidelines when:
- Adding collaborative commenting to a React/Next.js application
- Implementing any Velt comment mode (Freestyle, Popover, Stream, Text, Page, Inline)
- Integrating comments with rich text editors (TipTap, SlateJS, Lexical)
- Adding comments to media players (Video, Lottie animations)
- Adding comments to charts (Highcharts, ChartJS, Nivo)
- Building custom comment interfaces with standalone components

## Rule Categories by Priority

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 1 | Core Setup | CRITICAL | `core-` |
| 2 | Comment Modes | HIGH | `mode-` |
| 3 | Standalone Components | MEDIUM-HIGH | `standalone-` |
| 4 | Comment Surfaces | MEDIUM-HIGH | `surface-` |
| 5 | UI Customization | MEDIUM | `ui-` |
| 6 | Data Model | MEDIUM | `data-` |
| 7 | Debugging & Testing | LOW-MEDIUM | `debug-` |
| 8 | Moderation & Permissions | LOW | `permissions-` |
| 9 | Attachments & Reactions | MEDIUM | `attach-` |

## Quick Reference

### 1. Core Setup (CRITICAL)

- `core-provider-setup` - Initialize VeltProvider with API key
- `core-authentication` - Authenticate users before using comments
- `core-document-setup` - Configure document context for comments

[... additional categories elided for brevity in this reference doc; the full file
in the actual skill repo includes every rule listed under every category ...]

## How to Use

Read individual rule files for detailed explanations and code examples:

```
rules/shared/core/core-provider-setup.md
rules/shared/mode/mode-popover.md
```

Each rule file contains:
- Brief explanation of why it matters
- Incorrect code example with explanation
- Correct code example with explanation
- Source pointers to official documentation

## Compiled Documents

- `AGENTS.md` — Compressed index of all rules with file paths (start here)
- `AGENTS.full.md` — Full verbose guide with all rules expanded inline
```
