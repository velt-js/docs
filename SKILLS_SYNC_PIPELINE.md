# Skills-Sync Pipeline — End-to-End Summary

A multi-agent CI pipeline that watches `velt-js/docs`, detects when a merge to `main` should change rules in `velt-js/agent-skills`, edits the right files, validates the build, and opens (or updates) a single review-ready PR — automatically. Plus auto-propagation downstream into `velt-plugin-cursor` and `velt-plugin-claude`.

---

## How the pipeline works

### Trigger

Every push to `velt-js/docs/main` touching one of the watched paths runs `.github/workflows/docs-sync-skills.yml`:

```
async-collaboration/**       realtime-collaboration/**
api-reference/rest-apis/**   self-host-data/**
security/**                  webhooks/**
get-started/**               backend-sdks/**
ui-customization/**          permission-management/**
in-app-user-feedback/**
```

### Three jobs

**Job 1 — `plan`** (Stage 0 script + Agent 1, Opus 4.7)

- `compute-diff.sh` produces a structured diff of the docs change.
- `Agent-1-docs-diff-planner` reads `mapping.md` and emits `plan.json`:
  - `tickets[]` — one entry per impacted skill (`{skill, paths, intent, changes}`)
  - `unmapped[]` — feature paths with no current skill (issues filed, no auto-create)

**Job 2 — `update-skill`** (matrix, one job per ticket; Agent 2 variant, Opus 4.7)

`dispatch-updater-variant.sh` maps each skill to one of six variants:

| Variant | Skills |
|---|---|
| **2a** `frontend-async` | comments, notifications, activity, recorder |
| **2b** `frontend-realtime` | presence, cursors, huddle, single-editor-mode, crdt |
| **2c** `setup` | velt-setup-best-practices |
| **2d** `backend` | rest-apis, self-hosting-data |
| **2e** `infra` | proxy-server, yjs |
| **2f** `ai` | rewriter (extensible for future AI features) |

The chosen variant edits **source rule files only** (never AGENTS files), bumps `metadata.json` version, optionally adds a new category to `_sections.md`.

**Job 3 — `validate-and-pr`** (Agent 3 Haiku 4.5, Agent 4 Opus 4.7)

- **Resolve branch:** queries `gh pr list --label skills-sync --state open`. If a PR is open, checks out its branch and exports `EXISTING_PR_NUMBER`. Otherwise creates `skills-sync/<short-sha>`.
- `apply-patches.sh` merges all matrix artifacts onto the branch.
- `Agent-3-skill-format-validator` runs `npm run validate && npm run build` to regenerate `AGENTS.md` / `AGENTS.full.md`.
- `Agent-4-skill-pr-composer` either updates the existing PR (`gh pr edit` body, `--add-reviewer yoen-velt`, `gh pr comment` for timeline visibility) or opens a new one (`--reviewer yoen-velt`, labels `skills-sync` + `automated`).

### Sync downstream to plugins (automatic, separate workflow)

The merge to `agent-skills/main` triggers `agent-skills/.github/workflows/sync-to-plugins.yml`, which copies `skills/**` into `velt-plugin-cursor` and `velt-plugin-claude` and opens sync PRs there.

### Weekly drift check (independent, no PRs)

`docs/.github/workflows/skills-sync-drift-check.yml` runs every Monday at 14:00 UTC, comparing the docs feature tree to the agent-skills inventory and filing (or updating) a rollup issue in agent-skills if anything has drifted out of sync.

### Guardrails on the receiving end

`agent-skills/.github/workflows/skills-sync-guardrails.yml` fires on every PR labeled `skills-sync` and rejects:

- Edits inside `*-workspace/**` or `**/evals/**`.
- Rewrites of `metadata.json.abstract` or `.author` without the `manual-skill-rewrite` label.
- `metadata.json.version` not bumping when rule files change (unless labeled `docs-prose-only`).
- `AGENTS.md` changes without a sibling rule change.

