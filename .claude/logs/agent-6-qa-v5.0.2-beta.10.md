## QA Summary for v5.0.2-beta.10

### Issues Found: 8 (6 prior pass + 2 this pass)

**Prior pass (Agent-5 alignment):**

1. **release-notes/version-5/sdk-changelog.mdx** — `[**Activity Log**]` (singular) inconsistent with `[**Activity Logs**]` (plural) used elsewhere.
   - Fix: Changed `[**Activity Log**]` → `[**Activity Logs**]` on the New Features bullet.

2. **api-reference/sdk/models/data-models.mdx / ActivityRecord** — Missing `isActivityResolverUsed` field introduced in this release.
   - Fix: Added `isActivityResolverUsed?: boolean` row to the `ActivityRecord` table.

3. **api-reference/sdk/models/data-models.mdx / VeltDataProvider** — Missing `activity` field (new `ActivityAnnotationDataProvider`).
   - Fix: Added `activity: ActivityAnnotationDataProvider` row to `VeltDataProvider` table.

4. **api-reference/sdk/models/data-models.mdx / SetDocumentsRequestOptions** — Missing `debounceTime` and `optimisticPermissions` fields.
   - Fix: Added both fields to `SetDocumentsRequestOptions` table.

5. **api-reference/sdk/models/data-models.mdx / UserPermissionInfo** — Missing `accessType` field added in this release.
   - Fix: Added `accessType?: string` row to `UserPermissionInfo` table.

6. **api-reference/sdk/models/data-models.mdx** — Four new types (`ActivityAnnotationDataProvider`, `GetActivityResolverRequest`, `SaveActivityResolverRequest`, `PartialActivityRecord`) absent from data-models.mdx.
   - Fix: Added all four type definition tables.

**This pass (terminology alignment QA):**

7. **api-reference/sdk/api/api-methods.mdx** — `getUserPermissions()` Full Documentation link used broken anchor `#configuration-modes` (no such anchor in `key-concepts/overview.mdx`).
   - Fix: Changed to `#access-control`, the correct anchor.

8. **release-notes/version-5/sdk-changelog.mdx** — Improvements entry described `getReactionAnnotationForClient` and `getRecorderAnnotationForClient` as "utility methods" with no indication they are internal, risking confusion about public API surface.
   - Fix: Added "Internal" qualifier and clarified they are not part of the public API.

### Terminology Verified (No Changes Needed — This Pass)

- **`targetEntityId` optionality**: Consistently optional for non-`custom` featureTypes across all 8 pipeline files and all activity docs. Correct.
- **`featureType` enum values**: All five values (`comment`, `reaction`, `recorder`, `crdt`, `custom`) listed consistently across all relevant files. Correct.
- **`accessType` values**: `public`, `restricted`, `organizationPrivate` consistent in `UserPermissionInfo`, `get-permissions.mdx`, and `key-concepts/overview.mdx`. Correct.
- **`id` field on activity creation**: Present in both `CreateActivityData` (data-models) and `add-activities.mdx`. Consistent.
- **`createActivity()` method name**: Used consistently; no `addActivity` occurrences found anywhere in docs.
- **`getUserPermissions()` method name**: Used consistently; no `getPermissions` occurrences in pipeline files.
- **`getActivityForClient`**: Does not appear in any public API doc. Correctly absent.
- **`getReactionAnnotationForClient` / `getRecorderAnnotationForClient`**: Only in changelog Improvements entry; absent from api-methods.mdx and data-models.mdx. Correct placement.
- **`CreateActivityData` casing**: Consistent across all files.

### Summary
- Files corrected (this pass): 2
- Critical issues (this pass): 1 (broken anchor on `getUserPermissions()`)
- Clarification fixes (this pass): 1 (internal method disambiguation in changelog)
- Total issues across both passes: 8
