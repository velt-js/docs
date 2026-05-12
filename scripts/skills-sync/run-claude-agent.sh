#!/usr/bin/env bash
#
# run-claude-agent.sh — Thin wrapper around the claude-code CLI for skills-sync agents.
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
#   AGENT_MODEL      (default: leave unset; the agent's frontmatter `model:` controls)
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

# Invoke claude-code CLI.
# NOTE: The exact flags depend on the claude-code CLI version in the runner.
# This wrapper assumes the same invocation pattern as the release-note pipeline.
# Tune flags here when integrating with the chosen CLI.
claude-code \
  --agent "$AGENT_FILE" \
  --max-turns "$MAX_TURNS" \
  --output-dir "$PWD/outputs" \
  --allowed-tools "Read,Edit,Write,Glob,Grep,Bash"
