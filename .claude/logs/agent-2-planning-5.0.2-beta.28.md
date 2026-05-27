# Release Update Plan for v5.0.2-beta.28

## Overview
- Release Type: Patch
- Key Changes: Shadow DOM compatibility fix for comment-pin selection and click-outside detection inside Web Component / shadow root hosts (e.g. Apryse WebViewer).
- Breaking Changes: No

## Areas Requiring Updates

None. This is a pure bug-fix release with no customer-facing API, type, or behavior changes.

- No new types, interfaces, or enums → data-models.mdx: no update needed
- No new or changed customer API methods/hooks → api-methods.mdx: no update needed
- No new feature without existing docs → no new documentation pages needed
- No new wireframes → comment-dialog-components.mdx: no update needed
- No new primitive components or props → primitives overview: no update needed
- No breaking changes → upgrade-guide.mdx: no update needed

The three new helpers (isSnippylyEventTarget, resolveDomScope, findVeltCommentTextPinHost) are internal-only and explicitly excluded from the documented customer surface.

## Implementation Sequence

No downstream agent tasks required. Changelog entry written by Agent-1 is sufficient.

## Downstream Agent Instructions

- Agent-3: No action required
- Agent-4: No action required
- Agent-5: No action required
- Agent-6: No action required
- Agent-7: No action required

## Quality Checklist
- [x] Release note analyzed
- [x] Confirmed no new customer-facing types, APIs, wireframes, primitives, or breaking changes
- [x] No documentation updates fabricated
- [x] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.28.md`
