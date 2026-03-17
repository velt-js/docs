## QA Summary for v5.0.1

### Issues Found: 4

1. **release-notes/version-5/sdk-changelog.mdx** — Fix 1 (TEMP_COMPOSER_ persistence) exposed internal service class names `CommentService` and `ViewsService` with their private method paths. Agent-2 explicitly confirmed these are private service-layer guards with no public API surface.
   - Fix: Replaced `through CommentService.updateComment(), ViewsService.setCommentAnnotationAsRead(), and ViewsService.setCommentAnnotationAsUnread(). All three paths now have early-return guards` with `Guards were added so temp annotations remain client-only and are never written to the database.`

2. **release-notes/version-5/sdk-changelog.mdx** — Fix 3 (locationName sidebar) named internal functions `sortPageFilters` and `filterGroupedAnnotations`. Agent-2 confirmed these are internal sort logic with no public doc presence.
   - Fix: Replaced `Both sortPageFilters and filterGroupedAnnotations now resolve` with `The sidebar now resolves`

3. **release-notes/version-5/sdk-changelog.mdx** — Fix 4 (notification race condition) exposed internal class and method `NotificationService.getInitialConfigFromDB()`. Agent-2 explicitly confirmed this is not referenced in any public doc.
   - Fix: Removed `in NotificationService.getInitialConfigFromDB()` and trailing implementation detail `A generation counter now discards stale async results.`

4. **release-notes/version-5/sdk-changelog.mdx** — Fix 5 (video timeline parseFloat) exposed internal component `CommentPlayerTimelineComponent` and its internal input setter `totalMediaLength`, plus `parseFloat()` / `parseInt()` implementation detail. Agent-2 confirmed neither is a public API parameter.
   - Fix: Replaced implementation-detail sentence with `Fractional-second durations are now preserved correctly.`

### Structural Checks: All Pass

- v5.0.1 entry is correctly above v5.0.1-beta.4 (chronological order correct)
- v5.0.1 does not appear in version-4/sdk-changelog.mdx (correct file placement)
- `<Update label="5.0.1">` block format matches surrounding entries
- Section heading is `### Bug Fixes` only (correct — no New Features or Improvements for a patch)
- Five bug fix bullets present (matches Agent-2 count of 5 fixes)

### Terminology Checks: All Pass

- `TEMP_COMPOSER_` prefix: in backticks (line 16, 18) — correct
- `markAsRead()`: in backticks (line 18) — correct
- `locationName`: in backticks (line 20) — correct
- `location.id` / `location.locationName`: in backticks (line 20) — correct
- `id`: in backticks (line 20) — correct
- Internal symbols removed: `CommentService`, `ViewsService`, `sortPageFilters`, `filterGroupedAnnotations`, `NotificationService`, `getInitialConfigFromDB`, `CommentPlayerTimelineComponent`, `totalMediaLength`, `parseFloat()`, `parseInt()` — all stripped

### Summary

- Files corrected: 1 (`release-notes/version-5/sdk-changelog.mdx`)
- Critical issues: 4 (internal implementation symbols exposed in user-facing release notes)
- Structural/ordering issues: 0
- Terminology/formatting issues: 0
- All fixes are in the v5.0.1 `<Update>` block only; no other files required changes