---

## Visual

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      velt-js/docs   (you merge here)                        │
│                                                                             │
│  PR → main, touches any of: async-collaboration/**, realtime/**,            │
│       ui-customization/**, get-started/**, security/**, etc.                │
└──────────────────────────────┬──────────────────────────────────────────────┘
                               │  push trigger
                               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│             .github/workflows/docs-sync-skills.yml                          │
│                                                                             │
│  ┌──────────┐    ┌──────────────────┐    ┌──────────────────────────┐       │
│  │  plan    │───▶│  update-skill    │───▶│   validate-and-pr        │       │
│  │ (Agent 1)│    │  (Agent 2 a..f)  │    │   (Agent 3 + Agent 4)    │       │
│  │  Opus    │    │  Opus, matrix    │    │   Haiku + Opus           │       │
│  └──────────┘    └──────────────────┘    └────────────┬─────────────┘       │
│   plan.json       per-ticket patches      build + PR  │                     │
│                                                       │                     │
└───────────────────────────────────────────────────────┼─────────────────────┘
                                                       │
                              ┌────────────────────────┴───────────────┐
                              │ Existing open `skills-sync` PR?         │
                              │   YES → push commit + `gh pr edit`      │
                              │         (cumulative body)               │
                              │   NO  → `gh pr create --reviewer        │
                              │         yoen-velt --label skills-sync`  │
                              └────────────────────┬───────────────────┘
                                                   │
                                                   ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│           velt-js/agent-skills   (skills-sync PR opens here)                │
│                                                                             │
│  PR labeled `skills-sync`, `automated`, reviewer: @yoen-velt                │
│  Body: per-skill summary, source-commit link, pipeline-run link             │
│                                                                             │
│  On PR open, secondary CI fires:                                            │
│    .github/workflows/skills-sync-guardrails.yml                             │
│      • blocks edits in *-workspace/** or **/evals/**                        │
│      • requires metadata.json version bump on rule changes                  │
│      • blocks AGENTS.md changes without sibling rule change                 │
│                                                                             │
│  Reviewer merges to agent-skills/main                                       │
└─────────────────────────────────────────────────┬───────────────────────────┘
                                                  │  push to agent-skills/main
                                                  ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│          velt-js/agent-skills/.github/workflows/sync-to-plugins.yml         │
│                                                                             │
│  Triggered automatically on every push to agent-skills/main touching        │
│  skills/**. Copies skill files into the two plugin repos:                   │
└──────────┬───────────────────────────────────────────────┬──────────────────┘
           │                                               │
           ▼                                               ▼
┌──────────────────────────────┐               ┌──────────────────────────────┐
│  velt-js/velt-plugin-cursor  │               │  velt-js/velt-plugin-claude  │
│  (auto sync PR opens)        │               │  (auto sync PR opens)        │
└──────────────────────────────┘               └──────────────────────────────┘


────────────────────────────────────────────────────────────────────────────────
Independent: weekly drift check
────────────────────────────────────────────────────────────────────────────────

┌─────────────────────────────────────────────────────────────────────────────┐
│  Monday 14:00 UTC                                                           │
│  docs/.github/workflows/skills-sync-drift-check.yml                         │
│                                                                             │
│  Compares docs feature tree ↔ agent-skills/skills/ inventory                │
│  Drift found? → files (or updates) rollup issue in agent-skills             │
│  No drift?   → silent (no PR, no issue)                                     │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## File map

### Pipeline definition (in `velt-js/docs`)

| File | Purpose |
|---|---|
| `.github/workflows/docs-sync-skills.yml` | Main pipeline trigger + 3-job orchestration. |
| `.github/workflows/skills-sync-drift-check.yml` | Weekly Monday drift audit. |
| `.claude/agents/skills-sync/Agent-1-docs-diff-planner.md` | Plans which skills to touch. (Opus 4.7) |
| `.claude/agents/skills-sync/Agent-2a..f-*-skill-updater.md` | One variant per skill family. (Opus 4.7) |
| `.claude/agents/skills-sync/Agent-3-skill-format-validator.md` | `npm run validate && build`. (Haiku 4.5) |
| `.claude/agents/skills-sync/Agent-4-skill-pr-composer.md` | Opens / updates the PR. (Opus 4.7) |
| `scripts/skills-sync/*.sh` | Plumbing — diff, dispatch, apply, smoke-test. |
| `scripts/skills-sync/reference-artifacts/mapping.md` | Frozen docs-path → skill mapping. |
| `scripts/skills-sync/reference-artifacts/format-guide.md` | Authoritative skill-file format. |

### Receiving end (in `velt-js/agent-skills`)

| File | Purpose |
|---|---|
| `.github/workflows/skills-sync-guardrails.yml` | PR-level guardrails (rule-bump, workspace-edit blocks). |
| `.github/workflows/sync-to-plugins.yml` | Propagates merged changes to both plugin repos. |
| `.github/CODEOWNERS` | Ownership documentation only. **Not** the review-routing mechanism. |
| `skills/<name>/SKILL.md`, `metadata.json`, `rules/shared/_sections.md` | Source-of-truth files updater agents edit. |
| `skills/<name>/AGENTS.md`, `AGENTS.full.md` | Build artifacts. **Never hand-edited.** |

### Required secrets (in `velt-js/docs`)

| Secret | Used for |
|---|---|
| `ANTHROPIC_API_KEY` | All four Claude agents. |
| `AGENT_SKILLS_PAT` | Cross-repo writes (checkout, push, PR, issues) on `velt-js/agent-skills`. |

---

## How we set it up (chronological steps)

1. **Tested the pipeline on a no-op commit** (`44ae9b9` "Added proxy server to docs") — Plugin-Agent-1 correctly returned `hasDeltas: false` because the agent-skills repo already reflected that change.
2. **Tested the pipeline on a real release** (`650d917e` "v5.0.2-beta.18") — Plugin-Agent-1 produced 3 Comments deltas and parked 2 Rewriter deltas (no library existed yet).
3. **Manually scaffolded `velt-rewriter-best-practices`** in `velt-js/agent-skills` (per the policy that the pipeline never auto-creates new skills — it files an issue, humans decide).
4. **Plugin-Agent-2 patched** the 3 Comments rule files (`mode-inline-comments.md`, `ui-wireframes.md`, `config-ui-behavior.md`) and the 2 new Rewriter rule files (`api-default-ui-toggle.md`, `types-ai-model.md`).
5. **Caught and fixed a fabricated component name** in `ui-wireframes.md` — Plugin-Agent-1 had inferred `VeltInlineCommentsSectionWireframe.ShowMore` from prose; the real components are `VeltCommentDialogWireframe.ThreadCard.Message.ShowMore` / `.ShowLess`.
6. **Diagnosed two build bugs** surfaced by `npm run build`: proxy-server's `metadata.json` used a non-canonical schema (`{name, author, ruleCount, categories}`) so the build emitted `undefined|undefined`; self-hosting-data's `_sections.md` was missing entries for `data/` and `python-sdk/` so 5 rule files were orphaned.
7. **Migrated proxy-server's `metadata.json`** to the canonical schema (`{version, organization, date, abstract, references}`) used by every other library.
8. **Reformatted proxy-server's `_sections.md`** from the flat-list format to the canonical `## N. Title (folder)` + `**Impact:**` shape the parser expects.
9. **Reconnected self-hosting-data's orphaned folders** by adding Sections 6 (Data Types) and 7 (Python SDK) to its `_sections.md` (Debugging renumbered to 8).
10. **Created `_sections.md` for the new Rewriter library** defining `api/` and `types/` sections.
11. **Created a new Agent-2f variant** (`Agent-2f-ai-skill-updater.md`) for AI/productivity features, modeled on the infra variant; updated `mapping.md` and `dispatch-updater-variant.sh` so rewriter routes to it.
12. **Added `ai/rewriter/**` → `velt-rewriter-best-practices`** routing to `mapping.md` so future docs changes in that path land on the right library.
13. **Retired the old `docs-sync.yml`** workflow (it was a single-job shell pipeline that opened PRs in 3 repos on every `**/*.mdx` change) — superseded by the new agent-driven `docs-sync-skills.yml`.
14. **Wired Agent 4 to reuse open PRs** — if a `skills-sync` PR is already open, the next pipeline run commits onto its branch and `gh pr edit`s the body, rather than opening a parallel PR.
15. **Changed review routing from CODEOWNERS to direct `@yoen-velt`** — Agent 4 now passes `--reviewer yoen-velt` on PR creation and `--add-reviewer yoen-velt` on PR edit; CODEOWNERS file is kept for ownership documentation only.
16. **Added the Rewriter row to `agent-skills/.github/CODEOWNERS`** in a new "AI / productivity" section for completeness.
17. **Reconciled rule counts** to match build output — Comments 71→69, Recorder 21→23, Self-Hosting-Data 13→21 (+8 from reconnected sections), Rewriter +2 new, Total 277→282.
18. **Regenerated all 10 buildable libraries' `AGENTS.md` / `AGENTS.full.md`** files via `npm run build` (Comments now correctly indexes the new beta.18 content; proxy-server is no longer broken).
19. **Updated customer-facing docs** — added a Rewriter Card to `docs/get-started/skills.mdx`, added a use-case bullet and mapping row, updated counts in `docs/get-started/plugins.mdx` for both plugin trees.
20. **Confirmed `ANTHROPIC_API_KEY` already exists as a GitHub Actions secret** on `velt-js/docs` (rotated since it was exposed in chat).
21. **Committed 3 commits to agent-skills/main** (`Workflow fix`, `v5.0.2-beta.18 ...`, `Build fix + AGENTS regen ...`) and pushed.
22. **Committed 2 commits to a docs feature branch** (`Add docs-sync-skills pipeline ...`, `v5.0.2-beta.18 docs ...`).
23. **Cherry-picked just those 2 commits onto `docs/main` and pushed** — pipeline is now live. Other wireframe-variables work stayed on the feature branch for normal PR review.

---

## Carryover / out-of-scope workstreams

These exist but are intentionally not part of this auto-updater work:

1. **5 libraries still lack `metadata.json`** in the canonical schema: presence, cursors, huddle, rest-apis, yjs. They aren't picked up by the build and their `AGENTS.md` files remain stale. The customer-facing rule counts for those (presence 13, cursors 11, huddle 10, rest-apis 9) are inherited and unverified.
2. **The `@velt-js/ai-owners` team handle in `CODEOWNERS`** is a placeholder. Since review routing is direct to `@yoen-velt`, this is harmless — but worth resolving when CODEOWNERS becomes the routing mechanism for any other workflow.
3. **Wireframe-variables work** (~30 pages of new per-feature wireframe-variables docs) is still sitting on the feature branch `wireframe-variables-non-comments-notifications` — 8 commits ahead of main. Not pushed to `main` because that's normal-PR-review territory.

---

## Verifying the pipeline works

Next time you merge a docs PR to `main` that touches a watched path:

1. **Actions tab → docs-sync-skills**: watch the three jobs (`plan`, `update-skill`, `validate-and-pr`) run end-to-end. Should finish in ~5–10 min.
2. **agent-skills → Pull Requests**: filter `is:pr is:open label:skills-sync`. Expect either a new PR or a new commit on an existing one, with `@yoen-velt` requested.
3. **Worst-case diagnostic**: download the workflow run's `outputs/pr-composer-result.json` artifact for the status code and any error message.
