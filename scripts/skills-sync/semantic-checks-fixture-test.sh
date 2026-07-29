#!/usr/bin/env bash
#
# semantic-checks-fixture-test.sh — Offline regression coverage for the
# deterministic semantic checks. Does not call Claude or GitHub.
#
# Usage:
#   DOCS_DIR=/path/to/docs AGENT_SKILLS_DIR=/path/to/agent-skills \
#     bash docs/scripts/skills-sync/semantic-checks-fixture-test.sh

set -euo pipefail

DOCS_DIR="${DOCS_DIR:-$(pwd)}"
AGENT_SKILLS_DIR="${AGENT_SKILLS_DIR:-$(dirname "$DOCS_DIR")/agent-skills}"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

OUT_DIR="$WORK_DIR/outputs"
HUNKS_DIR="$OUT_DIR/hunks"
mkdir -p "$HUNKS_DIR"

echo "[semantic-fixture] Working dir:  $WORK_DIR"
echo "[semantic-fixture] Docs dir:     $DOCS_DIR"
echo "[semantic-fixture] Skills dir:   $AGENT_SKILLS_DIR"

if [ ! -d "$AGENT_SKILLS_DIR/skills" ]; then
  echo "semantic-fixture: AGENT_SKILLS_DIR does not contain skills/ — set AGENT_SKILLS_DIR" >&2
  exit 2
fi

cat > "$OUT_DIR/diff.json" <<'JSON'
[
  {"path": "async-collaboration/comments/setup/apryse.mdx", "status": "M", "additions": 4, "deletions": 0},
  {"path": "async-collaboration/comments-sidebar/v2/setup.mdx", "status": "M", "additions": 2, "deletions": 4},
  {"path": "async-collaboration/comments/customize-behavior.mdx", "status": "M", "additions": 3, "deletions": 0},
  {"path": "ui-customization/features/async/comments/comment-dialog/primitives.mdx", "status": "M", "additions": 3, "deletions": 0},
  {"path": "get-started/advanced.mdx", "status": "M", "additions": 3, "deletions": 0},
  {"path": "backend-sdks/node.mdx", "status": "M", "additions": 6, "deletions": 0},
  {"path": "ai/approval-engine/overview.mdx", "status": "M", "additions": 5, "deletions": 0},
  {"path": "api-reference/rest-apis/v2/agents/list-agent-executions.mdx", "status": "M", "additions": 3, "deletions": 0},
  {"path": "api-reference/rest-apis/v2/memory/search.mdx", "status": "M", "additions": 3, "deletions": 0}
]
JSON

cat > "$OUT_DIR/out-of-scope.json" <<'JSON'
[
  {"path": "release-notes/changelog.mdx", "status": "M", "reason": "explicitly out-of-scope in skills-sync mapping"}
]
JSON

