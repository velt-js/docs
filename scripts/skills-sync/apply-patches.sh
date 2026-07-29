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
DOWNLOAD_ROOT="${DOWNLOAD_ROOT:-$PWD/incoming}"
AGENT_SKILLS_DIR="${AGENT_SKILLS_DIR:-$PWD/agent-skills}"
OUT_DIR="${OUT_DIR:-$PWD/outputs}"

mkdir -p "$OUT_DIR"

shopt -s nullglob
PATCHES=( "$INCOMING_DIR"/*.patch )
# changes.json lives under outputs/ in each artifact, which extracts to
# $DOWNLOAD_ROOT/outputs/ — NOT inside $INCOMING_DIR (agent-skills-patches/).
CHANGES=( "$DOWNLOAD_ROOT"/changes.json "$DOWNLOAD_ROOT"/*/changes.json )
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
  # --3way lets a patch generated against a slightly different base (e.g. an
  # accumulator branch that already bumped metadata.json) still apply via a
  # 3-way merge instead of failing on stale context. With the patch generated
  # against the same ref it's applied onto (see docs-sync-skills.yml base_ref),
  # the normal path applies cleanly; --3way is the safety net. A genuine
  # conflict still fails loudly rather than being silently skipped.
  git apply --index --3way "$patch" 2>&1 || {
    echo "apply-patches.sh: patch failed to apply (3-way): $patch" >&2
    exit 2
  }
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
