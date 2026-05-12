# Wireframe Variables — Documentation Template

This is the authoring guide for **per-feature wireframe variable pages** in the public docs. Every feature in `sdk/docs/wireframe-variables/` should eventually have a matching MDX page in `ui-customization/features/...`. Use this template verbatim — consistency across features is the point.

> **Scope reminder.** "Wireframe variables" here means the dynamic template tokens (e.g. `{user.name}`, `{annotation.status}`) that are read by `velt-data` / `velt-if` / `velt-class` inside a `<velt-wireframe>`. They are **not** CSS variables. CSS variables are documented separately under `ui-customization/styling.mdx` and feature-level `variables.mdx` pages.

---

## 1. When to use this template

- Trigger: a feature has a source reference at `sdk/docs/wireframe-variables/<feature>.md` but no public-docs counterpart.
- Output: one new MDX page per source file, placed inside the existing feature folder alongside the existing `wireframes` and `primitives` files.
- Title (in frontmatter): always `<Feature Name> Wireframe Variables`, where `<Feature Name>` matches the feature's `group` label in `docs.json` (e.g. `Activity Logs`, `Comment Dialog`, `Notifications Panel`).

### Filename convention — match the siblings

Filenames in the docs repo are inconsistent across feature folders. **Match the convention used by the sibling `wireframes` / `primitives` files in the same folder.**

| Sibling files look like… | Use this filename |
|---|---|
| `wireframes.mdx`, `primitives.mdx` (bare) | `wireframe-variables.mdx` |
| `<feature>-wireframes.mdx`, `<feature>-primitives.mdx` (prefixed) | `<feature>-wireframe-variables.mdx` |

Examples:

```
ui-customization/features/async/comments/comment-dialog/
├── wireframes.mdx
├── primitives.mdx
└── wireframe-variables.mdx              ← bare convention

ui-customization/features/async/activity-logs/
├── activity-logs-wireframes.mdx
├── activity-logs-primitives.mdx
└── activity-logs-wireframe-variables.mdx  ← prefixed convention
```

### Source → docs map

| Public docs page (to author) | Source file |
|---|---|
| `ui-customization/.../activity-logs/activity-logs-wireframe-variables.mdx` | `sdk/docs/wireframe-variables/activity-log.md` |
| `ui-customization/.../comment-dialog/wireframe-variables.mdx` | `sdk/docs/wireframe-variables/comment-dialog.md` |
| `ui-customization/.../comment-sidebar/wireframe-variables.mdx` | `sdk/docs/wireframe-variables/sidebar.md` |
| `ui-customization/.../notifications/panel/wireframe-variables.mdx` | `sdk/docs/wireframe-variables/notifications-panel.md` |
| ...one per file in `sdk/docs/wireframe-variables/` | (25 source files total) |

---

## 2. Mapped vs flat-config — pick one mode

The source `README.md` defines two access patterns. **Pick the one that matches the feature** and follow only that branch of the skeleton below.

| Pattern | Features | Variable form in tables |
|---|---|---|
| **Mapped** | Comment Dialog, Comments Sidebar, Comment Bubble, Inline Comments Section, Multi-Thread Comment Dialog, Text Comment, Notifications Panel, Notifications Tool, Activity Log | Bare names, e.g. `user`, `annotation`, `darkMode` |
| **Flat-config** | Cursor, Presence, Huddle, Recording, Transcription, View Analytics, Area, Arrow, Tag, Reactions, Selection, Rewriter, Comments Tool, Sidebar Button, Autocomplete | Explicit prefix, e.g. `componentConfig.user`, `componentConfig.cursorUsers` |

- **Mapped** features → keep the four state buckets (`App State` / `Data State` / `UI State` / `Feature State`). Drop any bucket the source has nothing for. If the source MD has a separate "Per-instance Local UI State" bucket, fold it into `UI State` — do **not** add a fifth bucket.
- **Flat-config** features → replace the four buckets with a single `## Component Config` section, and keep the "flat-config" `<Note>` callout in the skeleton.

---

## 3. Page sections — required order

Every page follows this exact order. Sections in **(optional)** are included only when the source MD has the corresponding content.

