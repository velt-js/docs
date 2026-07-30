# API Reference Templates (Data Models, API Methods, React Hooks)

Style source of truth: `CLAUDE.md` (root).
Files: `api-reference/sdk/models/data-models.mdx`, `api-reference/sdk/api/api-methods.mdx`, `api-reference/sdk/api/react-hooks.mdx`.
These are dense indexes (roughly 500 to 600 `####` entries each). They contain signatures, links, and one-line descriptions, and **never** implementation details, configuration walkthroughs, or code examples. Those live in the feature docs the entry links to.

---

## 1. API method entry (api-methods.mdx)

Verbatim shape of a real entry:

```mdx
#### addCommentAnnotation()
Add a new comment annotation.
- Params: [AddCommentAnnotationRequest](/api-reference/sdk/models/data-models#addcommentannotationrequest)
- Returns: [AddCommentAnnotationEvent](/api-reference/sdk/models/data-models#addcommentannotationevent)
- React Hook: `useAddCommentAnnotation()`
- [Full Documentation →](/async-collaboration/comments/customize-behavior#addcommentannotation)
```

Rules:
- Heading: `#### methodName()` (with parentheses). Description on the next line, no blank line between, ≤2 sentences, imperative ("Add a new...", "Get the...").
- `Params:` link compound types to data-models anchors; `none` if no params. For multi-param methods, nest:

  ```mdx
  - Params:
    - `request:` [AddCommentRequest](/api-reference/sdk/models/data-models#addcommentrequest)
      - `editor: Editor`
      - `editorId?: string`
  ```

- `Returns:` exact shipped type. Get nullability right: `Promise<MediaStream | null>`, not `Promise<MediaStream>`. Plain primitives stay in backticks.
- `React Hook:` the hook name in backticks, or `n/a`.
- `[Full Documentation →](...)` points to the feature-doc section anchor where the method is actually demonstrated.
- Entries are grouped by feature area, roughly alphabetical within a group. Param descriptions ≤20 words.

## 2. React hook entry (react-hooks.mdx)

```mdx
#### useAddCommentAnnotation()
Hook to add a comment annotation
- Params: [AddCommentAnnotationRequest](/api-reference/sdk/models/data-models#addcommentannotationrequest)
- Returns: `addCommentAnnotation()`
- [Full Documentation →](/async-collaboration/comments/customize-behavior#addcommentannotation)
```

Rules: heading `#### useHookName()`; short lowercase description ("Hook to ..."), no trailing period required; `Params:` `void` when none; `Returns:` the function/value the hook yields; same Full Documentation link as the corresponding API method.

## 3. Data model entry (data-models.mdx)

```mdx
#### CommentAnnotation

---

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `annotationId` | `string` | Yes | Unique identifier for the comment annotation. Auto generated |
| `comments` | [`Comment`](#comment)`[]` | Yes | The list of all comments part of this annotation |
| `color` | `string` | No | Color used for the comment pin annotation |
```

Rules:
- Heading: `#### TypeName` (PascalCase, no parentheses), then a `---` rule, then the table.
- Columns exactly: `Property | Type | Required | Description`.
- Types in backticks; compound types link to their own anchor in the same file (`[`User`](#user)`); arrays append `[]`; unions written out (`[`Comment`](#comment)` | null`).
- Required column: `Yes` / `No` only.
- Descriptions ≤20 words; note auto-generated fields; add usage context only when the name doesn't carry it.
- Enums/string unions: list each value and when it applies.
- Group new types next to their feature's existing section; keep TypeScript-accurate field names (camelCase, `?` optionality reflected in the Required column, not in the property name).

## 4. Update checklist when a release adds or changes APIs

1. New type/interface/enum → add a data-models entry (section-appropriate placement, anchors lowercase).
2. New method → add an api-methods entry AND, if a hook exists, a react-hooks entry.
3. Method demonstrated in feature docs → ensure the customize-behavior (or setup) section exists and the `[Full Documentation →]` anchors match both ways.
4. Renamed/retyped API → update data-models + api-methods + react-hooks + every feature doc + changelog mention; grep the repo for the old name (this is what the Agent-6/7 alignment passes do).
5. Don't pad: if your edit grows a file >20% without adding new fields/methods, compress descriptions.
6. Never document internal-only fields (e.g. internal plan/config metadata) in public API references.
