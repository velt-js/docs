# Doc Gap Review: Approval Engine & Memory (v5.0.2-beta.31)

Rule applied: only close gaps using content that exists in the repo, the release notes,
or the internal developer guides / API references supplied by the team. No fabrication.

## Fixed
1. Changelog beta.31 bullets link to precise targets (inbound webhook anchor, storeDbId
   scope anchor, Memory overview/setup, knowledge/search REST page).
2. Memory overview page created (ai/memory/overview.mdx) from the internal guide.
3. Pages consolidated to the sitewide pattern: approval-engine/{overview,setup,
   customize-behavior} (developer guide merged into setup) and memory/{overview,setup}.
4. House style pass across all beta.31 pages (no em-dashes, second person, no internal
   terminology, backend-only changelog bullets removed).
5. beta.31 changelog entry repositioned chronologically.
6. Memory REST API reference built out from the internal memory-api-reference: 20 new
   pages (search, judgments/query, ask, suggest; knowledge upload-url/ingest/
   ingest-status/list/rules/download/update/delete; profiles/patterns/stats;
   alerts list/dismiss/action/config-get/config-update). All 21 public Memory endpoints
   are now documented. docs.json Memory REST group nests Search & Q&A / Knowledge /
   Insights / Alerts.
7. Approval Engine REST coverage audited against the internal api reference: all 14
   public endpoints have pages.
8. Beta labels: "(Beta)" on Approval Engine + Memory page titles and Documentation-tab
   group labels.

## Open issues (missing source material)
Approval Engine:
- Inbound webhook surfaces (/v1/workflow/webhook-inbound/trigger and /callback) are
  described in the internal reference without response schemas or full field tables;
  no REST pages created to avoid fabrication.
- definition-level webhookConfig inheritance and triggers[].inboundWebhook declaration
  are not yet documented field-level in create-definition/update-definition pages.
- webhook node (mode sync/async) runtime details documented internally; public docs
  mark the node type deferred in v1.

Memory:
- Old-SDK enrichment + migration (migrateOldSdk/backfillJudgments): internal-only,
  intentionally undocumented.
- Judgment object public field list lives in the REST page response examples; no
  standalone data-model entry yet.
