# Release-note -> docs-PR automation

When a Markdown release note changes in
`snippyly/internal-release-notes/release-notes/**`, the source repo dispatches
an event to `velt-js/docs`. The docs workflow classifies the note, creates or
reuses the right PR branch, and runs the committed release-note agents
sequentially on Opus 4.8 with checkpoints after every stage.

## Flow

```
internal-release-notes                         velt-js/docs
notify-docs-on-release-note.yml  --dispatch--> release-note-to-docs-pr.yml
  push -> release-notes/**                       run-release-note-pipeline.sh
  changed *.md                                    classify + branch/PR/checkpoint
  added/modified/renamed                          Agent-1..7 on claude-opus-4-8
  deleted -> docs triage issue                    commit/push after each stage
```

## Files

| Path | Repo | Role |
|---|---|---|
| `.github/workflows/release-note-to-docs-pr.yml` | `velt-js/docs` | Receives dispatches and runs the deterministic pipeline |
| `scripts/release-notes/run-release-note-pipeline.sh` | `velt-js/docs` | Routing, branch/PR reuse, checkpointing, restart behavior |
| `scripts/release-notes/run-release-note-agent.sh` | `velt-js/docs` | Runs one committed agent on `claude-opus-4-8` |
| `scripts/release-notes/lib.sh` | `velt-js/docs` | Shared route/classification helpers |
| `.github/release-note-pipeline/source-repo/notify-docs-on-release-note.yml` | copy to `snippyly/internal-release-notes` | Active source trigger |

## Routing

- `release-notes/v*.md` -> core SDK, branch/title `<version>`.
- `release-notes/shared-firebase-function-*.md` -> append to newest open core SDK release PR.
- `release-notes/velt-py-sdk/v*.md` -> branch/title `velt-py-<version>`.
- `release-notes/velt-node-sdk/v*.md` -> branch `velt-node-docs-<version>`, title `velt-node-<version>`.
- Anything else -> draft triage PR with the sanitized public note only.
- Firebase with no open core release PR -> draft triage PR; agents do not invent a changelog home.

## Internal sections

Source release notes may include private context at the bottom. The docs runner
creates a public-only local input note before any agent runs and stops copying
content at the first `Internal`, `For Internal Use`, or `Internal Context`
header. Agents are not given access to the raw source checkout, and the
committed `.claude/release-notes/input-*.md` file contains only the sanitized
public portion.

## Restart behavior

- The runner saves input, route metadata, logs, and stage checkpoints under
  `.claude/release-notes/runs/<safe-stem>/`.
- A draft PR is created before agent work starts, then the branch is pushed
  after each successful stage.
- `mode=auto` skips completed checkpointed runs and resumes incomplete branches.
- `mode=resume` ignores legacy changelog skip heuristics and continues from the
  next missing checkpoint.
- `mode=force` reruns every stage; source `modified` and `renamed` dispatches
  are treated as force reruns.
- Manual runs can provide `release_note_url` instead of `path`. URL-based runs
  default to `mode=resume`, so a failed run caused by API credits, rate limits,
  or transient agent runtime issues can continue from the last checkpoint.
- Push failures never force-push. The runner comments on the PR or creates a
  docs issue with the failed stage and workflow run URL.

## Model pinning

The workflow installs Claude Code, verifies `claude --version >= 2.1.154`, sets
`ANTHROPIC_DEFAULT_OPUS_MODEL=claude-opus-4-8`, and invokes every agent with
`--model claude-opus-4-8`. Agent 1-7 frontmatter is pinned to the same model.

## Manual checks

Dry-run route check:

```bash
gh workflow run release-note-to-docs-pr.yml -R velt-js/docs \
  -f path=release-notes/v6.0.0-beta.2.md \
  -f dry_run=true
```

Resume from a source note URL after a failed run:

```bash
gh workflow run release-note-to-docs-pr.yml -R velt-js/docs \
  -f release_note_url=https://github.com/snippyly/internal-release-notes/blob/main/release-notes/v6.0.0-beta.2.md
```

Local non-agent tests:

```bash
bash scripts/release-notes/test-routing.sh
bash scripts/release-notes/test-detector.sh
bash scripts/release-notes/test-url-parser.sh
bash scripts/release-notes/test-resolver.sh
bash scripts/release-notes/test-internal-trim.sh
```

## Required secrets

- `velt-js/docs`: `ANTHROPIC_API_KEY`, `CROSS_REPO_PAT`.
- `snippyly/internal-release-notes`: `DOCS_DISPATCH_PAT` with access to
  dispatch workflows and create fallback issues in `velt-js/docs`.
