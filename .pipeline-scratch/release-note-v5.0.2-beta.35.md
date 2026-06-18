Velt SDK Release Notes - v5.0.2-beta.35
Release Date: June 10, 2026

Summary
SDK	Files Changed	Insertions	Deletions
HTML/Vanilla (sdk)	27	+1511	-109
React (sdk-react)	6	+13	-39
This release ships a new client-side dev permission resolver for setPermissionProvider that lets developers test the Real-Time Permission Provider (RTPP) against a localhost endpoint without a public tunnel, removes the admin-only visibility gate from agent suggestion comments so all viewers can see and act on them, and removes the now-redundant maxOrganizations field from CrossOrganizationConfig (fan-out bounding is server-owned). The React SDK consolidates the CrossOrganizationConfig type to import from @veltdev/types rather than defining it locally.

Features

1. Client-Side Dev Permission Resolver for setPermissionProvider
What: setPermissionProvider now accepts four new optional fields on VeltPermissionProvider:

dev?: boolean — opt-in switch. When true and a resolver is configured, permissions are resolved in the browser rather than via the server-to-server Real-Time Permission Provider (RTPP).
endpointConfig?: ResolverEndpointConfig — URL resolver: the SDK POSTs { data: { requests: PermissionQuery[] } } to the provided URL.
resolvePermissions?: (req: PermissionResolverRequest) => Promise<PermissionResult[] | ResolverResponse<PermissionResult[]>> — callback resolver: invoked in-browser with the same request envelope.
resolveTimeout?: number — per-call deadline in milliseconds (default: 60000).

A new public type PermissionResolverRequest = { data: { requests: PermissionQuery[] } } is added. The request envelope is byte-identical to the server-side RTPP contract, so an existing /api/check-permissions handler works unchanged from either caller.

Why: The RTPP is server-to-server: Velt's backend POSTs to a Console-registered URL that it cannot reach when it is localhost. Developers testing RTPP locally had to expose their endpoint via ngrok or Cloudflare Tunnel. With dev: true the browser resolves permissions and relays the results to the backend — the localhost endpoint is always reachable from the browser.

Impact:

Opt-in only. No change to default behavior. Existing providers that do not set dev are byte-unaffected.
Production safety is enforced server-side: relayed clientResolvedResults are honored only for dev/test API keys (storeDbId === 'sdktest'). Production keys always fall back to the server-side RTPP regardless of the dev flag. The dev flag is an ergonomic switch, not a security control.
Fails closed: resolver errors, timeouts, retries-exhausted, and malformed payloads all deny access. Nothing is relayed on failure.
endpointConfig.url takes precedence over resolvePermissions when both are set.
A one-shot console.warn fires when the dev resolver is active (production-use warning) and when dev: true is set with no usable resolver configured.

API:

// URL resolver — browser POSTs to a localhost endpoint, no tunnel required
client.setPermissionProvider({
  dev: true,
  endpointConfig: {
    url: 'http://localhost:3000/api/check-permissions',
  },
  resolveTimeout: 60000,
  retryConfig: { retryCount: 3, retryDelay: 1000 },
});

// Callback resolver — resolve inline in the browser
client.setPermissionProvider({
  dev: true,
  resolvePermissions: async ({ data: { requests } }) => {
    // return PermissionResult[] or ResolverResponse<PermissionResult[]>
    return requests.map(r => ({ ...r, hasAccess: true }));
  },
});

HTML:

<script>
  // After Velt.init(...) / client.identify(...)
  window.Velt.setPermissionProvider({
    dev: true,
    endpointConfig: {
      url: 'http://localhost:3000/api/check-permissions',
    },
    resolveTimeout: 60000,
    retryConfig: { retryCount: 3, retryDelay: 1000 },
  });
</script>

New type:

export interface PermissionResolverRequest {
  data: { requests: PermissionQuery[] };
}

// VeltPermissionProvider gains these optional fields:
interface VeltPermissionProvider {
  // existing fields ...
  dev?: boolean;
  endpointConfig?: ResolverEndpointConfig;
  resolvePermissions?: (req: PermissionResolverRequest) => Promise<PermissionResult[] | ResolverResponse<PermissionResult[]>>;
  resolveTimeout?: number;
}

Improvements

1. Agent Suggestion Comments Now Visible and Actionable by All Viewers
What: The isUserAdmin gate has been removed from shouldShowAgentSuggestion and shouldShowAgentSuggestionActions. Agent suggestion cards and their accept/reject actions now render for any viewer when the annotation is agent-authored and marked as a suggestion (annotation.type === 'suggestion' OR annotation.commentType === 'suggestion').

Why: Agent suggestions were previously admin-gated (mirroring private-comment behavior). The product decision is full access for all viewers — agents create suggestions for everyone to act on, not just admins.

Impact:

Non-admin users can now see agent suggestion cards and accept or reject them.
The accept/reject write path (CommentActionsService.acceptSuggestion / rejectSuggestion) was never independently admin-gated; removing the UI gate makes full access consistent end-to-end.
No API or initialization changes. Existing annotations without agent or suggestion discriminators (annotation.type/annotation.commentType) are unaffected.

2. maxOrganizations Removed from Cross-Organization Notification Config
What: maxOrganizations has been removed from CrossOrganizationConfig and is no longer sent on getCrossOrgUserNotifications cloud-function requests. Fan-out bounding is now server-owned.

Why: The client-side cap duplicated server logic and was no longer the source of truth for org fan-out limits. Having it on the client created a false impression that callers could control the cap.

Impact:

enableCrossOrganization({ maxOrganizations: N }) is no longer a supported config option. TypeScript types are updated.
Existing callers who pass maxOrganizations should remove it; the field is silently ignored at runtime and the TypeScript type no longer accepts it.
organizationIds and excludeOrganizationIds are unchanged and continue to work as before.
Fan-out bounding behavior is unchanged in practice — the server always enforced the limit.

Breaking Changes

1. CrossOrganizationConfig.maxOrganizations Removed
The maxOrganizations?: number field has been dropped from CrossOrganizationConfig in both the SDK (src/app/models/data/notification.model.ts) and published type declarations (velt-sdk/app/models/data/notification.model.d.ts).

This field was introduced in v5.0.2-beta.33 alongside the cross-organization notification feature. Since the feature has not yet reached production, no migration shim is provided.

Before (v5.0.2-beta.33 / beta.34):

client.enableCrossOrganization({
  organizationIds: ['org-a', 'org-b'],
  excludeOrganizationIds: ['org-c'],
  maxOrganizations: 10,  // no longer accepted
});

After (v5.0.2-beta.35):

client.enableCrossOrganization({
  organizationIds: ['org-a', 'org-b'],
  excludeOrganizationIds: ['org-c'],
  // remove maxOrganizations — fan-out is server-controlled
});

Updated CrossOrganizationConfig type:

interface CrossOrganizationConfig {
  enabled?: boolean;
  organizationIds?: string[];
  excludeOrganizationIds?: string[];
  feeds?: ('forYou' | 'all')[];
  // maxOrganizations removed
}

Note (React SDK): The React SDK consolidates the CrossOrganizationConfig type to import from @veltdev/types rather than defining it locally.
