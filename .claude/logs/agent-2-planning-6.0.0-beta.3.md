# Release Update Plan for 6.0.0-beta.3 (June 30, 2026)

## Overview
- Release Type: Major-series beta (v6). Contains breaking type changes.
- Key Changes: `restrictTextSearchToAnchor` prop + enable/disable API on Comments; `fieldsToRemove` extended to reaction/recorder/all activity feature types; `PartialReactionAnnotation` index signature; type-only `@veltdev/types` entry chain; element-model `.d.ts` re-sync (TagPinAnnotation/enableFollowAlongMode/UserOptions removed/renamed); 16 enums converted to `as const` + string-literal unions.
- Breaking Changes: Yes — 16 enums (`EnumName.MEMBER` runtime access removed). Documented in upgrade-guide.mdx ONLY.

## Areas Requiring Updates

### Agent-3 — Data Models (`api-reference/sdk/models/data-models.mdx`)
- `#### PartialReactionAnnotation` (line 5566): add index-signature row `| `[key: string]` | `any` | No | Additional custom fields configured via `fieldsToRemove` |` — mirror `PartialActivityRecord` (line 6179). Priority: High.
- `#### ReactionAnnotationDataProvider` (config row 5944) and `#### RecorderAnnotationDataProvider` (config row ~6001): update `config` description to note `fieldsToRemove` is now supported (currently bare "Configuration for the data provider"). Priority: High.
- `ResolverConfig.fieldsToRemove` (line 5868): general definition already correct; no per-feature restriction stated there — leave, but ensure downstream matrix aligns. Priority: Low.
- UserOptions → Options rename (see dedicated item below). Priority: High.
- 16-enum representation: tables already use `Name | Value` (Value = string literal) or `type X = 'a' | 'b'` union form — already string-literal-friendly, NO structural reformat needed. Add a short callout near the enum group noting these are `as const` + string-literal unions requiring `import type` (link upgrade-guide). Priority: Low-Medium.
- Prose `.MEMBER` reference at line 5622 (CommentResolverSaveEvent / ResolverActions Note): reword to reference string values (already in parens) OR leave (member keys still valid on `as const`). Priority: Low.

### Agent-3 — API Methods (`api-reference/sdk/api/api-methods.mdx`)
- Add `enableRestrictTextSearchToAnchor()` / `disableRestrictTextSearchToAnchor()` as `CommentElement` methods (Params: `void`, Returns: `void`). Follow existing `#### method()` + Params/Returns/React Hook pattern near `getCommentElement()` (3873). Priority: High.
- Line 3398 `Params: user: User, userOptions?: UserOptions` → `Options` (see rename item). Priority: High.

### Agent-3 — UserOptions → Options reconciliation (CRITICAL, do not blind-rename)
- data-models.mdx has THREE relevant headings: `#### Options` (3446, `{grouping}` — unrelated), `#### Options` (7314, identity: `authToken/forceReset/throwError/context` — the real identify Options), `#### UserOptions` (7021, `replaceContacts/authToken/throwError` — stale name).
- `identify` second param type is `Options` (the 7314 shape). Reconcile/merge UserOptions (7021) into the canonical identity Options (7314) — decide whether `replaceContacts` belongs there — rather than renaming (which creates a THIRD `#### Options` collision).
- Duplicate `#### Options` anchors already exist → `#options` resolves to line 3446 (wrong). Resolve anchor ambiguity.
- Repoint inbound refs: api-methods.mdx:3398; snippets/velt-client-methods-json.mdx:15-16.

### Agent-3 — Backend SDK reference check (extended scope per precedent)
- backend-sdks/node.mdx:335 and backend-sdks/python.mdx:5064 mention `fieldsToRemove` only descriptively; neither claims comments/custom-only. No fieldsToRemove-coverage correction needed.
- backend-sdks/python.mdx:5205 uses `CommentResolverSaveEvent.` / `ResolverActions.` in prose (distinctness note) — Python SDK, string-constant world; leave unless Agent-6 aligns TS prose. Priority: Low.

### Agent-4 — Wireframes: NO-OP
- No new UI components/wireframes in this release. Verified. No changes to `ui-customization/features/async/comments/comment-dialog-components.mdx`.

### Agent-5 — Primitives: NO-OP
- No new primitive components or new props on existing primitives. Verified. No changes to `comment-dialog-primitives/overview.mdx`.

