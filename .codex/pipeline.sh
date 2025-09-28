#!/usr/bin/env bash
set -euo pipefail

NOTE="${1:-}"
INPUT_FILE="${2:-}"

if [ -z "${NOTE}" ] || [ -z "${INPUT_FILE}" ]; then
echo "Usage: .codex/pipeline.sh NOTE INPUT_FILE"
exit 1
fi

if [ ! -f "${INPUT_FILE}" ]; then
echo "ERROR: INPUT_FILE not found: ${INPUT_FILE}"
exit 1
fi

run() {
local prompt="$1"
echo "==> Running $(basename "$prompt") for NOTE=${NOTE}"
codex run
--prompt "$prompt"
--working-dir .
--var NOTE="${NOTE}"
--var INPUT_FILE="${INPUT_FILE}"
--allow Edit
--allow Bash("git *")
--allow Bash("rg *")
--allow Bash("mkdir -p *")
--allow Bash("mv *")
--allow Bash("cp *")
}

run ".codex/commands/agent1.mdx"
run ".codex/commands/agent2.mdx"
run ".codex/commands/agent3.mdx"
run ".codex/commands/agent4.mdx"
run ".codex/commands/agent5.mdx"
run ".codex/commands/agent6.mdx"

echo "STATUS: OK — Pipeline complete for NOTE=${NOTE}"
echo "Outputs:"
echo " - release-notes/version-4/v${NOTE}.mdx"
echo " - plans/v${NOTE}.impact-plan.json"
echo " - qa/v${NOTE}.qa-summary.{json,md}"
echo "Next step: If more notes exist, set NOTE/INPUT_FILE and run AGENTS.md again."
