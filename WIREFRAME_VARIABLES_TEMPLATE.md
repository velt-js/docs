# Wireframe Variables — Documentation Template

This is the authoring guide for **per-feature wireframe variable pages** in the public docs. Every feature in `sdk/docs/wireframe-variables/` should eventually have a matching MDX page in `ui-customization/features/...`. Use this template verbatim — consistency across features is the point.

> **Scope reminder.** "Wireframe variables" here means the dynamic template tokens (e.g. `{user.name}`, `{annotation.status}`) that are read by `velt-data` / `velt-if` / `velt-class` inside a `<velt-wireframe>`. They are **not** CSS variables. CSS variables are documented separately under `ui-customization/styling.mdx` and feature-level `variables.mdx` pages.

---

## 1. When to use this template

- Trigger: a feature has a source reference at `sdk/docs/wireframe-variables/<feature>.md` but no public-docs counterpart.
- Output: one new MDX page per source file, named exactly **`wireframe-variables.mdx`** (kebab-case, plural), placed inside the existing feature folder alongside `wireframes.mdx` and `primitives.mdx`.
- Title (in frontmatter): always **`<Feature Name> Wireframe Variables`**, where `<Feature Name>` matches the feature's `group` label in `docs.json`.

### Example placement

```
ui-customization/features/async/comments/comment-dialog/
├── wireframes.mdx              ← existing
├── primitives.mdx              ← existing
└── wireframe-variables.mdx     ← NEW (this template)
```

### Source → docs map

| Public docs page (to author) | Source file |
|---|---|
| `ui-customization/.../comment-dialog/wireframe-variables.mdx` | `sdk/docs/wireframe-variables/comment-dialog.md` |
| `ui-customization/.../comment-sidebar/wireframe-variables.mdx` | `sdk/docs/wireframe-variables/sidebar.md` |
| `ui-customization/.../notifications/panel/wireframe-variables.mdx` | `sdk/docs/wireframe-variables/notifications-panel.md` |
| `ui-customization/.../activity-logs/wireframe-variables.mdx` | `sdk/docs/wireframe-variables/activity-log.md` |
| ...one per file in `sdk/docs/wireframe-variables/` | (25 source files total) |

---

## 2. Mapped vs flat-config — pick one mode

The source `README.md` defines two access patterns. **Pick the one that matches the feature** and follow only that branch of the skeleton below.

| Pattern | Features | Variable form in tables |
|---|---|---|
| **Mapped** | Comment Dialog, Comments Sidebar, Comment Bubble, Inline Comments Section, Multi-Thread Comment Dialog, Text Comment, Notifications Panel, Notifications Tool, Activity Log | Bare names, e.g. `user`, `annotation`, `darkMode` |
| **Flat-config** | Cursor, Presence, Huddle, Recording, Transcription, View Analytics, Area, Arrow, Tag, Reactions, Selection, Rewriter, Comments Tool, Sidebar Button, Autocomplete | Explicit prefix, e.g. `componentConfig.user`, `componentConfig.cursorUsers` |

- **Mapped** features → keep the four state buckets (`App State` / `Data State` / `UI State` / `Feature State`). Drop any bucket the source has nothing for.
- **Flat-config** features → replace the four buckets with a single `## Component Config` section, and keep the "flat-config" `<Note>` callout in the skeleton.

---

## 3. Page skeleton (copy-paste scaffold)

Replace every `<Feature Name>`, every example variable, and the `<!-- comments -->` with real content from the source file. Delete sections that don't apply (mark each with a `<!-- comment -->` so it's obvious what's optional).

````mdx
---
title: <Feature Name> Wireframe Variables
description: Template variables exposed by the <Feature Name> wireframe — read them with velt-data, velt-if, and velt-class to drive dynamic content, conditional rendering, and class toggling.
---

<Note>
  New to wireframes? Start with [UI Customization Concepts](/ui-customization/overview) and the [Template Variables](/ui-customization/template-variables) overview.
