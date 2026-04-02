## QA Summary for v5.0.2-beta.10

### Issues Found: 6

1. **release-notes/version-5/sdk-changelog.mdx** — `[**Activity Log**]` (singular) on the New Features bullet (line 16) inconsistent with `[**Activity Logs**]` (plural) used on Improvements (line 99), Bug Fixes (line 103), and all prior changelog entries (beta.7 line 190).
   - Fix: Changed `[**Activity Log**]` → `[**Activity Logs**]` on line 16.

2. **api-reference/sdk/models/data-models.mdx / ActivityRecord** — Missing `isActivityResolverUsed` field introduced in this release. Referenced in self-host-data/activity.mdx and sdk-changelog.mdx but absent from the type definition.
   - Fix: Added `isActivityResolverUsed?: boolean` row to the `ActivityRecord` table.

3. **api-reference/sdk/models/data-models.mdx / VeltDataProvider** — Missing `activity` field. The changelog and self-host-data/activity.mdx both document the `activity` provider, but it was not added to the `VeltDataProvider` table (which lists `comment`, `user`, `reaction`, `attachment`, `recorder`, `anonymousUser`).
   - Fix: Added `activity: ActivityAnnotationDataProvider` row linking to new anchor.

4. **api-reference/sdk/models/data-models.mdx / SetDocumentsRequestOptions** — Missing `debounceTime` and `optimisticPermissions` fields introduced in this release and documented in sdk-changelog.mdx.
   - Fix: Added both fields to the `SetDocumentsRequestOptions` table.

5. **api-reference/sdk/models/data-models.mdx / UserPermissionInfo** — Missing `accessType` field. The changelog documents this addition to `GetUserPermissionsResponse` but the field belongs on `UserPermissionInfo` (the type used within that response map).
   - Fix: Added `accessType?: string` row to the `UserPermissionInfo` table.

6. **api-reference/sdk/models/data-models.mdx** — Four new types (`ActivityAnnotationDataProvider`, `GetActivityResolverRequest`, `SaveActivityResolverRequest`, `PartialActivityRecord`) linked from self-host-data/activity.mdx and sdk-changelog.mdx were entirely absent from data-models.mdx.
   - Fix: Added all four type definition tables after the `PartialRecorderAnnotationResult` section, before `AnonymousUserDataProvider`.

### No Issues Found

- Component names `VeltActivityLog` / `velt-activity-log` — correct and consistent throughout.
- Wireframe names `VeltActivityLogWireframe` / `velt-activity-log-wireframe` — correct and consistent throughout.
- Import path `@veltdev/react` for `VeltActivityLog` — correct (no sub-path imports used).
- `enableFirestorePersistentCache()` / `disableFirestorePersistentCache()` — spelled correctly in all locations.
- `setDataProviders()` (plural) — used consistently; no `setDataProvider` (singular) instances found.
- `getAllActivities()` — used consistently; no `getActivities()` or `getAllActivity()` variants found in Velt API references.
- `debounceTime` / `optimisticPermissions` / `isActivityResolverUsed` / `accessType` — casing consistent across all files where each appears.
- `docs.json` navigation — `Activity Logs` group (feature nav) vs. `Activity Log` group (UI customization) is intentional; matches page titles.

### Summary

- Files corrected: 2 (`sdk-changelog.mdx`, `data-models.mdx`)
- Critical issues: 6 (missing definitions and label inconsistency)
- Terminology label alignments: 1 (Activity Log → Activity Logs in changelog)
- Type definitions added: 4 (ActivityAnnotationDataProvider, GetActivityResolverRequest, SaveActivityResolverRequest, PartialActivityRecord)
- Fields added to existing types: 5 (isActivityResolverUsed, activity, debounceTime, optimisticPermissions, accessType)
