#!/usr/bin/env bash

set -euo pipefail

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

cd "$WORK_DIR"
git init -q
git config user.name "Release Note Test"
git config user.email "release-note-test@example.com"

mkdir -p release-notes/velt-node-sdk release-notes/velt-py-sdk docs
printf '# Old\n' > docs/readme.md
git add .
git commit -q -m init

BEFORE="$(git rev-parse HEAD)"
printf '# Core\n' > release-notes/v6.0.0-beta.2.md
printf '# Node\n' > release-notes/velt-node-sdk/v1.0.7.md
printf '# Py\n' > release-notes/velt-py-sdk/v0.1.14.md
printf '# Ignored\n' > docs/ignored.md
git add .
git commit -q -m 'add release notes'
AFTER="$(git rev-parse HEAD)"

git diff --name-status --diff-filter=AMRD "$BEFORE" "$AFTER" -- \
  'release-notes/*.md' \
  'release-notes/**/*.md' \
  | awk '
    BEGIN { OFS="\t" }
    $1 == "A" { print "added", $2; next }
    $1 == "M" { print "modified", $2; next }
    $1 ~ /^R/ { print "renamed", $3; next }
    $1 == "D" { print "deleted", $2; next }
  ' > changed.tsv

fail=0

assert_line() {
  local expected="$1"
  if grep -Fqx "$expected" changed.tsv; then
    printf '  ok  %s\n' "$expected"
  else
    printf '  FAIL missing: %s\n' "$expected" >&2
    fail=1
  fi
}

assert_absent() {
  local unexpected="$1"
  if grep -Fq "$unexpected" changed.tsv; then
    printf '  FAIL unexpected: %s\n' "$unexpected" >&2
    fail=1
  else
    printf '  ok  absent %s\n' "$unexpected"
  fi
}

assert_line $'added\trelease-notes/v6.0.0-beta.2.md'
assert_line $'added\trelease-notes/velt-node-sdk/v1.0.7.md'
assert_line $'added\trelease-notes/velt-py-sdk/v0.1.14.md'
assert_absent 'docs/ignored.md'

if [ "$fail" -ne 0 ]; then
  printf '\n[test-detector] changed.tsv:\n' >&2
  cat changed.tsv >&2
  exit 1
fi

printf '\n[test-detector] OK\n'
