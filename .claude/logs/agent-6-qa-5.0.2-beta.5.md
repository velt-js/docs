## QA Summary for v5.0.2-beta.5

### Issues Found: 3

1. **ui-customization/features/async/comments/comment-dialog-components.mdx** — `VeltAutocompleteEmptyWireframe` example missing `<VeltWireframe>` / `<velt-wireframe>` parent wrapper. Every other wireframe section in this file wraps with these containers; the new section was inconsistent.
   - Fix: Added `<VeltWireframe>` wrapper in React tab and `<velt-wireframe>` wrapper in Other Frameworks tab. Also added `VeltWireframe` to the import statement.

2. **ui-customization/features/async/comments/comment-dialog-components.mdx** — VeltAutocomplete Panel props table used 4-column format (`Prop | Type | Default | Description`) while all other prop tables in the same file use `Prop | HTML attr | Type | Description`. The HTML attribute equivalents for `multiSelect`, `selectedFirstOrdering`, `readOnly`, and `inline` were not surfaced in the table.
   - Fix: Changed to 5-column format (`Prop | HTML attr | Type | Default | Description`). Added HTML attrs: `multi-select`, `selected-first-ordering`, `read-only`, `inline`. Set `contacts` HTML attr to `—` (no HTML equivalent, consistent with Other Frameworks code example).

3. **api-reference/sdk/models/data-models.mdx** — Analytics event data models (`CommentAnalyticsEvent`, `ReactionAnalyticsEvent`, `CrdtAnalyticsEvent`) were planned by Agent-2 but not added. The changelog references analytics improvements (`COMMENT_ADDED`, `REACTION_ADDED`, `CRDT_DATA_UPDATED`) with no corresponding data model documentation.
   - Status: **Not fixed** — Agent-2 noted exact field names required SDK source verification before writing. Fields are partially described in changelog prose but type definitions are absent. Flagged for Agent-1 follow-up.

### Verified Clean

- No `### Breaking Changes` section in the v5.0.2-beta.5 changelog entry.
- Old visibility type strings (`personal`, `selected-people`, `org-users`) appear only in upgrade-guide.mdx "Before" migration examples — no leakage into other files.
- `CommentVisibilityOption` enum and `CommentVisibilityOptionType` type added to data-models.mdx with anchors `#commentvisibilityoption` and `#commentvisibilityoptiontype`; changelog links resolve.
- `AccessRequestEvent` and `SEMEvent` updated with `totalUsers`, `presenceSnippylyUserIds`, `presenceClientUserIds` in data-models.mdx.
- Changelog links to `#accessrequestevent` and `#semevent` anchors resolve.
- No `UserPicker` sub-components present in comment-dialog-components.mdx.
- No old visibility type strings outside upgrade-guide.mdx.
- VeltAutocomplete Panel props (multiSelect, selectedFirstOrdering, readOnly, inline, contacts) documented.
- 13 standalone autocomplete primitive components documented with React/HTML tabs.
- Changelog section order: New Features → Improvements → Bug Fixes — correct, no Breaking Changes.
- `[**Access Control**]` label used (not "Cloud Functions") — correct.
- `customize-behavior.mdx` updateVisibility examples use new type strings (`organizationPrivate`, `restricted`) — already aligned.

### Summary

- Files corrected: 1 (`comment-dialog-components.mdx`, 2 fixes applied)
- Critical issues: 0
- Consistency fixes: 2 (wireframe wrapper, props table HTML attr column)
- Deferred item: 1 (analytics event models — pending SDK source verification)
