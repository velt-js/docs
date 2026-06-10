# CLAUDE.md: Velt Docs Writing Guide

This is the Mintlify docs site for the Velt SDK (`docs.velt.dev`). Navigation lives in `docs.json`. Pages are MDX. The build ignores `.claude/**`, `scripts/**`, and `node_modules/**` (see `docs.json` `ignore` + `.mintignore`); internal guides and templates go there, never in published paths.

**Read this file before writing or editing any doc, release note, or UI customization page.** Full copy-paste skeletons live in `.claude/templates/`:

| Task | Template |
|---|---|
| Release notes / changelog / upgrade guide / client notes | `.claude/templates/release-notes-template.md` |
| Feature docs (overview, setup, customize-behavior) | `.claude/templates/feature-docs-template.md` |
| UI customization (wireframes, primitives, variables) | `.claude/templates/ui-customization-template.md` |
| API reference (data models, api methods, react hooks) | `.claude/templates/api-reference-template.md` |

---

## 1. Audience and golden rules

The reader is a **frontend web developer** (React first; Angular/Vue/vanilla second) integrating Velt into their product. They skim, copy code, and leave. Every rule below follows from that.

1. **Code first, prose second.** Show the snippet; explain only what the snippet can't.
2. **The shipped SDK is law.** Method names, prop names, return types, event names, and lifecycle statuses must match the released code exactly (e.g. the suggestion status is `accepted`, not `approved`). Never invent, infer, or "improve" an API name. If unsure, grep the docs for prior usage or leave a `TODO` comment; never guess.
3. **Describe observable behavior, not internals.** Say "the SDK installs delegated `focusin` / `change` / `focusout` listeners"; do not mention internal machinery like `MutationObserver`, caches, or framework plumbing unless the developer must interact with it.
4. **Every code change is duplicated** across the `React / Next.js` and `Other Frameworks` tabs. Editing one tab and not the other is a bug.
5. **One page per concern, consolidated.** Prefer one comprehensive page over three thin ones (the Suggestions docs were deliberately merged from overview + setup + customize-behavior into a single overview). When consolidating or renaming, update **all** cross-references (`api-methods.mdx`, `react-hooks.mdx`, `docs.json`, in-prose links).

## 2. Voice and tone

- **Second person, active voice, present tense.** "You can pin comments to any element." Steps use the imperative: "Import the component." "Add the `VeltComments` element."
- **Short sentences.** Aim under 20 words. One idea per sentence. Break complex ideas into bullets or `Steps`.
- **No em-dashes.** Replace `—` with a comma, colon, semicolon, or a connective ("by", "because", "and"). This is an explicit house rule (maintainers strip them on sight).
  - Bad: `the bot responds — replying in the thread`
  - Good: `the bot responds by replying in the thread`
  - Bad: `**Advanced (v2)** — verified requests`
  - Good: `**Advanced (v2):** verified requests`
- **No marketing fluff.** Banned words: *powerful, seamless, seamlessly, effortless, robust, flexible (as praise), supercharge, revolutionize, blazing, delightful*. Banned filler phrases: "improving workflow efficiency in collaborative environments", "for better visibility and workflow customization", "enabling you to create custom workflows that match your application's interaction patterns", or any clause that restates the obvious instead of adding information.
- **Concept first, API second** for complex features. Open with what the feature is and a numbered "How it works" pipeline (e.g. enable → snapshot → diff → pending → accept/reject → apply), then the setup steps, then the reference detail. Don't open with method signatures.
- **Be precise, not vague.** Name the exact prop/method/event in backticks. "Set `streamMode={true}`" beats "enable stream mode in the configuration".
- **Say when there's nothing to do.** End behavior-change notes with "No API change." / "No integration change required." / "No new API or props required." when true.
- **Don't document our internals or customers.** Never mention client/customer names ("host app" instead). Don't ship changelog entries for backend-only or internal refactors. No legacy-fallback notes ("the legacy `x-velt-auth-token` header is still accepted"); delete them unless they're part of an active migration.
- **Beta labeling.** In-progress features get `(Beta)` appended to the page `title` and feature heading: `title: "Suggestions (Beta)"`.

## 3. Terminology

| Term | Rule | Example |
|---|---|---|
| Velt, Velt SDK | product names, capitalized | "The Velt SDK handles presence." |
| Feature names | Capitalized when naming the feature | Comments, Presence, Recorder, Suggestions, Notifications, Access Control, Live State Sync |
| Feature states/concepts | lowercase in prose | suggestion mode, suggestion target, comment annotation |
| React components | PascalCase, `Velt` prefix | `VeltProvider`, `VeltComments`, `VeltCommentTool` |
| HTML custom elements | kebab-case, `velt-` prefix | `velt-comments`, `velt-comment-tool` |
| Hooks | `use` prefix, camelCase | `useVeltClient`, `useCommentUtils` |
| Code identifiers | camelCase, always backticked | `documentId`, `organizationId`, `annotationId` |
| Tab labels | exact strings only | `React / Next.js`, `Other Frameworks` (never `React / Next.JS`, `HTML/ Other frameworks`) |
| Release-note categories | map raw names | "Cloud Functions" → **Access Control**; "Recorder / Player" → **Recorder**; "Comments / Wireframes" → **UI Customization**; client-level APIs (`setDocuments`, locations) → **Core** |
| Forbidden words | never appear in docs | `Angular`-specific advice in generic docs, `ng-container`, `slot` / `sub-slot` (say "tag" or "sub-component") |

