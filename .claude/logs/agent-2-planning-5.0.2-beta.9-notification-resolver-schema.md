# Release Update Plan for v5.0.2-beta.9 — Notification Resolver Server-Side Schema Support

## Overview
- Release Type: Minor (supplemental to the main 5.0.2-beta.9 plan)
- Key Changes: `isNotificationResolverUsed: boolean` added to `NotificationRawData`; `displayHeadlineMessageTemplate` and `displayBodyMessage` are no longer required on the REST API write schema when `isNotificationResolverUsed: true`; notification write and batch flows updated to treat resolver-flagged notifications as eligible for in-app delivery without pre-stored templates
- Breaking Changes: No (relaxed validation is backward compatible; standard notifications are unaffected)

---

## Current State (what already exists)

- `data-models.mdx` (`Notification` table, line 2573): `isNotificationResolverUsed: boolean` is **already present**
- `self-host-data/notifications.mdx`: full resolver setup page **already exists**, covers `isNotificationResolverUsed` in the "Resolver Status Field" section (line 395–399) and references the write-side flow only implicitly
- REST API v2 `add-notifications.mdx`: `displayHeadlineMessageTemplate` (line 61) and `displayBodyMessage` (line 82) are still marked `required`; `isNotificationResolverUsed` is **not present** at all
- REST API v1 `add-notifications.mdx`: same — both fields marked `required`, `isNotificationResolverUsed` absent
- `api-methods.mdx`: no `addNotifications` SDK method documented; no changes needed

---

## Areas Requiring Updates

### 1. Data Models
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes: `isNotificationResolverUsed` is already on the `Notification` read model (line 2573). No `NotificationRawData` model exists in the docs; the write-schema is documented via the REST API files, not data-models.mdx. **No change needed here.**
- Priority: N/A — already complete

### 2. REST API — v2 Add Notifications
- File: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v2/notifications/add-notifications.mdx`
- Priority: High

**a. Relax `displayHeadlineMessageTemplate` from `required` to optional when resolver is used.**

Change `<ParamField body="displayHeadlineMessageTemplate" type="string" required>` (line 61) to remove `required` and update description:

```
<ParamField body="displayHeadlineMessageTemplate" type="string">
  Display Headline Message Template. Required for standard custom notifications.
  May be omitted when `isNotificationResolverUsed: true` — the resolver supplies
  the headline at read time.
</ParamField>
```

**b. Relax `displayBodyMessage` from `required` to optional when resolver is used.**

Change `<ParamField body="displayBodyMessage" type="string" required>` (line 82) to:

```
<ParamField body="displayBodyMessage" type="string">
  Display Body Message. Required for standard custom notifications.
  May be omitted when `isNotificationResolverUsed: true`.
</ParamField>
```

**c. Add `isNotificationResolverUsed` param field** after `notificationId` (before `displayHeadlineMessageTemplate`):

```
<ParamField body="isNotificationResolverUsed" type="boolean">
  Set to `true` when using the Notification Resolver to supply PII at read time.
  When `true`, `displayHeadlineMessageTemplate` and `displayBodyMessage` may be
  omitted — Velt stores the structural notification and the resolver enriches it
  client-side. Only applies to `notificationSource: 'custom'` notifications.
  [Learn more →](/self-host-data/notifications)
</ParamField>
```

**d. Add a resolver-mode example request** after the existing "Example Request with Context" block:

```json
// Resolver-mode: omit template fields, set isNotificationResolverUsed: true
{
  "data": {
    "organizationId": "org-abc",
    "documentId": "doc-789",
    "notificationSource": "custom",
    "isNotificationResolverUsed": true,
    "actionUser": { "userId": "user-123" },
    "notifyUsers": [{ "userId": "user-456" }]
  }
}
```

With a `<Note>` explaining: when `isNotificationResolverUsed` is `true`, `displayHeadlineMessageTemplate` and `displayBodyMessage` are not required. The notification is stored structurally in Velt and enriched with PII by the resolver at read time.

### 3. REST API — v1 Add Notifications
- File: `/Users/yoenzhang/Downloads/docs/api-reference/rest-apis/v1/notifications/add-notifications.mdx`
- Priority: Medium

Same three changes as v2 (items a, b, c above). No new example request required for v1 — add only the param field additions and relaxed `required` markers.

### 4. Self-Hosting Notifications Docs
- File: `/Users/yoenzhang/Downloads/docs/self-host-data/notifications.mdx`
- Priority: Medium

The page covers the read-side resolver flow thoroughly but does not explain the server-side write flow. Add a new section **"Writing Resolver-Eligible Notifications"** before the "Resolver Status Field" section (currently line 393).

Section content:
- Explain that when `isNotificationResolverUsed: true` is set on the write, `displayHeadlineMessageTemplate` and `displayBodyMessage` can be omitted
- Link to the REST API v2 add-notifications endpoint
- Include a minimal code example (POST body with `isNotificationResolverUsed: true`, omitting template fields) in dual-tab format (React/Next.js and Other Frameworks both show the JSON payload since this is a server-side REST call, not SDK)
- Note that `notificationSource` must be `'custom'` for resolver routing to apply
- Cross-reference: "The resolver then supplies PII at read time — see [How does it work?](#how-does-it-work) above."

### 5. API Methods
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Changes: None. No SDK method for `addNotifications` exists; write path is REST-only.
- Priority: N/A

### 6. Upgrade Guide
- Not applicable — no breaking changes.

---

## Implementation Sequence

1. `api-reference/rest-apis/v2/notifications/add-notifications.mdx`: Relax `displayHeadlineMessageTemplate` and `displayBodyMessage` required markers; add `isNotificationResolverUsed` param; add resolver-mode example. (No prerequisites)
2. `api-reference/rest-apis/v1/notifications/add-notifications.mdx`: Same param/required changes as v2. (No prerequisites, parallel with step 1)
3. `self-host-data/notifications.mdx`: Add "Writing Resolver-Eligible Notifications" section with POST body example and cross-references. (Prerequisite: steps 1–2 so links to REST API are accurate)

---

## Quality Checklist
- [ ] `displayHeadlineMessageTemplate` changed from `required` to optional in v2 add-notifications.mdx
- [ ] `displayBodyMessage` changed from `required` to optional in v2 add-notifications.mdx
- [ ] `isNotificationResolverUsed` param added to v2 add-notifications.mdx with link to `/self-host-data/notifications`
- [ ] Resolver-mode example request added to v2 add-notifications.mdx
- [ ] v1 add-notifications.mdx receives same required-marker relaxations and `isNotificationResolverUsed` param
- [ ] `self-host-data/notifications.mdx` gains "Writing Resolver-Eligible Notifications" section with dual-tab example
- [ ] `isNotificationResolverUsed` in `data-models.mdx` `Notification` table confirmed present (no action needed)
- [ ] No upgrade-guide changes required (confirmed non-breaking)
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.9-notification-resolver-schema.md`
