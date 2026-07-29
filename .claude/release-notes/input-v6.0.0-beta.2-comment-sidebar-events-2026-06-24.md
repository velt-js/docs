Velt SDK Release Notes - v6.0.0-beta.2
Release Date: June 24, 2026

SDK / PR / Files / Insertions / Deletions
- HTML/Vanilla (sdk)  #4418  32  +1095  -224
- React (sdk-react)   #2037   4   +15   -58

This release migrates the V2 comment sidebar open/close, comment-click, and comment-navigation events from per-component @Output() callbacks onto the unified commentElement.on() event bus, removes the matching deprecated React props and the legacy sortData / enableUrlNavigation sidebar inputs (breaking changes for V2 sidebar consumers), and ships correctness fixes: a P1 fix so a restricted comment no longer silently drops programmatically-granted recipients on submit; a fix restoring reaction pin/tool rendering inside the comment dialog after the modular-SDK custom-element switch; and a rework of the V2 sidebar to render through a CDK overlay portal so its host tag no longer reserves an invisible full-height block. Sidebar filter facet counts are now absolute.

The new sidebar events are surfaced as web-component / element-API behavior, so they are identical for HTML/Vanilla and React consumers.

=========================================================
BREAKING CHANGES (Migration Guide)
=========================================================

1. V2 comment sidebar events moved from @Output() callbacks to the commentElement.on() bus
The V2 comment sidebar's sidebar open, sidebar close, comment click, and comment navigation-button click events are no longer emitted as @Output() callbacks on <velt-comments-sidebar-v2>. They are now emitted on the unified event bus and must be consumed via commentElement.on(<event>) (HTML) or useCommentEventCallback(<event>) (React).

Removed React props from VeltCommentsSidebarV2 (including deprecated V1 aliases): onSidebarOpen, openSidebar (deprecated alias), onSidebarClose, onCommentClick, onSidebarCommentClick (deprecated alias), onCommentNavigationButtonClick. Corresponding @Output() emitters removed from the HTML SDK component. Only onFullscreenClick remains an @Output() callback.

New event keys (defined in CommentEventTypes): sidebarOpen, sidebarClose, commentClick, commentNavigationButtonClick.

Before (React):
<VeltCommentsSidebarV2
  onSidebarOpen={(data) => console.log('opened', data)}
  onSidebarClose={() => console.log('closed')}
  onCommentClick={(data) => console.log('comment clicked', data)}
  onCommentNavigationButtonClick={(data) => console.log('nav', data)}
/>

After (React):
import { useCommentEventCallback } from '@veltdev/react';
import { useEffect } from 'react';
const sidebarOpen = useCommentEventCallback('sidebarOpen');
useEffect(() => { if (sidebarOpen) console.log('opened', sidebarOpen); }, [sidebarOpen]);
const sidebarClose = useCommentEventCallback('sidebarClose');
useEffect(() => { if (sidebarClose) console.log('closed'); }, [sidebarClose]);
const commentClick = useCommentEventCallback('commentClick');
useEffect(() => { if (commentClick) console.log('comment clicked', commentClick.annotation); }, [commentClick]);
const commentNav = useCommentEventCallback('commentNavigationButtonClick');
useEffect(() => { if (commentNav) console.log('nav', commentNav.annotation); }, [commentNav]);
// onFullscreenClick is unchanged — still a prop callback:
<VeltCommentsSidebarV2 onFullscreenClick={(data) => console.log('fullscreen', data)} />

Before (HTML):
<velt-comments-sidebar-v2 onSidebarOpen="..." onSidebarClose="..." onCommentClick="..." onCommentNavigationButtonClick="..."></velt-comments-sidebar-v2>

After (HTML):
<script>
  const commentElement = Velt.getCommentElement();
  commentElement.on('sidebarOpen').subscribe((data) => console.log('opened', data));
  commentElement.on('sidebarClose').subscribe(() => console.log('closed'));
  commentElement.on('commentClick').subscribe((data) => console.log('comment clicked', data?.annotation));
  commentElement.on('commentNavigationButtonClick').subscribe((data) => console.log('nav', data?.annotation));
</script>
onFullscreenClick is unaffected — it remains an @Output() callback on the V2 sidebar element.

2. sortData / sort-data input removed from the V2 comment sidebar
The legacy sortData input (React prop sortData?: 'asc' | 'desc' | 'none', HTML attribute sort-data) has been removed. It was a V1-parity default-ordering shim superseded by the explicit sortBy / sortOrder inputs (which always took precedence). Use sortBy and sortOrder.
Before:
// 'asc' → lastUpdated asc; 'none' → createdAt desc; other → lastUpdated desc
<VeltCommentsSidebarV2 sortData="asc" />
<velt-comments-sidebar-v2 sort-data="asc"></velt-comments-sidebar-v2>
After:
<VeltCommentsSidebarV2 sortBy="lastUpdated" sortOrder="asc" />
<velt-comments-sidebar-v2 sort-by="lastUpdated" sort-order="asc"></velt-comments-sidebar-v2>

