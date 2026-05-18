# Release Update Plan for @veltdev/node v1.0.1

## Overview
- Release Type: Minor (first public release of a new package)
- Key Changes: New Node.js backend SDK achieving feature parity with Python SDK (velt-py)
- Breaking Changes: No

## Areas Requiring Updates

### 1. Agent Skills Page (MUST)
- File: `get-started/skills.mdx`
- Changes:
  - Line 94: `velt-self-hosting-data-best-practices` card mentions "Python SDK (velt-py)" only — add Node SDK reference.
  - Line 173 table: skill-selection row for REST API / backend — add note that `@veltdev/node` is available for TypeScript-native backend integration.
- Priority: Medium

### 2. Python SDK Page (SHOULD — verification only)
- File: `backend-sdks/python.mdx`
- Changes: Confirm cross-link to `backend-sdks/node` is present as sibling alternative. No content changes expected.
- Priority: Low

### 3. MCP Page (SHOULD — conditional)
- File: `mcp/mcp.mdx`
- Changes: Line 200 Python code block — if it is an SDK-level example (not a generic snippet), add Node SDK alternative note.
- Priority: Low

## Out of Scope
- `self-host-data/*.mdx` — no Python/Node SDK references
- `key-concepts/overview.mdx` — Python blocks are generic server endpoint examples
- `get-started/advanced.mdx` — Python block is a server endpoint snippet, not SDK docs
- All `ui-customization/`, `api-reference/`, data-models, api-methods — backend SDK, no frontend changes
- Upgrade guide — no breaking changes

## Implementation Sequence
1. Edit `get-started/skills.mdx` — 2 targeted string edits (card description + table row)
2. Read `mcp/mcp.mdx` line 200 context — update only if SDK-level example
3. Read `backend-sdks/python.mdx` — verify Node cross-link exists

## Quality Checklist
- [ ] `get-started/skills.mdx` updated to mention `@veltdev/node` alongside `velt-py`
- [ ] No frontend API docs modified
- [ ] No wireframe or primitive docs modified
- [ ] No upgrade guide created (not a breaking change)
- [ ] Log file written to `.claude/logs/agent-2-planning-node-v1.0.1.md`
