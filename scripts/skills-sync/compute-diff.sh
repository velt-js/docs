#!/usr/bin/env bash
#
# compute-diff.sh — Stage 0 of the skills-sync pipeline.
#
# Reads two docs SHAs (BEFORE_SHA, AFTER_SHA) and emits:
#   outputs/diff.json         — array of {path, status, additions, deletions}
#   outputs/hunks/<path>.patch — per-file diff hunks (added/removed lines)
#
# The downstream planner agent reads diff.json + the hunks/ tree.
#
# Expected env:
#   BEFORE_SHA  — base SHA (typically github.event.before)
#   AFTER_SHA   — head SHA (typically github.sha)
#   DOCS_DIR    — path to docs/ checkout (default: $PWD/docs)
#
# Outputs land in $PWD/outputs/

set -euo pipefail

: "${BEFORE_SHA:?BEFORE_SHA is required}"
: "${AFTER_SHA:?AFTER_SHA is required}"
DOCS_DIR="${DOCS_DIR:-$PWD/docs}"
OUT_DIR="${OUT_DIR:-$PWD/outputs}"
HUNKS_DIR="$OUT_DIR/hunks"

mkdir -p "$HUNKS_DIR"

cd "$DOCS_DIR"

# Verify both SHAs exist locally (workflow checkout uses fetch-depth: 0)
git cat-file -e "$BEFORE_SHA" 2>/dev/null || { echo "BEFORE_SHA $BEFORE_SHA not found in docs checkout" >&2; exit 2; }
git cat-file -e "$AFTER_SHA" 2>/dev/null || { echo "AFTER_SHA $AFTER_SHA not found in docs checkout" >&2; exit 2; }

# Emit one JSON line per changed file, then assemble into a JSON array.
# Statuses: A (added), M (modified), D (deleted), R (renamed). Skip C (copied) — treat as A.
TMP_JSONL="$(mktemp)"
TMP_OUT_OF_SCOPE_JSONL="$(mktemp)"
trap 'rm -f "$TMP_JSONL" "$TMP_OUT_OF_SCOPE_JSONL"' EXIT

# Pre-filter: drop paths that mapping.md marks as explicitly out-of-scope.
# This keeps the agent's diff.json small so it stays within its turn budget.
is_out_of_scope() {
  case "$1" in
    release-notes/*|key-concepts/*|migration/*|integrations/*) return 0 ;;
    mcp/*|images/*|gifs/*|global-styles/*|snippets/*) return 0 ;;
    *.css) return 0 ;;
    live-co-editing/*) return 0 ;;
    api-reference/open-api/*|api-reference/postman-collection/*) return 0 ;;
    # get-started pages are meta-docs about the AI toolchain, not SDK features
    get-started/skills.mdx|get-started/plugins.mdx|get-started/agentic-overview.mdx) return 0 ;;
    get-started/mcp-installer.mdx|get-started/cli.mdx) return 0 ;;
    *) return 1 ;;
  esac
}

git diff --name-status --no-renames "$BEFORE_SHA" "$AFTER_SHA" -- \
  'async-collaboration/**' \
  'realtime-collaboration/**' \
  'api-reference/rest-apis/**' \
  'api-reference/sdk/**' \
  'self-host-data/**' \
  'security/**' \
  'webhooks/**' \
  'get-started/**' \
  'backend-sdks/**' \
  'ui-customization/**' \
  'permission-management/**' \
  'in-app-user-feedback/**' \
  'ai/**' \
  | while IFS=$'\t' read -r status path; do
      # Skip out-of-scope paths before they enter diff.json
      if is_out_of_scope "$path"; then
        echo "Skipping out-of-scope: $path"
        jq -nc \
          --arg path "$path" \
          --arg status "$status" \
          --arg reason "explicitly out-of-scope in skills-sync mapping" \
          '{path: $path, status: $status, reason: $reason}' \
          >> "$TMP_OUT_OF_SCOPE_JSONL"
        continue
      fi
      # numstat for additions/deletions on this single path
      read -r additions deletions _ < <(git diff --numstat "$BEFORE_SHA" "$AFTER_SHA" -- "$path" || echo "0 0 $path")
      jq -nc \
        --arg path "$path" \
        --arg status "$status" \
        --argjson additions "${additions:-0}" \
        --argjson deletions "${deletions:-0}" \
        '{path: $path, status: $status, additions: $additions, deletions: $deletions}' \
        >> "$TMP_JSONL"

      # Emit hunks. Skip for deletions — there's nothing useful to read.
      if [ "$status" != "D" ]; then
        hunk_path="$HUNKS_DIR/${path}.patch"
        mkdir -p "$(dirname "$hunk_path")"
        git diff "$BEFORE_SHA" "$AFTER_SHA" -- "$path" > "$hunk_path"
      fi
    done

# Wrap JSONL into a JSON array (empty array if no lines)
if [ -s "$TMP_JSONL" ]; then
  jq -s '.' "$TMP_JSONL" > "$OUT_DIR/diff.json"
else
  echo '[]' > "$OUT_DIR/diff.json"
fi

if [ -s "$TMP_OUT_OF_SCOPE_JSONL" ]; then
  jq -s '.' "$TMP_OUT_OF_SCOPE_JSONL" > "$OUT_DIR/out-of-scope.json"
else
  echo '[]' > "$OUT_DIR/out-of-scope.json"
fi

echo "Wrote $OUT_DIR/diff.json ($(jq 'length' "$OUT_DIR/diff.json") changed files)"
echo "Wrote $OUT_DIR/out-of-scope.json ($(jq 'length' "$OUT_DIR/out-of-scope.json") skipped files)"
echo "Wrote per-file hunks under $HUNKS_DIR"
