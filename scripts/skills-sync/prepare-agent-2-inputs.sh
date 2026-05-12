#!/usr/bin/env bash
#
# prepare-agent-2-inputs.sh — Stages per-skill inputs for one skill-updater matrix job.
#
# Usage:
#   bash prepare-agent-2-inputs.sh <skill-name>
#
# Reads:
#   outputs/plan.json                  (from Agent 1)
#   docs/<path>                        (relevant docs files referenced by the ticket)
#   docs/scripts/skills-sync/reference-artifacts/format-guide.md
#   agent-skills/skills/<skill>/        (the target skill)
#
# Writes:
#   inputs/ticket.json                  (just this skill's ticket)
#   inputs/format-guide.md              (verbatim)
#   inputs/docs/<path>                  (each docs file referenced by the ticket, copied in)
#   inputs/skill/                       (a copy of agent-skills/skills/<skill>/)

set -euo pipefail

SKILL="${1:?skill name is required}"
INPUTS_DIR="${INPUTS_DIR:-$PWD/inputs}"
OUT_DIR="${OUT_DIR:-$PWD/outputs}"
DOCS_DIR="${DOCS_DIR:-$PWD/docs}"
SKILLS_DIR="${SKILLS_DIR:-$PWD/agent-skills/skills}"
ARTIFACTS_DIR="$DOCS_DIR/scripts/skills-sync/reference-artifacts"

mkdir -p "$INPUTS_DIR/docs" "$INPUTS_DIR/skill"

# Extract this skill's ticket from plan.json. If not present, exit cleanly (no work).
TICKET=$(jq --arg name "$SKILL" '.tickets[] | select(.skill == $name)' "$OUT_DIR/plan.json")
if [ -z "$TICKET" ]; then
  echo "No ticket for $SKILL in plan.json — nothing to do" >&2
  exit 0
fi

echo "$TICKET" > "$INPUTS_DIR/ticket.json"

# Copy the format guide (Agent 2 references it for hard rules)
cp "$ARTIFACTS_DIR/format-guide.md" "$INPUTS_DIR/format-guide.md"

# Copy each docs file referenced by the ticket
jq -r '.files[]' "$INPUTS_DIR/ticket.json" | while read -r doc_path; do
  src="$DOCS_DIR/$doc_path"
  if [ ! -f "$src" ]; then
    # File was deleted in this diff — record path but no content
    mkdir -p "$INPUTS_DIR/docs/$(dirname "$doc_path")"
    echo "[file was deleted in this diff]" > "$INPUTS_DIR/docs/$doc_path"
    continue
  fi
  mkdir -p "$INPUTS_DIR/docs/$(dirname "$doc_path")"
  cp "$src" "$INPUTS_DIR/docs/$doc_path"
done

# Copy the skill into a workspace the agent will edit in place
if [ ! -d "$SKILLS_DIR/$SKILL" ]; then
  echo "Skill directory not found: $SKILLS_DIR/$SKILL" >&2
  exit 1
fi
cp -R "$SKILLS_DIR/$SKILL/." "$INPUTS_DIR/skill/"

# Provide a hunks/ slice scoped to this ticket's files (helps the agent see what changed)
mkdir -p "$INPUTS_DIR/hunks"
jq -r '.files[]' "$INPUTS_DIR/ticket.json" | while read -r doc_path; do
  src="$OUT_DIR/hunks/${doc_path}.patch"
  [ -f "$src" ] || continue
  mkdir -p "$INPUTS_DIR/hunks/$(dirname "$doc_path")"
  cp "$src" "$INPUTS_DIR/hunks/${doc_path}.patch"
done

echo "Staged inputs/ for skill-updater on $SKILL"
