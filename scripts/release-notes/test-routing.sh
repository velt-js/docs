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

case_route() {
  local path="$1" class="$2" branch="$3" title="$4" changelog="$5"
  printf '\n[test-routing] %s\n' "$path"
  rn_classify_path "$path"
  assert_eq "class" "$class" "$RN_CLASS"
  assert_eq "branch" "$branch" "$RN_BRANCH"
  assert_eq "title" "$title" "$RN_TITLE"
  assert_eq "changelog" "$changelog" "$RN_CHANGELOG"
}

case_route \
  "release-notes/v6.0.0-beta.2.md" \
  "core-SDK" \
  "v6.0.0-beta.2" \
  "v6.0.0-beta.2" \
  "release-notes/version-6/sdk-changelog.mdx"

case_route \
  "release-notes/velt-node-sdk/v1.0.7.md" \
  "velt-node" \
  "velt-node-docs-v1.0.7" \
  "velt-node-v1.0.7" \
  "release-notes/version-5/velt-node-changelog.mdx"

case_route \
  "release-notes/velt-py-sdk/v0.1.14.md" \
  "velt-py" \
  "velt-py-v0.1.14" \
  "velt-py-v0.1.14" \
  "release-notes/version-5/velt-py-changelog.mdx"

case_route \
  "release-notes/shared-firebase-function-23-June-2026-pr3476.md" \
  "firebase" \
  "" \
  "shared-firebase-function shared-firebase-function-23-June-2026-pr3476" \
  ""

case_route \
  "release-notes/workspace-apis-documentation.md" \
  "unknown" \
  "release-note-unknown-workspace-apis-documentation" \
  "[needs triage] workspace-apis-documentation" \
  ""

if [ "$fail" -ne 0 ]; then
  exit 1
fi

printf '\n[test-routing] OK\n'
