# Release Update Plan for v6.0.0-beta.1 — Memory Knowledge Search (`includeRules`)

## Overview
- Release Type: Minor (additive, backend-only REST feature; folded into v6.0.0-beta.1 changelog).
- Key Changes: `POST /v2/memory/knowledge/search` gains optional `includeRules` boolean. `true` → combined chunk + extracted-rule vector search, merged into one ranked list; each item tagged `kind` (`"chunk"`|`"rule"`); rule hits add `ruleId` and optional `category`. New exported TS type `KnowledgeRuleHit`.
- Breaking Changes: None. With `includeRules` omitted/false the response is byte-identical to the prior contract. No migration required. Do NOT add anything to any upgrade guide.
- SDK: `shared-firebase-function` (Velt Memory REST API). No frontend Velt SDK surface, no UI components.

## Source of truth
- Raw note: `/Users/yoenzhang/Downloads/docs/.claude/release-notes/input-v6.0.0-beta.1-memory-knowledge-search-2026-06-23.mdx`
- Changelog (already updated by Agent-1, 3 bullets): `/Users/yoenzhang/Downloads/docs/release-notes/version-6/sdk-changelog.mdx` lines 22, 24, 26.

## Areas Requiring Updates

### 1. REST Endpoint Page — PRIMARY (and only required doc edit)
- File: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/memory/knowledge/search.mdx`
- Priority: High
- This page documents types INLINE on the endpoint page (no `<ResponseField>` components are used here; response shape is conveyed via prose + JSON code blocks). Agent-3 MUST match the existing conventions below, not introduce new component styles.

**Existing conventions to preserve (do not change):**
- Frontmatter: `title: "Search Knowledge Base"`, `api: "POST https://api.velt.dev/v2/memory/knowledge/search"`.
- Section order: intro prose → `# Endpoint` → `# Headers` (two `<ParamField header=...>`) → `# Body` → `#### Params` → `# Response` → `#### Success Response` → `#### Failure Response` → `<ResponseExample>`.
- Body params live inside a single `<ParamField body="data" type="object" required>` wrapping an `<Expandable title="properties">` with nested `<ParamField body=...>` children.
- Example requests are bare ` ```JSON ` blocks under `## **Example Requests**` with `#### ` sub-headings.
- Response shape is described in prose, then shown as ` ```JSON ` (Success/Failure) and duplicated in `<ResponseExample>` ` ```js `.

**Exact edits for Agent-3:**

a) Add a new body param `includeRules` inside the `<Expandable>` properties (place it after `limit`, before the `<Note>`):
```
<ParamField body="includeRules" type="boolean" default="false">
  When `true`, also vector-searches the extracted-rules corpus and merges those hits with the knowledge-chunk hits into one relevance-ranked list. When omitted or `false`, only knowledge chunks are searched and the response shape is unchanged. Must be a boolean; non-boolean values (e.g. the string `"true"` or `1`) are rejected with a `400`.
</ParamField>
```

b) Update the `limit` param description to add combined-cap semantics (keep it short):
- Current: "Maximum number of results to return."
- New: "Maximum number of results to return (1–50). When `includeRules` is `true`, this is the combined cap across both corpora (global top-N after the merge), not a per-corpus quota."
- NOTE (flag for human): the current `limit` description does not state the 1–50 bound; the raw note and the sibling `search.mdx` (judgments) both state 1–50. Adding "(1–50)" is consistent with the note; confirm there is no separate default value to document (sibling judgments `search` defaults to 10 — the note does not state a default for knowledge/search, so do NOT invent one).

c) Update the `sourceId` param description to add the both-corpora behavior. Append one sentence:
- Append: "When `includeRules` is `true`, `sourceId` narrows both corpora simultaneously (single id restricts both searches; an array fans out one query per id per corpus, then merges)."

d) Add a combined-search example under `## **Example Requests**` (new `#### Search chunks and extracted rules together` block):
```JSON
{
  "data": {
    "query": "image format requirements",
    "includeRules": true,
    "limit": 5
  }
}
```

