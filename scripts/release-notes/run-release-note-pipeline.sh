#!/usr/bin/env bash
#
# run-release-note-pipeline.sh — Run the release-note → docs-PR orchestrator
# via the Claude Code CLI (headless). The orchestrator drives the committed
# 7-agent pipeline (.claude/agents/Agent-1..7-*.md) as subagents, then opens
# a docs PR. Mirrors scripts/skills-sync/run-claude-agent.sh.
#
# Usage:
#   bash scripts/release-notes/run-release-note-pipeline.sh
#
# Working directory MUST be the docs repo root (so .claude/agents/ resolves).
#
# Required env:
#   ANTHROPIC_API_KEY   — Claude API key.
#   GH_TOKEN            — PAT with access to read the private source repo and
#                         push branches + open PRs on velt-js/docs.
#   NOTE_REPO           — e.g. snippyly/internal-release-notes
#   NOTE_PATH           — e.g. release-notes/v6.0.0-beta.2.md
#   SOURCE_DIR          — local checkout of NOTE_REPO (note at $SOURCE_DIR/$NOTE_PATH)
#
# Optional env:
#   PIPELINE_MAX_TURNS  — default 600 (the full 7-agent run is long).
#   PIPELINE_MODEL      — default claude-opus-4-8 (override if needed).

set -euo pipefail

: "${ANTHROPIC_API_KEY:?ANTHROPIC_API_KEY is required}"
: "${GH_TOKEN:?GH_TOKEN is required}"
: "${NOTE_REPO:?NOTE_REPO is required}"
: "${NOTE_PATH:?NOTE_PATH is required}"
: "${SOURCE_DIR:?SOURCE_DIR is required}"

MAX_TURNS="${PIPELINE_MAX_TURNS:-600}"
MODEL="${PIPELINE_MODEL:-claude-opus-4-8}"

DOCS_ROOT="$PWD"
PROMPT_FILE="$DOCS_ROOT/.github/release-note-pipeline/orchestrator.md"

if [ ! -f "$PROMPT_FILE" ]; then
  echo "run-release-note-pipeline: orchestrator prompt not found at $PROMPT_FILE" >&2
  exit 1
fi
if [ ! -f "$SOURCE_DIR/$NOTE_PATH" ]; then
  echo "run-release-note-pipeline: note not found at $SOURCE_DIR/$NOTE_PATH" >&2
  exit 1
fi

# The orchestrator prompt is plain markdown (no YAML frontmatter to strip).
# Prepend an explicit execution instruction + the live inputs so the model
# treats the body as imperative instructions and knows exactly which note.
PROMPT_BODY="$(cat "$PROMPT_FILE")"

BODY="Execute the following orchestrator instructions NOW. You are running headless and unattended — do not ask clarifying questions; make the safe, conservative choice at every fork and surface anything uncertain in the PR. The live inputs for this run are:

- NOTE_REPO = ${NOTE_REPO}
- NOTE_PATH = ${NOTE_PATH}
- SOURCE_DIR = ${SOURCE_DIR}
- Docs repo (your working directory) = ${DOCS_ROOT}

${PROMPT_BODY}"

echo "[run-release-note-pipeline] note=${NOTE_REPO}/${NOTE_PATH}"
echo "[run-release-note-pipeline] model=${MODEL} max-turns=${MAX_TURNS} pwd=${PWD}"
echo "[run-release-note-pipeline] prompt length: $(printf '%s' "$BODY" | wc -c) chars"

# Invoke Claude Code CLI in print (non-interactive) mode.
#  --print                       run once and exit (no REPL)
#  --permission-mode acceptEdits unattended: auto-approve file writes
#  --allowed-tools               include Task so the orchestrator can dispatch
#                                Agent-1..7 as subagents; Bash for git/gh.
#  --add-dir "$PWD"              grant access to the docs workspace + source dir
#  --add-dir "$SOURCE_DIR"       so the orchestrator can read the source note
#  --max-turns                   high bound — the full pipeline is long
exec claude \
  --print \
  --model "$MODEL" \
  --max-turns "$MAX_TURNS" \
  --permission-mode acceptEdits \
  --allowed-tools "Task,Read,Edit,Write,Glob,Grep,Bash" \
  --add-dir "$DOCS_ROOT" \
  --add-dir "$SOURCE_DIR" \
  -p "$BODY"
