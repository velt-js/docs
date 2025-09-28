# Agent Orchestrator (OpenAI Codex CLI)

This repository is configured so you can run the **entire 6-agent release-notes pipeline** by invoking **this single file** with OpenAI Codex CLI. Internally, it hands off to a hidden pipeline in **`.codex/`**.

## Run (one note at a time)

```bash
export NOTE=v4.5.2-beta.13
export INPUT_FILE=release_inputs/${NOTE}.txt

# Allow Codex to edit files and run the few bash commands needed
codex run \
  --prompt ./AGENTS.md \
  --working-dir . \
  --var NOTE=${NOTE} \
  --var INPUT_FILE=${INPUT_FILE} \
  --allow Edit \
  --allow Bash("bash *") \
  --allow Bash("git *") \
  --allow Bash("rg *")
```

Inputs
Single release note text file: release_inputs/${NOTE}.txt

Outputs (per stage)
Agent-1 → release-notes/version-4/v${NOTE}.mdx

Agent-2 → plans/v${NOTE}.impact-plan.json (and optional .md)

Agent-3 → updates only data-models.mdx and api-methods.mdx

Agent-4 → UI customization pages & examples under ui-customization/** (Tabs normalized)

Agent-5 → repo-wide alignment & creation of missing docs per plan

Agent-6 → qa/v${NOTE}.qa-summary.json and qa/v${NOTE}.qa-summary.md + instruction to run Agent-1 again for next note/revalidation

What this file does when executed by Codex
Validates NOTE and INPUT_FILE

Invokes the hidden pipeline script: .codex/pipeline.sh

The pipeline:

runs the 6 specialized prompts in order (.codex/commands/agent{1..6}.mdx)

passes through variables and safe permissions

prints a final STATUS: OK with a short summary

One note per run keeps accuracy high.

Allowed edit scope
Include: release-notes/**, plans/**, qa/**, docs/**, ui-customization/**, api-reference/**, examples/**, snippets/**, pages/**, content/**, realtime-collaboration/**

Exclude: node_modules/**, .next/**, dist/**, build/**, out/**, **/*.map, binaries/media

Execute now (Codex will run the commands below)
bash
Copy code
set -euo pipefail

if [ -z "${NOTE:-}" ] || [ -z "${INPUT_FILE:-}" ]; then
  echo "ERROR: NOTE and INPUT_FILE must be provided (env or --var)."
  exit 1
fi

if [ ! -f "${INPUT_FILE}" ]; then
  echo "ERROR: INPUT_FILE not found: ${INPUT_FILE}"
  exit 1
fi

bash ./.codex/pipeline.sh "${NOTE}" "${INPUT_FILE}"
STATUS: Delegated to .codex/pipeline.sh