e) Update the `# Response` prose + add a combined-response code block. Keep the existing chunk-only Success Response as the default shape. Add after it a note + example for `includeRules: true`:
- Prose to add: "When `includeRules` is `true`, every item gains a `kind` field (`\"chunk\"` or `\"rule\"`). `kind: \"rule\"` items also include a `ruleId` and an optional `category`. `kind: \"chunk\"` items carry no extra fields. Items are sorted ascending by `score` (cosine distance, lower = more relevant); on embedding failure both corpora fall back to most-recently-ingested items, which have no `score` and sort last. `recordsSearched` equals the number of items returned after merge + truncation to `limit`."
- Combined-response JSON to add (label e.g. `#### Success Response (includeRules: true)`):
```JSON
{
  "result": {
    "results": [
      {
        "kind": "rule",
        "ruleId": "rule_3f2...",
        "sourceId": "src_checklist",
        "text": "All images must be WEBP, max width 1200px",
        "score": 0.09,
        "category": "§Navigation Bar"
      },
      {
        "kind": "chunk",
        "sourceId": "src_brief",
        "text": "Our target audience is enterprise buyers...",
        "score": 0.21
      }
    ],
    "recordsSearched": 2
  }
}
```

f) Cross-reference to the rules endpoint: add to the intro or response prose a link to `[List Extracted Rules](/api-reference/rest-apis/v2/memory/knowledge/rules)` so readers know where the rule corpus comes from (mirrors how `search.mdx` cross-links to `knowledge/search`). The `ruleId` returned here corresponds to the `id` field on the rules endpoint — state this relationship in one clause.

**Decisions / omissions for the endpoint page:**
- Tenant safety (`metadata.apiKey` clause before `findNearest`): OMIT from public docs. It is an internal implementation invariant, not caller-facing. The existing page already covers the caller-facing tenant guarantee ("An unknown or cross-workspace `sourceId` returns empty results … never a cross-tenant read") in the `<Note>` — no change needed there.
- Merge contract INV-022 (embed once, concat, sort, dedup by `(kind, id)`, truncate): do NOT document the invariant id or internal steps. The caller-facing outcomes (single embed/lower latency, sorted-by-score, truncated-to-limit) are covered by the prose in (e). The dedup `(kind, id)` rule is internal — omit.
- Degraded-mode/recency: document ONLY the caller-facing outcome (no-score items sort last on embedding failure), already folded into (e). Do not describe the failure mechanism.

### 2. Types / Data Models — document INLINE on the endpoint page; do NOT touch frontend `data-models.mdx`
- Decision: per project memory (`project_backend_sdk_type_doc_conventions.md`), backend/REST types are documented on their endpoint/Node pages, NOT in the frontend SDK `data-models.mdx`. There is also no REST-specific data-models page for memory (the memory dir has no types/models page; types are conveyed inline as JSON shapes on each endpoint).
- `KnowledgeSearchResult` / `KnowledgeSearchResponse`: already represented inline as the JSON response shape on `search.mdx`. The new optional `kind`/`ruleId`/`category` fields are covered by edit (e) above. No separate type page needed.
- `KnowledgeRuleHit`: this is an INTERNAL exported TS interface for consumers calling the internal `getKnowledgeRules` helper. It is not part of the public REST contract surfaced to API callers. Recommendation: do NOT add `KnowledgeRuleHit` to any public docs page — its fields (`ruleId`, `sourceId?`, `text`, `score?`, `category?`) are already reflected in the rule-hit JSON shape on `search.mdx`. Flag for human: confirm there is no Node SDK reference page for Memory that documents internal helpers (none found under `api-reference/`); if one is later added, that is where `KnowledgeRuleHit` would belong — not `data-models.mdx`.
- Priority: N/A (no new type page).

### 3. Conceptual Docs — `ai/memory/setup.mdx` cross-reference (OPTIONAL, Low)
- File: `/Users/yoenzhang/Downloads/docs/ai/memory/setup.mdx`
- Context: lines 104–114 contain a "Search inside your knowledge base" block with a `/knowledge/search` curl example and a sentence about `sourceId`/`score`. It does not mention `includeRules`.
- Recommended (Low priority, optional): append one sentence after line 114 noting the combined search, e.g.: "Pass `includeRules: true` to also return extracted rules alongside chunks in a single ranked list — see [Search Knowledge Base](/api-reference/rest-apis/v2/memory/knowledge/search)." Do NOT add a full second curl example here; keep setup concise. The page already links to Search Knowledge Base, so this is an enhancement, not a correctness fix.
- Flag for human: decide whether `setup.mdx` should advertise `includeRules` at all, or stay minimal and defer entirely to the endpoint page. Default recommendation: add the single sentence; skip if the human prefers setup stay lean.
- `ai/memory/overview.mdx`: checked — no `knowledge/search` reference; no change.

