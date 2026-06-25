#!/usr/bin/env bash
#
# Deterministic release-note -> docs PR runner.
#
# This script owns routing, branch/PR reuse, checkpointing, restart behavior,
# and failure reporting. It invokes the committed release-note agents one at a
# time with Claude Code pinned to Opus 4.8.

set -euo pipefail

: "${GH_TOKEN:?GH_TOKEN is required}"
: "${NOTE_REPO:?NOTE_REPO is required}"
: "${NOTE_PATH:?NOTE_PATH is required}"
: "${SOURCE_DIR:?SOURCE_DIR is required}"

DOCS_REPO="${DOCS_REPO:-velt-js/docs}"
SOURCE_REPO="${SOURCE_REPO:-$NOTE_REPO}"
SOURCE_SHA="${SOURCE_SHA:-}"
SOURCE_NOTE_URL="${SOURCE_NOTE_URL:-}"
CHANGE_TYPE="${CHANGE_TYPE:-added}"
MODE="${PIPELINE_MODE:-auto}"
DRY_RUN="${PIPELINE_DRY_RUN:-false}"
MODEL="${PIPELINE_MODEL:-claude-opus-4-8}"
RUN_URL="${RUN_URL:-}"
SLACK_WEBHOOK_URL="${SLACK_WEBHOOK_URL:-}"
DOCS_ROOT="$PWD"

case "$MODE" in
  auto|resume|force) ;;
  *) echo "run-release-note-pipeline: unsupported PIPELINE_MODE=$MODE" >&2; exit 1 ;;
esac

if [ "$MODE" = "auto" ] && { [ "$CHANGE_TYPE" = "modified" ] || [ "$CHANGE_TYPE" = "renamed" ]; }; then
  MODE="force"
fi

BOOTSTRAP_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUNTIME_ROOT="${RUNNER_TEMP:-/tmp}/release-note-pipeline-runtime-${GITHUB_RUN_ID:-$$}"
SCRIPT_DIR="$RUNTIME_ROOT/scripts"
AGENTS_ROOT="$RUNTIME_ROOT/agents"
AGENT_SOURCES=()

