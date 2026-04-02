## QA Summary for v5.0.2-beta.11

### Issues Found: 2

1. **api-reference/sdk/models/data-models.mdx** — `SaveAttachmentResolverRequest.metadata` description used imprecise text "eg: apikey, organizationId, documentId, etc." with wrong casing (`apikey` instead of `apiKey`). The authoritative v5.0.2-beta.11 metadata contract is already documented on `DeleteAttachmentResolverRequest` and `AttachmentResolverMetadata`. The `save()` metadata description was inconsistent with both.
   - Fix: Updated to "Contains: `apiKey`, `documentId`, `organizationId`, `folderId` (when present), `attachmentId`, and `commentAnnotationId`." — matching the `AttachmentResolverMetadata` field list and distinguishing save() from delete() (save receives all fields; delete strips `attachmentId` and `commentAnnotationId` per beta.11).

2. **api-reference/sdk/api/api-methods.mdx** — `initConfig()` linked its `config?:` param to `#config` (the `Config` type, which contains URL/feature allow-lists) instead of `#veltproviderconfig` (the type added in this pipeline run that contains `proxyConfig`, `proxyDomain`, `apiProxyDomain`, `integrity`).
   - Fix: Updated link from `[Config](/api-reference/sdk/models/data-models#config)` to `[VeltProviderConfig](/api-reference/sdk/models/data-models#veltproviderconfig)`.

### No Issues Found In

- **security/proxy-server.mdx** — `proxyConfig` (camelCase) used correctly as config key; `ProxyConfig` used correctly as linked type name; `apiProxyDomain` deprecation warning present with correct version and migration path.
- **api-reference/sdk/models/data-models.mdx (ProxyConfig section)** — All host field names (`cdnHost`, `apiHost`, `v2DbHost`, `v1DbHost`, `storageHost`, `authHost`, `forceLongPolling`) match exactly between TypeScript interface block and property table. `VeltProviderConfig` casing consistent. Deprecation note on `apiProxyDomain` is present with correct migration guidance.
- **release-notes/version-5/sdk-changelog.mdx (beta.11 entry)** — `proxyConfig` (camelCase) used correctly in prose and code; `ProxyConfig` used only as a linked type; host field names in code examples match data-models.mdx definition exactly; `defaultCondition` / `default-condition` dual format consistent with primitives overview; `annotations` / `allAnnotations` descriptions match template-variables.mdx; `AttachmentDataProvider.delete()` metadata fields match beta.11 contract; `parentLocalUIState.context` description matches template-variables.mdx warning block.
- **ui-customization/template-variables.mdx** — `annotations` and `allAnnotations` descriptions match changelog improvement entry; `parentLocalUIState.context` description aligns with bug fix entry.
- **ui-customization/features/async/comments/comment-dialog-primitives/overview.mdx** — `defaultCondition` / `default-condition` prop documented in Common Inputs table; component names follow consistent `VeltCommentDialog*` / `velt-comment-dialog-*` pattern with no typos detected across all 92+ primitives scanned.
- **self-host-data/attachments.mdx** — Metadata contract note on `delete()` present (v5.0.2-beta.11+) with correct field list; `AttachmentDataProvider` link targets correct data-models anchor.
- **release-notes/version-4/sdk-changelog.mdx** — `apiProxyDomain` references are appropriate historical entries (its introduction); no updates needed.

### Summary

- Files corrected: 2
- Critical issues: 1 (`initConfig()` pointing to wrong type; `VeltProviderConfig` with proxy fields was unreachable from api-methods.mdx)
- Terminology alignments: 1 (metadata field description casing and precision in `SaveAttachmentResolverRequest`)
- No occurrences of `proxy_config`, `ProxyConfig` used as config key in prose, or incorrect host field name casing detected repo-wide
