# Verification checklist — v5.0.2-beta.33

**Why this exists:** The locally-installed `@veltdev` packages predate this release (`@veltdev/react` v4.5.7;
`@veltdev/types` not installed locally), so new shapes can't be verified locally. Most of this release was
documented **verbatim from the release note** (the full `CrossOrganizationConfig` interface and all method
signatures were given), which is low-risk. The items below are the few that were inferred or deliberately
omitted — confirm against the real `@veltdev/types` build / SDK PR #4370 + sdk-react PR #2003 before publish.
✅ confirmed · ❌ wrong (fix) · ❓ unverified.

## 1. Safe — documented verbatim from release note (spot-check only)
- [ ] `CrossOrganizationConfig` (data-models.mdx ~`#crossorganizationconfig`): all 5 fields + defaults
  (`maxOrganizations` 20; `feeds` only `'forYou'`; current org always excluded). Given verbatim — just confirm.
- [ ] Method signatures (api-methods.mdx): `enableCrossOrganization(config?: CrossOrganizationConfig | null)`,
  `disableCrossOrganization()`, `getCrossOrganizationConfig(): CrossOrganizationConfig`,
  `getCrossOrganizationConfig$(): Observable<CrossOrganizationConfig>`. Confirm return types & param.
- [ ] React prop `enableCrossOrganization` (boolean | string | CrossOrganizationConfig) + HTML attribute
  `enable-cross-organization` on `VeltNotificationsPanel`/`VeltNotificationsTool`.

## 2. Inferred — verify before publish
- [ ] **React Hook for the 4 cross-org methods**: documented as `React Hook: n/a` (release note gave no hooks).
  Confirm no `useEnableCrossOrganization` etc. hook actually ships.
- [ ] **Banner primitive props**: all 8 banner primitives documented as "Common inputs only" /
  `CommentDialogAgentSuggestionProps` (mirrors the beta.32 AgentSuggestion sibling pattern). Confirm the banner
  sub-components don't take additional/different props.
- [ ] **Banner React component names**: PascalCase names were derived from the release note's HTML element list
  (`velt-comment-dialog-agent-suggestion-banner-*`). Byte-match `VeltCommentDialogAgentSuggestionBanner*`
  (incl. `BannerAvatarUserImage`, `BannerAvatarStatusIcon`, `BannerResolverUserName`) against `declarations.d.ts`.

## 3. Deliberately NOT documented — confirm this was right
- [ ] `FirestorePaths.userNotificationIndex?: string` — SKIPPED. `FirestorePaths` is not documented anywhere in
  the docs; adding a one-field stub would misrepresent the type. If `FirestorePaths` should be documented (it's a
  self-hosting config type), that's a separate, larger task. Decide whether to add it properly.
- [ ] `setCrossOrganizationConfig` (private) — not documented (correct). Confirm it stays private.
- [ ] Internal cloud function `getCrossOrgUserNotifications` — not named in docs (correct).
- [ ] Improvement 1 (accept/reject no longer closes thread) & both bug fixes — captured in changelog prose only,
  no reference-doc change. Confirm no public API/prop changed (release note says none did).

## 4. Self-hosting
- [ ] `self-host-data/notifications.mdx` cross-org note (now placed after Overview): says cross-org needs a global
  per-user notification index + per-org resolver scoping, without naming internals. Confirm wording matches the
  actual self-hosting requirements once the backend contract is finalized.

## 5. Links/anchors (verified clean by Agent-6/7, re-confirm post-publish)
- [x] api-methods cross-org method links → `customize-behavior#enablecrossorganization` etc. resolve.
- [x] 8 banner Usage-Examples links → `primitives#veltcommentdialogagentsuggestionbanner` resolves.
- [x] changelog dead links fixed (was pointing to nonexistent `notifications/setup` and `comment-dialog-primitives/overview`).
- [x] pre-existing typo link `#enablereadnotificationsontheforyoutab` → `#enablereadnotificationsonforyoutab` fixed.