Casing conventions: PascalCase for components and headings of component names; camelCase for code identifiers and React props; kebab-case for HTML attributes, URLs, and anchors; anchors are lowercase with no separators (`#addcommentannotation`).

## 4. MDX component vocabulary

Use only these components, with these exact spellings:

- `Tabs` / `Tab`: framework switching. **Tab order is fixed: `React / Next.js` first, `Other Frameworks` second.** Quickstart-style pages may use `React / Next.js`, `Angular`, `Vue.js`, `HTML`.
- `Steps` / `Step`: numbered procedures. Setup pages use `<Steps titleSize="h2">`. Step titles are imperative ("Install Dependencies", "Authenticate Users").
- `CodeGroup`: multiple variants of the *same* thing (e.g. Organization Level / Folder Level / Document Level). Label each fence: ` ```jsx Organization Level `. Do **not** use extra Tabs for variants.
- `RequestExample`: the full runnable example at the end of setup pages, with fences labeled ` ```jsx React / Next.js ` and ` ```html HTML `.
- `Note` (caveats, prerequisites), `Warning` (required setup, destructive pitfalls), `Tip` (live demos, shortcuts), `Info` (neutral context), `Frame` (images/iframes), `Update` (changelog entries only), `Accordion` (long optional payloads).
- Callouts replace inline "**Important:** ..." bolding. Use sparingly; a page of warnings warns about nothing.

Code fence languages: `jsx` (React), `tsx` (typed React), `js` (framework-agnostic JS), `html`, `typescript` (interfaces), `json`, `bash` (cURL/installs).

## 5. Code example rules

- React tab: API access goes through `client` (from `useVeltClient`). Other Frameworks tab: through the global `Velt`. Never mix them up.
- When a React hook exists, the React tab shows **both** usages, labeled with comments:

  ```jsx
  // Hook
  const { addCommentAnnotation } = useAddCommentAnnotation();

  // API Method
  const commentElement = client.getCommentElement();
  await commentElement.addCommentAnnotation(request);
  ```

- React props are camelCase (`streamMode={true}`); the same option in HTML is a kebab-case string attribute (`stream-mode="true"`).
- HTML custom elements are **never self-closing**: `<velt-comments></velt-comments>`, not `<velt-comments />`.
- Wireframe examples always show the wrapper: `VeltWireframe` in React, `velt-wireframe` with `style="display:none;"` in HTML.
- Snippets must be complete and runnable in context, with no `{ ... }` elisions inside objects you're documenting. Keep them short (≈10 lines per tab in changelogs; setup pages can be longer). Include imports in full-file examples only.
- Event subscriptions always show the unsubscribe:

  ```jsx
  const subscription = commentElement.on('suggestionAccepted').subscribe((event) => { /* ... */ });
  subscription?.unsubscribe();
  ```

- **Never put links inside code blocks or code comments.**

## 6. Page anatomy by type

Heading rules: frontmatter `title` is the H1; never repeat it in the body. `##` for page sections. Customize-behavior pages use `#` for feature areas (Threads, Messages, @Mentions) and `####` for each method/prop name (plain text heading, no backticks, no parentheses-args). Max heading depth is 5; deeper levels use bold text instead. Method sections follow heading → metadata bullets (description, `Params:`, `Returns:` or `Event:`) → Tabs.

| Page type | Shape |
|---|---|
| Overview | hook sentence → what it is + "How it works" numbered pipeline → demo/screenshot Tabs → Setup (or pointer) → behavior notes → lifecycle/data-model reference |
| Setup | optional GIF of result → Tabs per framework → `Steps` (2 to 5, imperative titles) → `RequestExample` with full code |
| Customize behavior | feature-area `#` sections → one `####` per method with Params/Returns links and Hook + API tabs |
| Quickstart | prerequisites → numbered steps → debugging → complete example (`CodeGroup`, one fence per file: `App.js - Root Component`) → next steps |

Frontmatter: `title` (Title Case, noun phrase), optional `sidebarTitle`, `description` (1 to 3 plain sentences, no fluff). See `.claude/templates/feature-docs-template.md` for full skeletons.

## 7. Release notes (changelog)

Full rules + skeletons in `.claude/templates/release-notes-template.md`. The non-negotiables:

- File routing: `release-notes/version-[MAJOR]/[library]-changelog.mdx` (`sdk-changelog.mdx` for core; `tiptap|blocknote|codemirror|lexical|reactflow-changelog.mdx` for editor-specific; `crdt-core-changelog.mdx` for multi-editor/CRDT core). New entries go at the **top**, newest → oldest.
- Entry wrapper: `<Update label="5.0.2-beta.33" description="June 5, 2026">`: full month name, day, comma, year.
- Exactly three section headings, in this order, omitting empty ones: `### New Features`, `### Improvements`, `### Bug Fixes`.
- Bullet format: `- [**Feature**]: Past-tense action verb + what changed.` One bullet per release item; never merge related items (7 items in, 7 bullets out).
- Each bullet ≤2 short sentences before any code. Big tables, wireframe trees, and prop lists never go in the changelog; summarize and link: `[Learn more →](/path#anchor)`.
- **Breaking changes never appear in the changelog** (no `### Breaking Changes`, no `Warning`). They go in `release-notes/version-[MAJOR]/upgrade-guide.mdx` with Before/After tabs.
- Skip `[Internal]` items; merge backend-only releases into the adjacent SDK release.

## 8. Linking

- Always absolute site paths starting with `/`, lowercase anchors: `[CommentAnnotation](/api-reference/sdk/models/data-models#commentannotation)`, `[setDocuments()](/api-reference/sdk/api/api-methods#setdocuments)`.
- Feature docs link to API reference and vice versa (`- [Full Documentation →](/async-collaboration/comments/customize-behavior#addcommentannotation)`).
- Client-facing release notes (the A→B→C pipeline output) convert relative paths to full URLs by prepending `https://docs.velt.dev`.
- Never invent a URL. If you can't confirm a target, leave `<!-- TODO: confirm link target -->` for review.
- After any rename/move/consolidation, grep the whole repo for the old path and fix every reference, then update `docs.json` and consider a `redirects` entry there.

## 9. docs.json navigation

`docs.json` → `navigation.tabs[]` → `groups[]` → `pages[]` (paths without `.mdx`). Tabs: Documentation, UI Customization, API Reference, Release Notes, Examples, DevTools. Every new page must be added to the right group or it won't render. Convention: a feature's wireframes page is listed first, its primitives page immediately after. Removing a page from nav without a redirect breaks inbound links; check `redirects`.

## 10. Git conventions

- Commit messages: conventional style with a docs scope: `docs(suggestions): consolidate the three pages into one`, `docs(rest-apis): remove legacy auth-token fallback notes`, `fix(skills-sync): ...` for tooling. Verbs maintainers actually use: add, remove, rewrite, consolidate, rename, align, refine, drop, mark.
- Body explains the why and cross-file impact (pages merged, links updated, nav changes).
- PR titles: version PRs are the bare version (`v5.0.2-beta.33`); topic PRs are `Docs/<topic>` or the conventional-commit subject.
- Never edit generated artifacts: `AGENTS.md`, `AGENTS.full.md`, `metadata.json`, anything in `node_modules/`.

## 11. The docs pipelines (context)

Two agent pipelines exist in `.claude/agents/` and follow this guide:
- **Release-notes pipeline (Agents 1→7):** Agent-1 turns raw release notes into changelog MDX → Agent-2 plans which docs need updates → Agent-3 updates `data-models.mdx`/`api-methods.mdx` → Agent-4 wireframes → Agent-5 primitives → Agent-6 aligns terminology across the repo → Agent-7 final repo-wide QA replace.
- **Client-notes pipeline (A→B→C):** extract from changelog → categorize (major items only, ≤150 chars/bullet) → format the friendly client-facing summary ("Hey Velt Developers!", emoji category headers, full URLs, "Happy shipping! 🚀").

When asked to do one of these tasks manually, follow the same rules and templates rather than improvising.

## 12. Pre-publish checklist

Before committing any docs change, verify:

1. Both `React / Next.js` and `Other Frameworks` tabs updated, exact tab titles, React first.
2. `client.` in React code, `Velt.` in Other Frameworks; hooks shown with `// Hook` / `// API Method` labels.
3. HTML elements kebab-case and not self-closing; wireframes wrapped (`velt-wireframe` has `style="display:none;"`).
4. All names match the shipped SDK; no invented APIs.
5. No em-dashes, no banned fluff words, sentences short, present tense, second person.
6. Links absolute with lowercase anchors; no links in code; no stale links to moved pages.
7. New pages added to `docs.json`; renames have redirects and all cross-references updated.
8. Changelog: correct file, entry at top, three sections in order, `[**Feature**]:` bullets, no breaking changes (those go to the upgrade guide).
9. Tables use the canonical column schemas (see templates).
10. File ends with a single trailing newline; valid MDX (unclosed tags or raw `<placeholders>` outside code fences break the Mintlify build).
