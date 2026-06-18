Velt SDK Release Notes - v5.0.2-beta.34
Release Date: June 08, 2026

Summary
SDK	Files Changed	Insertions	Deletions
HTML/Vanilla (sdk)	316	+11332	-2568
React (sdk-react)	357	+2484	-831
This release ships client-controlled page info (setPageInfo / clearPageInfo), a new VeltMultiThreadCommentDialog React root component, a new VeltAutocompletePanel React primitive, three new thread-card React primitives, broad standalone primitive support across comment-bubble, comment-pin, sidebar-button, multi-thread-dialog, and inline-comments-section, plus a significant round of autocomplete and comment-dialog bug fixes.

Features

1. Client-Provided Page Info Override
What: Two new API methods let you supply your own page info (URL, title, path, etc.) that the SDK uses for all newly created data — comments, reactions, recordings, presence, cursors. Existing saved data is not affected.

client.setPageInfo(pageInfo, options?) — set the global page info used for newly created data.
client.clearPageInfo(options?) — revert to the SDK's automatic browser-derived page info.
Page info is also readable at setDocumentId / setDocuments call time via documentMetadata.pageInfo.

Note: the options.documentId field exists in the method signatures but is reserved for a future per-document scope. Only global page info ships in this release.

Why: Apps with client-side routing or custom URL schemes (e.g. hash-based navigation, embedded iframes) need to control the URL/title attached to new annotations rather than inheriting browser values that may be stale, incorrect, or undesired.

Impact: Opt-in; no change in default behavior. Newly created data for the current document will carry the provided page info fields. PageInfo is already a public type; the new fields are its standard URL-part fields.

API Methods:

client.setPageInfo(pageInfo: PageInfo, options?: { documentId?: string }): void;
client.clearPageInfo(options?: { documentId?: string }): void;
// Note: options.documentId is reserved for a future per-document scope;
// only global page info ships in this release.

Type:

class PageInfo {
  url?: string;
  path?: string;
  queryParams?: string;
  baseUrl?: string;
  title?: string;
  arrowUrl?: string;
  areaUrl?: string;
  commentUrl?: string;
  tagUrl?: string;
  recorderUrl?: string;
  screenWidth?: number;
  deviceInfo?: IDeviceInfo;
}

HTML:

<script>
  const client = Velt.getClient();
  client.setPageInfo({
    url: 'https://app.example.com/doc/42',
    title: 'Design Doc',
  });
  // Later, to revert:
  client.clearPageInfo();
</script>

React:

import { useSetPageInfo, useClearPageInfo } from '@veltdev/react';

function MyApp() {
  const { setPageInfo } = useSetPageInfo();
  const { clearPageInfo } = useClearPageInfo();

  useEffect(() => {
    setPageInfo({ url: 'https://app.example.com/doc/42', title: 'Design Doc' });
    return () => clearPageInfo();
  }, []);
}

2. VeltMultiThreadCommentDialog Root Component (React)
What: VeltMultiThreadCommentDialog is now exported as a standalone React root component. Previously only the sub-components (VeltMultiThreadCommentDialogList, VeltMultiThreadCommentDialogPanel, etc.) were exported; the root was absent from the React SDK.

Why: Developers embedding multi-thread comment dialogs programmatically needed the root React component to control the dialog directly rather than relying only on the HTML custom element.

Impact: Additive. The HTML element <velt-multi-thread-comment-dialog> (now also registered as a standalone custom element in this release) is still available for non-React use.

React:

import { VeltMultiThreadCommentDialog } from '@veltdev/react';

<VeltMultiThreadCommentDialog
  multiThreadAnnotationId="thread-123"
  readOnly={false}
  defaultCondition={true}
  onSaveComment={(e) => console.log(e)}
/>

Props:

Prop	Type	Default
annotationId	string	—
multiThreadAnnotationId	string	—
annotation	any	—
readOnly	boolean	false
defaultCondition	boolean	true
variant	string	—
inboxMode	boolean	false
onSaveComment	Function	—

Improvements

1. Standalone Primitive Support Extended Across Multiple Components
What: The following root components now support standalone primitives — sub-components that render with real annotation data when given only an annotation-id attribute, without requiring a parent root component on the page:

velt-comment-bubble — primitives like <velt-comment-bubble-avatar annotation-id="X"> now subscribe to annotation data independently.
velt-comment-pin — primitives like <velt-comment-pin-number annotation-id="X"> now load annotation data directly.
velt-multi-thread-comment-dialog — standalone primitives receive annotation context via multi-thread-annotation-id.
velt-inline-comments-section — primitives that share the same target-element-id now map to the same context, so standalone primitives co-locate with the root's data.
velt-sidebar-button — standalone <velt-sidebar-button-icon>, <velt-sidebar-button-comments-count>, <velt-sidebar-button-unread-icon> now use the shared 'default' context so they render with real data.

Why: The V2 primitives system is designed for component-by-component composition. Previously, most primitives only rendered correctly when nested inside their parent root element. This change makes each primitive usable on its own.

Impact: No breaking changes. Existing configurations keep working. Standalone usage becomes reliable: mount any primitive independently with annotation-id (or multi-thread-annotation-id / target-element-id) and it will render correctly.

2. New Thread-Card React Primitives
What: Three new standalone React components exported from @veltdev/react:

VeltCommentDialogThreadCardAssignButton — the assign-to button inside a thread card.
VeltCommentDialogThreadCardEditComposer — the inline edit composer inside a thread card.
VeltCommentDialogThreadCardReactionPin — the reaction pin inside a thread card.

Each wraps its corresponding HTML custom element with typed props for annotationId, commentObj, commentId, commentIndex, defaultCondition, and inlineCommentSectionMode (plus reactionId for the reaction pin).

Why: The thread card primitive set was incomplete for React — developers who wanted to wireframe individual thread-card sections lacked typed wrappers for these three sub-components.

Impact: Additive. The HTML elements (velt-comment-dialog-thread-card-assign-button, velt-comment-dialog-thread-card-edit-composer, velt-comment-dialog-thread-card-reaction-pin) already existed; this adds their React wrappers.

Props — VeltCommentDialogThreadCardAssignButton and VeltCommentDialogThreadCardEditComposer:

Prop	Type	Default
annotationId	string	—
defaultCondition	boolean	—
inlineCommentSectionMode	boolean	—
commentObj	any | string	—
commentId	number | string	—
commentIndex	number | string	—

Props — VeltCommentDialogThreadCardReactionPin:

Prop	Type	Default
annotationId	string	—
defaultCondition	boolean	—
inlineCommentSectionMode	boolean	—
reactionId	string	—
commentObj	any | string	—
commentIndex	number | string	—
index	number | string	—

3. VeltAutocompletePanel React Primitive
What: VeltAutocompletePanel is now exported as a standalone React primitive from @veltdev/react. It wraps <velt-autocomplete-panel> with typed props.

Why: The autocomplete panel is useful standalone (e.g. an inline user picker not tied to a text input), but the React SDK previously had no typed wrapper for it.

Impact: Additive.

React:

import { VeltAutocompletePanel } from '@veltdev/react';

<VeltAutocompletePanel
  type="contact"
  multiSelect={true}
  selectedFirstOrdering={true}
  defaultCondition={false}
/>

Props:

Prop	Type	Default
type	'contact' | 'generic'	'contact'
hideInput	boolean	false
placeholder	string	—
multiSelect	boolean	false
selectedFirstOrdering	boolean	false
readOnly	boolean	false
inline	boolean	false
enableOnFocus	boolean	false
position	'above' | 'below' | 'auto' | string	'auto'
defaultCondition	boolean	true

4. Notification Panel Content List: listType and documentId Inputs
What: notifications-panel-content-list and notifications-panel-content-load-more gain two new inputs for standalone use:

listType: 'all' (default) or 'for-you' — selects which notification feed to render from the shared context.
documentId: when set, renders notifications for that single document from notificationsByDocumentId.

Why: Developers building custom notification UIs sometimes need to render the "For You" feed separately from the "All" feed without duplicating the panel structure.

Impact: Additive; no change to existing usage. listType and documentId are ignored when [notifications] is bound directly.

Props:

Prop	Type	Default
listType	'all' | 'for-you'	'all'
documentId	string	—

5. New React Primitive: VeltInlineCommentsSectionFilterDropdownContentApplyButton
What: VeltInlineCommentsSectionFilterDropdownContentApplyButton is now exported from @veltdev/react. It is a React wrapper for the existing <velt-inline-comments-section-filter-dropdown-content-apply-button> HTML element, enabling the apply button inside the inline-comments-section filter dropdown to be used as a typed React primitive.

