# Release Notes Templates

Templates and rules for SDK changelogs, the upgrade guide, and client-facing release notes.
Source of truth for style: `CLAUDE.md` (root). Real-world reference: `release-notes/version-5/sdk-changelog.mdx`.

---

## 1. File routing

| Release content | Target file |
|---|---|
| Core SDK (comments, presence, auth, core APIs) | `release-notes/version-[MAJOR]/sdk-changelog.mdx` |
| TipTap only | `release-notes/version-[MAJOR]/tiptap-changelog.mdx` |
| BlockNote only | `release-notes/version-[MAJOR]/blocknote-changelog.mdx` |
| CodeMirror only | `release-notes/version-[MAJOR]/codemirror-changelog.mdx` |
| Lexical only | `release-notes/version-[MAJOR]/lexical-changelog.mdx` |
| ReactFlow only | `release-notes/version-[MAJOR]/reactflow-changelog.mdx` |
| Multi-editor or CRDT core | `release-notes/version-[MAJOR]/crdt-core-changelog.mdx` |
| Breaking changes | `release-notes/version-[MAJOR]/upgrade-guide.mdx` (ONLY here, never the changelog) |

`[MAJOR]` comes from the version prefix (`5.0.2-beta.33` → `version-5`).
New entries go at the TOP of the file, immediately after the frontmatter/`### Libraries` header. Entries are ordered newest → oldest.

## 2. Changelog entry skeleton

```mdx
<Update label="X.Y.Z-beta.N" description="Month D, YYYY">

### New Features

- [**FeatureName**]: Past-tense verb + what shipped, in 1 to 2 short sentences. State the exact prop/method/event in backticks. [Learn more →](/path/to/docs#anchor)

<Tabs>
<Tab title="React / Next.js">
```jsx
// Hook
const { data } = useNewHook();

// API Method
const element = client.getFeatureElement();
element.newMethod();
```
</Tab>
<Tab title="Other Frameworks">
```js
const element = Velt.getFeatureElement();
element.newMethod();
```
</Tab>
</Tabs>

### Improvements

- [**FeatureName**]: What got better and the observable effect. End with "No API change." when true.

### Bug Fixes

- [**FeatureName**]: Fixed an issue where X happened when Y. (Describe the broken behavior, then the fixed behavior: "now ...", "no longer ...".)

</Update>
```

Rules:
- `label` = exact version string, lowercase `beta`. `description` = human date, full month name: `June 5, 2026`.
- Section order is fixed: New Features → Improvements → Bug Fixes. Omit empty sections entirely. No other sections, ever (no Breaking Changes, no Warnings).
- Bullet anatomy: `- [**Feature**]: ` + past-tense action verb (Added, Fixed, Improved, Introduced, Removed, Expanded) + specifics. Behavior descriptions inside the bullet use present tense ("now appears", "no longer shows").
- One bullet per release-note item. Never merge items, even if related. 7 items in = 7 bullets out.
- Feature label mapping: "Cloud Functions" → `[**Access Control**]`; "Recorder / Player" → `[**Recorder**]`; "Comments / Wireframes" → `[**UI Customization**]`; client-level APIs (`setDocuments`, locations) → `[**Core**]`.
- Code examples only when they add clarity; ≤10 lines per tab; React tab shows Hook + API Method when a hook exists; React uses `client`, Other Frameworks uses `Velt`. No links in code.
- Never inline component/primitive tables, wireframe trees, or prop tables; summarize the count + key names and link: `[Learn more →](/ui-customization/...)`.
- Skip items marked `[Internal]`. Merge backend-only releases into the adjacent SDK release. Never mention customer names.
- Compression check: the generated entry should be ≤1.3× the length of the raw input fragment; tighten until ≈1.1×.

## 3. Real examples (verbatim from the live changelog)

New feature with no code needed:

```mdx
- [**Notifications**]: Opt-in cross-organization "For You" notifications. When enabled, notifications from the user's other organizations merge into the "For You" feed, sorted by timestamp (current-org wins on ID collision). Disabled by default. [Learn more →](/async-collaboration/notifications/customize-behavior#enablecrossorganization)
```

Improvement with explicit "no action" signal:

```mdx
- [**Core**]: Removed spurious "Missing or insufficient permissions" console errors in multi-org and user-switch flows. Org-scoped reads now run a permission check first and only block on an explicit denial. No API change.
```

Bug fix (broken behavior → fixed behavior):

```mdx
- [**Comments**]: Page-mode comments now respect the visibility selected in the dropdown at submit time. Previously they were always saved as public, regardless of the chosen visibility.
```

## 4. Upgrade guide entry (breaking changes only)

In `release-notes/version-[MAJOR]/upgrade-guide.mdx`, add under `## Breaking Changes` (which sits before `## How to Upgrade`):

```mdx
### [Short name of the breaking change]

[1 to 2 sentences: what changed and why the old usage stops working.]

**Before:**

<Tabs>
<Tab title="React / Next.js">
```jsx
// old usage
```
</Tab>
<Tab title="Other Frameworks">
```js
// old usage
```
</Tab>
</Tabs>

**After:**

<Tabs>
<Tab title="React / Next.js">
```jsx
// new usage
```
</Tab>
<Tab title="Other Frameworks">
```js
// new usage
```
</Tab>
</Tabs>
```

## 5. Client-facing release notes (A→B→C pipeline output)

File: `.claude/release-notes/release-notes-[month]-[year].mdx` (always a new file, never overwrite).

```mdx
Hey Velt Developers!

Here's what shipped from `vX.X.X` until `vY.Y.Y` across Comments, Access Control, Recorder, and Notifications.

:speech_balloon: **Comments**

- Added `featureName` to enable [specific workflow]. [Learn more](https://docs.velt.dev/async-collaboration/comments/overview).
- Introduced `apiMethod()` for programmatic control. [API docs](https://docs.velt.dev/api-reference/sdk/api/api-methods#apimethod).

:closed_lock_with_key: **Access Control**

- Added [User Permissions API](https://docs.velt.dev/api-reference/rest-apis/v2/permissions/get-permissions) with `viewer` and `editor` roles.

For full API examples and details, check the [Velt SDK Changelog](https://docs.velt.dev/release-notes/version-5/sdk-changelog).

Happy shipping! :rocket:
```

Rules: major items only (no minor fixes, CSS tweaks, internal refactors); ≤150 characters per bullet; preserve every link from the source and convert relative paths to full URLs by prepending `https://docs.velt.dev`; never add links that weren't in the source; emoji + bold category headers with a blank line after each; tone is friendly and developer-to-developer but still precise.

## 6. Checklist before committing a changelog entry

1. Correct changelog file for the library; entry inserted at the top.
2. `Update` label/date format exact; sections in order; empty sections omitted.
3. Every bullet: `[**Feature**]:` label, past-tense verb, ≤2 sentences, no fluff, no em-dashes.
4. Code tabs: exact titles, React first, `client` vs `Velt` correct, HTML not self-closing.
5. No breaking changes here; upgrade guide updated instead, with Before/After tabs.
6. Links absolute, anchors lowercase, "Learn more →" for anything that has a docs page.
7. Counts match: every item in the raw notes has exactly one bullet.