rm -rf "$RUNTIME_ROOT"
mkdir -p "$SCRIPT_DIR" "$AGENTS_ROOT"
cp "$BOOTSTRAP_SCRIPT_DIR"/*.sh "$SCRIPT_DIR/"

if [ -d "$DOCS_ROOT/.claude/agents" ]; then
  shopt -s nullglob
  AGENT_SOURCES=( "$DOCS_ROOT"/.claude/agents/Agent-*.md )
  shopt -u nullglob
  if [ "${#AGENT_SOURCES[@]}" -gt 0 ]; then
    cp "${AGENT_SOURCES[@]}" "$AGENTS_ROOT/"
  fi
fi

# shellcheck source=./lib.sh
source "$SCRIPT_DIR/lib.sh"

log() {
  printf '[release-note-pipeline] %s\n' "$*"
}

source_note_url() {
  if [ -n "$SOURCE_NOTE_URL" ]; then
    printf '%s' "$SOURCE_NOTE_URL"
  else
    printf 'https://github.com/%s/blob/%s/%s' "$SOURCE_REPO" "${SOURCE_SHA:-main}" "$NOTE_PATH"
  fi
}

version_ge() {
  local actual="$1" required="$2"
  [ "$(printf '%s\n%s\n' "$required" "$actual" | sort -V | head -n1)" = "$required" ]
}

ensure_claude_supports_opus_48() {
  local version

  if ! command -v claude >/dev/null 2>&1; then
    echo "Claude Code CLI is not installed" >&2
    exit 1
  fi

  version="$(claude --version | awk '{print $1}')"
  if ! version_ge "$version" "2.1.154"; then
    echo "Claude Code $version is too old for Opus 4.8; install v2.1.154 or newer before running agents" >&2
    exit 1
  fi
}

note_file() {
  printf '%s/%s' "$SOURCE_DIR" "$NOTE_PATH"
}

git_remote_branch_exists() {
  git ls-remote --exit-code --heads origin "$1" >/dev/null 2>&1
}

open_pr_for_branch() {
  local branch="$1"
  gh pr list \
    --repo "$DOCS_REPO" \
    --state open \
    --head "$branch" \
    --json number,url \
    --jq '.[0] // empty'
}

newest_core_release_pr() {
  gh pr list \
    --repo "$DOCS_REPO" \
    --state open \
    --limit 100 \
    --json number,title,headRefName,createdAt \
    --jq '[.[] | select(.headRefName | test("^v[0-9]"))] | sort_by(.createdAt) | reverse | .[0] // empty'
}

run_dir_for_current_route() {
  printf '.claude/release-notes/runs/%s' "$RN_SAFE_STEM"
}

write_route_files() {
  mkdir -p "$RUN_DIR" ".claude/release-notes"
  rn_write_public_note "$(note_file)" "$LOCAL_NOTE" "$RUN_DIR/public-note.env"
  rn_route_json > "$RUN_DIR/route.json"
  {
    printf 'NOTE_REPO=%q\n' "$NOTE_REPO"
    printf 'SOURCE_REPO=%q\n' "$SOURCE_REPO"
    printf 'NOTE_PATH=%q\n' "$NOTE_PATH"
    printf 'SOURCE_SHA=%q\n' "$SOURCE_SHA"
    printf 'CHANGE_TYPE=%q\n' "$CHANGE_TYPE"
    printf 'PIPELINE_MODE=%q\n' "$MODE"
    printf 'RUN_URL=%q\n' "$RUN_URL"
    printf 'RN_CLASS=%q\n' "$RN_CLASS"
    printf 'RN_VERSION=%q\n' "$RN_VERSION"
    printf 'RN_BRANCH=%q\n' "$RN_BRANCH"
    printf 'RN_TITLE=%q\n' "$RN_TITLE"
    printf 'RN_CHANGELOG=%q\n' "$RN_CHANGELOG"
    if [ -f "$RUN_DIR/public-note.env" ]; then
      cat "$RUN_DIR/public-note.env"
    fi
  } > "$RUN_DIR/run.env"
}

write_pr_body() {
  local body_file="$1"
  local status="${2:-In progress}"
  local source_ref="main"

  if [ -n "$SOURCE_SHA" ]; then
    source_ref="$SOURCE_SHA"
  fi

  cat > "$body_file" <<EOF
## Summary

Automated release-note docs pipeline for \`${NOTE_PATH}\`.

- Route: \`${RN_CLASS}\`
- Source note: https://github.com/${SOURCE_REPO}/blob/${source_ref}/${NOTE_PATH}
- Rerun URL: $(source_note_url)
- Status: ${status}
- Run: ${RUN_URL:-not provided}

## Needs human follow-up

- Review the generated docs changes before merging.
- Confirm the conservative automation defaults were appropriate for this note.
EOF

  if [ -n "$RN_TRIAGE_REASON" ]; then
    printf '%s\n' "- Triage reason: ${RN_TRIAGE_REASON}" >> "$body_file"
  fi

  cat >> "$body_file" <<EOF

## Checkpoints

Runtime checkpoints are saved under \`${RUN_DIR}\`.
EOF
}

commit_and_push() {
  local message="$1"
  local push_branch="${2:-$CURRENT_BRANCH}"

  git add -A
  if git diff --cached --quiet; then
    log "No changes to commit for: $message"
    return 0
  fi

  if [ "$DRY_RUN" = "true" ]; then
    log "Dry run: would commit and push to $push_branch: $message"
    git diff --cached --stat
    git reset -q
    return 0
  fi

  git commit -m "$message"
  if ! git push -u origin "HEAD:${push_branch}"; then
    echo "Push failed for $push_branch. This is usually a non-fast-forward branch update; not force-pushing." >&2
    return 1
  fi
}

comment_pr() {
  local number="$1"
  local body="$2"

  if [ "$DRY_RUN" = "true" ]; then
    log "Dry run: would comment on PR #$number: $body"
    return 0
  fi
  gh pr comment "$number" --repo "$DOCS_REPO" --body "$body" || true
}

create_issue() {
  local title="$1"
  local body="$2"

  if [ "$DRY_RUN" = "true" ]; then
    log "Dry run: would create issue: $title"
    return 0
  fi
  gh issue create --repo "$DOCS_REPO" --title "$title" --body "$body" --label documentation || true
}

notify_slack_pr_created() {
  local status="$1"
  local payload_file

  if [ "$DRY_RUN" = "true" ]; then
    log "Dry run: would notify Slack about PR #${PR_NUMBER:-unknown}"
    return 0
  fi

  if [ -z "$SLACK_WEBHOOK_URL" ]; then
    log "Slack notification skipped: DOCS_AUTOMATION_SLACK_WEBHOOK_URL is not configured"
    return 0
  fi

  payload_file="${RUNNER_TEMP:-/tmp}/release-note-pr-${PR_NUMBER}.slack.json"
  rn_slack_pr_payload \
    "$PR_URL" \
    "$PR_NUMBER" \
    "$RN_TITLE" \
    "$NOTE_PATH" \
    "$RN_CLASS" \
    "$(source_note_url)" \
    "$RUN_URL" \
    "$status" > "$payload_file"

  if curl -fsS \
    -X POST \
    -H 'Content-Type: application/json; charset=utf-8' \
    --data-binary "@${payload_file}" \
    "$SLACK_WEBHOOK_URL" >/dev/null; then
    log "Notified Slack for PR #$PR_NUMBER"
  else
    log "Slack notification failed for PR #$PR_NUMBER; continuing without failing the release-note pipeline"
  fi

  rm -f "$payload_file"
}

ensure_pr_for_current_branch() {
  local status="$1"
  local existing body_file url pr_json

  body_file="$RUN_DIR/pr-body.md"
  write_pr_body "$body_file" "$status"

  existing="$(open_pr_for_branch "$CURRENT_BRANCH")"
  if [ -n "$existing" ]; then
    PR_NUMBER="$(printf '%s' "$existing" | jq -r '.number')"
    PR_URL="$(printf '%s' "$existing" | jq -r '.url')"
    log "Reusing open PR #$PR_NUMBER for $CURRENT_BRANCH"
    if [ "$DRY_RUN" != "true" ]; then
      gh pr edit "$PR_NUMBER" --repo "$DOCS_REPO" --body-file "$body_file" || true
    fi
    return 0
  fi

  if [ "$DRY_RUN" = "true" ]; then
    PR_NUMBER="0"
    PR_URL="dry-run"
    log "Dry run: would create draft PR for $CURRENT_BRANCH"
    return 0
  fi

  url="$(gh pr create \
    --repo "$DOCS_REPO" \
    --base main \
    --head "$CURRENT_BRANCH" \
    --title "$RN_TITLE" \
    --label documentation \
    --assignee yoen-velt \
    --draft \
    --body-file "$body_file")"
  PR_URL="$url"
  pr_json="$(gh pr view "$url" --repo "$DOCS_REPO" --json number,url)"
  PR_NUMBER="$(printf '%s' "$pr_json" | jq -r '.number')"
  log "Created draft PR #$PR_NUMBER: $PR_URL"
  notify_slack_pr_created "$status"
}

notify_failure() {
  local stage="$1"
  local message="$2"
  local body

  body="release-note pipeline failed for \`${NOTE_PATH}\` at \`${stage}\`.

${message}

Run: ${RUN_URL:-not provided}
Rerun with release_note_url: $(source_note_url)

@yoen-velt"

  if [ -n "${PR_NUMBER:-}" ] && [ "$PR_NUMBER" != "0" ]; then
    comment_pr "$PR_NUMBER" "$body"
  else
    create_issue "release-note pipeline failed: ${NOTE_PATH}" "$body"
  fi
}

checkout_branch() {
  local branch="$1"
  local base_ref="${2:-origin/main}"

  git fetch origin main
  if git_remote_branch_exists "$branch"; then
    git fetch origin "$branch"
    git checkout -B "$branch" "origin/$branch"
  else
    git checkout -B "$branch" "$base_ref"
  fi
  CURRENT_BRANCH="$branch"
}

mark_deleted_note() {
  local body

  body="A source release note was deleted and was not processed by the agent pipeline.

- Path: \`${NOTE_PATH}\`
- Source repo: \`${SOURCE_REPO}\`
- Source SHA: \`${SOURCE_SHA:-unknown}\`
- Run: ${RUN_URL:-not provided}
- Rerun with release_note_url: $(source_note_url)

@yoen-velt"
  create_issue "release note deleted: ${NOTE_PATH}" "$body"
}

create_triage_pr() {
  local reason="$1"

  RN_CLASS="unknown"
  RN_TRIAGE_REASON="$reason"
  RN_BRANCH="release-note-unknown-${RN_SAFE_STEM}"
  RN_TITLE="[needs triage] ${RN_STEM}"

  checkout_branch "$RN_BRANCH"
  RUN_DIR="$(run_dir_for_current_route)"
  LOCAL_NOTE=".claude/release-notes/input-${RN_SAFE_STEM}.md"
  write_route_files
  write_pr_body "$RUN_DIR/pr-body.md" "Needs triage"

  if ! commit_and_push "release-note triage: ${RN_STEM}" "$CURRENT_BRANCH"; then
    create_issue "release-note triage failed: ${NOTE_PATH}" "Could not push the triage branch for \`${NOTE_PATH}\`.

Reason: ${reason}

Run: ${RUN_URL:-not provided}
Rerun with release_note_url: $(source_note_url)

@yoen-velt"
    exit 1
  fi
  if ! ensure_pr_for_current_branch "Needs triage"; then
    create_issue "release-note triage PR failed: ${NOTE_PATH}" "Could not create or update the triage PR for \`${NOTE_PATH}\`.

Reason: ${reason}

Run: ${RUN_URL:-not provided}
Rerun with release_note_url: $(source_note_url)

@yoen-velt"
    exit 1
  fi
  comment_pr "$PR_NUMBER" "@yoen-velt this source note needs manual routing before agents should edit docs: ${reason}"
  log "Triage PR: ${PR_URL:-unknown}"
}

version_already_present_without_checkpoints() {
  [ -n "$RN_VERSION" ] || return 1
  [ -n "$RN_CHANGELOG" ] || return 1
  [ ! -d "$RUN_DIR" ] || return 1
  [ -f "$RN_CHANGELOG" ] || return 1
  rg -F "<Update label=\"${RN_VERSION}\"" "$RN_CHANGELOG" >/dev/null 2>&1
}

run_agent_stage() {
  local stage_id="$1"
  local agent="$2"
  local done_file="$RUN_DIR/${stage_id}.done"
  local output_file="$RUN_DIR/${stage_id}.log"

  if [ "$MODE" != "force" ] && [ -f "$done_file" ]; then
    log "Skipping completed stage $stage_id"
    return 0
  fi

  log "Running stage $stage_id ($agent)"
  if ! env \
    DOCS_ROOT="$DOCS_ROOT" \
    RUN_DIR="$RUN_DIR" \
    LOCAL_NOTE="$LOCAL_NOTE" \
    RN_CLASS="$RN_CLASS" \
    RN_STEM="$RN_STEM" \
    RN_VERSION="$RN_VERSION" \
    RN_BRANCH="$CURRENT_BRANCH" \
    RN_CHANGELOG="$RN_CHANGELOG" \
    BACKEND_ONLY="$BACKEND_ONLY" \
    ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}" \
    AGENTS_ROOT="$AGENTS_ROOT" \
    SOURCE_DIR="$SOURCE_DIR" \
    NOTE_PATH="$NOTE_PATH" \
    PIPELINE_MODEL="$MODEL" \
      bash "$SCRIPT_DIR/run-release-note-agent.sh" "$agent" "$stage_id" 2>&1 | tee "$output_file"; then
    printf 'failed_at=%s\n' "$stage_id" > "$RUN_DIR/failure.env"
    commit_and_push "release-note pipeline checkpoint: ${RN_STEM} failed at ${stage_id}" "$CURRENT_BRANCH" || true
    notify_failure "$stage_id" "Agent \`${agent}\` failed. Check \`${output_file}\` on the branch for details."
    exit 1
  fi

  {
    printf 'stage=%s\n' "$stage_id"
    printf 'agent=%s\n' "$agent"
    printf 'completed_at=%s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  } > "$done_file"
  commit_and_push "release-note pipeline checkpoint: ${RN_STEM} ${stage_id}" "$CURRENT_BRANCH" || {
    notify_failure "$stage_id" "Checkpoint commit or push failed after successful agent execution."
    exit 1
  }
}

if [ "$CHANGE_TYPE" = "deleted" ]; then
  mark_deleted_note
  exit 0
fi

if [ ! -f "$(note_file)" ]; then
  echo "Source note not found: $(note_file)" >&2
  exit 1
fi

rn_classify_path "$NOTE_PATH"
rn_validate_summary_hint "$(note_file)" || true

RUN_DIR="$(run_dir_for_current_route)"
LOCAL_NOTE=".claude/release-notes/input-${RN_SAFE_STEM}.md"

log "Route:"
rn_route_json

if [ "$DRY_RUN" = "true" ]; then
  if [ "$RN_CLASS" = "firebase" ]; then
    log "Dry run: newest core release PR candidate:"
    newest_core_release_pr || true
  fi
  exit 0
fi

if [ "$RN_CLASS" = "unknown" ]; then
  create_triage_pr "${RN_TRIAGE_REASON:-unknown release-note route}"
  exit 0
fi

ensure_claude_supports_opus_48

export ANTHROPIC_DEFAULT_OPUS_MODEL="claude-opus-4-8"
export GH_TOKEN

git config user.name "${GIT_AUTHOR_NAME:-release-notes-bot}"
git config user.email "${GIT_AUTHOR_EMAIL:-release-notes-bot@users.noreply.github.com}"

PR_NUMBER=""
PR_URL=""
BACKEND_ONLY="false"

case "$RN_CLASS" in
  velt-py|velt-node|firebase) BACKEND_ONLY="true" ;;
esac

if [ "$RN_CLASS" = "firebase" ]; then
  target_pr="$(newest_core_release_pr)"
  if [ -z "$target_pr" ] || [ "$target_pr" = "null" ]; then
    create_triage_pr "no open core release PR was found for shared-firebase-function append"
    exit 0
  fi

  PR_NUMBER="$(printf '%s' "$target_pr" | jq -r '.number')"
  PR_URL="https://github.com/${DOCS_REPO}/pull/${PR_NUMBER}"
  CURRENT_BRANCH="$(printf '%s' "$target_pr" | jq -r '.headRefName')"
  git fetch origin "$CURRENT_BRANCH"
  git checkout -B "$CURRENT_BRANCH" "origin/$CURRENT_BRANCH"
else
  checkout_branch "$RN_BRANCH"
  pr_json="$(open_pr_for_branch "$CURRENT_BRANCH")"
  if [ -n "$pr_json" ]; then
    PR_NUMBER="$(printf '%s' "$pr_json" | jq -r '.number')"
    PR_URL="$(printf '%s' "$pr_json" | jq -r '.url')"
  fi
fi

RUN_DIR="$(run_dir_for_current_route)"
LOCAL_NOTE=".claude/release-notes/input-${RN_SAFE_STEM}.md"

if [ "$MODE" != "force" ] && [ -f "$RUN_DIR/.complete" ]; then
  log "Run already completed for ${NOTE_PATH}; skipping."
  if [ -n "$PR_NUMBER" ]; then
    comment_pr "$PR_NUMBER" "@yoen-velt release-note pipeline re-detected \`${NOTE_PATH}\` and skipped because checkpoints are complete. Run: ${RUN_URL:-not provided}"
  fi
  exit 0
fi

if [ "$MODE" = "auto" ] && version_already_present_without_checkpoints; then
  log "Version ${RN_VERSION} already appears in ${RN_CHANGELOG}; skipping legacy/manual completed branch."
  if [ -n "$PR_NUMBER" ]; then
    comment_pr "$PR_NUMBER" "@yoen-velt release-note pipeline re-detected \`${NOTE_PATH}\` and skipped because the changelog already contains \`${RN_VERSION}\`. Run: ${RUN_URL:-not provided}"
  fi
  exit 0
fi

write_route_files
commit_and_push "release-note pipeline start: ${RN_STEM}" "$CURRENT_BRANCH" || {
  notify_failure "start" "Initial checkpoint push failed."
  exit 1
}

if [ "$RN_CLASS" != "firebase" ]; then
  ensure_pr_for_current_branch "In progress"
else
  comment_pr "$PR_NUMBER" "@yoen-velt appending shared-firebase-function note \`${RN_STEM}\` to this release PR. Run: ${RUN_URL:-not provided}"
fi

run_agent_stage "01-agent-1" "mdx-release-notes-generator"
run_agent_stage "02-agent-2" "release-planning-agent"
run_agent_stage "03-agent-3" "models-and-methods-updater"
run_agent_stage "04-agent-4" "ui-customization-updater"
run_agent_stage "05-agent-5" "primitives-updater"
run_agent_stage "06-agent-6" "documentation-alignment-enforcer"
run_agent_stage "07-agent-7" "qa-terminology-aligner"

python3 -m json.tool docs.json >/dev/null

{
  printf 'completed_at=%s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  printf 'pr_number=%s\n' "${PR_NUMBER:-}"
  printf 'pr_url=%s\n' "${PR_URL:-}"
} > "$RUN_DIR/.complete"

write_pr_body "$RUN_DIR/pr-body.md" "Complete"
if [ -n "${PR_NUMBER:-}" ] && [ "$RN_CLASS" != "firebase" ]; then
  gh pr edit "$PR_NUMBER" --repo "$DOCS_REPO" --body-file "$RUN_DIR/pr-body.md" || true
fi

commit_and_push "release-note pipeline complete: ${RN_STEM}" "$CURRENT_BRANCH" || {
  notify_failure "complete" "Final checkpoint push failed."
  exit 1
}

if [ -n "${PR_NUMBER:-}" ]; then
  if [ "$RN_CLASS" = "firebase" ]; then
    comment_pr "$PR_NUMBER" "@yoen-velt appended \`${RN_STEM}\` (shared-firebase-function). Run: ${RUN_URL:-not provided}"
  else
    comment_pr "$PR_NUMBER" "@yoen-velt ready for review. Run: ${RUN_URL:-not provided}"
  fi
fi

log "PR: ${PR_URL:-https://github.com/${DOCS_REPO}/pull/${PR_NUMBER:-unknown}}"
