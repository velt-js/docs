#!/usr/bin/env bash
#
# prepare-agent-1-inputs.sh — Stages the input/ tree that docs-diff-planner reads.
#
# Inputs (assumed in $PWD):
#   outputs/diff.json
#   outputs/hunks/**.patch
#   docs/scripts/skills-sync/reference-artifacts/{format-guide.md, mapping.md}
#   agent-skills/skills/  (checked-out skills repo)
#
# Outputs:
#   inputs/diff.json
#   inputs/hunks/**.patch
#   inputs/mapping.md
#   inputs/format-guide.md
#   inputs/skill-inventory.json  — derived: list of {name, categories} for each skill

set -euo pipefail

INPUTS_DIR="${INPUTS_DIR:-$PWD/inputs}"
OUT_DIR="${OUT_DIR:-$PWD/outputs}"
DOCS_DIR="${DOCS_DIR:-$PWD/docs}"
SKILLS_DIR="${SKILLS_DIR:-$PWD/agent-skills/skills}"
ARTIFACTS_DIR="$DOCS_DIR/scripts/skills-sync/reference-artifacts"

mkdir -p "$INPUTS_DIR/hunks"

# Copy the diff and hunks
cp "$OUT_DIR/diff.json" "$INPUTS_DIR/diff.json"
if [ -d "$OUT_DIR/hunks" ]; then
  cp -R "$OUT_DIR/hunks/." "$INPUTS_DIR/hunks/"
fi

# Copy the frozen reference artifacts the planner needs
cp "$ARTIFACTS_DIR/mapping.md" "$INPUTS_DIR/mapping.md"
cp "$ARTIFACTS_DIR/format-guide.md" "$INPUTS_DIR/format-guide.md"

# Build skill-inventory.json — walk skills/ for dirs containing SKILL.md,
# then list their rule category folders under rules/shared/ (and rules/react/, rules/non-react/).
INVENTORY="$INPUTS_DIR/skill-inventory.json"
{
  echo '['
  first=1
  for skill_dir in "$SKILLS_DIR"/*/; do
    skill_name="$(basename "$skill_dir")"
    [ -f "$skill_dir/SKILL.md" ] || continue   # skip workspace dirs and non-skill siblings
    [ "$first" = 1 ] || echo ','
    first=0

    # Gather category folders (one level under each source group)
    categories="[]"
    for group in shared react non-react; do
      gdir="$skill_dir/rules/$group"
      [ -d "$gdir" ] || continue
      for cat in "$gdir"/*/; do
        [ -d "$cat" ] || continue
        cat_name="$(basename "$cat")"
        categories=$(echo "$categories" | jq --arg g "$group" --arg c "$cat_name" '. + [{group: $g, name: $c}]')
      done
    done

    jq -nc --arg name "$skill_name" --argjson categories "$categories" \
      '{name: $name, categories: $categories}'
  done
  echo ']'
} | jq -s '.[0]' > "$INVENTORY"

echo "Wrote $INVENTORY ($(jq 'length' "$INVENTORY") skills)"
echo "Staged inputs/ for Agent 1"