Why: The inline-comments-section filter dropdown primitive set lacked a React wrapper for its apply button, making it unavailable to React developers building custom filter UIs.

Impact: Additive. The HTML element already existed; this adds the typed React wrapper.

React:

import { VeltInlineCommentsSectionFilterDropdownContentApplyButton } from '@veltdev/react';

<VeltInlineCommentsSectionFilterDropdownContentApplyButton
  targetElementId="my-section"
  defaultCondition={true}
/>

Props:

Prop	Type	Default
targetElementId	string	—
defaultCondition	boolean	—

6. People Tab Populated for Org-Mode Notification Sessions
What: The notifications panel's People tab now correctly builds its notificationsByUserMap for org-mode sessions (where notificationsInSession is set directly rather than via getNotificationsWithoutOrganization).

Why: In org-mode sessions the existing user-map refresh path was not triggered, so the People tab appeared empty.

Impact: People tab now shows notification counts per user in org-mode without requiring any configuration change.

7. React SDK — Missing Props Added to Existing Components
What: Several existing React SDK wrapper components received previously-missing props that were already supported by the underlying HTML custom elements. The React TypeScript interfaces now match the full HTML attribute set:

VeltCommentDialog: Added multiThreadAnnotationId, darkMode, readOnly, sidebarMode, isFocusedThreadEnabled, openAnnotationInFocusMode, expandOnSelection, inlineCommentMode, inboxMode, isInsidePdfViewer, multiThread, commentComposerMode, dialogSelection, dialogMode, focusedThreadMode, pageModeComposer, messageTruncation, initialEditCommentIndex, messageTruncationLines, variant, composerPosition, sortBy, sortOrder, commentPinType, containerComponentId, targetElementId, targetComposerElementId, locationVersion, locationDisplayName, context, commentPlaceholder, replyPlaceholder.
VeltCommentDialogOptionsDropdownContent: Added commentObj, commentIndex, enableAssignment, enableEdit, enableNotifications, enablePrivateMode, enableMarkAsRead.

Why: The React wrappers were originally generated with a minimal prop set. These components accept the same attributes as their HTML counterparts, but the TypeScript interfaces did not expose them — so React developers who needed to pass these props had to use untyped workarounds.

Impact: No behavioral change. React developers can now pass all supported props with full TypeScript type safety. No migration required.

Props added to VeltCommentDialog:

Prop	Type	Default
multiThreadAnnotationId	string	—
darkMode	boolean	—
readOnly	boolean	—
sidebarMode	boolean	—
isFocusedThreadEnabled	boolean	—
openAnnotationInFocusMode	boolean	—
expandOnSelection	boolean	—
inlineCommentMode	boolean	—
inboxMode	boolean	—
isInsidePdfViewer	boolean	—
multiThread	boolean	—
commentComposerMode	boolean	—
dialogSelection	boolean	—
dialogMode	boolean	—
focusedThreadMode	boolean	—
pageModeComposer	boolean	—
messageTruncation	boolean	—
initialEditCommentIndex	number | string | null	—
messageTruncationLines	number | string	—
variant	string	—
composerPosition	string	—
sortBy	string	—
sortOrder	string	—
commentPinType	'bubble' | 'pin' | 'chart' | 'text'	—
containerComponentId	string	—
targetElementId	string	—
targetComposerElementId	string	—
locationVersion	string	—
locationDisplayName	string	—
context	any	—
commentPlaceholder	string	—
replyPlaceholder	string	—

Props added to VeltCommentDialogOptionsDropdownContent:

Prop	Type	Default
commentObj	any | string	—
commentIndex	number | string	—
enableAssignment	boolean	—
enableEdit	boolean	—
enableNotifications	boolean	—
enablePrivateMode	boolean	—
enableMarkAsRead	boolean	—

API Changes

1. New Public Methods: client.setPageInfo and client.clearPageInfo

client.setPageInfo(pageInfo: PageInfo, options?: { documentId?: string }): void;
client.clearPageInfo(options?: { documentId?: string }): void;
// Note: options.documentId is reserved for a future per-document scope;
// only global page info ships in this release.

See Features section for full documentation.

2. New React Hooks: useSetPageInfo and useClearPageInfo
What: Two new hooks exported from @veltdev/react wrap the page-info methods. Each returns a memoized callback:

import { useSetPageInfo, useClearPageInfo } from '@veltdev/react';

const { setPageInfo } = useSetPageInfo();
const { clearPageInfo } = useClearPageInfo();