### 4. docs.json Navigation — NO CHANGE (verify only)
- File: `/Users/yoenzhang/Downloads/docs/docs.json`
- Finding: the string `memory` does NOT appear anywhere in `docs.json`. The entire `api-reference/rest-apis/v2/memory/**` tree (including `knowledge/search`) is NOT registered in the published navigation. These pages are reachable only via direct in-page links (e.g. the changelog `[Learn more →]` links and the cross-refs in `setup.mdx`/`search.mdx`), which resolve by file path regardless of nav membership.
- Action: none. We are editing an existing page, not adding one, so no nav entry is required. Do NOT add the memory pages to nav as part of this release (out of scope; would be a separate editorial decision).
- Flag for human: the memory REST endpoints being absent from nav is pre-existing and may be intentional (beta/unlisted). Surface it but do not fix it here.

### 4a. UI Customization — Wireframes — NO-OP
- Agent-4: nothing to do. Backend-only REST feature; no Velt UI components, no wireframes. Confirmed no component/primitive names in the release note.

### 4b. UI Customization — Primitives — NO-OP
- Agent-5: nothing to do. No new primitive components or props. No `Velt*` components involved.

### 5. Upgrade Guide — NO-OP
- No breaking changes. Nothing for any `upgrade-guide.mdx`. Breaking-change rule N/A.

## Implementation Sequence
1. Agent-3: edit `knowledge/search.mdx` per section 1 (a–f). Single file, ~Medium effort. This is the only required change.
2. Agent-3 (optional, Low): add the one-sentence cross-ref in `ai/memory/setup.mdx` per section 3, if human approves.
3. Agent-4: no-op (wireframes). Skip.
4. Agent-5: no-op (primitives). Skip.
5. Agent-6 (alignment): scan repo for consistent naming of `includeRules`, `kind`, `ruleId`, `category`, "extracted rules", "knowledge chunks" / "knowledge base", "recordsSearched". Ensure `kind` values are quoted as `"chunk"`/`"rule"`. Verify the new `search.mdx` content matches the 3 changelog bullets (lines 22/24/26) and the raw note. Low effort.
6. Agent-7 (QA terminology): verify no stray variants (e.g. `include_rules`, `includeRule`, `ruleID`, `rule_id`, "custom_context" leaking into public prose — it should NOT appear; public docs say "extracted rules"). Confirm all `[Learn more →]` / cross-ref links resolve to `/api-reference/rest-apis/v2/memory/knowledge/search` and `/api-reference/rest-apis/v2/memory/knowledge/rules`. No repo-wide rename needed (no terminology changed; this is purely additive).

## Quality Checklist
- [ ] `includeRules` body param added to `search.mdx` (type boolean, default false, 400-on-non-boolean noted).
- [ ] `limit` updated to combined-cap-when-true semantics (and 1–50 confirmed with human re: default).
- [ ] `sourceId` updated to both-corpora-when-true semantics.
- [ ] Combined request example added; combined response example with `kind`/`ruleId`/`category` added.
- [ ] Response prose explains `kind`, rule-only `ruleId`/`category`, score sort + no-score recency items last, `recordsSearched`.
- [ ] Cross-link to `knowledge/rules` added; `ruleId` ↔ rules `id` relationship stated.
- [ ] Tenant-safety / INV-022 / dedup internals OMITTED from public docs (confirmed).
- [ ] No edits to frontend `data-models.mdx`; `KnowledgeRuleHit` kept out of public docs (internal type).
- [ ] No `upgrade-guide` edits (no breaking changes).
- [ ] No `docs.json` nav changes (memory tree not in nav; verified).
- [ ] Agent-4 / Agent-5 confirmed no-op.
- [ ] Existing `<ParamField>` / `<Expandable>` / `<ResponseExample>` conventions matched; no new component styles introduced.
- [ ] Plan written to `/Users/yoenzhang/Downloads/docs/.claude/release-notes/plan-v6.0.0-beta.1-memory-knowledge-search-2026-06-23.md`.

## Open questions flagged for the human
1. `limit` default for knowledge/search: not stated in the note (judgments `search` defaults to 10). Do not invent one — confirm if a default should be documented.
2. `setup.mdx`: add the optional one-sentence `includeRules` cross-ref, or leave setup lean?
3. Memory REST endpoints are entirely absent from `docs.json` nav (pre-existing). Intentional (unlisted/beta), or should they be added separately (out of scope for this release)?
