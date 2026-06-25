#!/usr/bin/env bash
#
# Run one committed release-note agent through Claude Code in non-interactive
# mode. The deterministic pipeline script owns routing, branching, checkpointing,
# and PR operations; this wrapper only executes the requested agent's body.

set -euo pipefail

AGENT="${1:?agent suffix is required, e.g. mdx-release-notes-generator}"
STAGE="${2:?stage id is required, e.g. 01-agent-1}"

: "${ANTHROPIC_API_KEY:?ANTHROPIC_API_KEY is required}"
: "${NOTE_PATH:?NOTE_PATH is required}"
: "${RUN_DIR:?RUN_DIR is required}"
: "${LOCAL_NOTE:?LOCAL_NOTE is required}"
: "${RN_CLASS:?RN_CLASS is required}"
: "${RN_STEM:?RN_STEM is required}"

MODEL="${PIPELINE_MODEL:-claude-opus-4-8}"
MAX_TURNS="${AGENT_MAX_TURNS:-80}"
DOCS_ROOT="${DOCS_ROOT:-$PWD}"
AGENTS_ROOT="${AGENTS_ROOT:-$DOCS_ROOT/.claude/agents}"

shopt -s nullglob
AGENT_FILES=( "$AGENTS_ROOT"/Agent-*-"${AGENT}".md )
shopt -u nullglob

if [ "${#AGENT_FILES[@]}" -eq 0 ]; then
  echo "run-release-note-agent: no agent file matched Agent-*-${AGENT}.md" >&2
  exit 1
fi
if [ "${#AGENT_FILES[@]}" -gt 1 ]; then
  echo "run-release-note-agent: multiple agent files matched Agent-*-${AGENT}.md" >&2
  printf '  %s\n' "${AGENT_FILES[@]}" >&2
  exit 1
fi

AGENT_FILE="${AGENT_FILES[0]}"
RAW_BODY="$(awk 'BEGIN{f=0} /^---$/{f++; next} f>=2{print}' "$AGENT_FILE")"

if [ -z "${RAW_BODY//[[:space:]]/}" ]; then
  echo "run-release-note-agent: agent body is empty after stripping frontmatter: $AGENT_FILE" >&2
  exit 1
fi

BODY="Execute the following release-note agent instructions NOW against the docs repo in your working directory. Do not ask clarifying questions. Use the deterministic context below as authoritative.

Run context:
- Stage: ${STAGE}
- Source note path: ${NOTE_PATH}
- Public-only local note: ${LOCAL_NOTE}
- Run directory: ${RUN_DIR}
- Route class: ${RN_CLASS}
- Version/stem: ${RN_VERSION:-$RN_STEM}
- Changelog target: ${RN_CHANGELOG:-none}
- Branch: ${RN_BRANCH:-current branch}
- Backend-only note: ${BACKEND_ONLY:-false}

Rules for this automated run:
- Use ${LOCAL_NOTE} as the only source note input.
- Do not read the raw source repository note directly. Internal sections have already been removed from ${LOCAL_NOTE}; content under Internal, For Internal Use, or Internal Context headers must never influence docs output.
- Write durable notes/logs under ${RUN_DIR} or .claude/logs when useful.
- If this agent has no applicable work for the route class, write a short no-op note to ${RUN_DIR}/${STAGE}-noop.md and exit successfully.
- Do not push, commit, create branches, or create PRs; the outer script handles that.
- Do not dispatch or trigger the next agent; the outer script invokes Agent 1-7 sequentially.
- Do not create brand-new public docs pages unless the agent instructions require it and the route is not marked backend-only.

${RAW_BODY}"

echo "[run-release-note-agent] stage=${STAGE} agent=${AGENT} model=${MODEL} max-turns=${MAX_TURNS}"

export ANTHROPIC_DEFAULT_OPUS_MODEL="claude-opus-4-8"

exec claude \
  --print \
  --model "$MODEL" \
  --max-turns "$MAX_TURNS" \
  --permission-mode acceptEdits \
  --allowed-tools "Read,Edit,Write,Glob,Grep,Bash" \
  --add-dir "$DOCS_ROOT" \
  -p "$BODY"
