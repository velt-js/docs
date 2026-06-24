# Release-note → docs-PR automation

When a new release note is added to `snippyly/internal-release-notes/release-notes/**`,
this automation runs the committed 7-agent pipeline (`.claude/agents/Agent-1..7-*.md`)
against this repo, opens a docs PR off `main` named after the note, and tags
`@yoen-velt` for review. Human review happens **at the PR**, not mid-pipeline.

## Flow

```
internal-release-notes (source)                 velt-js/docs (this repo)
notify-docs-on-release-note.yml  ─repository_dispatch─►  release-note-to-docs-pr.yml
  push → release-notes/**                          run-release-note-pipeline.sh
  detect ADDED *.md (diff-filter=A)                  → orchestrator.md (headless Claude)
  1 dispatch per file                                  → Agent-1..7 (subagents) → PR
```

## Pieces

| Path | Repo | Role |
|---|---|---|
| `.github/workflows/release-note-to-docs-pr.yml` | this repo | dispatch-triggered; runs the pipeline + opens the PR |
| `.github/release-note-pipeline/orchestrator.md` | this repo | the headless orchestrator prompt (classify → route → run agents → PR) |
| `scripts/release-notes/run-release-note-pipeline.sh` | this repo | invokes the Claude CLI headless with the orchestrator |
| `.github/release-note-pipeline/source-repo/notify-docs-on-release-note.yml` | **copy to** `internal-release-notes` | detects added notes → `repository_dispatch` |

## Routing (encoded in `orchestrator.md`)

- `release-notes/v*.md` (core SDK) → new branch off `main` = filename stem, own PR.
- `release-notes/shared-firebase-function-*.md` → append to the **newest open core-SDK release PR** (else new branch + tag).
- `release-notes/velt-py-sdk/v*.md` → branch/PR `velt-py-<ver>`.
- `release-notes/velt-node-sdk/v*.md` → branch `velt-node-docs-<ver>`, PR title `velt-node-<ver>`.
- anything else → `unknown` → draft PR + tag for triage (never auto-processed).

Tagging: assignee `yoen-velt` + `@yoen-velt` comment + `documentation` label.
Idempotency: branch/PR/changelog state is the durable record (pre-flight skips already-shipped notes).

## Secrets

- **this repo** already has `ANTHROPIC_API_KEY` + `CROSS_REPO_PAT` (used by `docs-sync-skills.yml`). No new secret here.
- **`internal-release-notes`** needs `DOCS_DISPATCH_PAT` — a PAT with `repo` scope on `velt-js/docs` (may reuse the `CROSS_REPO_PAT` value).

## Rollout (phased — same as `docs-sync-skills.yml`)

1. Copy `source-repo/notify-docs-on-release-note.yml` into
   `internal-release-notes/.github/workflows/` (push trigger stays **commented out**).
2. Add the `DOCS_DISPATCH_PAT` secret to `internal-release-notes`.
3. Test `release-note-to-docs-pr.yml` directly via `workflow_dispatch` (provide a `path`)
   against a throwaway test note. Verify branch/classification/PR/tagging.
4. Run the verification matrix (see the project plan): already-shipped guard, core-SDK,
   firebase append, velt-py/velt-node naming, idempotency re-run.
5. Only then uncomment the `push:` trigger in the source workflow to go live.
