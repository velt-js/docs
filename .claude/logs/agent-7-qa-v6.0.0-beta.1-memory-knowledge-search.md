## QA Summary for v6.0.0-beta.1 — Memory knowledge/search `includeRules` (backend REST slice)

### Verdict: PASS — terminology consistent for this release; 0 edits required.

> Note: a separate log `agent-7-qa-v6.0.0-beta.1.md` already exists covering the **frontend Modular SDK** slice of this same beta. This file covers the additive **Memory knowledge/search** slice; both are preserved.

### Edits applied: 0
Independent repo-wide re-verification confirmed Agent-6's alignment is clean. No casing/spelling drift of this release's terms exists in any published page, so no search/replace was performed.

### Terminology sweep (published roots; `.claude/**` is in docs.json `ignore`, so unpublished)
| Term | Status | Notes |
| --- | --- | --- |
| `includeRules` (bool, default `false`) | OK | 12 occurrences, all correct case |
| `include_rules` / `includeRule` / `IncludeRules` | none | zero drift |
| `kind` = `"chunk"` / `"rule"` | OK | values quoted in search.mdx + changelog |
| `ruleId` | OK | no `ruleID` / `rule_id` anywhere |
| `category`, `recordsSearched` | OK | consistent |
| BANNED: custom_context, custom-context, knowledge_chunks, INV-022, (kind, id), getKnowledgeRules, KnowledgeSearchSchema, KnowledgeRuleHit | none in published pages | all confined to internal input artifact under `.claude/` (Mintlify-ignored) |

### Link verification
- `/api-reference/rest-apis/v2/memory/knowledge/search` -> search.mdx EXISTS
- `/api-reference/rest-apis/v2/memory/knowledge/rules` -> rules.mdx EXISTS
- Changelog `[Learn more →]` targets resolve to real pages.
- Consistency: search.mdx says a rule hit's `ruleId` maps to the `id` field on List Extracted Rules; rules.mdx response uses `id`/`category`/`index` — matches.

### MDX well-formedness (edited files)
- search.mdx: ParamField 7/7, Expandable 1/1, Note 1/1, ResponseExample 1/1; 16 fences (even). OK.
- sdk-changelog.mdx: Update 1/1. OK.
- ai/memory/setup.mdx: Note 3/3; 24 fences (even). OK.

### Default contract confirmation
Chunk-only default still documented as unchanged: search.mdx L41 ("response shape is unchanged") and L103 ("byte-identical to the prior contract"). PASS.

### Flags for human (no action taken — per constraints)
1. **Date discrepancy**: changelog `description="June 22, 2026"` vs Memory input artifact dated 2026-06-23. NOT changed per instruction.
2. **`limit` default**: search.mdx documents range 1–50 but no default value. Confirm if a default should be stated.
3. **docs.json nav**: `memory/knowledge/search` and `.../rules` are not listed in docs.json navigation (pre-existing). Not touched per constraint.
4. **Legitimate `metadata.apiKey`**: `self-host-data/field-inventory.mdx:461` pre-existing public-API-key row — left alone as instructed.
5. **Banned identifiers** live solely in `.claude/release-notes/input-v6.0.0-beta.1-memory-knowledge-search-2026-06-23.mdx` (internal input, ignored by Mintlify). No leak.

### Handoff
Documentation consistent for this release. Ready for Plugin Agent 1 (Skills Delta Extractor).