1. Frontmatter
2. Intro `<Note>` linking to overview + template variables
3. `## Overview` (3-form usage table + mapped/flat-config note)
4. `## App State` / `## Data State` / `## UI State` / `## Feature State` (mapped) **or** `## Component Config` (flat-config)
5. `## Common Props` *(optional — include only if the feature documents shared attributes / signal inputs)*
6. `## Context-Specific Variables` *(optional — only when the source has it; include the alias `<Note>` directly under the table when the source mentions aliases)*
7. `## Type Reference` *(optional — slim summary table linking out to `data-models`; include when the page references 2+ compound types)*
8. `## Subcomponents` *(optional — one `### <subcomponent>` per item that has at least one of: extra variables, a `shouldShow` condition, a host class, or a meaningful example)*
9. `## Deeply-Nested Wireframe Tags` *(optional — flattens the long tail of leaf tags the source documents at the bottom)*
10. `## Putting it together` (always — exactly one realistic combined example, in `<Tabs>`)
11. `## Related` (always — links to siblings + template-variables overview)

---

## 4. Page skeleton (copy-paste scaffold)

Replace every `<Feature Name>`, every example variable, and the `<!-- comments -->` with real content from the source file. Delete sections that don't apply.

````mdx
---
title: <Feature Name> Wireframe Variables
description: Template variables exposed by the <Feature Name> wireframe — read them with velt-data, velt-if, and velt-class to drive dynamic content, conditional rendering, and class toggling.
---

<Note>
  New to wireframes? Start with [UI Customization Concepts](/ui-customization/overview) and the [Template Variables](/ui-customization/template-variables) overview.
</Note>

## Overview

The **<Feature Name>** wireframe exposes the variables below. Use them inside any `<velt-...-wireframe>` tag via three forms:

| You want to… | Use | Example |
|---|---|---|
| Display a value as text | `<velt-data field="var" />` | `<velt-data field="user.name" />` |
| Hide / show conditionally | `velt-if="{var}"` | `velt-if="{enableResolve}"` |
| Toggle a CSS class | `velt-class="'cls': {var}"` | `velt-class="'is-dark': {darkMode}"` |

{/* MAPPED FEATURES — include this line. */}
All variables are mapped — reference them by their short name. You do not need the `componentConfig.` prefix.

{/* FLAT-CONFIG FEATURES — replace the line above with this Note. */}
<Note>
  This feature uses the **flat-config** access pattern — variables must be referenced with the explicit `componentConfig.` prefix, e.g. `field="componentConfig.user.name"`.
</Note>

{/* ─────────────────────────────────────────────────────────────────
     MAPPED FEATURES — use the four buckets below. Drop any the
     source has nothing for. Fold any "Per-instance Local UI State"
     rows into UI State.
   ───────────────────────────────────────────────────────────────── */}

## App State

App-wide values resolved from the shared signal.