3. enableUrlNavigation / enable-url-navigation (deprecated alias) removed from the V2 comment sidebar
The deprecated enableUrlNavigation input (HTML attribute enable-url-navigation) has been removed. Use urlNavigation (HTML attribute url-navigation), already the canonical input.
Before:
<VeltCommentsSidebarV2 enableUrlNavigation={true} />
<velt-comments-sidebar-v2 enable-url-navigation="true"></velt-comments-sidebar-v2>
After:
<VeltCommentsSidebarV2 urlNavigation={true} />
<velt-comments-sidebar-v2 url-navigation="true"></velt-comments-sidebar-v2>

=========================================================
API CHANGES
=========================================================
1. New comment sidebar events on the on() bus: sidebarOpen, sidebarClose, commentClick, commentNavigationButtonClick
What: Four new event keys added to CommentEventTypes and CommentEventTypesMap, each with its own payload interface. They replace the removed V2 sidebar @Output() callbacks (Breaking §1) and are delivered through commentElement.on() / useCommentEventCallback().
Why: Consolidating onto the single on() bus makes them consistent with the rest of the comment element's events (uniform subscription, consistent payload typing via CommentEventTypesMap).
Impact: Additive at the event-bus level (new keys), paired with removal of the old @Output() callbacks/props (see Breaking §1). Payloads carry the clicked annotation and its location/context where applicable.

Event keys:
const CommentEventTypes = {
  // ...existing
  SIDEBAR_OPEN: 'sidebarOpen',
  SIDEBAR_CLOSE: 'sidebarClose',
  COMMENT_CLICK: 'commentClick',
  COMMENT_NAVIGATION_BUTTON_CLICK: 'commentNavigationButtonClick',
};

Payload types:
/** Fired when the comment sidebar opens. Subscribe via commentElement.on('sidebarOpen'). */
interface SidebarOpenEvent { metadata?: VeltEventMetadata; }
/** Fired when the comment sidebar closes. Subscribe via commentElement.on('sidebarClose'). */
interface SidebarCloseEvent { metadata?: VeltEventMetadata; }
/** Fired when a comment is clicked in the sidebar list. Subscribe via commentElement.on('commentClick'). */
interface CommentClickEvent {
  documentId?: string | null;
  location?: Location | null;
  targetElementId?: string | null;
  context?: { [key: string]: any };
  annotation?: CommentAnnotation;
  metadata?: VeltEventMetadata;
}
/** Fired when the navigation ("go to") button on a sidebar comment is clicked. Subscribe via commentElement.on('commentNavigationButtonClick'). */
interface CommentNavigationButtonClickEvent extends CommentClickEvent {}

Used in: commentElement.on('sidebarOpen' | 'sidebarClose' | 'commentClick' | 'commentNavigationButtonClick') and React useCommentEventCallback(...).

Example (HTML):
const commentElement = Velt.getCommentElement();
commentElement.on('commentClick').subscribe((event) => {
  console.log(event?.annotation);
  console.log(event?.documentId, event?.targetElementId);
});

Example (React):
import { useCommentEventCallback } from '@veltdev/react';
import { useEffect } from 'react';
const commentClick = useCommentEventCallback('commentClick');
useEffect(() => {
  if (commentClick) { console.log(commentClick.annotation); console.log(commentClick.documentId, commentClick.targetElementId); }
}, [commentClick]);

=========================================================
IMPROVEMENTS
=========================================================
1. Comment sidebar filter counts are now absolute
What: In V2 sidebar filter dropdowns, each filter option's facet count is now absolute — it reflects how many annotations match that option across the entire (page-mode-scoped) annotation universe, and no longer changes as you apply active search text, quick filter, or other category selections. Previously counts were scoped to the current filter universe (AND used an exclude-self intersection with other active fields; OR was standalone within the quick-filter universe), so a selection elsewhere could shrink/grow a sibling option's count.
Why: A facet count that shifts as other filters are applied is hard to read. Absolute totals make counts a reliable indicator of how many comments each option would match.
Impact: Filter option counts are now stable. The page-mode universe is still applied as a hard boundary before counting — only per-filter scoping was removed. The filter-count attribute still toggles whether counts are shown.

2. Comment sidebar filter dropdown visual fixes (dark-mode funnel icon, checkbox alignment, selected-row color)
What: Styling fixes in the V2 sidebar filter dropdown:
- Filter funnel (trigger) icon now uses themed muted color (--velt-text-8, --velt-text-3 hover) instead of inheriting black, so it is visible in dark mode; it no longer turns accent-colored when filters are active (the --filter-selected host class is still applied for customer targeting but carries no default styling).
- Filter list-item checkbox indicator is now inline-flex + vertically centered (checkbox SVGs display: block), removing the inline-baseline descender gap.
- On a selected filter row, only the checkbox indicator picks up the accent color; the row's label/count keep normal text colors.
Why: Funnel icon invisible in dark mode; checkbox misaligned; full-row recolor reduced readability.
Impact: Visual-only refinements. No API change.

