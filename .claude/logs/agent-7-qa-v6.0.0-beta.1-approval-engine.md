# Agent-7 QA Log — v6.0.0-beta.1 Approval Engine & Agent Tooling (23 Jun 2026)

Independent final QA pass. Scope: 12 changed files (working tree). **Verdict: PASS. Zero corrective edits made.** One PRE-EXISTING dead anchor flagged (out of this release's scope — not fixed, per constraints).

## Tooling note
Multi-directory `rg` with a space-separated shell variable + `\b` anchors silently returned 0 hits in this environment (false clean). All scans below were re-run with reliable `rg`/`grep` over explicit single paths or bash arrays. Trust these results, not any earlier multi-root `rg` runs.

## 1. Old/removed-model survivor scan (case-sensitive, all doc roots)
| Term | Survivors | Verdict |
| --- | --- | --- |
| `onReject` | upgrade-guide (5 lines: migration table + prose), sdk-changelog v6 ln18; all other hits are `suggestionRejected`/`SuggestionRejectEvent`/`SUGGESTION_REJECTED` substring matches in agent-comments/api-methods/data-models/v5-changelog | OK — only intentional + LEAVE-ALONE feature |
| `loopBack` | upgrade-guide migration table only (ln16,29,31) | OK — intentional |
| `loops[]` (authored) | upgrade-guide + sdk-changelog v6 (named as removed) | OK — intentional |
| `compiled.loops[]` | customize-behavior ln209 | OK — NEW read-only model, leave alone |
| `ApprovalLoop` / `ApprovalLoopRejectTrigger` / `ApprovalLoopExhaustionPolicy` / `ApprovalHumanNodeOnReject` / `onIterationReject` | **zero hits** | OK — fully removed |

Confirmed only surviving old-model references are the upgrade-guide migration table + the single changelog breaking-change bullet. node.mdx/data-models.mdx correctly dropped the removed interfaces and `loops` field.

## 2. The 10 `APPROVAL_*` error keys — independent re-verification
Extracted all keys from raw note (minus the `APPROVAL_EDGE_` glob token), upgrade-guide.mdx, customize-behavior.mdx. Byte-exact `diff`: **all three sets IDENTICAL (10/10)**. The long ones re-checked individually — all correct:
`APPROVAL_EDGE_EXHAUSTED_REQUIRES_LOOP_SIBLING`, `APPROVAL_EDGE_LOOP_TARGET_NOT_ANCESTOR`, `APPROVAL_EDGE_REJECT_CYCLE_REQUIRES_LOOP`, `APPROVAL_GROUP_FROM_LOOP_REQUIRES_JOINONQUORUM`, `APPROVAL_GROUP_FROM_REJECT_REQUIRES_LOOP`, `APPROVAL_HUMAN_NODE_REQUIRES_REJECT_PATH`, `APPROVAL_EDGE_GROUP_TO_GROUP_FORBIDDEN`, `APPROVAL_EDGE_CUSTOM_REQUIRES_WHEN`, `APPROVAL_EDGE_WHEN_ONLY_FOR_CUSTOM`, `APPROVAL_EDGE_LOOP_REQUIRES_REJECT`.
(customize-behavior shows 11 occurrences because `APPROVAL_HUMAN_NODE_REQUIRES_REJECT_PATH` appears in both the prose at ln63 and the error table — not a duplicate key.)

## 3. Canonical NEW-term presence (approval-engine surface)
`edges[]` 8/4f · `EdgeSchema` 3/3f · `EdgeEndpoint` 11/5f · `compiled.forwardEdges` 6/6f · `compiled.loops` 6/5f · `fromGroupId` 1 · `toGroupId` 1 (both only in get-definition compiled table) · `waitAll` 11 · `cancelOnQuorum` 20 · `joinOnQuorum` 23 · `sourceEdges` 6/4f · `ApprovalEdge`/`ApprovalEdgeEndpoint` present in node.mdx. `on:` roles scanned: only `approve/reject/always/exhausted/custom` — zero stray roles. Group policies: exact camelCase everywhere (lowercase only inside linter slugs / `..._JOINONQUORUM` constant).

## 4. Link / anchor verification
- All 18 cross-ref target FILES exist (changelog `[Learn more →]`, setup/customize-behavior/get/create links, etc.). ✓
- All 13 `customize-behavior#…` anchors resolve to live headings. ✓
- `get-definition#the-compiled-block` ✓; `overview#inbound-webhook-handler`, `overview#scope` ✓; `setup#step-4-get-the-outcome` ✓.
- node.mdx → data-models `#approvalcreatedefinitionrequest-node` / `#veltapiresponse-node` anchors unchanged & valid. ✓
- **FLAG (pre-existing, NOT this release):** `customize-behavior.mdx:306` → `setup#step-3-configure-your-webhook-receiver` is DEAD. setup Step 3 is "Find the pending step and record a decision"; webhook-receiver setup lives under Step 4 (`#step-4-get-the-outcome`). Present in HEAD since v5.0.2-beta.31 (#201) in BOTH the ref line and the setup headings. Left unedited per "flag, don't alter pre-existing content." Suggested fix for human: repoint to `#step-4-get-the-outcome`.

## 5. MDX well-formedness (all 12 edited files)
Code fences even on every file. JSX components balanced: `ParamField` (15/15 create & update, 6/6 get, etc.), `ResponseField` 3/3, `Expandable`, `ResponseExample`, `Note`, `Warning`, `Tabs` 3/3, `Update` 1/1, `Card`/`CardGroup`, `Accordion`/`AccordionGroup` all matched. node.mdx + REST `ts`/`JSON` blocks balanced (node.mdx approval TS block opens ```ts / closes ```). ✓

## 6. Banned internal identifiers
Scanned all doc roots (ai, api-reference, backend-sdks, release-notes, get-started, security, async/realtime-collab, ui-customization) for: `compileGraph`, `ApiKeySecretCipher`, `ProviderApiKeyService`, `McpClientService`, `ILlmProvider`, `askAIWithTools`, `CryptoUtil`, `INV-005/022`, `DEPLOY_ALL`, plus service-class names (`*Service`, `*Validator`, `assertSafeOutboundUrl`, `redactConfigSecrets`, `stripServerManagedMetadata`). **Zero hits in published docs.** ✓

## 7. Agent-tooling = changelog-only (as mandated)
- Agent-tooling internals (`restApiData`, `mcp-tools`, `docs-code-comparison`, `execution.mcpServers`, `stagehand-agent`, `DOCS_CODE_COMPARISON`, `CommonAgentResponse`) appear ONLY in v6 sdk-changelog Agents bullets. (`mcpServers` hits in get-started/mcp-installer + plugins are pre-existing, unrelated MCP-installer JSON.)
- All 6 `[**Agents**]` changelog bullets are **link-less** (verified). ✓
- No `ai/agents/` dir; `api-reference/.../agents/` has only pre-existing `list-agent-executions.mdx`. `docs.json` untouched (not in changed set). ✓

## 8. Round-trip / default-behavior claims
"authored `edges` echo `sourceEdges` byte-for-byte" + "`compiled` is read-only / additive" stated consistently across create / get / customize-behavior. `on` defaults to `"always"`; `compiled` schema matches the `CompiledGraph` interface field-for-field. React tab uses `client.*`, Other Frameworks uses `Velt.*` (upgrade-guide modular section). ✓ Changelog order Breaking → New Features → Improvements → Bug Fixes; date June 23 2026 consistent; prior Memory release (4 bullets) intact, no clobber.

## Flags for human (carry forward)
1. **Pre-existing dead anchor** `customize-behavior.mdx:306` → `setup#step-3-configure-your-webhook-receiver` (correct target `#step-4-get-the-outcome`). Not this release; not fixed. **Recommend a separate cleanup PR.**
2. **SDK-contract-ahead-of-shipped-SDK** (from Agent-3/6): node.mdx + data-models.mdx describe the unified `ApprovalEdge` (`on`/`loop`, no `onReject`/`loops[]`). Assumes `@veltdev/node` shipped the `edges[]` migration in lockstep with the Cloud Functions contract. Verify before publish. (python.mdx untouched — correct.)
3. **`compiled` example values are placeholders** (loopId `"..."`, JsonAst `{}`): shapes correct, concrete values illustrative.
4. June 22-vs-23 date: resolved (23 Jun everywhere).
5. docs.json: no approval/agents nav change this release — intentional and untouched.

## Verdict
**PASS** — terminology consistency for v6.0.0-beta.1 Approval Engine is correct; the unified `edges[]` model is applied uniformly; the only old-model references are the intentional migration table + changelog bullet. Zero edits required. Pipeline may proceed to Plugin Agent 1 (skills delta extraction). The one dead anchor is pre-existing and explicitly out of scope.