| Variable | Type | Description | Example |
|---|---|---|---|
| `user` | [`User`](/api-reference/sdk/models/data-models#user) | Currently identified end-user. | `<velt-data field="user.name" />` |
| `darkMode` | `boolean` | Dark mode active (global config or per-instance attribute). | `velt-class="'theme-dark': {darkMode}"` |

## Data State

Per-feature data: the live records, lists, and selection / filter state.

| Variable | Type | Description | Example |
|---|---|---|---|
| `annotation` | [`CommentAnnotation`](/api-reference/sdk/models/data-models#commentannotation) | Annotation rendered by this wireframe instance. | `<velt-data field="annotation.from.name" />` |
| `editComment` | [`Comment`](/api-reference/sdk/models/data-models#comment) \| `null` | Comment currently being edited, if any. | `velt-if="{editComment}"` |

## UI State

Per-instance UI flags driven by the component itself.

| Variable | Type | Description | Example |
|---|---|---|---|
| `isOpen` | `boolean` | Panel is open. | `velt-class="'is-open': {isOpen}"` |
| `composerInOpenState` | `boolean` | Composer is currently expanded. | `velt-if="{composerInOpenState}"` |
| `variant` | `string` | Per-instance variant tag set on the host element. | `<velt-data field="variant" />` |

## Feature State

Capability flags toggled via SDK config.

| Variable | Type | Description | Example |
|---|---|---|---|
| `isEnabled` | `boolean` | Feature is enabled in the SDK. | `velt-if="{isEnabled}"` |
| `enableResolve` | `boolean` | Resolve action enabled by config. | `velt-if="{enableResolve}"` |

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

{/* OPTIONAL — Common Props. Include if the source documents shared
     attributes that every primitive in this feature accepts. */}

## Common Props

Every <Feature Name> primitive accepts:

| React Prop | HTML Attribute | Type | Default | Description |
|---|---|---|---|---|
| `defaultCondition` | `default-condition` | `boolean \| "true" \| "false"` | `true` | When `false`, the component always renders regardless of internal state. |

Signal inputs (for parent-child component composition):
- `[componentConfigSignal]` — shared config signal.
- `[parentLocalUIState]` — per-instance UI state signal.

The root `<velt-...>` element additionally accepts attributes that map onto config and local UI state values: `dark-mode`, `variant`, `is-open`, etc.

{/* OPTIONAL — Context-Specific Variables. Only include if the source
     has variables only resolvable inside specific nested wireframe
     tags. Include the alias <Note> only when the source mentions
     aliases. */}

## Context-Specific Variables

These are only resolvable inside the nested wireframe tags noted in the **Available in** column. Each is injected by the iteration primitive that owns the tag.

| Variable | Type | Available in | Example |
|---|---|---|---|
| `commentObj` | [`Comment`](/api-reference/sdk/models/data-models#comment) | `<velt-comment-dialog-thread-card-wireframe>` and descendants | `<velt-data field="commentObj.text" />` |
| `commentIndex` | `number` | Same as above. `0` on the parent comment. | `velt-if="{commentIndex} === 0"` |

<Note>
  **Aliases:** `commentObj` ↔ `comment`. Either name resolves; the friendly short form is preferred.
</Note>

{/* OPTIONAL — Type Reference. A SLIM summary table linking to
     data-models. Do NOT inline full type field tables. Include only
     when 2+ compound types are referenced on the page. */}

## Type Reference

Types referenced by the variables above are documented in [Data Models](/api-reference/sdk/models/data-models):

| Type | Description |
|---|---|
| [`CommentAnnotation`](/api-reference/sdk/models/data-models#commentannotation) | The annotation thread (id, status, comments, etc.). |
| [`Comment`](/api-reference/sdk/models/data-models#comment) | A single message inside an annotation thread. |
| [`User`](/api-reference/sdk/models/data-models#user) | Identified end-user object. |

{/* OPTIONAL — Subcomponents. One `### <name>` per subcomponent that
     has at least one of: extra variables, a shouldShow condition,
     a host class, or a meaningful example. Use the Property/Value
     table for metadata. Use a 3-col Variable | Type | Example
     table (NO Description column) for extra variables. */}

## Subcomponents

Each subcomponent below has its own wireframe tag. The tables show extra variables beyond the common set, the `shouldShow` condition, and host CSS classes.

### `<feature>` (root)

- **Public element:** `<velt-<feature>>`
- **Wireframe tag:** `<velt-<feature>-wireframe>`

| Property | Value |
|---|---|
| Extra variables | None — root only sees common variables. |
| `shouldShow` | `isEnabled === true && isOpen === true` |
| Host class | `velt-<feature>--container` (always present) |

<Tabs>
<Tab title="React / Next.js">
```jsx
<Velt<Feature>Wireframe velt-if="{isEnabled} && {isOpen}">
  <Velt<Feature>Wireframe.Header />
  <Velt<Feature>Wireframe.Body />
</Velt<Feature>Wireframe>
```
</Tab>
<Tab title="Other Frameworks">
```html
<velt-<feature>-wireframe velt-if="{isEnabled} && {isOpen}">
  <velt-<feature>-header-wireframe></velt-<feature>-header-wireframe>
  <velt-<feature>-body-wireframe></velt-<feature>-body-wireframe>
</velt-<feature>-wireframe>
```
</Tab>
</Tabs>

---

### `<feature>-list-item`

A single row in the list.

- **Public element:** `<velt-<feature>-list-item>`
- **Wireframe tag:** `<velt-<feature>-list-item-wireframe>`

| Variable | Type | Example |
|---|---|---|
| `record` | [`SomeRecord`](/api-reference/sdk/models/data-models#somerecord) | `<velt-data field="record.title" />` |
| `record.user` | [`User`](/api-reference/sdk/models/data-models#user) | `<velt-data field="record.user.name" />` |
| `index` | `number` | `velt-if="{index} === 0"` |

| Property | Value |
|---|---|
| `shouldShow` | `record !== null` |

{/* OPTIONAL — Deeply-Nested Wireframe Tags. A flat reference for the
     long tail of leaf tags the source documents at the bottom (icon
     fragments, label fragments, sub-row pieces). One subgroup per
     parent area. */}

## Deeply-Nested Wireframe Tags

Each tag below has its own `<velt-<feature>-...-wireframe>` registration and inherits context variables from its parent.

### Header sub-components

| Tag | Notes | Example |
|---|---|---|
| `<velt-<feature>-header-title-wireframe>` | Header title text. | `<velt-data field="title" />` |
| `<velt-<feature>-header-close-button-wireframe>` | Close button. | (composes an icon + click target) |

### List-item sub-components

| Tag | Notes | Example |
|---|---|---|
| `<velt-<feature>-list-item-avatar-wireframe>` | Avatar of the row's actor. | `<velt-data field="record.user.photoUrl" />` |
| `<velt-<feature>-list-item-time-wireframe>` | Relative timestamp. | `<velt-data field="record.timestamp" />` |

## Putting it together

A typical row that highlights actions taken by the current user:

<Tabs>
<Tab title="React / Next.js">
```jsx
<Velt<Feature>Wireframe.List.Item>
  <div
    velt-class="'mine': {record.user.userId} === {user.userId}"
  >
    <velt-data field="record.user.name" />
    <velt-data field="record.action" />
    <velt-data velt-if="{record.target}" field="record.target.label" />
    <time><velt-data field="record.timestamp" /></time>
  </div>
</Velt<Feature>Wireframe.List.Item>
```
</Tab>
<Tab title="Other Frameworks">
```html
<velt-<feature>-list-item-wireframe>
  <div velt-class="'mine': {record.user.userId} === {user.userId}">
    <velt-data field="record.user.name"></velt-data>
    <velt-data field="record.action"></velt-data>
    <velt-data velt-if="{record.target}" field="record.target.label"></velt-data>
    <time><velt-data field="record.timestamp"></velt-data></time>
  </div>
</velt-<feature>-list-item-wireframe>
```
</Tab>
</Tabs>

## Related

- [<Feature Name> Wireframes](./<wireframes-filename>) — composition reference for the wireframe tags themselves.
- [<Feature Name> Primitives](./<primitives-filename>) — granular components if you don't need a full wireframe.
- [Template Variables](/ui-customization/template-variables) — overview of the `velt-data` / `velt-if` / `velt-class` system.
````

---

## 5. Authoring rules

### A. Frontmatter

| Field | Rule |
|---|---|
| `title` | Exactly `<Feature Name> Wireframe Variables`. `<Feature Name>` matches the `group` label in `docs.json`. |
| `description` | One sentence. Must mention `velt-data`, `velt-if`, `velt-class` so the page indexes well for in-site search. |

### B. Variable tables — table-shape depends on context

There are **two** table shapes used on the page. Match the right one to the context:

**Top-level state buckets** (App State / Data State / UI State / Feature State / Component Config) and **Context-Specific Variables** — 4 columns:

| Variable | Type | Description | Example |
|---|---|---|---|

(Context-Specific uses `Available in` instead of `Description`.)

**Subcomponent extra-variable tables** — 3 columns (no Description):

| Variable | Type | Example |
|---|---|---|

The Description column is dropped at the subcomponent level because the rows are typically nested-access shorthands (`record.user`, `record.user.userId`) where the example tells you everything you need.

### C. Column rules (apply to both table shapes)

| Column | Rule |
|---|---|
| **Variable** | Backticks around the name. Mapped features use bare names (`user`). Flat-config features use the full path (`componentConfig.user`). Nested-access rows in subcomponent tables use dot paths (`record.user.userId`). |
| **Type** | Backticks. If compound (`User`, `CommentAnnotation`, `Comment`, `Notification`, `ActivityRecord`, etc.), make the type name a markdown link to `/api-reference/sdk/models/data-models#<lowercased-type-name>`. Union types: write outside the backticks and escape with `\|` if inside a table cell, e.g. `` [`Comment`](...) \| `null` ``. Array types: append `[]` outside the backticks, e.g. `` [`User`](...)`[]` ``. |
| **Description** *(only on 4-col)* | One sentence. Start with the noun or verb — no leading "The …" / "A …". Use the source's "Notes" column when present; otherwise summarize the source's sample-value comment. |
| **Example** | One usage form, chosen by type:<br/>• booleans → `velt-if` / `velt-class`<br/>• primitives & nested-access roots → `velt-data`<br/>• arrays → `velt-data` with index<br/>Use the HTML self-closing form (`<velt-data field="…" />`) inline. The React/Other Frameworks tabs are reserved for the `<Tabs>` blocks. |

### D. Subcomponent Property/Value tables

For each subcomponent, put metadata in a 2-column **Property | Value** table. Standard properties (omit any row that doesn't apply):

| Property row | Use when | Example value |
|---|---|---|
| `Extra variables` | Always include this row. | `None — root only sees common variables.` or `None.` or `None beyond common variables.` |
| `shouldShow` | Source documents a `shouldShow` condition for the subcomponent. | `` `isEnabled === true && isOpen === true` `` |
| `Host class` | Source documents a CSS class always applied to the host element. | `` `velt-activity-log--container` (always present) `` |

If the subcomponent has extra variables, place the 3-col **Variable | Type | Example** table **above** the Property/Value table.

### E. Type Reference section

Keep it slim. **Do NOT inline full type field tables** — that duplicates content from `data-models.mdx`. The section is just a quick lookup table:

```mdx
## Type Reference

Types referenced by the variables above are documented in [Data Models](/api-reference/sdk/models/data-models):

| Type | Description |
|---|---|
| [`ActivityRecord`](/api-reference/sdk/models/data-models#activityrecord) | Core activity log object (id, featureType, actionType, actionUser, timestamp, etc.). |
```

The Description column is one short sentence — typically the type's purpose plus its 3–5 most-used fields in parentheses. Include the section only when the page references **2 or more** compound types.

### F. Sample values — use Accordion sparingly

The source MD files include large JSON sample values per variable. **Do not paste these into the variable tables.**

If a sample is genuinely useful (typically only for compound objects whose shape isn't obvious from the linked data-models page), put it in a collapsible `<Accordion>` immediately after the relevant table:

````mdx
<Accordion title="Sample value: annotation">
```json
{
  "annotationId": "ann-123",
  "from": { "userId": "u-1", "name": "Mayank" },
  "comments": [/* ... */]
}
```
</Accordion>
````

**Default is omit.** The linked data-models page is the source of truth for shape.

### G. Code examples — drop wrapper elements

Top-level rule: prefer attaching `velt-if` / `velt-class` directly to a real element rather than wrapping it in a structural container.

**Don't** use these wrappers in either tab:

```html
<!-- DON'T: Angular-specific structural directive container -->
<ng-container velt-if="{x}">
  <velt-data field="x.label"></velt-data>
</ng-container>

<!-- DON'T: redundant <velt-if> wrapper around a single <velt-data> -->
<velt-if velt-if="{x}">
  <velt-data field="x.label" />
</velt-if>
```

**Do** put `velt-if` directly on the element it controls:

```html
<!-- DO -->
<velt-data velt-if="{x}" field="x.label"></velt-data>
```

If the conditional truly wraps multiple elements, use a real DOM element (`<div>`, `<span>`, `<section>`) with `velt-if` as an attribute.

### H. "Putting it together" example

- Always exactly one realistic wireframe combining 2–4 variables — enough to show real-world usage, not a kitchen sink.
- Always wrapped in `<Tabs>` with two tabs titled exactly `"React / Next.js"` and `"Other Frameworks"` (matches sibling pages).
- React tab uses the dot-notation wireframe component (e.g. `<VeltCommentDialogWireframe.ResolveButton>`) wrapping HTML that still uses `velt-if` / `velt-data` attributes — the tokens themselves are framework-agnostic.
- Other Frameworks tab uses the kebab-case web component (e.g. `<velt-comment-dialog-resolve-button-wireframe>`).
- Position: place this section **after** Subcomponents and Deeply-Nested Wireframe Tags, **before** Related. It's the closing example.

### I. Related links

End every page with a `## Related` section linking to:

1. The sibling wireframes page — relative path matching the actual filename in this folder (`./wireframes` or `./<feature>-wireframes`).
2. The sibling primitives page — relative path matching the actual filename (`./primitives` or `./<feature>-primitives`).
3. `/ui-customization/template-variables` (absolute path).

This closes the loop between the three pages of every feature group.

### J. Navigation registration (`docs.json`)

After authoring the page, register it in navigation:

1. Open `docs.json`.
2. Find the `group` matching the feature name (e.g. `"group": "Activity Logs"`) under the **UI Customization** navigation tab.
3. Add the new page path to its `pages` array, between the existing `wireframes` and `primitives` entries:

```json
{
  "group": "Activity Logs",
  "pages": [
    "ui-customization/features/async/activity-logs/activity-logs-wireframes",
    "ui-customization/features/async/activity-logs/activity-logs-wireframe-variables",
    "ui-customization/features/async/activity-logs/activity-logs-primitives"
  ]
}
```

The same group label appears in multiple places in `docs.json` (Async Collaboration features, REST API, UI Customization). Make sure you edit the **UI Customization** entry, not the others.

### K. Forbidden terminology — never use these words

The public docs are framework-neutral. The source MD files come from an Angular-heavy SDK codebase and use vocabulary that leaks framework details — strip it. **Do not use any of these words anywhere on the page:**

| Don't write | Why | Use instead |
|---|---|---|
| `Angular` | Framework-specific name. | "parent-child component composition", or omit the framework reference entirely. |
| `<ng-container>` | Angular structural-directive container. | Drop the wrapper; put `velt-if` directly on the conditional element (see §G). |
| `slot` / `sub-slot` | Conflates with Web Components `<slot>` semantics; not what we mean here. | "tag" (for the markup-level meaning of `<velt-...-wireframe>`) or "sub-component" (for the conceptual subdivision). Use "values" if "slot" was being used in the sense of "field/property". |

If a source MD file uses any of these words, translate them as part of authoring.

---

## 6. Anti-patterns — explicitly do NOT do these

- ❌ **Do not rename the four state buckets**, even if the source mixes them. Keep `App State`, `Data State`, `UI State`, `Feature State` exactly as-is. Fold any "Per-instance Local UI State" rows into `UI State` — do not add a fifth bucket.
- ❌ **Do not inline full type field tables** in the Type Reference section. Link out to `data-models.mdx`; only summarize.
- ❌ **Do not restate template-variable mechanics** (operators, path resolution, `safeEval`, nested-access rules). Link to `template-variables.mdx` instead — DRY.
- ❌ **Do not add a CSS variables section.** That's covered by `styling.mdx` and feature-level `variables.mdx` (CSS-only) pages.
- ❌ **Do not paste large JSON sample values directly into variable tables.** Use an `<Accordion>` only when the shape isn't obvious from the linked type.
- ❌ **Do not invent variable names.** If a name isn't in the source MD file, it's not supported — leave it out.
- ❌ **Do not use forbidden terminology** (§K): no `Angular`, no `<ng-container>`, no `slot`/`sub-slot`.
- ❌ **Do not wrap a single `<velt-data>` in a `<velt-if>` or other structural container.** Put `velt-if` directly on the element (§G).

---

## 7. Authoring checklist

Before merging a new wireframe-variables page, confirm:

- [ ] Filename matches the sibling-files convention in the same folder (bare vs prefixed).
- [ ] Frontmatter `title` matches the feature's `group` label in `docs.json`.
- [ ] Mapped vs flat-config decision matches the table in §2.
- [ ] Top-level state buckets use the 4-col table (`Variable | Type | Description | Example`).
- [ ] Subcomponent extra-variable tables use the 3-col table (`Variable | Type | Example`).
- [ ] Subcomponent metadata uses the 2-col Property/Value table with the standard rows.
- [ ] All compound types in the **Type** column link to the correct `data-models` anchor.
- [ ] Type Reference section (if present) links out and does not inline field tables.
- [ ] Each row's **Example** uses the right form for its type (`velt-data` / `velt-if` / `velt-class`).
- [ ] Code examples never use `<ng-container>` or `<velt-if>` as a single-element wrapper.
- [ ] No forbidden terminology: search the page for `angular`, `ng-container`, `slot` (case-insensitive) — must return zero hits in prose, headings, and code.
- [ ] Exactly one `## Putting it together` block exists, wrapped in `<Tabs>` with both framework variants, positioned after Subcomponents and Deeply-Nested Wireframe Tags.
- [ ] `## Related` links resolve (relative paths match the sibling filenames; absolute `/ui-customization/template-variables`).
- [ ] No `## Component Config` section coexists with the four state buckets — pick one.
- [ ] No CSS variables on this page.
- [ ] `docs.json` updated under the **UI Customization** group (not API Reference or Async Collaboration), between the feature's `wireframes` and `primitives` entries.
