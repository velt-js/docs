#!/usr/bin/env bash
#
# drift-check.sh — Detect drift between docs feature dirs, the mapping table,
# and the skills inventory. Used by the weekly skills-sync-drift-check.yml
# workflow.
#
# Outputs:
#   outputs/drift-report.md   — human-readable rollup; empty if no drift.
#   outputs/drift-summary.json — machine-readable summary {has_drift, counts, items}
#
# Usage:
#   DOCS_DIR=/path/to/docs SKILLS_DIR=/path/to/agent-skills/skills \
#     bash drift-check.sh

set -euo pipefail

DOCS_DIR="${DOCS_DIR:-$PWD/docs}"
SKILLS_DIR="${SKILLS_DIR:-$PWD/agent-skills/skills}"
OUT_DIR="${OUT_DIR:-$PWD/outputs}"
MAPPING="${MAPPING:-$DOCS_DIR/scripts/skills-sync/reference-artifacts/mapping.md}"

mkdir -p "$OUT_DIR"
REPORT="$OUT_DIR/drift-report.md"
SUMMARY="$OUT_DIR/drift-summary.json"

# ─────────────────────────────────────────────────────────────────────────────
# 1. Collect known paths from mapping.md
# ─────────────────────────────────────────────────────────────────────────────

# Path prefixes that ARE mapped (extract from the "Mapped paths" table — first column entries with `**`)
MAPPED_PREFIXES=$(awk '
  /^## Mapped paths/      { in_section=1; next }
  /^## /                  { in_section=0 }
  in_section && /^\| `/   {
    # Extract paths from `path/**` cells (may be comma-separated)
    line=$0
    while (match(line, /`[^`]+`/)) {
      cell = substr(line, RSTART+1, RLENGTH-2)
      print cell
      line = substr(line, RSTART+RLENGTH)
    }
  }
' "$MAPPING" | grep -E '^[a-z][a-z0-9-]*/' | sed 's,/\*\*,,' | sort -u)

# Path prefixes that are explicitly unmapped (feature dirs the team has flagged but won't auto-create)
UNMAPPED_PREFIXES=$(awk '
  /^## Unmapped feature paths/ { in_section=1; next }
  /^## /                       { in_section=0 }
  in_section && /^\| `/        {
    line=$0
    while (match(line, /`[^`]+`/)) {
      cell = substr(line, RSTART+1, RLENGTH-2)
      print cell
      line = substr(line, RSTART+RLENGTH)
    }
  }
' "$MAPPING" | grep -E '^[a-z][a-z0-9-]*/' | sed 's,/\*\*,,' | sort -u)

# Explicitly out-of-scope (top-level dirs the pipeline ignores)
OUT_OF_SCOPE_DIRS="release-notes key-concepts migration integrations mcp ai images gifs global-styles snippets live-co-editing"

# ─────────────────────────────────────────────────────────────────────────────
# 2. Walk docs feature dirs and classify each
# ─────────────────────────────────────────────────────────────────────────────

declare -a DRIFT_DOCS

while read -r dir; do
  rel="${dir#$DOCS_DIR/}"
  # Only consider 2nd-level dirs under the watched roots
  top="$(echo "$rel" | cut -d/ -f1)"
  case " $OUT_OF_SCOPE_DIRS " in *" $top "*) continue ;; esac

  # Check if this path prefix is mapped or unmapped
  match_found=0
  for prefix in $MAPPED_PREFIXES $UNMAPPED_PREFIXES; do
    case "$rel/" in
      "$prefix"/*) match_found=1; break ;;
      "$prefix") match_found=1; break ;;
    esac
  done

  if [ "$match_found" -eq 0 ]; then
    # Also tolerate single-file mappings (e.g., security/auth-tokens.mdx)
    # We only flag if NO file inside this dir is mapped or out-of-scope
    DRIFT_DOCS+=("$rel")
  fi
done < <(find "$DOCS_DIR" -mindepth 2 -maxdepth 2 -type d \
            -not -path '*/.*' \
            -not -path '*/node_modules/*' \
            -not -path '*/images/*' \
            -not -path '*/gifs/*' \
            -not -path '*/global-styles/*' \
            -not -path '*/snippets/*' \
            -not -path '*/release-notes/*' 2>/dev/null | sort)

# ─────────────────────────────────────────────────────────────────────────────
# 3. Find skills with no docs path mapping to them
# ─────────────────────────────────────────────────────────────────────────────

declare -a DEAD_SKILLS

for skill_dir in "$SKILLS_DIR"/*/; do
  skill="$(basename "$skill_dir")"
  [ -f "$skill_dir/SKILL.md" ] || continue
  # Search mapping.md for any occurrence of this skill name
  if ! grep -q "\`$skill\`" "$MAPPING"; then
    DEAD_SKILLS+=("$skill")
  fi
done

# ─────────────────────────────────────────────────────────────────────────────
# 4. Compose report
# ─────────────────────────────────────────────────────────────────────────────

HAS_DRIFT=false
{
  echo "# Skills-sync drift report"
  echo ""
  echo "Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo ""

  if [ "${#DRIFT_DOCS[@]}" -gt 0 ]; then
    HAS_DRIFT=true
    echo "## Docs feature dirs with no mapping or unmapped entry"
    echo ""
    echo "These docs paths exist but neither map to a skill nor appear in the unmapped list. Either add a mapping entry, mark them out-of-scope, or open an issue to create a new skill."
    echo ""
    for d in "${DRIFT_DOCS[@]}"; do
      echo "- \`$d\`"
    done
    echo ""
  fi

  if [ "${#DEAD_SKILLS[@]}" -gt 0 ]; then
    HAS_DRIFT=true
    echo "## Skills with no docs path mapped to them"
    echo ""
    echo "These skills exist in \`agent-skills/skills/\` but no entry in \`mapping.md\` references them. They may be orphaned or the mapping table may be incomplete."
    echo ""
    for s in "${DEAD_SKILLS[@]}"; do
      echo "- \`$s\`"
    done
    echo ""
  fi

  if [ "$HAS_DRIFT" = "false" ]; then
    echo "No drift detected. Mapping and skills inventory are in sync."
  fi
} > "$REPORT"

# Summary JSON
jq -nc \
  --argjson has_drift "$([ "$HAS_DRIFT" = "true" ] && echo true || echo false)" \
  --argjson drift_docs_count "${#DRIFT_DOCS[@]}" \
  --argjson dead_skills_count "${#DEAD_SKILLS[@]}" \
  --argjson drift_docs "$(printf '%s\n' "${DRIFT_DOCS[@]:-}" | jq -R . | jq -s .)" \
  --argjson dead_skills "$(printf '%s\n' "${DEAD_SKILLS[@]:-}" | jq -R . | jq -s .)" \
  '{has_drift: $has_drift, drift_docs_count: $drift_docs_count, dead_skills_count: $dead_skills_count, drift_docs: $drift_docs, dead_skills: $dead_skills}' \
  > "$SUMMARY"

echo "Wrote $REPORT"
echo "Wrote $SUMMARY"
if [ "$HAS_DRIFT" = "true" ]; then
  echo "DRIFT DETECTED — ${#DRIFT_DOCS[@]} unmapped doc dir(s), ${#DEAD_SKILLS[@]} orphaned skill(s)"
fi
