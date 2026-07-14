# CRDT Editor Integration Documentation Guidelines

Use this guide when creating or updating CRDT editor integration pages in this
directory. The goal is to keep React and framework-agnostic instructions on one
page while preserving the initialization and cleanup requirements of each
editor.

## Scope

These guidelines currently cover:

1. SuperDoc
2. Lexical
3. TinyMCE
4. Monaco
5. ProseMirror
6. CKEditor
7. Apryse
8. SpreadJS
9. Nutrient
10. Ace
11. Quill

## Verified framework-agnostic sources

Treat the matching `INTEGRATION.md` as the source of truth for package names,
public APIs, editor lifecycle, supported options, and cleanup behavior.

| Library | Repository | Path within repository |
| --- | --- | --- |
| SuperDoc | `superdoc-crdt` | `demo/INTEGRATION.md` |
| Lexical | `lexical-crdt` | `demo/INTEGRATION.md` |
| TinyMCE | `tinymce-crdt` | `demo/INTEGRATION.md` |
| Monaco | `monaco-crdt` | `demo/INTEGRATION.md` |
| ProseMirror | `prosemirror-crdt` | `demo/INTEGRATION.md` |
| CKEditor | `ckeditor-crdt` | `demo/INTEGRATION.md` |
| Apryse | `apryse-crdt` | `demo/INTEGRATION.md` |
| SpreadJS | `spreadjs-crdt` | `demo/INTEGRATION.md` |
| Nutrient | `nutrient-crdt` | `demo/INTEGRATION.md` |
| Ace | `ace-crdt` | `demo/INTEGRATION.md` |
| Quill | `quill-crdt` | `demo/INTEGRATION.md` |

When information differs between a source integration and an existing docs
example, verify the current package implementation before changing behavior.
Do not infer framework-agnostic behavior by mechanically removing React hooks.

## Page strategy

Each library MUST have one combined documentation page. Do not create separate
React and non-React pages.

Use the established patterns in these pages:

- `core.mdx`
- `tiptap.mdx`
- `codemirror.mdx`

Use these labels consistently:

- `React / Next.js`
- `Other Frameworks`

Use **Other Frameworks**, not **Non-React**. The imperative packages can be used
with Vue, Angular, Svelte, vanilla JavaScript, and other environments.

## When to use tabs

Tabs MUST represent a real framework or API boundary. Do not duplicate every
step merely to maintain two parallel versions.

Use `React / Next.js` and `Other Frameworks` tabs for:

- Installing framework-specific packages
- Initializing Velt
- Authenticating users and setting document context
- Creating or binding an editor when construction differs
- Subscribing through hooks versus client or manager callbacks
- Configuring encryption through `VeltProvider` versus the client API
- Cleaning up automatically versus explicitly destroying resources
- Complete working examples

Keep content outside tabs when it is identical, including:

- Conceptual explanations
- Shared configuration options
- Required CSS that does not depend on the framework
- Collaboration behavior
- Troubleshooting guidance
- Shared manager methods and types
- Testing requirements

Do not nest tabs. For the main collaboration initialization step, use one tab
group with the applicable variants:

1. `React Component`
2. `React Hook`
3. `Other Frameworks`

If a page currently has an `Imperative API` tab, rename it to `Other Frameworks`
and expand it into a complete framework-agnostic lifecycle. A factory call by
itself is not a usable integration example.

## Required page structure

Use this order unless the editor has a documented lifecycle requirement that
makes a different order necessary:

1. Frontmatter, introduction, and shared prerequisites
2. Setup
3. Install dependencies
4. Initialize Velt
5. Authenticate the user and set document context
6. Create or load the editor/viewer
7. Initialize collaboration
8. Monitor connection and initialization status
9. Configure initial content and version management
10. Add cursor, selection, or overlay styling
11. Add editor-specific collaboration features
12. Subscribe to CRDT events
13. Configure encryption when applicable
14. Handle errors
15. Clean up resources
16. Notes
17. Testing and debugging
18. Complete example
19. How it works
20. API reference and types

