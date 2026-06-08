# Verification checklist — v5.0.2-beta.32 (Agent Suggestion Comment)

**Why this exists:** The Agent 1-7 docs pipeline wrote field-level detail for this release by
mirroring sibling types, because the source release note gave only method *signatures* (not field
shapes) and the locally-installed `@veltdev/types` (**v4.5.2-beta.2**) predates this feature. None of
the items below could be verified locally. Confirm each against the real `@veltdev/types` build and
sdk-react **PR #2000** before publishing. ✅ = confirmed, ❌ = wrong (fix), ❓ = still unverified.

---

## 1. Request types — `api-reference/sdk/models/data-models.mdx` (~L1641-1658)
- [ ] `AcceptSuggestionRequest` — fields exactly `annotationId: string` (required), `options?: RequestOptions`. Confirm names + types; confirm no extra required fields.
- [ ] `RejectSuggestionRequest` — fields exactly `annotationId: string` (required), `rejectReason?: string`, `options?: RequestOptions`.

## 2. Event types — `data-models.mdx` (~L1754-1773)
- [ ] `SuggestionAcceptEvent` — confirm `annotationId: string`, `commentAnnotation: CommentAnnotation`, `metadata: VeltEventMetadata`. (commentAnnotation presence + the `VeltEventMetadata` type were inferred.)
- [ ] `SuggestionRejectEvent` — confirm above + `rejectReason?: string`.

## 3. Method service location — `api-reference/sdk/api/api-methods.mdx` (~L1476-1486)
- [ ] Confirm `acceptSuggestion()` / `rejectSuggestion()` are public on `CommentActionsService` (single source of truth) and that `CommentDialogActionService` delegates to them. Decide whether public docs should state the service (currently listed bare, matching sibling convention).
- [ ] Confirm `source?: 'internal' | 'external'` second param and `Promise<...Event | null>` return.

## 4. Annotation / agent payload shapes — NOW DOCUMENTED (inferred — verify field names/types)
These drive the visibility gate. They were initially left undocumented as unverifiable, but have now been
added to `data-models.mdx` based strictly on the release-note field paths. Field NAMES and TYPES are
inferred (installed `@veltdev/types` v4.5.2-beta.2 predates the feature) — confirm each against the real build:
- [ ] `agent` object on `CommentAnnotation` → documented as new type `CommentAnnotationAgent` (fields: `name`, `photoUrl`, `result`, `agentFields`). `name`/`photoUrl` mirror the `User` shape and are inferred from the header prose ("agent display name + avatar"). Confirm exact field names.
- [ ] `agent.result.title` → documented as new type `AgentResult` with `title: string`. Confirm `result` shape (may carry more than `title`).
- [ ] `agent.agentFields` → documented as `string[]` (consistent with the pre-existing `CommentRequestQuery.agentFields` filter path at `data-models.mdx` ~L412).
- [ ] `sourceType` → documented as `string` on `CommentAnnotation`. Confirm it is a string (vs an enum/union).
- [ ] `suggestion` object → documented as new type `CommentAnnotationSuggestion` (`status: 'pending' | 'accepted' | 'rejected'`, `rejectReason?`, `resolvedBy?`, `resolvedAt?`). Confirm `suggestion` lives on `CommentAnnotation` (vs `Comment`) and confirm `resolvedAt` is epoch-ms `number`.
- [x] `commentType` — verified present in installed types as `commentType?: string`; **now documented** on `CommentAnnotation`.

## 5. Enum / event channels — `data-models.mdx` (~L1582-1583) — drives finding #4
- [ ] Confirm the exact enum constants `SUGGESTION_APPROVED` / `SUGGESTION_REJECTED`.
- [ ] Confirm `suggestionAccepted` / `suggestionRejected` are genuinely **separate comment-element events** fired alongside the suggestion-stream events (the docs now describe them this way) — not the enum's event-type string value. If they are actually one event in two forms, revert the description edit to match the sibling rows.

## 6. Component inventory — sdk-react PR #2000 — drives finding #1
- [ ] Confirm PR #2000 exports exactly **21** primitives + **21** wireframes (release-note prose says "~22"; docs document 21). If 22, identify the missing component and add it everywhere.
- [ ] Byte-match the 21 `VeltCommentDialogAgentSuggestion*` names against `declarations.d.ts`, **including** the doubled `…ActionsActionAccept` / `…ActionsActionReject` mirror (the wireframe page was corrected to `Actions.ActionAccept` / `velt-comment-dialog-agent-suggestion-actions-action-accept-wireframe`).

## 7. Dead links — `api-methods.mdx` — finding #5 (resolved, pending content)
- [x] Removed the dead `Full Documentation →` links (target page had no `acceptSuggestion`/`rejectSuggestion` section).
- [ ] When a verified section is written in `async-collaboration/comments/customize-behavior.mdx`, re-add the links with `#acceptsuggestion` / `#rejectsuggestion` anchors.