### Agent-6 — Feature docs + cross-repo alignment
- `async-collaboration/comments/customize-behavior.mdx`: add `restrictTextSearchToAnchor` section (enable/disable method pair) mirroring the `#### anonymousEmail` pattern (1742-1785). Include prop + attribute + enable/disable, React/Other Frameworks tabs. Priority: High.
- `self-host-data/reactions.mdx` (Note at 560-571): the "reaction resolver does NOT support fieldsToRemove" Note is now FALSE — rewrite to state reaction resolver accepts `fieldsToRemove`; add it to the config bullet list (562-567) and example (573-580). Priority: High.
- `self-host-data/recordings.mdx` (config 397-406): add `fieldsToRemove` to the config bullet list + example. Priority: High.
- `self-host-data/activity.mdx` (43-73, 340-357): "What gets stripped" says built-in feature types IGNORE `fieldsToRemove` (lines 67, 350) — now FALSE for the extended allowlist. Rewrite to reflect `fieldsToRemove` applies to reaction/recorder/all activity feature types. Priority: High.
- `self-host-data/overview.mdx`: "Where these are supported" matrix (391-397) — flip `reaction` and `recorder` from `—` to `✅`, and `activity` from "(for `custom` activity types)" to all feature types. Falsy-values note (385) already correct. Priority: High.
- `self-host-data/comments.mdx` (268-275): code example imports `CommentResolverSaveEvent` from `@veltdev/react` and uses `.STATUS_CHANGE` etc. VERIFY whether `@veltdev/react` still exports these `as const` objects as runtime values. If not, flip to string literals per upgrade guide; if yes, example is valid (optionally add `import type` guidance). Priority: Medium-High.
- Sidebar V2 (`async-collaboration/comments-sidebar/v2/customize-behavior.mdx`): Improvement 2 (explicit status filter overrides hide-resolved) and Bug Fix 2 (facet-count universe) are behavior refinements. No page documents them at that detail (nearest: `filterCount` 320, default filter 247). CHANGELOG-ONLY. Optional 1-line clarification. Priority: Low.

### Agent-7 — Repo-wide terminology
- `UserOptions` → `Options`: after Agent-3 reconciles, replace in `snippets/velt-client-methods-json.mdx:15-16`. Verify api-methods/data-models handled by Agent-3.
- `TagPinAnnotation`, `enableFollowAlongMode`, `disableFollowAlongMode`: ZERO current-docs occurrences (only sdk-changelog.mdx:79 mapping line — intentional). No replacements; confirm only.
- DO NOT edit `release-notes/archive/*` or `release-notes/version-6/*` (upgrade-guide Before examples + changelog mapping are intentional historical/instructional).

## Grep Audit — stale identifiers (current docs vs release-notes)
| Identifier | Current-docs hits | Release-notes hits (leave) | Action |
|---|---|---|---|
| `TagPinAnnotation` | 0 | sdk-changelog.mdx:79 | none |
| `enableFollowAlongMode` | 0 | sdk-changelog.mdx:79 | none |
| `disableFollowAlongMode` | 0 | sdk-changelog.mdx:79 | none |
| `UserOptions` | data-models.mdx:7021; api-methods.mdx:3398; snippets/velt-client-methods-json.mdx:15,16 | sdk-changelog.mdx:79 | rename → `Options` (reconcile anchors) |

## Grep Audit — enum `.MEMBER` runtime usage (16 enums)
| Enum | Current-docs code hits | Current-docs prose hits | Release-notes hits (leave) |
|---|---|---|---|
| `CommentResolverSaveEvent.` | self-host-data/comments.mdx:272-275 (4) | data-models.mdx:5622; python.mdx:5205 | — |
| `ResolverActions.` | — | data-models.mdx:5622 (x2); python.mdx:5205 | — |
| `PermissionResourceType.` | — | — | upgrade-guide.mdx:20,21,37,38 (Before examples) |
| other 13 enums | 0 | 0 | 0 |

## Implementation Sequence
1. Agent-3: data-models.mdx (PartialReactionAnnotation index sig, reaction/recorder config, enum callout, UserOptions→Options reconciliation) + api-methods.mdx (enable/disable methods, param rename).
2. Agent-4 / Agent-5: no-op (verify + report).
3. Agent-6: customize-behavior restrictTextSearchToAnchor; self-host-data reactions/recordings/activity/overview fieldsToRemove corrections; comments.mdx enum-example verification; sidebar changelog-only note.
4. Agent-7: snippets UserOptions→Options; confirm zero stale-identifier residue; skip archives/version-6.

## Quality Checklist
- [x] New index signature planned for data-models.mdx
- [x] New API methods planned for api-methods.mdx + customize-behavior.mdx
- [x] Code examples require React + Other Frameworks tabs
- [x] Breaking changes in upgrade-guide.mdx ONLY (not changelog)
- [x] fieldsToRemove capability corrections identified (docs currently contradict release)
- [x] UserOptions→Options anchor-collision flagged
- [x] Grep audit distinguishes current docs vs release-notes archives
- [x] Wireframes/primitives confirmed no-op
- [x] Log written to `.claude/logs/agent-2-planning-6.0.0-beta.3.md`
