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

## Fixed in the consolidation + REST build-out pass
8. **Pages consolidated to sitewide convention.** Developer guides merged into Setup:
   approval-engine is now overview/setup/customize-behavior; memory is overview/setup.
   All links, cards, changelog bullets, and docs.json updated; no redirects needed
   (the developer-guide URLs never shipped).
9. **Memory REST reference built out** from the internal memory-api-reference: 20 new
   pages (search, judgments/query, ask, suggest; knowledge upload-url/ingest/
   ingest-status/list/rules/download/update/delete; profiles/patterns/stats;
   alerts list/dismiss/action/config get+update). docs.json Memory group now has
   Search & Q&A / Knowledge / Insights / Alerts subgroups. Memory setup links to them.
10. **Approval Engine REST coverage audited**: all 14 public endpoints in the internal
   api-reference have existing pages (definitions 5, executions 5, steps 4).
11. **Beta labels** added: "Memory (Beta)" page title, and "(Beta)" on the
   Approval Engine and Memory sidebar groups (AE overview title already had it).
12. **embeddingType** is now documented on the Search Judgments REST page.

## Open issues (missing source material)
Approval Engine:
- Inbound webhook surfaces (`/v1/workflow/webhook-inbound/trigger` and `/callback`,
  `triggers[].inboundWebhook`, definition-level `webhookConfig`) are described in the
  internal api-reference without response schemas; no public REST pages yet.
- `webhook` node (deferred): runtime behavior if shipped is unspecified.
- Field-level drift audit of the 14 existing AE REST pages against the internal
  api-reference has not been done (endpoint coverage confirmed only).

Memory:
- Old-SDK enrichment + migration (`migrateOldSdk`/`backfillJudgments`): internal-only,
  intentionally undocumented.
- Judgment object: exact field list documented only via REST response examples.
