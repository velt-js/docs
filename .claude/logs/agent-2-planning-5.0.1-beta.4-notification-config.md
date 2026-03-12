# Release Update Plan for v5.0.1-beta.4 (Notification Config Additions)

## Overview
- Release Type: Minor (additive API changes)
- Key Changes: Webhook payloads now include per-user notification config fields; `getConfig` gains `getOrganizationConfig` option; `setConfig` makes `documentIds` optional for org-level config.
- Breaking Changes: No

---

## Areas Requiring Updates

### 1. Data Models
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes:
  - Add `#### UserNotificationsConfig` type under the Webhooks section (after `WebhookV2Payload`). Two optional fields: `usersOrganizationNotificationsConfig: Record<string, NotificationChannelConfig>` and `usersDocumentNotificationsConfig: Record<string, NotificationChannelConfig>`. Describe that exactly one is present per payload depending on the config level in use.
  - Add `#### NotificationChannelConfig` type directly after: key-value map type where each key is a channel ID (e.g. `inbox`, `email`) and the value is a string preference (`ALL | MINE | NONE`). Annotate as `Record<string, string>`.
- Priority: High

### 2. Webhook Documentation
- File: `/Users/yoenzhang/Downloads/docs/webhooks/basic.mdx`
- Changes:
  - Add `usersOrganizationNotificationsConfig` and `usersDocumentNotificationsConfig` rows to the **Webhook Data** table in the Comments Events section. Type: `Record<string, NotificationChannelConfig>`, Required: Optional. Description: Per-user notification preferences keyed by userId; org-level or doc-level depending on which config scope is active.
  - Add the two tab-separated JSON examples from the release note (Org-Level Config and Document-Level Config) to the Webhook Data section.
- Priority: High

### 3. REST API — getConfig (v1 and v2)
- Files:
  - `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v1/notifications/get-config.mdx`
  - `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/notifications/get-config.mdx`
- Changes:
  - Add optional `getOrganizationConfig` boolean field to the `data` body params. Description: When `true`, fetches the org-level config for the user; `documentIds` is not required in this mode.
  - Update the `documentIds` field description to note it is optional when `getOrganizationConfig: true`.
  - Add a second example request showing org-level config retrieval (omitting `documentIds`, including `getOrganizationConfig: true`).
- Priority: High

### 4. REST API — setConfig (v1 and v2)
- Files:
  - `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v1/notifications/set-config.mdx`
  - `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/notifications/set-config.mdx`
- Changes:
  - Change `documentIds` from `required` to optional. Update description: When omitted, config is applied at the organization level and stored as the user's default for all documents.
  - Add a second example request showing org-level setConfig (omitting `documentIds`).
- Priority: High

---

## Areas Confirmed NOT Requiring Updates

- **api-methods.mdx** — no new SDK methods; `getConfig`/`setConfig` changes are REST API only.
- **UI Customization docs** — no new wireframes.
- **Migration Guide** — no breaking changes.
- **customize-behavior.mdx** — already updated in the prior beta.4 plan for notification delivery; these changes are REST API / webhook payload additions only.

---

## Implementation Sequence

1. Update `data-models.mdx`: add `UserNotificationsConfig` and `NotificationChannelConfig` types in the Webhooks section. (Low effort)
2. Update `webhooks/basic.mdx`: extend Comments Webhook Data table with the two new fields; add tabbed JSON payload examples. (Medium effort)
3. Update v1 and v2 `get-config.mdx`: add `getOrganizationConfig` param, make `documentIds` optional, add org-level example. (Medium effort)
4. Update v1 and v2 `set-config.mdx`: make `documentIds` optional, add org-level example. (Medium effort)

---

## Quality Checklist
- [ ] `UserNotificationsConfig` type added to `data-models.mdx` in the Webhooks section
- [ ] `NotificationChannelConfig` type added to `data-models.mdx` directly after
- [ ] `webhooks/basic.mdx` Webhook Data table includes `usersOrganizationNotificationsConfig` and `usersDocumentNotificationsConfig` rows
- [ ] Tabbed JSON payload examples for both config-level variants added to `webhooks/basic.mdx`
- [ ] v1 `get-config.mdx` updated: `getOrganizationConfig` param added, `documentIds` marked optional
- [ ] v2 `get-config.mdx` updated: same as v1
- [ ] v1 `set-config.mdx` updated: `documentIds` changed from required to optional, org-level example added
- [ ] v2 `set-config.mdx` updated: same as v1
- [ ] All new type anchors follow pattern `/api-reference/sdk/models/data-models#<anchor>`
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.1-beta.4-notification-config.md`
