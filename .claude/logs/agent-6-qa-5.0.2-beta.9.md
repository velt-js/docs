## QA Summary for v5.0.2-beta.9

### Issues Found: 2

1. **api-reference/sdk/models/data-models.mdx** — `VeltCommentsSidebarV2Props` was missing `embedMode` and `floatingMode` props.
   - The changelog (sdk-changelog.mdx line 190) explicitly lists both as forwarded props when `version="2"` is set, and `customize-behavior.mdx` Props table (lines 1353–1354) documents both with types `string | null` and `boolean`.
   - Fix: Added `embedMode` (`string | null`) and `floatingMode` (`boolean`) rows to `VeltCommentsSidebarV2Props` table, positioned between `readOnly` and `position` to match the ordering in `customize-behavior.mdx`.

2. **api-reference/sdk/models/data-models.mdx** — `ResolverConfig` was missing `fieldsToRemove` field.
   - The changelog (sdk-changelog.mdx line 205) describes `fieldsToRemove` as a co-existing property alongside `additionalFields` in `CommentAnnotationDataProvider.config`. `additionalFields` was already documented in `ResolverConfig` but `fieldsToRemove` had no data-models entry anywhere in the repo.
   - Fix: Added `fieldsToRemove` (`string[]`) row to `ResolverConfig` table with description distinguishing it from `additionalFields`.

### Verified Clean (no changes needed)

- `comment-sidebar-components-v2.mdx` — All 27 primitive names consistent with structure-v2 and changelog.
- `comment-sidebar-structure-v2.mdx` — React/HTML naming 1:1 consistent.
- `self-host-data/notifications.mdx` — `NotificationDataProvider`, `NotificationResolverConfig`, `GetNotificationResolverRequest`, `DeleteNotificationResolverRequest`, `PartialNotification`, `isNotificationResolverUsed`, pipeline order (`notification → user → comment`), and `notificationSource === 'custom'` scoping all consistent with data-models.mdx and changelog.
- `self-host-data/overview.mdx` — Notifications entry present and accurate.
- `async-collaboration/comments-sidebar/setup.mdx` — V2 setup section present; `version="2"` (string) used correctly; cross-reference links resolve correctly.
- `async-collaboration/comments-sidebar/customize-behavior.mdx` — V2 Props table and `version` prop section consistent with changelog.
- `docs.json` — `self-host-data/notifications`, `comment-sidebar-components-v2`, and `comment-sidebar-structure-v2` all present in navigation.
- `agentFields` — camelCase used consistently; `agent.agentFields` Firestore path reference in data-models.mdx correct.
- `additionalFields` / `fieldsToRemove` — camelCase used consistently across all files; no snake_case variants found.
- `version="2"` — string type used consistently; no numeric `version={2}` occurrences found.
- No stray `NotificationResolver` (non-`DataProvider`) terminology found outside changelog/data-models/notifications.

### Summary

- Files corrected: 1 (api-reference/sdk/models/data-models.mdx)
- Critical issues: 0
- Missing prop definitions: 2 (`embedMode`, `floatingMode` in VeltCommentsSidebarV2Props)
- Missing field definition: 1 (`fieldsToRemove` in ResolverConfig)
