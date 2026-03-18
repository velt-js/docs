## QA Summary for v5.0.2-beta.8

### Issues Found: 2

1. **api-reference/sdk/api/api-methods.mdx** - Six CRDT methods had broken `Full Documentation` links pointing to `#step-7-configure-webhooks-optional`, an anchor that no longer exists in `realtime-collaboration/crdt/setup/core.mdx` (the `### Step 7: Configure Webhooks (Optional)` heading was replaced in an earlier release).
   - Affected methods: `enableWebhook()`, `disableWebhook()`, `setWebhookDebounceTime()`, `useCrdtUtils()`, `useCrdtEventCallback()`, `getCrdtElement()`
   - Fix: `enableWebhook()`, `disableWebhook()`, `setWebhookDebounceTime()`, `useCrdtUtils()`, `useCrdtEventCallback()` → `#configure-webhooks`; `getCrdtElement()` → `#core`

2. **api-reference/sdk/models/data-models.mdx** - Missing `RecorderResolverEvent` section in the `DataProviderEvent` block. The sdk-changelog states `RECORDER_RESOLVER` was added to `CoreEventTypesMap` with a "full 3-stage lifecycle (request formed → triggered → result/error) for get, save, and delete resolver operations", matching the existing `CommentResolverEvent`, `AttachmentResolverEvent`, and `ReactionResolverEvent` patterns — but no corresponding `RecorderResolverEvent` table was added.
   - Fix: Added `RecorderResolverEvent` table (13 event types: get/save/delete × formed/triggered/result/error + cache variant for get) and `RecorderResolverModuleName` table after `ReactionResolverEvent`, consistent with existing pattern.

### Validation Checks Passed

- `isRecorderResolverUsed` and `isUrlAvailable` casing: consistent across `data-models.mdx`, `recordings.mdx`, and `sdk-changelog.mdx`
- `RecorderAnnotationDataProvider` naming: no instances of incorrect `RecorderDataProvider` shorthand found
- `attachmentScope` field: present in `UploadFileOptions` in `data-models.mdx`, matches `sdk-changelog.mdx` description
- `additionalFields` on `ResolverConfig`: present in `data-models.mdx`
- CRDT method names (`pushMessage`, `onMessage`, `getMessages`, `getSnapshot`, `saveSnapshot`, `pruneMessages`): exact casing consistent across `api-methods.mdx`, `data-models.mdx`, `core.mdx`, and `crdt-core-changelog.mdx`
- `### Message Stream` heading: used consistently (not "Unified Message Stream") in both `api-methods.mdx` and `core.mdx`
- `self-host-data/recordings` in `docs.json` nav: present and correct
- `#debugging` anchor in `self-host-data/recordings.mdx`: matches link from `data-models.mdx` `RecorderResolverModuleName` entry
- `VeltDataProvider.recorder` field typed as `RecorderAnnotationDataProvider`: correct in `data-models.mdx`
- React tabs use `client`, Other Frameworks use `Velt`: verified in `sdk-changelog.mdx` and `recordings.mdx`

### Summary
- Files corrected: 2
- Critical issues: 1 (missing `RecorderResolverEvent` definition inconsistent with established pattern)
- Broken link fixes: 6 anchors in `api-methods.mdx`
