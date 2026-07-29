## QA Summary for v5.0.4 (core Velt SDK, frontend)

QA date: 2026-06-24 | Verified via Read/Grep/Bash (not from memory). No edits required.

### Per-check results

| # | Check | Result | Evidence |
|---|-------|--------|----------|
| 1 | `CommentResolverSaveEvent` lists exactly **14** members w/ exact wire values | PASS | data-models.mdx 4961-4976; all 14 values match (status_change…unsubscribe) |
| 2 | No `\| string` in `SaveCommentResolverRequest.event` union | PASS | Line 541 = `ResolverActions \| CommentResolverSaveEvent`; grep `\| string` hits are unrelated (Type aliases / index sigs / `string \| null`) |
| 3 | REACTION_ADD distinctness note present & correct | PASS | Line 4978-4980: `comment.reaction_add` vs `ResolverActions.REACTION_ADD` (`reaction.add`) |
| 4 | All data-models edits present; CommentVisibilityConfig NOT given organizationIds | PASS | ResolverEndpointConfig headers union + `credentials` (5207-5208); ResolverConfig `additionalSaveEvents` (5226); SaveCommentResolverRequest `targetComment` (543); `#### AdditionalSaveEventConfig` (4982); CommentAnnotationVisibilityConfig `organizationIds` + tightened `userIds` (306-307); input-type CommentVisibilityConfig (271-276) has only `organizationId` — correctly NOT widened |
| 5 | In-page anchors / self-host links / changelog anchors resolve | PASS | Headings exist: 4955 / 4982 / 533 / 296. self-host-data + changelog links to those 4 anchors all resolve (see anchor table) |
| 6 | `eventType` widening SKIPPED; no fabricated `PartialCommentAnnotationResult` | PASS | `PartialRecorderAnnotationResult.eventType` = `ResolverActions` unchanged (5482); `PartialCommentAnnotationResult` absent everywhere; changelog L24 reworded to "matching resolver-result `eventType`" (no dangling code token) |
| 7 | Terminology case-exactness, no drift | PASS | All good forms present; zero bad forms. Only `excludeOrganizationIds` (legit pre-existing field) matched the loose grep |
| 8 | 6 sibling `<Note>`s consistent + link to /self-host-data/comments; webhook block untouched | PASS | 6 identical Notes (attachments/recordings/reactions/notifications/users/activity). comments.mdx hunks = 252-362 & 477-484 only; webhook `targetComment` block (825-866) outside hunks |
| 9 | No escaped `\|` in ts/js/jsx code fences; no broken tables | PASS | Fence scan = 0; all 5 edited/new tables have uniform pipe-counts |
| 10 | Changelog ordering/date/counts | PASS | v5.0.4 at top above v5.0.2; date "June 19, 2026"; 6 separate bullets — New Features (3) / Improvements (2) / Bug Fixes (1); no Breaking Changes section |
| 11 | Scope guard | PASS | Exactly the 9 expected files; no Node/Python/wireframe/primitive files |

### Count check
`CommentResolverSaveEvent` member count = **14** (matches spec exactly).

### No-`| string` check
`SaveCommentResolverRequest.event` = `ResolverActions | CommentResolverSaveEvent`. No `| string` in the union anywhere in data-models.mdx. PASS.

### Anchor-resolution table

| Anchor | Source(s) | Target heading | Resolves |
|--------|-----------|----------------|----------|
| `#commentresolversaveevent` | changelog, comments.mdx L302/L480 | L4955 `#### CommentResolverSaveEvent` | Yes |
| `#additionalsaveeventconfig` | data-models ResolverConfig row | L4982 `#### AdditionalSaveEventConfig` | Yes |
| `#savecommentresolverrequest` | changelog L24, comments.mdx L101/L479 | L533 `#### SaveCommentResolverRequest` | Yes |
| `#commentannotationvisibilityconfig` | changelog L26/L30 | L296 `#### CommentAnnotationVisibilityConfig` | Yes |
| `/self-host-data/comments` | 6 sibling Notes + 3 changelog "Learn more" | self-host-data/comments.mdx | Yes |

### git diff --name-only
```
api-reference/sdk/models/data-models.mdx
release-notes/version-5/sdk-changelog.mdx
self-host-data/activity.mdx
self-host-data/attachments.mdx
self-host-data/comments.mdx
self-host-data/notifications.mdx
self-host-data/reactions.mdx
self-host-data/recordings.mdx
self-host-data/users.mdx
```
(Plus untracked `.claude/logs/agent-2-planning-v5.0.4.md` — pipeline artifact, not a doc change.)

### Fixes made
None. All edits by prior agents were accurate, in-scope, and consistent.

### Flag (non-blocking, left as-is per scope)
- data-models.mdx L306 describes `CommentAnnotationVisibilityConfig.organizationIds` as a "display-only mirror of `CommentVisibilityConfig.organizationIds`", but the input type `CommentVisibilityConfig` (L271-276) has no `organizationIds` property (it ships in v5.0.3 scope, intentionally not added here). The prose reference is forward-looking; not changed to avoid touching out-of-scope v5.0.3 type. Surface to Agent-1 if v5.0.3 input-type edit is expected to land alongside.

Issues found: 0
