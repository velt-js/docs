# Docs Path → Skill Mapping

> **Status:** Ground truth for the skills-sync pipeline. Loaded by Agent 1 (docs-diff-planner) as an input.

## How routing works

The planner resolves each changed file to a skill using this priority order:

1. **Explicit overrides** (§Explicit path overrides) — checked first, handles cross-cutting files and special cases
2. **Folder conventions** (§Folder conventions) — pattern-based rules that cover entire directory trees
3. **Convention-based fallback** (§Convention-based fallback) — derives the skill slug from the path automatically
4. **Out-of-scope filter** (§Explicitly out-of-scope) — drops files that should never produce skill updates
5. **Unmapped** — only if all of the above fail. Flag in the PR body with a suggested slug, but push **no changes** for that path. Never silently drop a file — if it reaches this stage, it must be visible in the PR.

## Explicit path overrides

These take priority over all convention rules. Use for cross-cutting files where the path alone is ambiguous.

| Docs path prefix | Target skill(s) |
|---|---|
| `get-started/**` | `velt-setup-best-practices` |
| `security/auth-tokens.mdx`, `security/jwt-tokens.mdx`, `security/supported-regions.mdx` | `velt-setup-best-practices` |
| `security/proxy-server.mdx`, `security/content-security-policy.mdx` | `velt-proxy-server-best-practices` |
| `self-host-data/**` | `velt-self-hosting-data-best-practices` |
| `backend-sdks/python.mdx` | `velt-self-hosting-data-best-practices` |
| `backend-sdks/node.mdx` | `velt-node-sdk-best-practices` |
| `api-reference/rest-apis/v1/**`, `api-reference/rest-apis/v2/**` | `velt-rest-apis-best-practices` |
| `api-reference/sdk/api/api-methods.mdx` | route by method family (match `<Feature>Element` or service name to skill) |
| `api-reference/sdk/api/react-hooks.mdx` | route by hook family (match `use<Feature>` to skill) |
| `api-reference/sdk/models/data-models.mdx` | route by model family (see §Model-family routing) |
| `webhooks/basic.mdx`, `webhooks/advanced.mdx` | route by event family (see §Webhook routing) |

## Nested feature namespace routing

These routes take priority over the generic `ui-customization/features/<feature>/**` convention. The first folder under `features/` is a namespace (`async` or `realtime`), not the owning feature.

| Docs path prefix | Target skill |
|---|---|
| `ui-customization/features/async/comments/**` | `velt-comments-best-practices` |
| `ui-customization/features/async/comments-sidebar/**` | `velt-comments-best-practices` |
| `ui-customization/features/async/notifications/**` | `velt-notifications-best-practices` |
| `ui-customization/features/async/activity/**` | `velt-activity-best-practices` |
| `ui-customization/features/async/recorder/**` | `velt-recorder-best-practices` |
| `ui-customization/features/async/reactions/**` | `velt-reactions-best-practices` |
| `ui-customization/features/async/arrows/**` | `velt-arrows-best-practices` |
| `ui-customization/features/async/area/**` | `velt-area-best-practices` |
| `ui-customization/features/async/view-analytics/**` | `velt-view-analytics-best-practices` |
| `ui-customization/features/realtime/presence/**` | `velt-presence-best-practices` |
| `ui-customization/features/realtime/cursors/**` | `velt-cursors-best-practices` |
| `ui-customization/features/realtime/huddle/**` | `velt-huddle-best-practices` |
| `ui-customization/features/realtime/crdt/**` | `velt-crdt-best-practices`, `yjs-best-practices` |
| `ui-customization/features/realtime/single-editor-mode/**` | `velt-single-editor-mode-best-practices` |

## Folder conventions

These rules derive the target skill from the path structure. They cover entire directory trees so new subfolders and files are handled automatically without updating this document.

| Pattern | Target skill | Notes |
|---|---|---|
| `async-collaboration/<feature>/**` | `velt-<feature>-best-practices` | Feature = subfolder name. e.g. `comments/` → `velt-comments-best-practices` |
| `realtime-collaboration/<feature>/**` | `velt-<feature>-best-practices` | Feature = subfolder name. e.g. `cursors/` → `velt-cursors-best-practices` |
| `ai/<feature>/**` or `ai/<feature>.mdx` | see §AI routing | AI paths are cross-cutting — use the sub-routing table |
| `ui-customization/features/<feature>/**` | `velt-<feature>-best-practices` | Feature = subfolder name under `features/` |
| `<top-level-folder>/**` | `velt-<top-level-folder>-best-practices` | General fallback for unmapped top-level folders (e.g. `permission-management/` → `velt-permission-management-best-practices`) |

### Exceptions to folder conventions

These override the default `velt-<feature>-best-practices` derivation:

| Path | Target skill | Why |
|---|---|---|
| `async-collaboration/comments-sidebar/**` | `velt-comments-best-practices` | Sidebar is part of comments, not a separate skill |
| `realtime-collaboration/crdt/**` | `velt-crdt-best-practices`, `yjs-best-practices` | Dual-skill: CRDT docs feed both skills |

### AI routing

The `ai/` folder contains features that map to different skills. Route by filename or subfolder:

| AI path | Target skill |
|---|---|
| `ai/rewriter/**` | `velt-rewriter-best-practices` |
| `ai/approval-engine/**` | `velt-approval-engine-best-practices` |
| `ai/chat-sdk-adapter.mdx` | `velt-approval-engine-best-practices` |
| `ai/agent-comments.mdx` or `ai/agent-comments/**` | `velt-comments-best-practices` |
| Any other `ai/<name>.*` or `ai/<name>/**` | Derive from name: `velt-<name>-best-practices`. If no such skill exists, flag as unmapped. |