setPageInfo(pageInfo);   // pageInfo: PageInfo
clearPageInfo();

useSetPageInfo manages state internally and calls client.setPageInfo only once the client is ready. As with the underlying methods, the optional options.documentId argument is reserved for a future per-document scope and is not yet active.

Bug Fixes

1. Contact List Fields No Longer Overridden by Central Database Data
What: updateContactList() now registers the provided contacts as authoritative via setContactListUsers(), preventing central-DB or resolver data from overriding customer-provided user fields (name, avatar, etc.) on subsequent user lookups.

Why: setUserByIds() (the previous call) participated in the shared user-merge logic, which allowed server-fetched user data to silently win over fields set by the customer.

Impact: User fields provided via updateContactList() now persist correctly through annotation resolution. No API changes.

2. Cross-Org Notification Org IDs Now Server-Hashed Before Going On the Wire
What: enableCrossOrganization({ organizationIds: [...], excludeOrganizationIds: [...] }) now server-hashes (md5) the customer-supplied org IDs before sending them to the cloud function and before comparing against the server-side index keys.

Why: The server index is keyed by hashed org IDs. Sending raw (client-facing) org IDs meant that an explicit allowlist always intersected to empty and an explicit blocklist silently no-oped, so filters never took effect.

Impact: organizationIds and excludeOrganizationIds filters on enableCrossOrganization() now work correctly.

3. Inline Assign Menu Visible Without assignToMenuOpened Toggle
What: When <velt-comment-dialog-assign-menu> is used in inline mode (inline="true" or bound via [inline]="true"), the menu now renders without requiring the assignToMenuOpened flag to be set first.

Why: assignToMenuOpened is only toggled by the in-dialog "Assign to" button — a control not present in inline layouts. The shouldShowAssignMenu guard was not accounting for inline mode, so inline assign menus never appeared.

Impact: Inline assign menus in standalone and custom wireframe layouts now render correctly.

4. Reaction Pin in Thread Card Renders When Accessed via Annotation ID
What: comment-dialog-thread-card-reaction-pin now renders correctly when the reaction is accessed via resolvedReactionAnnotationId() (the standalone/annotation-id path), not only when reactionId() is set directly.

Why: The visibility guard previously checked only reactionId(), which is empty when the pin is loaded standalone via annotation-id. The pin would be invisible in that case even when annotation data was fully loaded.

Impact: Reaction pins in standalone thread-card configurations now display correctly.

5. Sidebar Button Primitives Now Share Real Data Context
What: velt-sidebar-button now uses the fixed context ID 'default' instead of a randomly generated per-instance ID, and no longer clears this context on destroy.

Why: Standalone <velt-sidebar-button-icon>, <velt-sidebar-button-comments-count>, and <velt-sidebar-button-unread-icon> primitives register to the 'default' context. The parent was writing to a different (random) ID, so primitives never received data.

Impact: Standalone sidebar-button primitives now display comment counts and unread indicators correctly.

6. Autocomplete Group Binding and User Resolution Fixes
What: Several autocomplete edge cases fixed:

A parent-bound [group] now wins over a standalone groupObject input — a standalone groupObject no longer overrides or clears an inherited group.
The parent-group flag is cleared on unbind so subsequent standalone usage does not retain a phantom group.
userId resolution is re-run when userObject is cleared, so stale contacts from a previous user are not left in the chip.
groupId is re-armed after a parent clears the context so the correct group is used after parent resets.

Why: These conditions caused the autocomplete to either ignore the correct group context or retain stale user contact data across re-renders.

Impact: Autocomplete group and user resolution is consistent across parent-bound and standalone usage.

7. Comment Dialog Composer: Multiple Stability Fixes
What: Several edge cases in the comment dialog composer were fixed:

Submit during upload: Pending-but-not-yet-uploaded attachments are now considered submittable (no data loss on submit while upload completes).
Boolean attribute parsing: Present-but-empty boolean attributes (e.g. <velt-comment-dialog inline>) are now treated as true.
Inline vs dialog mode per-instance: inline-vs-dialog mode is now resolved per-component-instance; a shared config swap can no longer override the local instance's mode.
Auto-scroll baseline: The auto-scroll baseline is reset when the annotation config changes, preventing stale baseline comparisons on annotation swap.
Draft recording pruning: Draft recordings are pruned on delete, and userObject clearing triggers the correct cleanup chain.
Sidebar-mode in standalone dialog: <velt-comment-dialog annotation-id sidebar-mode> now correctly preserves its sidebar-mode layout instead of falling back to dialog mode.

