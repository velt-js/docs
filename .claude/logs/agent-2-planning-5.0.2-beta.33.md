# Release Update Plan for 5.0.2-beta.33

## Overview
- Release Type: Minor (new feature + improvement + 2 bug fixes)
- Key Changes: Cross-org "For You" notifications (new API + type), agent suggestion resolution banner (new primitives + wireframes), accept/reject no longer closes thread.
- Breaking Changes: No

## Local @veltdev/types Status
- `@veltdev/types` is NOT installed in node_modules (not found at any path).
- `@veltdev/react` v4.5.7 is installed — predates these features.
- CrossOrganizationConfig, enableCrossOrganization, userNotificationIndex, FirestorePaths: NONE locally verifiable.
- All new type shapes come verbatim from the release note and are safe to document exactly as specified. Do NOT invent any field not listed in the release note.

---

## Areas Requiring Updates

### 1. Data Models — New types/interfaces
**File:** `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`

**Safe to document (given verbatim in release note):**

**A. CrossOrganizationConfig** — Insert after `GetNotificationsDataQuery` (line 3315) and before `NotificationSettingsLayout` (line 3317), inside the `# Notifications` section.

Exact interface:
```
interface CrossOrganizationConfig {
  enabled?: boolean;
  organizationIds?: string[];
  excludeOrganizationIds?: string[];
  maxOrganizations?: number;          // default 20
  feeds?: ('forYou' | 'all')[];       // only 'forYou' supported; 'all' ignored with warning
}
```

Anchor: `#crossorganizationconfig`

**B. FirestorePaths** — New type. FirestorePaths does NOT currently exist anywhere in data-models.mdx (confirmed by search). Insert after `CrossOrganizationConfig` in the Notifications section, or create a new subsection.

Field to document: `userNotificationIndex?: string` — path to the global per-user notification index collection (opt-in, used by cross-org feature).

NOTE: Only `userNotificationIndex` is safe to document. Do NOT invent other fields for FirestorePaths — the full shape is not given in the release note. Flag remaining fields as "verify against @veltdev/types."

**C. CommentDialogAgentSuggestionBannerProps** — Decide whether a new props type is needed. The existing `CommentDialogAgentSuggestionProps` (data-models.mdx line 1983) covers parent props. The banner sub-components (BannerAvatar, BannerLabel, etc.) likely reuse `CommentDialogCommonProps`. Do NOT create a new type entry unless explicitly needed — the existing pattern for beta.32 AgentSuggestion sub-components all say "Props: Common inputs only." Follow that same pattern for all banner sub-components.

**Priority:** High (A + B); Low (C — likely not needed)

---

### 2. API Methods — New methods
**File:** `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`

**Insertion point (verified):** Inside `# Notifications > ### Configuration` section. Last method in Configuration before `### Actions` is `enableReadNotificationsOnForYouTab()` at line 1841. Insert the three new methods after `enableReadNotificationsOnForYouTab()` (line 1846), before `### Actions` (line 1849).

**Methods to add (safe — given verbatim):**

**A. enableCrossOrganization()**
- Params: `config?: CrossOrganizationConfig | null`
- Returns: `void`
- React Hook: `n/a`
- Behavior note: passing `null` or omitting normalizes to defaults and opts in; `{ enabled: false }` routes to disable.
- Link to: `/async-collaboration/notifications/customize-behavior#enablecrossorganization`

**B. disableCrossOrganization()**
- Params: none
- Returns: `void`
- React Hook: `n/a`
- Link to: `/async-collaboration/notifications/customize-behavior#disablecrossorganization`

**C. getCrossOrganizationConfig()**
- Params: none
- Returns: `CrossOrganizationConfig`
- React Hook: `n/a`
- Link to: `/async-collaboration/notifications/customize-behavior#getcrossorganizationconfig`

**D. getCrossOrganizationConfig$()**
- Params: none
- Returns: `Observable<CrossOrganizationConfig>`
- React Hook: `n/a`
- Link to: `/async-collaboration/notifications/customize-behavior#getcrossorganizationconfig-1` (use `-1` suffix or verify anchor)

DO NOT DOCUMENT: `setCrossOrganizationConfig` (private/internal).

**New banner primitives listing (Comments section of api-methods.mdx):**
- The beta.32 run added `VeltCommentDialogAgentSuggestion*` primitives to api-methods.mdx. The new banner primitives must also be added in the same Comments primitives listing.
- Search for the existing AgentSuggestion block in api-methods.mdx Comments section and append the banner primitives after `VeltCommentDialogAgentSuggestionActionsActionReject`.
- NOTE: Agent-3 must first verify where in api-methods.mdx the Comments primitives are listed before inserting. Run: `grep -n "VeltCommentDialogAgentSuggestion" /Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`

**Priority:** High

---

### 3. Feature Documentation — Notifications
**File:** `/Users/yoenzhang/Downloads/docs/async-collaboration/notifications/customize-behavior.mdx`