cat > "$OUT_DIR/plan.json" <<'JSON'
{
  "tickets": [
    {
      "skill": "velt-comments-best-practices",
      "version_bump": "patch",
      "files": [
        "async-collaboration/comments/setup/apryse.mdx",
        "async-collaboration/comments-sidebar/v2/setup.mdx",
        "async-collaboration/comments/customize-behavior.mdx",
        "ui-customization/features/async/comments/comment-dialog/primitives.mdx"
      ],
      "changes": [
        {"kind": "new-component", "identifier": "ApryseVeltComments", "docs_path": "async-collaboration/comments/setup/apryse.mdx", "target_rule_hint": "rules/shared/mode/mode-apryse.md", "rationale": "Apryse WebViewer comments setup."},
        {"kind": "removed-identifier", "identifier": "VeltCommentsSidebar version=\"2\"", "docs_path": "async-collaboration/comments-sidebar/v2/setup.mdx", "target_rule_hint": "rules/shared/sidebar/sidebar-v2.md", "rationale": "Remove stale version prop guidance."},
        {"kind": "new-prop", "identifier": "collapsedRepliesPreview", "docs_path": "async-collaboration/comments/customize-behavior.mdx", "target_rule_hint": "rules/shared/mode/mode-comments-collapsed-replies.md", "rationale": "Collapsed replies preview behavior."}
      ]
    },
    {
      "skill": "velt-setup-best-practices",
      "version_bump": "patch",
      "files": ["get-started/advanced.mdx"],
      "changes": [
        {"kind": "new-method", "identifier": "setPageInfo", "docs_path": "get-started/advanced.mdx", "target_rule_hint": "rules/shared/documents/documents-page-info.md", "rationale": "Page info API with reserved future documentId option."}
      ]
    },
    {
      "skill": "velt-node-sdk-best-practices",
      "version_bump": "patch",
      "files": ["backend-sdks/node.mdx"],
      "changes": [
        {"kind": "new-prop", "identifier": "FieldFilterOptions", "docs_path": "backend-sdks/node.mdx", "target_rule_hint": "rules/shared/api/api-field-allowlist.md", "rationale": "Node SDK field allowlist."}
      ]
    },
    {
      "skill": "velt-approval-engine-best-practices",
      "version_bump": "patch",
      "files": ["ai/approval-engine/overview.mdx"],
      "changes": [
        {"kind": "new-webhook-event", "identifier": "Inbound webhook handler", "docs_path": "ai/approval-engine/overview.mdx", "target_rule_hint": "rules/shared/webhooks/webhooks-inbound-handler.md", "rationale": "Inbound webhook handler security."}
      ]
    },
    {
      "skill": "velt-rest-apis-best-practices",
      "version_bump": "patch",
      "files": [
        "api-reference/rest-apis/v2/agents/list-agent-executions.mdx",
        "api-reference/rest-apis/v2/memory/search.mdx"
      ],
      "changes": [
        {"kind": "new-endpoint", "identifier": "/v2/agents/execution/list", "docs_path": "api-reference/rest-apis/v2/agents/list-agent-executions.mdx", "target_rule_hint": "rules/shared/rest-api/rest-agents.md", "rationale": "Agents REST endpoint."},
        {"kind": "new-endpoint", "identifier": "/v2/memory/search", "docs_path": "api-reference/rest-apis/v2/memory/search.mdx", "target_rule_hint": "rules/shared/rest-api/rest-memory.md", "rationale": "Memory REST endpoint."}
      ]
    }
  ],
  "unmapped": [],
  "noops": []
}
JSON

write_hunk() {
  local docs_path="$1"
  local body="$2"
  local hunk_file="$HUNKS_DIR/${docs_path}.patch"
  mkdir -p "$(dirname "$hunk_file")"
  printf '%s\n' "$body" > "$hunk_file"
}

write_hunk "async-collaboration/comments/setup/apryse.mdx" '+Apryse WebViewer setup uses ApryseVeltComments with AddCommentArgs and RenderCommentsArgs.'
write_hunk "async-collaboration/comments-sidebar/v2/setup.mdx" '-<VeltCommentsSidebar version="2" />\n+<VeltCommentsSidebarV2 />'
write_hunk "async-collaboration/comments/customize-behavior.mdx" '+<VeltComments collapsedRepliesPreview={true} />'
write_hunk "ui-customization/features/async/comments/comment-dialog/primitives.mdx" '+Use VeltCommentDialogMoreReply.Count and VeltCommentDialogMoreReply.Text.'
write_hunk "get-started/advanced.mdx" '+setPageInfo(pageInfo, { documentId }) is reserved for future per-document scope.'
write_hunk "backend-sdks/node.mdx" '+FieldFilterOptions filterUnknownFields pickKnownFields filterRequest FilterSpec.'
write_hunk "ai/approval-engine/overview.mdx" '+Inbound webhook handler raw JSON ingress Authorization: Bearer signed callback SSRF.'
write_hunk "api-reference/rest-apis/v2/agents/list-agent-executions.mdx" '+POST /v2/agents/execution/list.'
write_hunk "api-reference/rest-apis/v2/memory/search.mdx" '+POST /v2/memory/search.'

OUT_DIR="$OUT_DIR" DOCS_DIR="$DOCS_DIR" AGENT_SKILLS_DIR="$AGENT_SKILLS_DIR" \
  node "$DOCS_DIR/scripts/skills-sync/semantic-checks.mjs"

echo "[semantic-fixture] OK"