=========================================================
BUG FIXES
=========================================================
1. Restricted comments no longer drop programmatically-granted recipients on submit (P1)
What: With private mode enabled + explicit restricted user list (e.g. commentElement.enablePrivateMode({ type: 'restricted', userIds: ['user-2'] })), placing+submitting a new pin via the V2 comment dialog composer could silently collapse the persisted comment to author-only, dropping user-2. Regression from the multi-org visibility rework (organizationPrivate got a lossless fallback; the sibling restricted case read only from a lossy reverse-resolved picker state).
Why: Visibility has two representations: hashed context.accessFields tokens (Firestore queries, one-way) and the plaintext annotation.visibilityConfig.userIds mirror (display + edit). The composer-submit path for RESTRICTED_SELECTED_PEOPLE rebuilt userIds only from selectedVisibilityUsers, seeded by reverse-resolving one-way __velt_private_self:<hash> self-tokens against the contact list. A programmatic userId not in the contact list cannot be recovered from its hash, so it dropped, falling through to author-only.
Impact: Composer-submit now derives userIds by precedence: (0) lossless plaintext mirror annotation.visibilityConfig.userIds; (1) committed accessFields self-tokens, trusted only when every token resolves (legacy annotations without the mirror); (2) lossy picker state unioned with getPrivateModeConfig() (new-pin fallback); (3) restrictedSelf ([currentUser.userId]) only when merged set is empty. Seeding/display (deriveCurrentVisibility via new resolveSelectedPeopleUsers helper) also prefers the mirror. Optimistic visibility update now writes the plaintext mirror (visibilityConfig) in lockstep with hashed accessFields on every pick/deselect. Backward-compatible: annotations without the mirror behave as before.

2. Reaction pin and reaction tool render correctly inside the comment dialog again
What: After the modular-SDK switch to lazy custom elements, the reaction pin and reaction tool embedded in the comment-dialog thread card stopped rendering correctly (e.g. reaction-tool icon disappeared in 6.0.0-beta.1). This restores correct rendering. The thread-card reaction-pin embed now binds the property as [reactionId] (not attribute-style [reaction-id]) on <velt-reaction-pin>, and data-testid moves to the container element. SCSS selectors that styled app-reaction-tool now also match velt-reaction-tool / snippyly-reaction-tool custom-element tags.
Why: As <velt-reaction-tool> / <velt-reaction-pin> Angular Elements custom elements (lazy chunk), the property binding used an attribute-cased name the custom element didn't pick up as a property, and SCSS targeted only the old app-reaction-tool selector. For the reaction tool, the custom-element lifecycle delivers [template] after ngOnInit, so a late/undefined parent [template] clobbered the global wireframe getWireframe$ had already resolved. Fix extracts wireframe precedence into pure resolveReactionToolTemplate(serviceWireframe, parentTemplate) (serviceWireframe || parentTemplate), recomputing order-independently. Restores the 5.0.4 hierarchy: global velt-reaction-tool-wireframe wins; parent [template] is only a fallback.
Impact: Reaction pins and reaction tool render/style correctly inside the comment dialog thread card again; a registered global reaction-tool wireframe is no longer clobbered by the late [template] input.

3. V2 comment sidebar no longer reserves an invisible full-height block at its tag location
What: In default (non-embed/non-floating) mode, <velt-comments-sidebar-v2> host used to be forced height: 100%, reserving a full-height invisible block where the tag sits, even though the sidebar is position: fixed and pinned to the viewport edge. The sidebar now renders through a CDK overlay portal (attached to the overlay container on <body>) and is added/removed from the DOM on open/close, so the host tag is just an overlay anchor. Embed/floating mode still renders inline at the tag location.
Why: The fixed-position sidebar does not need host layout space; forced height: 100% created an invisible full-height block disrupting surrounding layout. Portaling (mirroring V1 cdkConnectedOverlay) decouples it from the tag location.
Impact: Default-mode sidebar no longer reserves layout space and is added/removed from DOM on open/close. Light/dark theme variables are now (re)declared on .velt-sidebar-container (root of the portaled subtree on <body>) so theme travels with portaled content. The default-condition="false" force-show escape hatch (wireframe/docs previews) is preserved.

4. Notification-resolver org id now falls back to the organization config
What: When resolving custom notification data via the data provider, the resolver organization id now falls back to docService.getOrganizationConfig()?.clientOrganizationId when neither an explicit organizationId argument nor docService.getDocumentPaths()?.clientOrganizationId is available (previously it fell through directly to an empty string).
Why: With an empty resolver org id, a self-hosting data provider is queried under the wrong (empty) org and returns nothing, so comment text / user PII fail to resolve.
Impact: Custom notification data resolution now has an additional org-id source before falling back to empty string, reducing empty-resolution cases. No public API change.