**Changes needed:** Add a new "Cross-Organization Notifications" subsection documenting:
- `enableCrossOrganization(config?)` usage with CrossOrganizationConfig fields
- `disableCrossOrganization()` usage
- `getCrossOrganizationConfig()` / `getCrossOrganizationConfig$()` usage
- React prop `enableCrossOrganization` on `<VeltNotificationsPanel>` and `<VeltNotificationsTool>` (boolean | string | CrossOrganizationConfig)
- HTML attribute `enable-cross-organization` on `<velt-notifications-panel>` and `<velt-notifications-tool>`
- Behavior: opt-in, For You tab only, current org always excluded, defaults to maxOrganizations=20

Anchors to create: `#enablecrossorganization`, `#disablecrossorganization`, `#getcrossorganizationconfig`

**Safe to document:** All prop/attribute names and CrossOrganizationConfig fields given in release note.

**Must verify before publish:** The detail of how `organizationIds` allowlist interacts with current-org exclusion — release note says "current org always excluded" regardless of allowlist. Document as stated.

**Priority:** High

---

### 3b. Self-Hosting Documentation — Flag Only
**File:** `/Users/yoenzhang/Downloads/docs/self-host-data/notifications.mdx`

**Scope:** This feature requires backend support (userNotificationIndex Firestore listener + getCrossOrgUserNotifications cloud function) and per-org resolver scoping for self-hosted installs. The self-host-data/notifications.mdx page currently exists but has no cross-org content.

**Action for downstream agents:** Add a note that cross-org notifications require backend configuration. DO NOT document the internal cloud function name (`getCrossOrgUserNotifications`) — it is an internal implementation detail. Only note that self-hosted installs require additional backend setup for this feature, with resolver scoping per org.

**Priority:** Medium — flag but do not block the main docs on this

---

### 4a. UI Customization — Wireframes (Comments)
**File:** `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog/wireframes.mdx`

**Verified structure:** The existing `VeltCommentDialogWireframe.AgentSuggestion` tree ends at `ActionReject` (line ~5188). The overview tree at lines 32/54 includes `<VeltCommentDialogWireframe.AgentSuggestion />`.

**Changes needed:**

**A. Add AgentSuggestion.Banner to the overview tree.** In the top-level component tree examples (React: lines ~32, HTML: ~54), add `<VeltCommentDialogWireframe.AgentSuggestion.Banner />` as a sibling after `<VeltCommentDialogWireframe.AgentSuggestion.Actions />`.

**B. Add new "Agent Suggestion Banner" wireframe subsection** after the existing `AgentSuggestion.Actions.ActionReject` block (line ~5192). Follow the exact same heading and code-block pattern as existing AgentSuggestion sub-sections.

Wireframe components to add (derived from HTML element names given in release note, following exact beta.32 naming convention):

| React wireframe component | HTML wireframe element |
|---|---|
| `VeltCommentDialogWireframe.AgentSuggestion.Banner` | `velt-comment-dialog-agent-suggestion-banner-wireframe` |
| `VeltCommentDialogWireframe.AgentSuggestion.Banner.Avatar` | `velt-comment-dialog-agent-suggestion-banner-avatar-wireframe` |
| `VeltCommentDialogWireframe.AgentSuggestion.Banner.Avatar.UserImage` | `velt-comment-dialog-agent-suggestion-banner-avatar-user-image-wireframe` |
| `VeltCommentDialogWireframe.AgentSuggestion.Banner.Avatar.StatusIcon` | `velt-comment-dialog-agent-suggestion-banner-avatar-status-icon-wireframe` |
| `VeltCommentDialogWireframe.AgentSuggestion.Banner.Label` | `velt-comment-dialog-agent-suggestion-banner-label-wireframe` |
| `VeltCommentDialogWireframe.AgentSuggestion.Banner.Separator` | `velt-comment-dialog-agent-suggestion-banner-separator-wireframe` |
| `VeltCommentDialogWireframe.AgentSuggestion.Banner.ResolverUserName` | `velt-comment-dialog-agent-suggestion-banner-resolver-user-name-wireframe` |
| `VeltCommentDialogWireframe.AgentSuggestion.Banner.Timestamp` | `velt-comment-dialog-agent-suggestion-banner-timestamp-wireframe` |

NAMING DERIVATION: HTML custom-element names given verbatim in release note. Wireframe names follow `-wireframe` suffix convention confirmed in existing file. React dot-notation derived by stripping `velt-comment-dialog-` prefix and converting kebab-to-TitleCase per established pattern.

**VERIFY:** Agent-4 must confirm the exact dot-path depth for `Banner.Avatar.UserImage` vs `Banner.AvatarUserImage` — the release note gives `-banner-avatar-user-image` and `-banner-avatar-status-icon` as sub-parts of `-banner-avatar`. This implies a 3-level nesting: `Banner > Avatar > (UserImage, StatusIcon)`. Follow that nesting.

**Priority:** High

---

### 4b. UI Customization — Primitives (Comments)
**File:** `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/comments/comment-dialog/primitives.mdx`

**Verified structure:** The last AgentSuggestion primitive is `VeltCommentDialogAgentSuggestionActionsActionReject` at line 4679, followed by `## Notes` at line 4703.

**Changes needed:** Add a new "Agent Suggestion Banner" sub-section directly after `VeltCommentDialogAgentSuggestionActionsActionReject` (after line 4701 `---`) and before `## Notes` (line 4703).

