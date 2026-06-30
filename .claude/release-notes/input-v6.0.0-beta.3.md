# Velt SDK Release Notes - v6.0.0-beta.3
Release Date: June 30, 2026

## Summary
| SDK | Files Changed | Insertions | Deletions |
|-----|--------------|------------|----------|
| HTML/Vanilla (sdk) | 151 | +6791 | -862 |
| React (sdk-react) | 4 | +14 | -4 |

## Features

### 1. [Comments] `restrictTextSearchToAnchor` — control the text-comment highlight fallback search

**What:** A new boolean control on `velt-comments` that decides how aggressively the SDK searches the DOM when re-locating a text comment's highlight. By default (`false`) the SDK now falls back to a wider (body-level, or location-scoped) search when the commented text is no longer found inside the comment's original anchor element. Setting it to `true` restricts the search to the anchor element only — no fallback — so a comment ghosts immediately if its anchor text is gone.

**Why:** Some apps re-render or move the DOM around a text comment's anchor element. When that happens the stored text can no longer be found under the original anchor, and the comment would ghost even though the text still exists elsewhere on the page. The body-level fallback recovers those comments. Apps that deliberately reuse the same text across regions (and never want a comment to re-bind outside its anchor) can opt out with this flag.

**Impact:** Customers get a single switch to choose between maximum highlight recovery (default, fallback enabled) and strict anchor-only matching. The default flips behavior toward recovery, so previously-ghosted text comments may now re-highlight (see Bug Fixes #1 for the underlying behavior change).

**Prop:**
| Prop / Attribute | Type | Default |
|------|------|---------|
| `restrictTextSearchToAnchor` / `restrict-text-search-to-anchor` | `boolean` | `false` |

**React:**
```jsx
<VeltComments restrictTextSearchToAnchor={true} />
```

**HTML:**
```html
<velt-comments restrict-text-search-to-anchor="true"></velt-comments>
```

**API Methods:**
```ts
commentElement.enableRestrictTextSearchToAnchor(): void;
commentElement.disableRestrictTextSearchToAnchor(): void;
```

**Example:**
```ts
const commentElement = client.getCommentElement();

// Restrict the highlight search to the anchor element only (no body-level fallback).
commentElement.enableRestrictTextSearchToAnchor();

// Allow the body-level fallback search before ghosting (default behavior).
commentElement.disableRestrictTextSearchToAnchor();
```

---

## Improvements

### 1. [Self-hosting] `fieldsToRemove` allowlist extended to reaction, recorder, and activity annotations

**What:** The self-hosting field allowlist (`fieldsToRemove`) — which moves customer-private top-level fields out of Velt's database and into the customer's own storage on write, then restores them from the resolver cache on read — now applies to reaction annotations, recorder annotations, and all activity feature types. Previously the `fieldsToRemove` extraction in `ActivityUtilsService` only ran for activities whose `featureType === 'custom'`; it now runs for every feature type (custom, comment, reaction, recorder, …). The reaction and recorder annotation resolver services now read `fieldsToRemove` from their data-provider config and expose it via a new internal config accessor on the resolver service, and both `ReactionUtilsService` and `RecorderUtilsService` strip/restore those fields around the Velt-DB write (`RecorderUtilsService` received the `stripRecorderAnnotationData` / merge counterpart alongside `ReactionUtilsService`'s reaction-annotation strip/restore). To support arbitrary custom fields, `PartialReactionAnnotation` gained an index signature (`[key: string]: any`).

**Why:** Self-hosting customers (e.g. Harvey) rely on the resolver system to keep their private data out of Velt's database. That guarantee previously only covered comments and custom activities, leaving reaction and recording metadata fields with no way to be self-hosted. Extending the same allowlist mechanism closes that gap. The activity-side change is also a correctness fix: a reaction embedded in an `ActivityRecord`'s `entityData` is written through the activity allowlist, which keeps `entityData` opaque and never re-filters it — so without removing the field on both the changed and unchanged code paths, an unchanged reaction activity could leak a customer-private field to Velt's database.

**Impact:** Customers can now list reaction- and recorder-specific custom fields (and any activity feature type's custom fields) in their resolver's `fieldsToRemove` config and have those values stored only in their own backend. The values still round-trip transparently on read via the resolver cache. Fields are matched on `!== undefined`, so falsy-but-meaningful values (`0`, `false`, `""`) are moved too.

**Example (reaction annotation data provider):**
```ts
// Fields listed here are written to your storage (stripped data) and deleted
// from the payload sent to Velt's database; they are restored on read.
reactionAnnotationDataProvider = {
  config: {
    fieldsToRemove: ['internalRef', 'tenantId'],
  },
  // ...resolver implementation
};
```

### 2. [Comments / Sidebar v2] Selecting a resolved status now surfaces resolved comments under "hide resolved" presets

**What:** In the v2 comment sidebar's filter engine, the "hide resolved by default" rule now treats an explicit status-field selection as an override. An annotation survives the hide rule when it is non-terminal **or** the user has explicitly selected its status in the status field filter. This applies to the `all`, `unread`, `read`, `open`, and `assignedToMe` quick-filter presets.

**Why:** Presets like `all` hide terminal (resolved) comments by design. But once a user explicitly picks "Resolved" in the status field filter, they clearly want to see resolved comments — the preset's default hide was suppressing the very comments they asked for.

**Impact:** Explicitly selecting a terminal/resolved status surfaces those comments even under presets that otherwise hide resolved comments, instead of returning an empty or short list.

---

## Bug Fixes

### 1. [Comments] Text comments failing to highlight are now recovered via a body-level fallback search

**What:** When a text comment's stored text can no longer be found inside its resolved anchor element, the SDK now retries the search in a wider scope before ghosting the comment. The fallback scope is `document.body` for body-anchored comments and the comment's location element for location-scoped comments (so the fallback never escapes the location and matches the same text in a different location/document). The highlight-resolution logic was refactored into two private service-internal helpers — one that runs anchor-first then falls back to the scoped search, and one that validates the matched nodes (excluding `<script>` content) exactly match the stored text. When the fallback recovers the text **outside** the original anchor, the comment's tracking baseline is re-pointed: `commonAncestorElement`, `commonAncestorContainer`, and `commonAncestorText` are updated together so the `MutationObserver` tracks later edits at the recovered location instead of the stale anchor.

**Why:** If an app re-rendered or restructured the DOM around a text comment's anchor element, the stored text was no longer locatable under that anchor and the comment ghosted — even though the text still existed elsewhere on the page (reported via the Varonis text-comment-not-highlighting RCA). The original code also only ever searched the single resolved anchor element, with no recovery path. Re-pointing all three baseline fields together is required because the observer compares the live text of `commonAncestorElement` against `commonAncestorText`, and recomputes occurrence against `commonAncestorContainer`; updating only the element would fire a spurious change on the first mutation and count occurrence against the wrong container.

**Impact:** Text comments whose anchor element went stale now re-highlight at their recovered location instead of silently ghosting. The fallback is the new default; customers who require strict anchor-only matching can opt out with `restrictTextSearchToAnchor` (see Features #1). The fallback reuses the same `calculateNodes(text, document.body, occurrence)` search the SDK already uses for body-anchored comments, so Velt-injected UI text (rendered in shadow DOM, outside `document.body.textContent`) is not matched.

### 2. [Comments / Sidebar v2] Facet counts now match the filtered list universe

**What:** The v2 comment sidebar's per-field facet option counts are now computed against the same hard boundaries as the visible list — page mode **and** the client/system filters (`setCommentSidebarFilters` / the `filters` input) — via a shared private filter stage helper used by both the facets computed and the list pipeline. Previously the facet universe was scoped only to the page-mode boundary, while the visible list was additionally bounded by client/system filters.

**Why:** Because the counts and the list were derived from different universes, a facet option could show a non-zero count that, when selected, filtered the list to nothing — e.g. an option reading "Resolved 1" that resolved to "No comments to display" once clicked.

**Impact:** Every per-option facet count can now be realized by selecting that option; counts and the resulting list can no longer disagree.

### 3. [Types] `@veltdev/types` no longer leaks phantom runtime values

**What:** `@veltdev/types` is a declarations-only package that ships zero JavaScript, but its published entry chain (`velt.d.ts` → `types.d.ts`) re-exported symbols with plain `export *`, which re-exports **values as well as types**. Every value-bearing export (53 enums, 19 element-model classes, 2 client-model classes — 74+ symbols) therefore became a "phantom value": it type-checked in a consumer's IDE and shipped in the `.d.ts`, but was `undefined` at runtime because the package contains no JS to back it. The fix makes the entire published entry chain type-only — all 22 `export * from …` became `export type * from …` in `types.d.ts`, and `velt.d.ts` re-exports `./types` as `export type *` while keeping the one intentional runtime handle (the `Velt` / `Snippyly` global). The 16 enums that appear in public method signatures or fields were additionally converted from nominal `enum` to `as const` object + string-literal-union type so consumers can still produce and pass values (see Breaking Changes #1).

**Why:** Customers hit this directly — e.g. `RevokeAccessOnType.DOCUMENT_UNSET` imported from `@veltdev/types` resolved to `undefined` at runtime. The defect was structural, not enum-specific: any new `enum`/`const`/`class` added to a re-exported module silently joined the category with no feedback loop (it compiled, shipped, and broke only at a consumer's runtime).

**Impact:** No value of any kind is reachable through the published types entry, so a consumer can no longer accidentally import a type-only symbol as a runtime value and get `undefined`. Enums used in signatures are now usable as string literals with full type-checking and autocomplete.

### 4. [Types] Published element-model declarations re-synced with the runtime SDK

**What:** The hand-maintained `.d.ts` files in the published `velt-sdk`, `velt-sdk-staging`, and `velt-sdk-dev` packages were stale and masked by `// @ts-nocheck`. This release removes `@ts-nocheck` from the entry/model declarations and re-syncs the public surface with the actual source (enforced going forward by a new `check-element-dts-parity.mjs` gate). Corrections include:

- **Signature accuracy:** numerous comment/cursor/arrow/tag/reaction/presence/notification methods typed `() => any` are now `() => void` (e.g. notification's `openHistoryPanel()` / `closeHistoryPanel()` / `toggleHistoryPanel()`); `RecorderElement.initRecording` is now `(type, panelId?) => Promise<void>` (was `=> any`).
- **Tag:** the stale `TagPinAnnotation` type alias was removed; it is now `TagAnnotation` throughout (the runtime has used `TagAnnotation` for some time). `getAllTagAnnotations` now returns `Observable<TagAnnotation[] | null>` (was `Observable<TagPinAnnotation[] | null>`).
- **Presence:** `enableFlockMode(options?)` / `disableFlockMode()` are now correctly typed, and `startFollowingUser(userId, name)` / `stopFollowingUser()` are now present in the published types. The stale `enableFollowAlongMode` / `disableFollowAlongMode` declarations were removed.
- **Notification:** `enableCrossOrganization(config?)` / `disableCrossOrganization()` and the typed `on<T>(action)` event subscription are now present in the published types.
- **Rewriter:** `on<T>(action)`, `askAi(request)`, `replaceText(request)`, and `addComment(request)` are now present in the published types.
- **Recorder:** `enableDarkMode()` / `disableDarkMode()` are now present in the published types.
- **Client:** `Snippyly.identify`'s second parameter is now typed `Options` (was the non-existent `UserOptions`).

**Why:** The published declarations had drifted from the runtime API, so `@veltdev/types` consumers saw methods that no longer existed, missed methods that did, and got `any` where a concrete return type was available. `@ts-nocheck` had been hiding these inconsistencies.

**Impact:** `@veltdev/types` consumers now get accurate types for the current runtime API surface — correct method names, correct return types, and the methods that actually exist. Consumers referencing removed/renamed type-only names (e.g. `enableFollowAlongMode`, `UserOptions`, `TagPinAnnotation`) should update to the current names (`TagPinAnnotation` → `TagAnnotation`).

### 5. [Comments] No `veltDynamicTemplate` context binding changes in this release

**What:** Pattern analysis of attachment-related field names (`attachment`, `commentObj`, `attachmentIndex`, `fileIndex`) in the SDK diff produced 5 matches, all in engineering spec documents (`specs/recording-resolver/design.md` and `specs/recording-resolver/spec.md`). No Angular template files (`.ts` or `.html`) introduced new context data-field bindings on `veltDynamicTemplate` in this release.

**Why:** The spec documents use `attachment` and related field names as prose when describing the recorder annotation resolver data model (part of the Improvements #1 self-hosting extension). These are design references, not template code.

**Impact:** No customer-facing template binding changes. `veltDynamicTemplate` context shape is unchanged.

---

## Breaking Changes

### 1. [Types] Enums in `@veltdev/types` are now string-literal unions, not runtime enum objects

**What:** 16 enums in `@veltdev/types` that appear in public method signatures were converted from nominal TypeScript `enum` to `as const` object + string-literal union type. Consumers can no longer import and use `EnumName.MEMBER` as a runtime value. The affected enums are `CommentStatus`, `ResolverActions`, `CommentResolverSaveEvent`, `AreaStatus`, `DocumentAccessType`, `CommentAccessMode`, `ServerConnectionState`, `ContactListScopeForOrganizationUsers`, `CommentSidebarSystemFiltersOperator`, `RevokeAccessOnType`, `PermissionSource`, `PermissionResourceType`, `UserPermissionAccessRole`, `UserPermissionAccessRoleResult`, `UserIndicatorPosition`, and `UserIndicatorType`.

**Why:** Combined with the type-only entry change (Bug Fixes #3), these enums would have produced compile errors if left as nominal enums. The `as const` + union pattern preserves full TypeScript type-checking and autocomplete while being safe to use as string literals.

**Impact:** Any consumer currently importing `CommentStatus.OPEN`, `RevokeAccessOnType.DOCUMENT_UNSET`, etc. as runtime values must migrate to string literals. (Before this release such an import already resolved to `undefined` at runtime as a phantom value; it is now a compile error that points you to the correct usage.) Full Before/After migration guide is below.

**Before:**
```ts
import { PermissionResourceType } from '@veltdev/types';

// PermissionResourceType.DOCUMENT was `undefined` at runtime (phantom value).
const resourceType = PermissionResourceType.DOCUMENT;
```

**After:**
```ts
import type { PermissionResourceType } from '@veltdev/types';

// Pass the string literal — typed as `PermissionResourceType` ('folder' | 'document' | ...).
const resourceType: PermissionResourceType = 'document';
```

---
