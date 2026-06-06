#!/usr/bin/env bash
#
# run-claude-agent.sh — Run a skills-sync agent via the Claude Code CLI.
#
# Usage:
#   bash run-claude-agent.sh <agent-name>
#
# Where <agent-name> is the name suffix in Agent-*-<agent-name>.md, e.g.:
#   docs-diff-planner
#   frontend-async-skill-updater  (or any of the 5 variant names)
#   skill-format-validator
#   skill-pr-composer
#
# Resolves to docs/.claude/agents/skills-sync/Agent-*-<agent-name>.md via glob
# (handles the Agent-2a..2e numbering).
#
# Required env:
#   ANTHROPIC_API_KEY
#
# Optional env:
#   AGENT_MAX_TURNS  (default: 40)
#   AGENT_MODEL      (default: parsed from the agent file's frontmatter; falls back to claude-opus-4-7)
#   DOCS_DIR         (default: $PWD/docs)

set -euo pipefail

AGENT="${1:?agent name is required}"
DOCS_DIR="${DOCS_DIR:-$PWD/docs}"
MAX_TURNS="${AGENT_MAX_TURNS:-40}"

: "${ANTHROPIC_API_KEY:?ANTHROPIC_API_KEY is required}"

# Resolve agent file via glob
shopt -s nullglob
AGENT_FILES=( "$DOCS_DIR"/.claude/agents/skills-sync/Agent-*-"${AGENT}".md )
shopt -u nullglob

if [ ${#AGENT_FILES[@]} -eq 0 ]; then
  echo "run-claude-agent.sh: no agent file matched Agent-*-${AGENT}.md under $DOCS_DIR/.claude/agents/skills-sync/" >&2
  exit 1
fi
if [ ${#AGENT_FILES[@]} -gt 1 ]; then
  echo "run-claude-agent.sh: multiple agent files matched Agent-*-${AGENT}.md — disambiguate" >&2
  printf '  %s\n' "${AGENT_FILES[@]}" >&2
  exit 1
fi

AGENT_FILE="${AGENT_FILES[0]}"
echo "[run-claude-agent] Using $AGENT_FILE (max-turns=$MAX_TURNS)"

# Extract model from frontmatter (override with AGENT_MODEL env var).
# Falls back to a recent Opus if neither source provides one.
MODEL="${AGENT_MODEL:-}"
if [ -z "$MODEL" ]; then
  MODEL="$(awk '/^---$/{f++; next} f==1 && $1=="model:"{print $2; exit}' "$AGENT_FILE" | tr -d '[:space:]')"
fi
MODEL="${MODEL:-claude-opus-4-7}"

# Strip the YAML frontmatter so we pass just the agent body as the user prompt.
# Convention: frontmatter is fenced by two `---` lines at the top.
BODY="$(awk 'BEGIN{f=0} /^---$/{f++; next} f>=2{print}' "$AGENT_FILE")"

if [ -z "${BODY//[[:space:]]/}" ]; then
  echo "run-claude-agent.sh: agent body is empty after stripping frontmatter — refusing to run" >&2
  exit 1
fi

echo "[run-claude-agent] model=$MODEL pwd=$PWD"
echo "[run-claude-agent] body length: $(printf '%s' "$BODY" | wc -c) chars"

# Invoke Claude Code CLI in print (non-interactive) mode.
#  --print                       run once and exit (no REPL)
#  --permission-mode acceptEdits unattended: auto-approve file writes
#  --allowed-tools               only the tools the agents actually need
#  --add-dir "$PWD"              grant the agent access to the workspace root
#                                (it expects to read inputs/* and write outputs/*)
#  --max-turns                   safety bound for the run
#  --model                       from the agent's frontmatter
exec claude \
  --print \
  --model "$MODEL" \
  --max-turns "$MAX_TURNS" \
  --permission-mode acceptEdits \
  --allowed-tools "Read,Edit,Write,Glob,Grep,Bash" \
  --add-dir "$PWD" \
  -p "$BODY"
