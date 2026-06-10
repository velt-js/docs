# Doc Gap Review: Approval Engine & Memory (v5.0.2-beta.31)

Rule applied: only close gaps using content that exists in the repo, the release notes,
or the internal developer guides supplied by the team. No fabrication.

## Fixed
1. **Changelog → inbound webhook link precision.** beta.31 inbound-webhook bullet points to
   `/ai/approval-engine/overview#inbound-webhook-handler`.
2. **Changelog → storeDbId link.** beta.31 `storeDbId` bullet links to
   `/ai/approval-engine/overview#scope`.
3. **Overview discoverability.** `ai/approval-engine/overview.mdx` "Get started" includes a
   Developer Guide card (CardGroup cols={3}).
4. **Memory overview page created** (`ai/memory/overview.mdx`) from the internal Memory
   developer guide: concepts, how-it-works pipeline, data provenance, limitations. Added to
   docs.json before the developer guide. Closes the "No Memory overview/setup page" gap.
5. **Changelog Memory bullets now link** to the new overview / developer guide where no
   REST page exists yet.
6. **beta.31 entry repositioned** chronologically (between beta.32 and beta.30) after the
   main merge had stranded it next to beta.22.
7. **House style pass** across all beta.31 pages: em-dashes removed, second person,
   internal terminology dropped (Cloud Function/onCall/onRequest, Firestore collection
   names), and backend-only changelog bullets removed per changelog rules (Stripe billing
   fan-out, FieldValue sentinel handling, log-level changes, Firestore path normalization).

## Open issues (missing source material)
Approval Engine:
- Inbound webhook has no URL, request/response schema, bearer-token source, callback
  verification recipe, concrete rate-limit/body-size numbers, or api-reference page.
- `webhook` node (deferred): runtime behavior if shipped is unspecified.

Memory:
- No api-reference pages for ~15 of 16 endpoints (`ingest`, `ingest-status`, `rules`,
  `list`, `upload-url`, `update`, `download`, `delete`, `ask`, `search`, `suggest`,
  `judgments/query`, `profiles/get`, `patterns/get`, `stats/get`, `alerts/*`).
- Old-SDK enrichment + migration (`migrateOldSdk`/`backfillJudgments`): no endpoint doc.
- Judgment object: exact field list unspecified in public docs.
- Embedding type (`review` vs `content`) never shown on an endpoint example.
