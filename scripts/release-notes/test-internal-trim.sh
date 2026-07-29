#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./lib.sh
source "$SCRIPT_DIR/lib.sh"

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

fail=0

assert_absent() {
  local name="$1" pattern="$2" file="$3"
  if rg -F "$pattern" "$file" >/dev/null; then
    printf '  FAIL %s leaked pattern: %s\n' "$name" "$pattern" >&2
    fail=1
  else
    printf '  ok  %s did not leak %s\n' "$name" "$pattern"
  fi
}

assert_present() {
  local name="$1" pattern="$2" file="$3"
  if rg -F "$pattern" "$file" >/dev/null; then
    printf '  ok  %s contains %s\n' "$name" "$pattern"
  else
    printf '  FAIL %s missing pattern: %s\n' "$name" "$pattern" >&2
    fail=1
  fi
}

write_case() {
  local name="$1" header="$2"
  local source="$WORK_DIR/${name}.md"
  local output="$WORK_DIR/${name}-public.md"
  local marker="$WORK_DIR/${name}.env"

  cat > "$source" <<EOF
# v6.0.0-beta.2

Public change summary.

${header}

PRIVATE_TOKEN_SHOULD_NOT_LEAK
Internal implementation context.
EOF

  rn_write_public_note "$source" "$output" "$marker"
  assert_present "$name" "Public change summary." "$output"
  assert_absent "$name" "PRIVATE_TOKEN_SHOULD_NOT_LEAK" "$output"
  assert_absent "$name" "Internal implementation context." "$output"
  assert_present "$name marker" "trimmed_internal_section=true" "$marker"
}

write_case "internal" "## Internal"
write_case "for-internal-use" "# For Internal Use"
write_case "internal-context" "Internal Context:"

cat > "$WORK_DIR/internal-only.md" <<'EOF'
## Internal
Private details only.
EOF

if rn_write_public_note "$WORK_DIR/internal-only.md" "$WORK_DIR/internal-only-public.md" "$WORK_DIR/internal-only.env" 2>/dev/null; then
  printf '  FAIL internal-only note unexpectedly produced public content\n' >&2
  fail=1
else
  printf '  ok  internal-only note rejected\n'
fi

cat > "$WORK_DIR/summary-hint.md" <<'EOF'
# v6.0.0-beta.2

| SDK | React (sdk-react) |

Public summary.

## Internal Context

@veltdev/node private implementation notes that must not affect routing.
EOF

rn_classify_path "release-notes/v6.0.0-beta.2.md"
if rn_validate_summary_hint "$WORK_DIR/summary-hint.md"; then
  if [ "$RN_CLASS" = "core-SDK" ]; then
    printf '  ok  internal SDK mention did not affect summary validation\n'
  else
    printf '  FAIL expected core-SDK after summary validation, got %s\n' "$RN_CLASS" >&2
    fail=1
  fi
else
  printf '  FAIL internal SDK mention caused summary validation conflict\n' >&2
  fail=1
fi

if [ "$fail" -ne 0 ]; then
  exit 1
fi

printf '\n[test-internal-trim] OK\n'
