# UI Customization Templates (Wireframes & Primitives)

Style source of truth: `CLAUDE.md` (root). For wireframe **variables** pages, the canonical template is `WIREFRAME_VARIABLES_TEMPLATE.md` (repo root); follow it exactly; the summary here only covers wireframes and primitives pages.

Concepts:
- **Wireframes** = layout templates that re-skin Velt's built-in UI. React uses dot notation (`VeltCommentDialogWireframe.Header`); HTML uses kebab-case with `-wireframe` suffix (`velt-comment-dialog-header-wireframe`).
- **Primitives** = standalone building blocks for fully custom UIs. Flat React names (`VeltCommentDialogHeader`); HTML kebab-case without `-wireframe` (`velt-comment-dialog-header`).
- Never mix the two on one page. Comment Dialog wireframes live ONLY in `ui-customization/features/async/comments/comment-dialog-components.mdx`; its primitives live in the sibling primitives page. New feature areas get sibling `wireframes` and `primitives` pages under `ui-customization/features/async/<feature>/` or `.../realtime/<feature>/`, added to `docs.json` (wireframes entry first, primitives right after).

---

## 1. Wireframe page section (one component)

Heading depth mirrors the component tree: `##` root sections, `###` major children, `####`/`#####` deeper children. Past depth 5, use bold text instead of headings. Child headings carry the parent path in parentheses: `#### CloseButton (Panel Header)`.

```mdx
### Header (Panel)

<Tabs>
<Tab title="React / Next.js">
```jsx
<VeltWireframe>
    <VeltCommentsSidebarWireframe.Header>
        <VeltCommentsSidebarWireframe.CloseButton />
        <VeltCommentsSidebarWireframe.Search />
    </VeltCommentsSidebarWireframe.Header>
</VeltWireframe>
```
</Tab>
<Tab title="Other Frameworks">
```html
<velt-wireframe style="display:none;">
    <velt-comments-sidebar-header-wireframe>
        <velt-comments-sidebar-close-button-wireframe></velt-comments-sidebar-close-button-wireframe>
        <velt-comments-sidebar-search-wireframe></velt-comments-sidebar-search-wireframe>
    </velt-comments-sidebar-header-wireframe>
</velt-wireframe>
```
</Tab>
</Tabs>

#### CloseButton (Panel Header)

<Tabs>
<Tab title="React / Next.js">
```jsx
<VeltWireframe>
    <VeltCommentsSidebarWireframe.CloseButton />
</VeltWireframe>
```
</Tab>
<Tab title="Other Frameworks">
```html
<velt-wireframe style="display:none;">
    <velt-comments-sidebar-close-button-wireframe></velt-comments-sidebar-close-button-wireframe>
</velt-wireframe>
```
</Tab>
</Tabs>
```

Hard rules:
- Always show the `VeltWireframe` / `velt-wireframe` wrapper; the HTML wrapper always carries `style="display:none;"`.
- HTML wireframe tags are never self-closing.
- Use the EXACT component names from the SDK/release notes; never infer or rename.
- Older wireframe pages include screenshots in `Frame`; when generating new sections from release notes, do not add image references (no `Frame`/`img`) unless the image asset actually exists.
- Behavior/usage prose per component: ≤3 short bullets or ≤3 sentences.
- Every edit is mirrored in both tabs.

## 2. Primitives page skeleton

```mdx
---
title: <Feature> Primitives
description: <N>+ primitive components for building custom <Feature> interfaces.
---

<Note>
We recommend that you familiarize yourselves with [UI Customization Concepts](/ui-customization/overview) before attempting to modify any components.
</Note>

## Overview

The <Feature> Primitives API provides <N>+ granular components that can be used independently to build completely custom <feature> interfaces.

## Usage Patterns

### Pattern 1: Context Wrapper (Recommended)

Components are wrapped in a context wrapper that provides shared context to children.

<Tabs>
<Tab title="React / Next.js">
```jsx
<VeltFeatureContextWrapper someId="abc123">
  <VeltFeatureHeader />
  <VeltFeatureComposer />
</VeltFeatureContextWrapper>
```
</Tab>
<Tab title="Other Frameworks">
```html
<velt-feature-context-wrapper some-id="abc123">
  <velt-feature-header></velt-feature-header>
  <velt-feature-composer></velt-feature-composer>
</velt-feature-context-wrapper>
```
</Tab>
</Tabs>

### Pattern 2: ID-Based (Standalone)

[Same Tabs shape, passing IDs directly on each component.]

## Common Inputs

All <Feature> primitive components accept the following input.

| React Prop | HTML Attribute | Type | Default | Description |
|------------|----------------|------|---------|-------------|
| `defaultCondition` | `default-condition` | `boolean` | `true` | When `false`, the component always renders regardless of internal state. |

---

## Components

### VeltFeatureComponent

<One-sentence description.>

<Tabs>
<Tab title="React / Next.js">
```jsx
<VeltFeatureComponent />
```

**Props:** Common inputs only (see [Common Inputs](#common-inputs) section).
</Tab>
<Tab title="Other Frameworks">
```html
<velt-feature-component></velt-feature-component>
```

**Attributes:** Common attributes only (see [Common Inputs](#common-inputs) section).
</Tab>
</Tabs>

---

### VeltFeatureComponentWithProps

<One-sentence description.>

<Tabs>
<Tab title="React / Next.js">
```jsx
<VeltFeatureComponentWithProps someProp={true} />
```

**Props:**

| Prop | Type | Required | Description |
|------|------|----------|-------------|
| `someProp` | `boolean` | No | <One sentence.> |
</Tab>
<Tab title="Other Frameworks">
```html
<velt-feature-component-with-props some-prop="true"></velt-feature-component-with-props>
```

**Attributes:**

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `some-prop` | `string` | No | <One sentence; boolean attributes are the strings "true"/"false".> |
</Tab>
</Tabs>

---
```

Hard rules:
- Component order: root → children → sub-children (logical tree order, not alphabetical).
- Every component section ends with a `---` separator.
- Component description ≤1 sentence; prop description ≤1 sentence; Overview ≤3 sentences.
- React table columns `Prop | Type | Required | Description` (or `Default` instead of `Required` when defaults matter); HTML table mirrors it with `Attribute`. Prop names map camelCase → kebab-case 1:1.
- Components with no special props reference Common Inputs instead of repeating tables.
- No marketing language. No images. Both tabs always.
- If a compound props type exists in data-models, link it above the Tabs: `` Props: [`FeatureComponentProps`](/api-reference/sdk/models/data-models#featurecomponentprops) ``.

## 3. Wireframe variables pages (pointer)

Follow `WIREFRAME_VARIABLES_TEMPLATE.md` at the repo root exactly. Key reminders:
- Section order: Overview → state buckets (App/Data/UI/Feature State) OR Component Config (never both) → Common Props → Context-Specific Variables → Type Reference (slim table, link out) → Subcomponents → Deeply-Nested Wireframe Tags → "Putting it together" (exactly one combined Tabs example) → Related.
- Variable tables: `Variable | Type | Description | Example` (4-col) or `Variable | Type | Example` (3-col for subcomponent extras).
- Never invent variable names; only document what the source defines.
- Forbidden words: `Angular`, `ng-container`, `slot`/`sub-slot` (say "tag" or "sub-component").
- Don't restate template-variable mechanics; link to the template-variables overview instead.
