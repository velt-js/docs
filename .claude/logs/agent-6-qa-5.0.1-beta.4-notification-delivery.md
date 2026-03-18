## QA Summary for v5.0.1-beta.4 — Notification Delay & Batching Pipeline

### Issues Found: 2

1. **release-notes/version-4/sdk-changelog.mdx** — `Update` label used `"v5.0.1-beta.4"` (with `v` prefix), inconsistent with every other label in this file (`4.7.13`, `4.7.12`, etc.) and with the v5 changelog label `"5.0.1-beta.4"`.
   - Fix: Changed `label="v5.0.1-beta.4"` to `label="5.0.1-beta.4"`.

2. **release-notes/version-5/sdk-changelog.mdx** and **release-notes/version-4/sdk-changelog.mdx** — Webhook exclusion phrasing differed from the canonical warning in `customize-behavior.mdx`. Changelogs said "are unaffected by delay or batch settings"; feature doc said "are never subject to delay or batching."
   - Fix: Aligned both changelogs to use "are never subject to delay or batching" — matching the `<Warning>` in `customize-behavior.mdx`.

### Verified Clean (no changes needed)

- **api-reference/sdk/models/data-models.mdx** — `NotificationServiceConfig`, `DelayConfig`, `BatchConfig`, `BatchWindowConfig` all present with correct property tables and anchor IDs matching all cross-references.
- **async-collaboration/notifications/customize-behavior.mdx** — `notificationServiceConfig` section present; delivery pipeline steps (`delay → seen check → batch → deliver`) documented correctly; type reference links (`#notificationserviceconfig`, `#delayconfig`, `#batchconfig`, `#batchwindowconfig`) verified.
- **async-collaboration/notifications/setup.mdx** — Optional step 5 present; `notificationServiceConfig` link points to correct anchor in `customize-behavior.mdx`.
- **Internal terms** — Scanned all `.mdx` files for `pendingDelayedNotifications`, `pendingDocBatches`, `pendingUserBatches`, `processdelayednotification`, `flushdocbatch`, `flushuserbatch`. Zero occurrences found — none exposed in user-facing docs.
- **All anchor links** — `#notificationserviceconfig`, `#delayconfig`, `#batchconfig`, `#batchwindowconfig` all resolve correctly to `data-models.mdx` headings.

### Summary

- Files corrected: 2
- Critical issues: 0
- Terminology alignments: 2 (webhook phrasing, label prefix)
- Internal terms leaked: 0
