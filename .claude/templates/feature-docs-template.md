# Feature Documentation Templates

Skeletons for the three feature-doc page types plus the quickstart pattern.
Style source of truth: `CLAUDE.md` (root). Recent gold-standard example: `async-collaboration/suggestions/overview.mdx` (concept-first, consolidated single page).

---

## 1. Overview page

```mdx
---
title: "Feature Name"            # add "(Beta)" suffix while in beta
sidebarTitle: "Overview"
description: "One to three plain sentences: what the feature does and who it's for."
---

[Hook: 1 to 2 sentences. What the developer gets. No marketing adjectives.]

<Note>
[Prerequisite, if any: e.g. "This feature requires [Comments](/async-collaboration/comments/overview) to be set up first."]
</Note>

## How it works

<Steps>
<Step title="[Stage 1, imperative or noun]">
[1 to 2 sentences describing this stage of the pipeline.]
</Step>
<Step title="[Stage 2]">
[...]
</Step>
</Steps>

## Setup

<Steps>
<Step title="[Imperative action, e.g. Define targets]">
[Prose + code. Both framework tabs if code differs.]
</Step>
<Step title="[Next action]">
[...]
</Step>
</Steps>

## [Behavior notes / deeper sections as needed]

## Lifecycle & events            # reference tables at the END of the page

| Event | When it fires | Payload |
|---|---|---|
| `eventName` | [trigger] | [`TypeName`](/api-reference/sdk/models/data-models#typename) |

## Data model

[Table or short interface block; link compound types to data-models.mdx.]
```

Notes:
- Demos: overview pages may embed live demo iframes/screenshots in `Tabs` (one tab per mode/variant) with inline setup links: `[View Setup for Popover Comments](/async-collaboration/comments/setup/popover)`.
- Lead with concept and the how-it-works pipeline before any API detail. Don't open with "How to Use".
- Prefer ONE consolidated page for small features (overview + setup + behavior in one) over three thin pages. If you consolidate, update every cross-reference and `docs.json`.

## 2. Setup page

```mdx
---
title: "Setup"
---

[Optional: GIF or screenshot of the end result inside <Frame>.]

<Tabs>
<Tab title="React / Next.js">

<Steps titleSize="h2">
<Step title="Import Components">

```jsx
import { VeltProvider, VeltComments } from '@veltdev/react';
```
</Step>
<Step title="Add Component">

[1 sentence on where it goes and the key props.]

```jsx
<VeltComments streamMode={true} streamViewContainerId="scrolling-container-id" />
```
</Step>
<Step title="Test Integration">
[How to verify it works, concretely: what to click, what should appear.]
</Step>
</Steps>

</Tab>
<Tab title="Other Frameworks">

<Steps titleSize="h2">
<Step title="Add Component">

```html
<velt-comments stream-mode="true" stream-view-container-id="scrolling-container-id"></velt-comments>
```
</Step>
<Step title="Test Integration">
[...]
</Step>
</Steps>

</Tab>
</Tabs>

<RequestExample>

```jsx React / Next.js
import { VeltProvider, VeltComments } from '@veltdev/react';

export default function App() {
  return (
    <VeltProvider apiKey="API_KEY">
      <div id="scrolling-container-id">
        {/* Your content */}
        <VeltComments streamMode={true} streamViewContainerId="scrolling-container-id" />
      </div>
    </VeltProvider>
  );
}
```

```html HTML
<!DOCTYPE html>
<html>
  <body>
    <div id="scrolling-container-id">
      <velt-comments stream-mode="true" stream-view-container-id="scrolling-container-id"></velt-comments>
    </div>
  </body>
</html>
```

</RequestExample>
```

Notes:
- 2 to 5 steps per framework tab. Step titles are imperative.
- The `RequestExample` at the bottom is the complete, copy-paste-ready version with imports and wrapper.
- React fences `jsx`; full-page HTML fences `html`.

## 3. Customize-behavior page (method sections)

Heading scheme: `#` for feature areas (Threads, Messages, @Mentions). `####` for each method/prop. Method headings are plain text (no backticks, no `()` needed for props).

One method section:

```mdx
#### addCommentAnnotation

- Adds a new comment annotation programmatically.
- Params: [AddCommentAnnotationRequest](/api-reference/sdk/models/data-models#addcommentannotationrequest)
- Returns: [AddCommentAnnotationEvent](/api-reference/sdk/models/data-models#addcommentannotationevent)

<Tabs>
<Tab title="React / Next.js">
```jsx
// Hook
const { addCommentAnnotation } = useAddCommentAnnotation();
const result = await addCommentAnnotation(request);

// API Method
const commentElement = client.getCommentElement();
const result = await commentElement.addCommentAnnotation(request);
```
</Tab>
<Tab title="Other Frameworks">
```js
const commentElement = Velt.getCommentElement();
const result = await commentElement.addCommentAnnotation(request);
```
</Tab>
</Tabs>
```

Variations:
- **Event-driven method:** replace `Returns:` with `Event: [EventType](/api-reference/...)` and show subscribe + unsubscribe:

  ```jsx
  const subscription = commentElement.on('suggestionAccepted').subscribe((event) => { /* ... */ });
  subscription?.unsubscribe();
  ```

- **Component prop:** show `<VeltComments propName={value} />` (React) and `<velt-comments prop-name="value"></velt-comments>` (HTML) instead of method calls. Enable/disable pairs go in one block with `// Enable` / `// Disable` comments.
- **Multiple parameter shapes:** use one `CodeGroup` with labeled fences (` ```jsx Organization Level `), never extra Tabs.
- Add an `Info`/`Note` callout under the metadata bullets only when the method has a real caveat.

## 4. Quickstart pattern

`## Prerequisites` (bulleted: "Node.js (v14 or higher)", "A Velt account with an API key") → `## Setup` with `### Step N: Imperative Title` sections (Install Dependencies → Get Your API Key → Initialize Velt → Authenticate Users → Initialize Document → Add Feature Components → Verify Setup) → `## Debugging` (common pitfalls) → `## Complete Example` (`CodeGroup`, one fence per file, labeled `App.js - Root Component`) → `## Next Steps` (links).

## 5. Writing reminders for all feature docs

- Second person, present tense, imperative steps, sentences under ~20 words.
- No em-dashes; use commas/colons/semicolons or "by"/"because".
- Name exact props/methods/events in backticks; describe observable behavior, not internals.
- Both tabs always; exact tab titles `React / Next.js` then `Other Frameworks`.
- Prerequisites in a `Note` at the top, not buried mid-page.
- End-of-page reference tables (lifecycle, data model) rather than scattering them.
- Every method documented here should also exist in `api-reference/sdk/api/api-methods.mdx` (and `react-hooks.mdx` if it has a hook) with a `[Full Documentation →]` link pointing back to this section's anchor.
