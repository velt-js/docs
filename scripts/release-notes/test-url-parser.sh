#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./lib.sh
source "$SCRIPT_DIR/lib.sh"

fail=0

assert_eq() {
  local name="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    printf '  ok  %s = %s\n' "$name" "$actual"
  else
    printf '  FAIL %s: expected %s, got %s\n' "$name" "$expected" "$actual" >&2
    fail=1
  fi
}

parse_case() {
  local url="$1" repo="$2" ref="$3" path="$4"
  printf '\n[test-url-parser] %s\n' "$url"
  rn_parse_release_note_url "$url"
  assert_eq "repo" "$repo" "$RN_URL_REPO"
  assert_eq "ref" "$ref" "$RN_URL_REF"
  assert_eq "path" "$path" "$RN_URL_PATH"
}

parse_case \
  "https://github.com/snippyly/internal-release-notes/blob/main/release-notes/v6.0.0-beta.2.md" \
  "snippyly/internal-release-notes" \
  "main" \
  "release-notes/v6.0.0-beta.2.md"

parse_case \
  "https://github.com/snippyly/internal-release-notes/blob/9b9bf9e6bb20d0c6d1b520275632e2c5ec72e7db/release-notes/velt-node-sdk/v1.0.7.md?plain=1" \
  "snippyly/internal-release-notes" \
  "9b9bf9e6bb20d0c6d1b520275632e2c5ec72e7db" \
  "release-notes/velt-node-sdk/v1.0.7.md"

parse_case \
  "https://raw.githubusercontent.com/snippyly/internal-release-notes/main/release-notes/velt-py-sdk/v0.1.14.md" \
  "snippyly/internal-release-notes" \
  "main" \
  "release-notes/velt-py-sdk/v0.1.14.md"

if rn_parse_release_note_url "https://github.com/snippyly/internal-release-notes/tree/main/release-notes"; then
  printf '  FAIL unsupported tree URL parsed unexpectedly\n' >&2
  fail=1
else
  printf '  ok  unsupported tree URL rejected\n'
fi

if [ "$fail" -ne 0 ]; then
  exit 1
fi

printf '\n[test-url-parser] OK\n'
