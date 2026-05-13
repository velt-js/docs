#!/usr/bin/env bash
#
# apply-patches.sh — Merge per-skill patch artifacts into the agent-skills working tree.
#
# Each Agent-2 matrix job produces:
#   agent-skills-patches/<skill>.patch  — a `git diff` of that skill's edits
#
# This script applies them all into one agent-skills/ checkout. Conflicts across
# matrix jobs shouldn't happen (each job edits a distinct skill dir), but if they
# do, we fail loudly.
#
# Expected layout:
#   incoming/                   — downloaded artifacts from update-skill matrix
#     <skill>.patch
#     changes-<skill>-<runid>.json (one per matrix job)
#   agent-skills/               — checked-out target repo
#
# Outputs:
#   agent-skills/                — patched working tree
#   outputs/changes-merged.json  — concatenated changes from all matrix jobs

set -euo pipefail

INCOMING_DIR="${INCOMING_DIR:-$PWD/incoming}"
AGENT_SKILLS_DIR="${AGENT_SKILLS_DIR:-$PWD/agent-skills}"
OUT_DIR="${OUT_DIR:-$PWD/outputs}"

mkdir -p "$OUT_DIR"

shopt -s nullglob
PATCHES=( "$INCOMING_DIR"/*.patch )
CHANGES=( "$INCOMING_DIR"/changes.json "$INCOMING_DIR"/*/changes.json )
shopt -u nullglob

if [ ${#PATCHES[@]} -eq 0 ]; then
  echo "apply-patches.sh: no patches found in $INCOMING_DIR" >&2
  echo "[]" > "$OUT_DIR/changes-merged.json"
  exit 0
fi

echo "[apply-patches] Applying ${#PATCHES[@]} patch(es) to $AGENT_SKILLS_DIR"

cd "$AGENT_SKILLS_DIR"
for patch in "${PATCHES[@]}"; do
  echo "  - $(basename "$patch")"
  # --3way leaves conflict markers if there's a conflict; we want a clean apply.
  git apply --index --check "$patch" 2>&1 || {
    echo "apply-patches.sh: patch failed precheck: $patch" >&2
    exit 2
  }
  git apply --index "$patch"
done

# Merge all changes.json files into a single array
{
  echo '['
  first=1
  for c in "${CHANGES[@]}"; do
    [ -f "$c" ] || continue
    [ "$first" = 1 ] || echo ','
    first=0
    cat "$c"
  done
  echo ']'
} | jq -s 'flatten' > "$OUT_DIR/changes-merged.json"

echo "[apply-patches] Done. Merged changes → $OUT_DIR/changes-merged.json"
