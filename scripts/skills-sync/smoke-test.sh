#!/usr/bin/env bash
#
# smoke-test.sh — Local end-to-end check that Agent 1 (docs-diff-planner)
# behaves sanely on a synthetic diff.
#
# Constructs a fake diff that adds a "darkMode" prop to a comments docs file,
# then runs Agent 1 against it and asserts plan.json has exactly one ticket
# routed to velt-comments-best-practices.
#
# Usage:
#   ANTHROPIC_API_KEY=sk-ant-... \
#   AGENT_SKILLS_DIR=/path/to/agent-skills \
#   DOCS_DIR=/path/to/docs \
#   bash docs/scripts/skills-sync/smoke-test.sh
#
# Exit codes:
#   0  — all assertions passed
#   1  — assertion failed (see stderr)
#   2  — environment or setup error

set -euo pipefail

: "${ANTHROPIC_API_KEY:?ANTHROPIC_API_KEY is required}"
DOCS_DIR="${DOCS_DIR:-$(pwd)}"
AGENT_SKILLS_DIR="${AGENT_SKILLS_DIR:-$(dirname "$DOCS_DIR")/agent-skills}"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

echo "[smoke-test] Working dir:  $WORK_DIR"
echo "[smoke-test] Docs dir:     $DOCS_DIR"
echo "[smoke-test] Skills dir:   $AGENT_SKILLS_DIR"

if [ ! -d "$AGENT_SKILLS_DIR/skills" ]; then
  echo "smoke-test: AGENT_SKILLS_DIR does not contain skills/ — set AGENT_SKILLS_DIR" >&2
  exit 2
fi

cd "$WORK_DIR"
mkdir -p outputs inputs

# ─────────────────────────────────────────────────────────────────────────────
# 1. Build a synthetic diff.json + hunks/
# ─────────────────────────────────────────────────────────────────────────────

FAKE_DOC_PATH="async-collaboration/comments/customize-bubble.mdx"

# diff.json — one modified file
cat > outputs/diff.json <<EOF
[
  {"path": "$FAKE_DOC_PATH", "status": "M", "additions": 3, "deletions": 0}
]
EOF

# hunks/ — a synthetic unified diff that introduces a darkMode prop
mkdir -p "outputs/hunks/$(dirname "$FAKE_DOC_PATH")"
cat > "outputs/hunks/${FAKE_DOC_PATH}.patch" <<'EOF'
diff --git a/async-collaboration/comments/customize-bubble.mdx b/async-collaboration/comments/customize-bubble.mdx
index abc1234..def5678 100644
--- a/async-collaboration/comments/customize-bubble.mdx
+++ b/async-collaboration/comments/customize-bubble.mdx
@@ -42,6 +42,9 @@ Customize the comment bubble's appearance with the following props:
 <ParamField path="theme" type="string">
   Visual theme: "light" or "dark".
 </ParamField>
+<ParamField path="darkMode" type="boolean">
+  Force the bubble into dark mode regardless of system theme.
+</ParamField>
 <ParamField path="badge" type="boolean">
   Show an unread badge.
 </ParamField>
EOF

# ─────────────────────────────────────────────────────────────────────────────
# 2. Stage Agent 1 inputs (reuses prepare-agent-1-inputs.sh)
# ─────────────────────────────────────────────────────────────────────────────

DOCS_DIR_ABS="$DOCS_DIR" SKILLS_DIR="$AGENT_SKILLS_DIR/skills" \
  DOCS_DIR="$DOCS_DIR" \
  bash "$DOCS_DIR/scripts/skills-sync/prepare-agent-1-inputs.sh"

# ─────────────────────────────────────────────────────────────────────────────
# 3. Run Agent 1
# ─────────────────────────────────────────────────────────────────────────────

if ! command -v claude-code >/dev/null 2>&1; then
  echo "smoke-test: claude-code CLI not on PATH — install it before running this test" >&2
  exit 2
fi

DOCS_DIR="$DOCS_DIR" \
  bash "$DOCS_DIR/scripts/skills-sync/run-claude-agent.sh" docs-diff-planner

# ─────────────────────────────────────────────────────────────────────────────
# 4. Assertions
# ─────────────────────────────────────────────────────────────────────────────

PLAN="outputs/plan.json"
if [ ! -f "$PLAN" ]; then
  echo "FAIL: Agent 1 did not produce plan.json" >&2
  exit 1
fi

fail=0

assert_eq() {
  local name="$1" expected="$2" actual="$3"
  if [ "$actual" = "$expected" ]; then
    echo "  ✓ $name = $actual"
  else
    echo "  ✗ $name: expected $expected, got $actual" >&2
    fail=1
  fi
}

echo "[smoke-test] Asserting plan.json shape and content..."

assert_eq "tickets length"  "1" "$(jq '.tickets | length' "$PLAN")"
assert_eq "ticket[0].skill" '"velt-comments-best-practices"' "$(jq '.tickets[0].skill' "$PLAN")"
assert_eq "ticket[0].changes length (>=1)" "true" \
  "$([ "$(jq '.tickets[0].changes | length' "$PLAN")" -ge 1 ] && echo true || echo false)"

# Check that the change references darkMode
if jq -e '.tickets[0].changes[] | select(.identifier == "darkMode")' "$PLAN" >/dev/null; then
  echo "  ✓ ticket[0].changes references darkMode"
else
  echo "  ✗ ticket[0].changes does not reference identifier=darkMode (Agent 1 may have misclassified)"
  echo "    Got: $(jq -c '.tickets[0].changes' "$PLAN")" >&2
  fail=1
fi

# version_bump should be patch (adding a prop)
assert_eq "ticket[0].version_bump" '"patch"' "$(jq '.tickets[0].version_bump' "$PLAN")"

# unmapped should be empty
assert_eq "unmapped length"   "0" "$(jq '.unmapped | length' "$PLAN")"

if [ "$fail" -ne 0 ]; then
  echo ""
  echo "[smoke-test] FAILED. Full plan.json:"
  jq . "$PLAN" >&2
  exit 1
fi

echo ""
echo "[smoke-test] OK — all assertions passed."
