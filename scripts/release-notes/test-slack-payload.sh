#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./lib.sh
source "$SCRIPT_DIR/lib.sh"

payload="$(rn_slack_pr_payload \
  "https://github.com/velt-js/docs/pull/123" \
  "123" \
  "v6.0.0-beta.2" \
  "release-notes/v6.0.0-beta.2.md" \
  "core-SDK" \
  "https://github.com/snippyly/internal-release-notes/blob/main/release-notes/v6.0.0-beta.2.md" \
  "https://github.com/velt-js/docs/actions/runs/1234567890" \
  "In progress")"

printf '%s\n' "$payload" | jq -e . >/dev/null

assert_jq() {
  local name="$1"
  local filter="$2"

  if printf '%s\n' "$payload" | jq -e "$filter" >/dev/null; then
    printf '  ok  %s\n' "$name"
  else
    printf '  FAIL %s\n' "$name" >&2
    printf '%s\n' "$payload" >&2
    exit 1
  fi
}

assert_jq "fallback text includes PR number" '.text | contains("#123")'
assert_jq "payload links PR" '[.. | strings] | any(.[] ; contains("<https://github.com/velt-js/docs/pull/123|#123 v6.0.0-beta.2"))'
assert_jq "payload includes note path" '[.. | strings] | any(.[] ; contains("release-notes/v6.0.0-beta.2.md"))'
assert_jq "payload includes route" '[.. | strings] | any(.[] ; contains("core-SDK"))'
assert_jq "payload includes run link" '[.. | strings] | any(.[] ; contains("GitHub Actions run"))'

printf '\n[test-slack-payload] OK\n'