React component names (derived from HTML element names given in release note, matching beta.32 PascalCase convention):

| React component | HTML element |
|---|---|
| `VeltCommentDialogAgentSuggestionBanner` | `velt-comment-dialog-agent-suggestion-banner` |
| `VeltCommentDialogAgentSuggestionBannerAvatar` | `velt-comment-dialog-agent-suggestion-banner-avatar` |
| `VeltCommentDialogAgentSuggestionBannerAvatarUserImage` | `velt-comment-dialog-agent-suggestion-banner-avatar-user-image` |
| `VeltCommentDialogAgentSuggestionBannerAvatarStatusIcon` | `velt-comment-dialog-agent-suggestion-banner-avatar-status-icon` |
| `VeltCommentDialogAgentSuggestionBannerLabel` | `velt-comment-dialog-agent-suggestion-banner-label` |
| `VeltCommentDialogAgentSuggestionBannerSeparator` | `velt-comment-dialog-agent-suggestion-banner-separator` |
| `VeltCommentDialogAgentSuggestionBannerResolverUserName` | `velt-comment-dialog-agent-suggestion-banner-resolver-user-name` |
| `VeltCommentDialogAgentSuggestionBannerTimestamp` | `velt-comment-dialog-agent-suggestion-banner-timestamp` |

All banner sub-components use "Props: Common inputs only" pattern (same as all beta.32 AgentSuggestion sub-components). The root `VeltCommentDialogAgentSuggestionBanner` also uses common inputs only — no unique props are given in the release note.

Each entry follows the existing format: h3 heading, one-sentence description, Tabs with React/Other Frameworks code blocks, Props line.

**DO NOT add** a new props type to data-models.mdx for the banner — existing `CommentDialogCommonProps` covers all sub-components per the established pattern.

**Priority:** High

---

### 4c. UI Customization — Notifications Panel Props
**File:** `/Users/yoenzhang/Downloads/docs/ui-customization/features/async/notifications/notifications-panel/primitives.mdx`

The `enableCrossOrganization` prop is a prop on `<VeltNotificationsPanel>` (the host component), not on a primitive sub-component. The notifications primitives page documents sub-components only (VeltNotificationsToolIcon, etc.) — there is no `VeltNotificationsPanel` root component entry in that file.

**Action:** The `enableCrossOrganization` React prop and `enable-cross-organization` HTML attribute on `<VeltNotificationsPanel>` and `<VeltNotificationsTool>` should be documented in the feature docs (customize-behavior.mdx, covered in item 3 above), NOT in the primitives page.

**No changes needed** to notifications-panel/primitives.mdx or notifications-tool/primitives.mdx.

---

### 5. Upgrade Guide
No breaking changes. No update to `upgrade-guide.mdx` required.

---

## Items Explicitly NOT to Document
- `setCrossOrganizationConfig` — private/internal method
- `getCrossOrgUserNotifications` — internal cloud function name
- Internal CommentActionsService changes (Improvement 1 — behavior only, no API change; document only the user-visible behavior change: accept/reject no longer closes the thread — this is a prose note in the changelog already, no API doc update needed)
- Bug fix 1 (resolution banner rejected-styling fix) — internal behavior, no doc change
- Bug fix 2 (cross-org feed hardening) — no API change, no doc change

---

## Implementation Sequence
1. **Agent-3:** data-models.mdx — add `CrossOrganizationConfig` (after line 3315) and `FirestorePaths` with `userNotificationIndex` field. Verify whether CommentDialogAgentSuggestionBannerProps is needed (it is not, per pattern analysis).
2. **Agent-3:** api-methods.mdx — add 4 notification methods in `### Configuration` section after line 1846. Find and append banner primitives after existing AgentSuggestion primitives listing.
3. **Agent-3:** async-collaboration/notifications/customize-behavior.mdx — add Cross-Organization Notifications subsection.
4. **Agent-4:** wireframes.mdx — add Banner wireframe subsection + update overview tree.
5. **Agent-5:** primitives.mdx — add 8 Banner primitive component entries before `## Notes`.
6. **Agent-5 / Agent-3 coordination:** self-host-data/notifications.mdx — add backend requirement note for cross-org feature (low priority, non-blocking).

---

## Quality Checklist
- [ ] CrossOrganizationConfig added to data-models.mdx with exact interface from release note
- [ ] FirestorePaths.userNotificationIndex added to data-models.mdx (with "verify remaining fields" caveat)
- [ ] 4 notification methods added to api-methods.mdx Configuration section
- [ ] Banner primitives added to api-methods.mdx Comments primitives listing
- [ ] customize-behavior.mdx updated with cross-org feature docs including React prop + HTML attribute
- [ ] 8 banner wireframe components added to wireframes.mdx
- [ ] 8 banner primitive components added to primitives.mdx before ## Notes
- [ ] No breaking changes in upgrade-guide.mdx
- [ ] Private setCrossOrganizationConfig NOT documented anywhere
- [ ] Log file written to `.claude/logs/agent-2-planning-5.0.2-beta.33.md`
