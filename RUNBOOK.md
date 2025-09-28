Release Notes Pipeline — OpenAI Codex
One note per run
Place a single note file at release_inputs/<NOTE>.txt.

Run
bash
Copy code
export NOTE=v4.5.2-beta.13
export INPUT_FILE=release_inputs/${NOTE}.txt

codex run \
  --prompt ./AGENTS.md \
  --working-dir . \
  --var NOTE=${NOTE} \
  --var INPUT_FILE=${INPUT_FILE} \
  --allow Edit \
  --allow Bash("bash *") \
  --allow Bash("git *") \
  --allow Bash("rg *")

Stage outputs
Agent-1 → release-notes/version-4/v${NOTE}.mdx

Agent-2 → plans/v${NOTE}.impact-plan.json

Agent-3 → updates data-models.mdx, api-methods.mdx

Agent-4 → UI customization sections with Tabs

Agent-5 → repo-wide alignment + created docs

Agent-6 → qa/v${NOTE}.qa-summary.{json,md} (then instructs to run Agent-1 again)

Compare to Claude Code
Paths and artifacts are identical, enabling diffs across both CLIs.
