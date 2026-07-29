#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

OUTPUT="$WORK_DIR/github-output.txt"

GITHUB_OUTPUT="$OUTPUT" \
INPUT_RELEASE_NOTE_URL="https://github.com/snippyly/internal-release-notes/blob/main/release-notes/v6.0.0-beta.2.md" \
INPUT_CHANGE_TYPE="added" \
INPUT_DRY_RUN="false" \
  bash "$SCRIPT_DIR/resolve-release-note-input.sh" >/tmp/release-note-resolver-test.log

fail=0

assert_line() {
  local expected="$1"
  if grep -Fqx "$expected" "$OUTPUT"; then
    printf '  ok  %s\n' "$expected"
  else
    printf '  FAIL missing: %s\n' "$expected" >&2
    fail=1
  fi
}

assert_line "note_path=release-notes/v6.0.0-beta.2.md"
assert_line "note_ref=main"
assert_line "source_repo=snippyly/internal-release-notes"
assert_line "pipeline_mode=resume"
assert_line "source_note_url=https://github.com/snippyly/internal-release-notes/blob/main/release-notes/v6.0.0-beta.2.md"

if GITHUB_OUTPUT="$WORK_DIR/conflict.txt" \
  INPUT_RELEASE_NOTE_URL="https://github.com/snippyly/internal-release-notes/blob/main/release-notes/v6.0.0-beta.2.md" \
  INPUT_PATH="release-notes/v5.0.4.md" \
    bash "$SCRIPT_DIR/resolve-release-note-input.sh" >/tmp/release-note-resolver-conflict.log 2>&1; then
  printf '  FAIL path/url conflict resolved unexpectedly\n' >&2
  fail=1
else
  printf '  ok  path/url conflict rejected\n'
fi

if [ "$fail" -ne 0 ]; then
  printf '\n[test-resolver] output:\n' >&2
  cat "$OUTPUT" >&2 || true
  exit 1
fi

printf '\n[test-resolver] OK\n'