The complete examples MUST follow the same ordering and APIs shown in the
individual steps.

## Content rules

### Prerequisites and terminology

- Keep shared browser, package-manager, Velt account, and editor-license
  requirements outside tabs.
- Keep React-specific prerequisites inside the React tab or label them clearly.
- Do not describe a combined page or navigation title as React-only.
- Use the editor's official product name and capitalization consistently.

### Velt initialization

- Initialize the Velt client before creating a collaboration manager.
- Authenticate the user before establishing document collaboration.
- Set a stable document ID and editor ID before initializing collaboration.
- Use the same IDs across all collaborators for the same document/editor.
- Describe only readiness conditions that the source implementation actually
  checks. Do not claim that a hook waits for document context unless it does.
- Prefer the current authenticated provider pattern in React examples. Do not
  introduce deprecated identification APIs.

### Collaboration initialization

- Use the package and exported API from the matching integration source.
- Preserve the editor-specific initialization order.
- Do not initialize or bind the same editor twice.
- If an editor can be attached later, show that as an alternative—not an
  additional required step.
- Explain whether initial content is applied only to a new collaborative
  document and how force-reset behavior affects existing state.

### Yjs behavior

- Use the Yjs-aware undo/redo implementation required by the binding.
- Disable or omit the editor's native history plugin when it conflicts with
  collaborative history.
- Do not create a second Y.Doc or provider when the manager supplies them.
- Avoid multiple bundled copies of Yjs. Duplicate Yjs imports can break shared
  type identity and synchronization.
- Treat awareness and cursor state as ephemeral presence data, not persisted
  document content.

### Styling

- Include all CSS needed for remote cursors, selections, overlays, and editor
  content modes used by the example.
- A remote caret MUST remain visibly distinguishable without relying on a later
  optional snippet.
- When an editor supports iframe and inline modes, explain which styles each
  mode requires.

### Cleanup

- React examples MUST state whether the wrapper or hook performs cleanup.
- Other Frameworks examples MUST explicitly unsubscribe callbacks and destroy
  the collaboration manager.
- Unless a library-specific source requires another order, unsubscribe
  callbacks, destroy the collaboration manager so it releases editor listeners,
  and then dispose or unload the application-owned editor or viewer.
- Preserve source-documented exceptions explicitly. SuperDoc is the inverse:
  destroy SuperDoc while it can still release the manager-owned provider, then
  destroy the collaboration manager.

### Source filtering

Translate consumer-facing integration behavior, not repository-maintenance
material. Exclude the following unless they are necessary for using the SDK:

- Demo build commands
- Test selectors and automated test internals
- Repository file maps
- Release and publishing checklists
- Internal implementation details not exposed by the public API

## Library-specific requirements

### SuperDoc

- Create the collaboration manager before constructing SuperDoc.
- Obtain the Y.Doc and provider through `getCollaborationConfig()`.
- Pass that configuration to the SuperDoc document.
- Destroy SuperDoc before destroying the collaboration manager.

### Lexical

- Create and configure the Lexical editor before collaboration initialization.
- Do not register Lexical's normal history plugin when collaborative history is
  active.
- Explain that collaborative undo/redo is backed by Yjs.
- Preserve the automatic remote-cursor overlay behavior.

### TinyMCE

- Initialize TinyMCE before creating the collaboration manager.
- State that the package supports both inline and iframe-mode editors.
- Do not prescribe mode-specific skin or content CSS unless a verified source
  documents those requirements.
- Destroy the collaboration manager before removing the TinyMCE editor.

### Monaco

- Show either automatic binding by passing the editor to
  `createCollaboration()` or attach-later binding with `bindEditor()`.
- Never show both binding paths in the same initialization flow.
- Include a visible border or equivalent treatment for remote carets.
- Destroy the collaboration manager before disposing the Monaco editor.

