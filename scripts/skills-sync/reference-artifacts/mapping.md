# Docs Path → Skill Mapping

> **Status:** Frozen ground truth for the skills-sync pipeline. Loaded by Agent 1 (docs-diff-planner) as an input.

## Mapped paths

| Docs path prefix | Target skill(s) |
|---|---|
| `async-collaboration/comments/**` | `velt-comments-best-practices` |
| `async-collaboration/notifications/**` | `velt-notifications-best-practices` |
| `async-collaboration/recorder/**` | `velt-recorder-best-practices` |
| `async-collaboration/activity/**` | `velt-activity-best-practices` |
| `async-collaboration/arrows/**` | `velt-arrows-best-practices` |
| `async-collaboration/reactions/**` | `velt-reactions-best-practices` |
| `async-collaboration/view-analytics/**` | `velt-view-analytics-best-practices` |
| `realtime-collaboration/presence/**` | `velt-presence-best-practices` |
| `realtime-collaboration/cursors/**` | `velt-cursors-best-practices` |
| `realtime-collaboration/huddle/**` | `velt-huddle-best-practices` |
| `realtime-collaboration/crdt/**` | `velt-crdt-best-practices`, `yjs-best-practices` |
| `realtime-collaboration/single-editor-mode/**` | `velt-single-editor-mode-best-practices` |
| `get-started/**` | `velt-setup-best-practices` |
| `security/auth-tokens.mdx`, `security/jwt-tokens.mdx`, `security/supported-regions.mdx` | `velt-setup-best-practices` |
| `security/proxy-server.mdx`, `security/content-security-policy.mdx` | `velt-proxy-server-best-practices` |
| `ai/rewriter/**` | `velt-rewriter-best-practices` |
| `ai/chat-sdk-adapter.mdx` | `velt-approval-engine-best-practices` |
| `self-host-data/**` | `velt-self-hosting-data-best-practices` |
| `backend-sdks/python.mdx` | `velt-self-hosting-data-best-practices` |
| `backend-sdks/node.mdx` | `velt-node-sdk-best-practices` |
| `api-reference/rest-apis/v1/**`, `api-reference/rest-apis/v2/**` | `velt-rest-apis-best-practices` |
| `api-reference/sdk/api/api-methods.mdx` | route by method family (match `<Feature>Element` or service name to skill) |
| `api-reference/sdk/api/react-hooks.mdx` | route by hook family (match `use<Feature>` to skill) |
| `api-reference/sdk/models/data-models.mdx` | route by model family (see §model-family routing below) |
| `async-collaboration/suggestions/**` | `velt-suggestions-best-practices` (unmapped — new skill needed) |
| `webhooks/basic.mdx`, `webhooks/advanced.mdx` | route by event family (see §webhook routing) |
| `ui-customization/features/<feature>/**` | skill matching `<feature>` (e.g., `comments` → `velt-comments-best-practices`) |

## Model-family routing

`data-models.mdx` is cross-cutting. The planner examines diff hunks for type names and routes to the owning skill:

| Type prefix | Target skill |
|---|---|
| `CommentAnnotation`, `Comment`, `PartialComment`, `CommentAnnotationAgent`, `AgentResult`, `CommentAnnotationSuggestion` | `velt-comments-best-practices` |
| `PermissionRequest`, `PermissionProvider`, `PermissionResponse` | `velt-setup-best-practices` |
| `NotificationData`, `Notification`, `NotificationEvent` | `velt-notifications-best-practices` |
| `RecorderData`, `Recording`, `RecordingAnnotation` | `velt-recorder-best-practices` |
| `PresenceUser`, `Presence` | `velt-presence-best-practices` |
| `CursorUser`, `Cursor` | `velt-cursors-best-practices` |
| `HuddleData`, `Huddle` | `velt-huddle-best-practices` |
| `BaseMetadata`, `User`, `UserContact` | (cross-cutting — route to skill matching the changed section's heading context) |

If a type name doesn't match any prefix above, check the `#### <TypeName>` heading's enclosing section in the diff for context clues (e.g., if it appears under "Permission Models", route to `velt-setup-best-practices`). Do **not** send to `unmapped` unless you've exhausted both the prefix table and the heading context.

## Webhook routing

`webhooks/basic.mdx` and `webhooks/advanced.mdx` are cross-cutting. The planner examines diff hunks for event-name prefixes and routes:

| Event prefix | Target skill |
|---|---|
| `comment.*` | `velt-comments-best-practices` |
| `notification.*` | `velt-notifications-best-practices` |
| `recorder.*`, `recording.*` | `velt-recorder-best-practices` |
| `activity.*` | `velt-activity-best-practices` |
| `huddle.*` | `velt-huddle-best-practices` |
| `presence.*` | `velt-presence-best-practices` |
| `cursor.*` | `velt-cursors-best-practices` |
| `crdt.*`, `yjs.*` | `velt-crdt-best-practices` |
| `editor.*`, `single-editor-mode.*` | `velt-single-editor-mode-best-practices` |
| Anything else | `velt-rest-apis-best-practices` (default webhook home) |

## Unmapped feature paths (file issue, do not edit skills)

These docs paths exist but have no skill counterpart. Agent 1 sends them to `unmapped`; Agent 4 files an issue with a suggested slug.

| Path | Suggested slug | Notes |
|---|---|---|
| `async-collaboration/comments-sidebar/**` | (extend existing) | Likely folds into `velt-comments-best-practices` — file as extension proposal, not new skill |
| `realtime-collaboration/flock-mode/**` | `velt-flock-mode-best-practices` | New skill candidate |
| `realtime-collaboration/live-selection/**` | `velt-live-selection-best-practices` | New skill candidate |
| `realtime-collaboration/live-state-sync/**` | `velt-live-state-sync-best-practices` | New skill candidate |
| `realtime-collaboration/video-player-sync/**` | `velt-video-player-sync-best-practices` | New skill candidate |
| `permission-management/**` | `velt-permissions-best-practices` | New skill candidate |
| `in-app-user-feedback/**` | `velt-feedback-best-practices` | New skill candidate |

## Explicitly out-of-scope (drop silently)

The planner drops these without filing issues:

- `release-notes/**` — handled by the existing release-note pipeline
- `key-concepts/**`, `migration/**` — conceptual; no skill counterpart
- `integrations/**` — third-party; not in skill scope today
- `mcp/**` — meta-docs about the MCP itself
- `images/**`, `gifs/**`, `global-styles/**`, `snippets/**`, `*.css` — assets and shared MDX fragments
- `live-co-editing/**` — deprecated
- `api-reference/open-api/**`, `api-reference/postman-collection/**` — tooling assets, not endpoint docs

## Updater variant dispatch (matched against the resolved skill name)

| Variant | Skills |
|---|---|
| `frontend-async-skill-updater` | `velt-comments-best-practices`, `velt-notifications-best-practices`, `velt-activity-best-practices`, `velt-recorder-best-practices`, `velt-reactions-best-practices`, `velt-arrows-best-practices`, `velt-area-best-practices`, `velt-view-analytics-best-practices` |
| `frontend-realtime-skill-updater` | `velt-presence-best-practices`, `velt-cursors-best-practices`, `velt-huddle-best-practices`, `velt-single-editor-mode-best-practices`, `velt-crdt-best-practices` |
| `setup-skill-updater` | `velt-setup-best-practices` |
| `backend-skill-updater` | `velt-rest-apis-best-practices`, `velt-self-hosting-data-best-practices`, `velt-node-sdk-best-practices` |
| `infra-skill-updater` | `velt-proxy-server-best-practices`, `yjs-best-practices` |
| `ai-skill-updater` | `velt-rewriter-best-practices`, `velt-approval-engine-best-practices` |