Why: Each of these represented a silent failure in a specific interaction path in the standalone or programmatic dialog.

Impact: Composer reliability improved across upload, editing, standalone, and sidebar-mode configurations. No API changes.

Breaking Changes

Migration Guide

1. React — SidebarV2 Primitive Components Renamed (Plural to Singular)
All VeltCommentsSidebarV2* named exports (sub-components, not the root) have been renamed to VeltCommentSidebarV2* — dropping the s from Comments. The root component VeltCommentsSidebarV2 (with the s) is unchanged.

Affected exports (all 26 sub-component names):

Before	After
VeltCommentsSidebarV2Skeleton	VeltCommentSidebarV2Skeleton
VeltCommentsSidebarV2Panel	VeltCommentSidebarV2Panel
VeltCommentsSidebarV2Header	VeltCommentSidebarV2Header
VeltCommentsSidebarV2CloseButton	VeltCommentSidebarV2CloseButton
VeltCommentsSidebarV2EmptyPlaceholder	VeltCommentSidebarV2EmptyPlaceholder
VeltCommentsSidebarV2ResetFilterButton	VeltCommentSidebarV2ResetFilterButton
VeltCommentsSidebarV2List	VeltCommentSidebarV2List
VeltCommentsSidebarV2ListItem	VeltCommentSidebarV2ListItem
VeltCommentsSidebarV2PageModeComposer	VeltCommentSidebarV2PageModeComposer
VeltCommentsSidebarV2FocusedThread	VeltCommentSidebarV2FocusedThread
VeltCommentsSidebarV2FocusedThreadBackButton	VeltCommentSidebarV2FocusedThreadBackButton
VeltCommentsSidebarV2FocusedThreadDialogContainer	VeltCommentSidebarV2FocusedThreadDialogContainer
VeltCommentsSidebarV2MinimalActionsDropdown	VeltCommentSidebarV2MinimalActionsDropdown
VeltCommentsSidebarV2MinimalActionsDropdownTrigger	VeltCommentSidebarV2MinimalActionsDropdownTrigger
VeltCommentsSidebarV2MinimalActionsDropdownContent	VeltCommentSidebarV2MinimalActionsDropdownContent
VeltCommentsSidebarV2MinimalActionsDropdownContentMarkAllRead	VeltCommentSidebarV2MinimalActionsDropdownContentMarkAllRead
VeltCommentsSidebarV2MinimalActionsDropdownContentMarkAllResolved	VeltCommentSidebarV2MinimalActionsDropdownContentMarkAllResolved
VeltCommentsSidebarV2FilterDropdown	VeltCommentSidebarV2FilterDropdown
VeltCommentsSidebarV2FilterDropdownTrigger	VeltCommentSidebarV2FilterDropdownTrigger
VeltCommentsSidebarV2FilterDropdownContent	VeltCommentSidebarV2FilterDropdownContent
VeltCommentsSidebarV2FilterDropdownContentList	VeltCommentSidebarV2FilterDropdownContentList
VeltCommentsSidebarV2FilterDropdownContentListItem	VeltCommentSidebarV2FilterDropdownContentListItem
VeltCommentsSidebarV2FilterDropdownContentListItemIndicator	VeltCommentSidebarV2FilterDropdownContentListItemIndicator
VeltCommentsSidebarV2FilterDropdownContentListItemLabel	VeltCommentSidebarV2FilterDropdownContentListItemLabel
VeltCommentsSidebarV2FilterDropdownContentListCategory	VeltCommentSidebarV2FilterDropdownContentListCategory
VeltCommentsSidebarV2FilterDropdownContentListCategoryContent	VeltCommentSidebarV2FilterDropdownContentListCategoryContent

Before:

import {
  VeltCommentsSidebarV2Panel,
  VeltCommentsSidebarV2Header,
  VeltCommentsSidebarV2List,
} from '@veltdev/react';

After:

import {
  VeltCommentSidebarV2Panel,
  VeltCommentSidebarV2Header,
  VeltCommentSidebarV2List,
} from '@veltdev/react';

The root component is unaffected:

// Unchanged — root keeps the 's'
import VeltCommentsSidebarV2 from '@veltdev/react';
<VeltCommentsSidebarV2 />
