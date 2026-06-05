# Doc Gap Review — Approval Engine & Memory

Rule applied: only fix gaps that can be closed by wiring/precision using content that
already exists in the repo or the pasted release notes. Anything requiring information not
present in the pasted docs is left as an open issue (no fabrication).

## Fixed (wiring only — no new content invented)
1. **Changelog → inbound webhook link precision.** beta.31 inbound-webhook bullet now points
   to the exact section `/ai/approval-engine/overview#inbound-webhook-handler` (was the bare
   page).
2. **Changelog → storeDbId link.** beta.31 `storeDbId` improvement bullet now links to
   `/ai/approval-engine/overview#scope`, where the storeDbId tenant-partition Note lives.
3. **Overview discoverability.** `overview.mdx` "Get started" now includes a Developer Guide
   card (CardGroup `cols={3}`: Setup · Developer Guide · Customize Behavior).

Files touched: `release-notes/version-5/sdk-changelog.mdx`, `ai/approval-engine/overview.mdx`.

## Open issues (missing source material — nothing pasted bridges the gap)
Approval Engine:
- Inbound webhook has no URL, request/response/body schema, bearer-token source, callback-
  verification recipe, concrete rate-limit/body-size numbers, or api-reference page. The
  pasted notes describe it only in the same prose already in `overview.mdx`.
- `webhook` node (deferred): runtime behavior if one is shipped is unspecified.
- `__mock__`: no allowed-config/output detail beyond the inline mention (acceptable; link
  resolves).

Memory (entire area is under-documented in the source material):
- No api-reference pages for ~15 of 16 endpoints (`ingest`, `ingest-status`, `rules`,
  `list`, `upload-url`, `update`, `download`, `delete`, `ask`, `search`, `suggest`,
  `judgments/query`, `profiles/get`, `patterns/get`, `stats/get`, `alerts/*`).
- Old-SDK enrichment + migration (`migrateOldSdk`/`backfillJudgments`): no doc, no link.
- Judgment object: which activity creates one, and its fields, unspecified.
- No Memory overview/setup page.
- Embedding type (`review` vs `content`) never shown on an endpoint.
- Changelog: 6 of 7 Memory bullets have no link because no target page exists.