### ProseMirror

- Direct plugin wiring MUST use `autoInitialize: false`.
- Create the collaboration plugins before creating `EditorState` and
  `EditorView`.
- Attach the completed view with `attachEditorView()`.
- Call `initialize()` only after the view has been attached so remote content
  can hydrate correctly.
- Destroy both the view and collaboration manager during cleanup.

### CKEditor

- Create the CKEditor instance before creating the collaboration manager.
- Supplement the source integration with the shared Core Velt initialization,
  authentication, and document-context flow where needed.
- Do not claim the wrapper waits for conditions that its implementation does
  not check.

### Apryse

- Initialize the WebViewer instance before creating collaboration.
- Destroy the collaboration manager before disposing WebViewer.
- Exclude demo commands, test selectors, repository maps, and release-checklist
  sections from the public guide.

### SpreadJS

- Create the workbook before creating the collaboration manager.
- Recommend passing `GC.Spread.Sheets.Events`, and note that fallback event
  strings are available for simple setups.
- Document attach/detach behavior as an alternative lifecycle.
- Destroy the collaboration manager before disposing the workbook.

### Nutrient

- Load the viewer before creating collaboration.
- Pass the viewer host as `overlayContainer` when remote overlays are needed.
- Document viewer attach/detach behavior when applicable.
- Destroy the collaboration manager before unloading the Nutrient viewer.
- Do not claim the hook waits for document context unless verified in source.

### Ace

- Create the Ace editor before creating collaboration.
- Explain that the wrapper can resolve Ace's global Range module and that an
  explicit `rangeFactory` is optional.
- Document attach/detach behavior when applicable.
- Destroy the manager before destroying the editor and removing its DOM.

### Quill

- Load the required Quill styles and register `quill-cursors` before creating
  the editor.
- Use the Yjs-aware undo/redo path rather than Quill's standalone history.
- Ensure the application resolves only one compatible Yjs instance.
- Unsubscribe callbacks before destroying the collaboration manager.

## Navigation rules

- Keep exactly one `docs.json` navigation entry per library.
- Keep the CRDT/Multiplayer integration entries alphabetical.
- Do not add separate Other Frameworks navigation entries.
- Remove `React` from combined-page titles and navigation labels unless React is
  genuinely the only supported integration.
- Keep the existing page slug when combining content so published links remain
  stable.

## Recommended implementation order

Update and review the pages one at a time in this order:

1. SuperDoc
2. Lexical
3. TinyMCE
4. Monaco
5. ProseMirror
6. CKEditor
7. Apryse
8. SpreadJS
9. Nutrient
10. Ace
11. Quill

Use SuperDoc as the initial combined-page template. Treat Monaco and
ProseMirror as explicit lifecycle review checkpoints because binding order is
especially important in those integrations.

## Review checklist

Before considering a page complete, verify all of the following:

- [ ] The package names and imports match the integration source.
- [ ] React and Other Frameworks instructions live on the same page.
- [ ] Tab labels and ordering match the established docs convention.
- [ ] Shared prose and API tables are not duplicated across tabs.
- [ ] Velt initialization, authentication, and document setup occur in the
      correct order.
- [ ] Editor/viewer creation and collaboration initialization follow the source
      lifecycle.
- [ ] The example does not bind the editor twice.
- [ ] Initial-content and version behavior is described accurately.
- [ ] Undo/redo uses the collaboration-aware implementation.
- [ ] Cursor, selection, overlay, skin, and content CSS is complete.
- [ ] Framework-agnostic cleanup is explicit and ordered correctly.
- [ ] The complete examples agree with the smaller setup snippets.
- [ ] Demo-only, test-only, and release-only source material is excluded.
- [ ] Troubleshooting includes testing with two authenticated users in separate
      browser profiles or sessions.
- [ ] The page title and navigation label are no longer React-only.
- [ ] `docs.json` contains one alphabetical entry for the page.
- [ ] Formatting and link checks pass.