## Convention-based fallback

If no explicit override or folder convention matches a changed file, the planner should:

1. Extract the **feature keyword** from the path — use the deepest meaningful directory name or the filename stem (without `.mdx`)
2. Construct the candidate slug: `velt-<feature>-best-practices`
3. Check whether that skill exists in the agent-skills repo (it will be checked out at `$AGENT_SKILLS_DIR`)
4. If the skill exists → route to it
5. If the skill does not exist → mark as **unmapped** (see §Unmapped handling)

This fallback means new docs folders that follow the naming convention `velt-<folder-name>-best-practices` are picked up automatically.

## Unmapped handling

When a file cannot be routed to any skill:

- **Do not push changes** for that file — no ticket, no patch, no skill update
- **Do flag it** in the PR body under a `## Unmapped paths` section listing each unmapped file with its suggested slug
- **Do not silently drop it** — every unmapped file must be visible to the reviewer
- If the entire run contains only unmapped files (no tickets at all), still create a PR with no code changes, just the unmapped report in the body, so the reviewer is notified

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

## Identifier routing overrides

Use this table when an API reference, SDK, UI-customization, or cross-cutting docs hunk includes one of these identifiers. Identifier routing is especially important when a single docs file covers multiple feature families.

| Identifier / signal | Target skill | Notes |
|---|---|---|
| `setPageInfo`, `clearPageInfo`, `useSetPageInfo`, `useClearPageInfo`, `PageInfo`, `options.documentId` | `velt-setup-best-practices` | `options.documentId` is reserved for future per-document scope unless the docs explicitly say otherwise. Do not present it as current scoped behavior. |
| `ApryseVeltComments`, `Apryse`, `WebViewer`, `AddCommentArgs`, `RenderCommentsArgs`, `AttachedExtension`, `TextEditorConfig` | `velt-comments-best-practices` | Apryse WebViewer comments are a comments setup/editor-integration surface. |
| `VeltCommentsSidebarV2`, `<velt-comments-sidebar-v2>`, removed `VeltCommentsSidebar version="2"` usage | `velt-comments-best-practices` | Removed identifiers must remove or negate stale guidance; do not leave old usage in a recommended example. |
| `collapsedRepliesPreview`, `enableCollapsedRepliesPreview`, `disableCollapsedRepliesPreview`, `VeltCommentDialogMoreReply.Count`, `VeltCommentDialogMoreReply.Text` | `velt-comments-best-practices` | Public primitive subproperties use `VeltCommentDialogMoreReply.*`; reserve `VeltCommentDialogWireframe.MoreReply.*` for wireframe rules. |
| `FieldFilterOptions`, `filterUnknownFields`, `pickKnownFields`, `filterRequest`, `FilterSpec`, `*_SPEC` | `velt-node-sdk-best-practices` | Node SDK allowlist behavior. Python `filter_unknown_fields` belongs to `velt-self-hosting-data-best-practices`. |
| `filter_unknown_fields`, `field_allowlists` | `velt-self-hosting-data-best-practices` | Python SDK self-hosting / velt-py allowlist behavior. |
| `/v2/agents/*`, `/v2/agents/execution/list`, `/v2/memory/*` | `velt-rest-apis-best-practices` | REST API docs are authoritative for Agents and Memory. Do not infer visible Node/Python SDK namespaces from commented or hidden SDK sections. |
| `sdk.api.agents`, `sdk.api.memory` in hidden/commented Node or Python SDK sections | no SDK ticket unless visible in published docs | If the docs say the sections are hidden/commented, the corresponding SDK skills should only warn not to document those namespaces as live. |
| Approval Engine inbound webhook, raw JSON ingress, `Authorization: Bearer`, signed callback token, SSRF guard | `velt-approval-engine-best-practices` | Inbound webhook handler is distinct from outbound webhook delivery and deferred `node.type === "webhook"` nodes. |

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

## Explicitly out-of-scope (drop silently)

The planner drops these without filing issues or flagging:

- `release-notes/**` — handled by the existing release-note pipeline
- `key-concepts/**`, `migration/**` — conceptual; no skill counterpart
- `integrations/**` — third-party; not in skill scope today
- `mcp/**` — meta-docs about the MCP itself
- `images/**`, `gifs/**`, `global-styles/**`, `snippets/**`, `*.css` — assets and shared MDX fragments
- `live-co-editing/**` — deprecated
- `api-reference/open-api/**`, `api-reference/postman-collection/**` — tooling assets, not endpoint docs
- `docs.json`, `mint.json` — config files, not content

## Updater variant dispatch (matched against the resolved skill name)

| Variant | Skills |
|---|---|
| `frontend-async-skill-updater` | `velt-comments-best-practices`, `velt-notifications-best-practices`, `velt-activity-best-practices`, `velt-recorder-best-practices`, `velt-reactions-best-practices`, `velt-arrows-best-practices`, `velt-area-best-practices`, `velt-view-analytics-best-practices` |
| `frontend-realtime-skill-updater` | `velt-presence-best-practices`, `velt-cursors-best-practices`, `velt-huddle-best-practices`, `velt-single-editor-mode-best-practices`, `velt-crdt-best-practices` |
| `setup-skill-updater` | `velt-setup-best-practices` |
| `backend-skill-updater` | `velt-rest-apis-best-practices`, `velt-self-hosting-data-best-practices`, `velt-node-sdk-best-practices` |
| `infra-skill-updater` | `velt-proxy-server-best-practices`, `yjs-best-practices` |
| `ai-skill-updater` | `velt-rewriter-best-practices`, `velt-approval-engine-best-practices` |
