# Release Update Plan for v5.0.1-beta.4

## Overview
- Release Type: Minor (new opt-in feature)
- Key Changes: Notification delay + batching pipeline; two new org-scoped config types (`DelayConfig`, `BatchConfig`) placed under `notificationServiceConfig` in workspace settings
- Breaking Changes: No

---

## Areas Requiring Updates

### 1. Data Models
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes:
  - Add `#### NotificationServiceConfig` after the existing `#### NotificationSettingsLayout` block (line 2556). Contains two optional fields: `delayConfig: DelayConfig` and `batchConfig: BatchConfig`.
  - Add `#### DelayConfig` directly after: two fields — `isEnabled: boolean` (No, default false), `delaySeconds: number` (No).
  - Add `#### BatchConfig` directly after: two fields — `document: BatchWindowConfig` (No) and `user: BatchWindowConfig` (No).
  - Add `#### BatchWindowConfig` directly after: three fields — `isEnabled: boolean` (No), `batchWindowSeconds: number` (No), `maxActivities: number` (No).
- Priority: High

### 2. Documentation
- File: `/Users/yoenzhang/Downloads/docs/async-collaboration/notifications/customize-behavior.mdx`
- Changes:
  - Add new section `#### configureDelayAndBatching` at end of page (after `#### getSettings`). Include: description of the delay-then-batch chain, note that webhooks/workflow triggers are unaffected, params referencing `NotificationServiceConfig`, and JSON config example matching the release note snippet.
  - The section must use a `<Tabs>` block with `React / Next.js` first and `Other Frameworks` second, both showing how to pass `notificationServiceConfig` in workspace settings (console-only config — note it is set in the Velt Console, not via SDK methods).
- Priority: High

---

## Areas Confirmed NOT Requiring Updates

- **api-methods.mdx** — no new SDK methods or changed signatures; `notificationServiceConfig` is a workspace-level console setting, not a client API call.
- **UI Customization docs** — no new wireframes or component primitives.
- **Migration Guide** — no breaking changes.
- **REST API docs** — no new REST endpoints introduced.

---

## Implementation Sequence

1. Update `data-models.mdx`: add `NotificationServiceConfig`, `DelayConfig`, `BatchConfig`, `BatchWindowConfig` types after the `NotificationSettingsLayout` block. (High effort)
2. Update `customize-behavior.mdx`: add `configureDelayAndBatching` section with description, chain behavior note, webhook exclusion note, and JSON config example. (Medium effort)

---

## Quality Checklist
- [ ] `NotificationServiceConfig` type added to `data-models.mdx` with links to `DelayConfig` and `BatchConfig`
- [ ] `DelayConfig` type added to `data-models.mdx` (`isEnabled`, `delaySeconds`)
- [ ] `BatchConfig` type added to `data-models.mdx` (`document`, `user` referencing `BatchWindowConfig`)
- [ ] `BatchWindowConfig` type added to `data-models.mdx` (`isEnabled`, `batchWindowSeconds`, `maxActivities`)
- [ ] `configureDelayAndBatching` section added to `customize-behavior.mdx`
- [ ] Section notes that webhooks and workflow triggers always fire immediately
- [ ] Section notes the chain order: delay → seen check → batch → deliver
- [ ] JSON example in `customize-behavior.mdx` matches the release note schema
- [ ] Code examples include React / Next.js tab first, Other Frameworks tab second
- [ ] `data-models.mdx` links use anchor pattern `/api-reference/sdk/models/data-models#<anchor>`
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.1-beta.4.md`