</Note>

## Overview

The **<Feature Name>** wireframe exposes the variables below. Use them inside any `<velt-...-wireframe>` slot of this feature via three forms:

| You want to… | Use | Example |
|---|---|---|
| Display a value as text | `<velt-data field="var" />` | `<velt-data field="user.name" />` |
| Hide / show conditionally | `velt-if="{var}"` | `velt-if="{enableResolve}"` |
| Toggle a CSS class | `velt-class="'cls': {var}"` | `velt-class="'is-dark': {darkMode}"` |

{/* FLAT-CONFIG ONLY — delete this Note entirely for mapped features. */}
<Note>
  This feature uses the **flat-config** access pattern — variables must be referenced with the explicit `componentConfig.` prefix, e.g. `field="componentConfig.user.name"`.
</Note>

{/* ─────────────────────────────────────────────────────────────────
     MAPPED FEATURES — use the four buckets below.
     Drop any bucket the source has nothing for.
   ───────────────────────────────────────────────────────────────── */}

## App State

App-wide values: current user, admin flags, unread counts.

| Variable | Type | Description | Example |
|---|---|---|---|
| `user` | [`User`](/api-reference/sdk/models/data-models#user) | Currently identified end-user. | `<velt-data field="user.name" />` |
| `isUserAdmin` | `boolean` | True if the current user has admin role. | `velt-if="{isUserAdmin}"` |

## Data State

Per-annotation / per-document data: the annotation, comments, attachments.

| Variable | Type | Description | Example |
|---|---|---|---|
| `annotation` | [`CommentAnnotation`](/api-reference/sdk/models/data-models#commentannotation) | Annotation rendered by this wireframe instance. | `<velt-data field="annotation.from.name" />` |
| `editComment` | [`Comment`](/api-reference/sdk/models/data-models#comment) \| `null` | Comment currently being edited, if any. | `velt-if="{editComment}"` |

## UI State

Per-instance UI flags driven by the component itself.

| Variable | Type | Description | Example |
|---|---|---|---|
| `darkMode` | `boolean` | Dark mode active on the host page. | `velt-class="'is-dark': {darkMode}"` |
| `composerInOpenState` | `boolean` | Composer is currently expanded. | `velt-if="{composerInOpenState}"` |

## Feature State

Capability flags toggled via SDK config (e.g. `setCommentResolveEnabled`).

| Variable | Type | Description | Example |
|---|---|---|---|
| `enableResolve` | `boolean` | Resolve action enabled by config. | `velt-if="{enableResolve}"` |
| `canResolveAnnotation` | `boolean` | Current user is allowed to resolve. | `velt-if="{enableResolve} && {canResolveAnnotation}"` |

{/* ─────────────────────────────────────────────────────────────────
     FLAT-CONFIG FEATURES — delete the four buckets above and use
     this single section instead.
   ─────────────────────────────────────────────────────────────────

## Component Config

| Variable | Type | Description | Example |
|---|---|---|---|
| `componentConfig.user` | [`User`](/api-reference/sdk/models/data-models#user) | Currently identified end-user. | `<velt-data field="componentConfig.user.name" />` |
| `componentConfig.cursorUsers` | [`User`](/api-reference/sdk/models/data-models#user)`[]` | Active remote cursor users. | `<velt-data field="componentConfig.cursorUsers.0.name" />` |

   ───────────────────────────────────────────────────────────────── */}

{/* OPTIONAL — include only if the source has a "Context-Specific Variables" or
     "Subcomponent variables" section (variables only resolvable inside specific
     nested wireframe slots). Otherwise delete this whole section. */}

## Context-Specific Variables

These are only resolvable inside the nested wireframe slots noted in the **Available in** column.

| Variable | Type | Available in | Example |
|---|---|---|---|
| `commentObj` | [`Comment`](/api-reference/sdk/models/data-models#comment) | `<velt-comment-dialog-thread-card-wireframe>` and descendants | `<velt-data field="commentObj.text" />` |
| `commentIndex` | `number` | Same as above. `0` on the parent comment. | `velt-if="{commentIndex} === 0"` |

## Putting it together

A typical wireframe combining several variables:

<Tabs>
<Tab title="React / Next.js">
```jsx
<VeltCommentDialogWireframe.ResolveButton>
  <button velt-if="{enableResolve} && {canResolveAnnotation}">
    <velt-data field="user.name" />: Resolve
  </button>
</VeltCommentDialogWireframe.ResolveButton>
```
</Tab>
<Tab title="Other Frameworks">
```html
<velt-comment-dialog-resolve-button-wireframe>
  <button velt-if="{enableResolve} && {canResolveAnnotation}">
    <velt-data field="user.name"></velt-data>: Resolve
  </button>
</velt-comment-dialog-resolve-button-wireframe>
```
</Tab>
</Tabs>

## Related

- [<Feature Name> Wireframes](./wireframes) — composition reference for the wireframe slots themselves.
- [<Feature Name> Primitives](./primitives) — granular components if you don't need a full wireframe.
- [Template Variables](/ui-customization/template-variables) — overview of the `velt-data` / `velt-if` / `velt-class` system.
````

---

## 4. Authoring rules

### A. Frontmatter

| Field | Rule |
|---|---|
| `title` | Exactly `<Feature Name> Wireframe Variables`. `<Feature Name>` matches the `group` label in `docs.json` (e.g. `Comment Dialog`, `Notifications Panel`, `Activity Log`). |
| `description` | One sentence. Must mention `velt-data`, `velt-if`, `velt-class` so the page indexes well for in-site search. |

### B. Variable table — 4 columns, no exceptions

| Column | Rule |
|---|---|
| **Variable** | Backticks around the name. Mapped features use bare names (`user`). Flat-config features use the full path (`componentConfig.user`). |
| **Type** | Backticks. If compound (`User`, `CommentAnnotation`, `Comment`, `Notification`, etc.), make the type name a markdown link to `/api-reference/sdk/models/data-models#<lowercased-type-name>`. Union types: write outside the backticks and escape with `\|` if inside a table cell, e.g. `` [`Comment`](...) \| `null` ``. |
| **Description** | One sentence. Start with the noun or verb — no leading "The …" / "A …". Use the source's "Notes" column when present; otherwise summarize the source's sample-value comment. |
| **Example** | One usage form, chosen by type:<br/>• booleans → `velt-if` / `velt-class`<br/>• primitives & nested-access roots → `velt-data`<br/>• arrays → `velt-data` with index<br/>Use the HTML self-closing form (`<velt-data field="…" />`) inline. The React/Other Frameworks tabs are reserved for the bottom **Putting it together** block. |

### C. Sample values — use Accordion sparingly

The source MD files include large JSON sample values per variable. **Do not paste these into the variable tables.** They balloon the page.

If a sample is genuinely useful (typically only for compound objects whose shape isn't obvious from the linked data-models page), put it in a collapsible `<Accordion>` immediately after the relevant table:

````mdx
<Accordion title="Sample value: annotation">
```json
{
  "annotationId": "ann-123",
  "from": { "userId": "u-1", "name": "Mayank" },
  "comments": [/* ... */],
  "status": { "id": "open", "name": "Open", "color": "#FF9F4A" }
}
```
</Accordion>
````

**Default is omit.** The linked data-models page is the source of truth for shape.

### D. "Putting it together" example

- Always exactly one realistic wireframe combining 2–4 variables — enough to show real-world usage, not a kitchen sink.
- Always wrapped in `<Tabs>` with two tabs titled exactly `"React / Next.js"` and `"Other Frameworks"` (matches sibling pages).
- React tab uses the dot-notation wireframe component (e.g. `<VeltCommentDialogWireframe.ResolveButton>`) wrapping HTML that still uses `velt-if` / `velt-data` attributes — the tokens themselves are framework-agnostic.
- Other Frameworks tab uses the kebab-case web component (e.g. `<velt-comment-dialog-resolve-button-wireframe>`).

### E. Context-specific variables — only when applicable

Some sources document variables only resolvable inside specific nested slots:
- `commentObj`, `commentIndex` inside thread-card descendants
- `notification` inside notifications-panel rows
- `focusedAnnotation` inside the sidebar
- `activity`, `dateGroup` inside activity-log iteration slots

When present, add the optional `## Context-Specific Variables` section with an extra **Available in** column. Otherwise omit the section entirely.

### F. Related links

End every page with a `## Related` section linking to:

1. The sibling `wireframes` page (relative path `./wireframes`)
2. The sibling `primitives` page (relative path `./primitives`)
3. `/ui-customization/template-variables` (absolute path)

This closes the loop between the three pages of every feature group.

### G. Navigation registration (`docs.json`)

After authoring the page, register it in navigation:

1. Open `docs.json`.
2. Find the `group` matching the feature name (e.g. `"group": "Comment Dialog"`).
3. Add the new page path to its `pages` array, immediately after the existing `wireframes` entry:

```json
{
  "group": "Comment Dialog",
  "pages": [
    "ui-customization/features/async/comments/comment-dialog/wireframes",
    "ui-customization/features/async/comments/comment-dialog/wireframe-variables",
    "ui-customization/features/async/comments/comment-dialog/primitives"
  ]
}
```

The pattern of registering a `variables`-style sibling page already exists for `arrows/variables` and `huddle/variables` — mirror it.

---

## 5. Anti-patterns — explicitly do NOT do these

- ❌ **Do not rename the four state buckets**, even if the source mixes them. Keep `App State`, `Data State`, `UI State`, `Feature State` exactly as-is.
- ❌ **Do not include the SDK source's "shouldShow" tables, deeply-nested wireframe slot lists, or per-primitive props/classes.** Those belong on `primitives.mdx`, not on this page.
- ❌ **Do not restate template-variable mechanics** (operators, path resolution, `safeEval`, nested-access rules). Link to `template-variables.mdx` instead — DRY.
- ❌ **Do not add a CSS variables section.** That's covered by `styling.mdx` and feature-level `variables.mdx` (CSS-only) pages, which are unrelated to wireframe template variables despite the name overlap.
- ❌ **Do not paste large JSON sample values directly into variable tables.** Use an `<Accordion>` if and only if the shape isn't obvious from the linked type — and even then, only for the 1–2 most-used compound objects per page.
- ❌ **Do not invent variable names.** If a name isn't in the source MD file, it's not supported — leave it out.

---

## 6. Authoring checklist

Before merging a new wireframe-variables page, confirm:

- [ ] Filename is exactly `wireframe-variables.mdx` and lives next to `wireframes.mdx` / `primitives.mdx`.
- [ ] Frontmatter `title` matches the feature's `group` label in `docs.json`.
- [ ] Mapped vs flat-config decision matches the table in §2.
- [ ] All variable tables have exactly the 4 columns from §4B.
- [ ] All compound types in the **Type** column link to the correct `data-models` anchor.
- [ ] Each row's **Example** uses the right form for its type (`velt-data` / `velt-if` / `velt-class`).
- [ ] Exactly one `## Putting it together` block exists, wrapped in `<Tabs>` with both framework variants.
- [ ] `## Related` links resolve (relative `./wireframes`, `./primitives`; absolute `/ui-customization/template-variables`).
- [ ] No `## Component Config` section coexists with the four state buckets — pick one.
- [ ] No CSS variables. No primitives. No deeply-nested slot lists.
- [ ] `docs.json` updated, with the new page registered immediately after the feature's `wireframes` entry.
