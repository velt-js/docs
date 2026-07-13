# Velt SDK Release Notes - v6.0.0-beta.8
Release Date: July 9, 2026

## Summary
| SDK | Files Changed | Insertions | Deletions |
|-----|--------------|------------|-----------|
| HTML/Vanilla (sdk) | 74 | +8758 | -297 |
| React (sdk-react) | 3 | +4 | -4 |

> This release lays the **foundation for self-hosting / on-prem deployments**. It adds a new, fully-optional `config.selfHosted` block that lets a deployment point Velt's backend endpoints (Firebase config, cloud-function URLs, the notifications-hub RTDB URL, the encrypted-write endpoints) at the customer's own infrastructure, plus the internal adapter architecture (endpoint registry, Firebase adapters, typed denial normalization) that makes those endpoints swappable. For existing SaaS customers this release is **behavior-preserving** — with no `selfHosted` config, every endpoint resolves to exactly the same default as before. There are **no breaking changes**. The React SDK change is a version bump only.

## Features

### 1. Self-Hosting / On-Prem Backend Configuration (`config.selfHosted`)

**What:** A new optional `selfHosted` block on the `initConfig` config lets a deployment redirect Velt's backend endpoints to the customer's own infrastructure. Every field is optional; every unspecified value falls back to the per-build Velt default, so a config with no `selfHosted` block behaves exactly as before.

The block supports:
- **`strict`** — full self-hosting / data-sovereignty mode. When `false` (default, "hybrid"), any endpoint without an injected override falls back to the Velt default (useful for migrating one endpoint at a time). When `true`, there is **no** fallback to Velt: an endpoint without an override resolves to an inert, non-fetchable `velt://self-hosted-disabled/<endpoint>` sentinel (zero network egress), and any missing **core** endpoint is reported once as a loud misconfiguration error.
- **`firebaseConfig`** — a Firebase config override, deep-merged over the environment default (injected keys win).
- **`firebaseNotificationsDatabaseURL`** — override for the notifications-hub RTDB URL.
- **`cloudFunction`** — per-endpoint absolute base-URL overrides for the cloud-function fleet (including a single `setEncryptedData` override that collapses the ×5 regional split, or per-region overrides).
- **`deploymentProfile`** — the resolved list of enabled backend feature-modules. Any endpoint whose module is not in the list degrades silently as "unimplemented" with zero egress. Absent/empty means all modules enabled (identical to today).
- **`enablePortableBackend`** — opt-in defensive consumption of a future portable-backend `identify()` response. Default `false`; when off, the existing Firebase path runs unchanged.

**Why:** Enterprise and data-sovereignty customers need to run the Velt backend (or parts of it) inside their own cloud, with no traffic egressing to Velt infrastructure. This release ships the SDK-side seam that makes each Velt endpoint independently redirectable, staged so that a customer can adopt it incrementally (hybrid) or fully (strict).

**Impact:** Existing SaaS builds are unaffected — with no `selfHosted` config every endpoint resolves to the same `environment.*` default as before (behavior-preserving). Self-hosting customers can now point the SDK at their own infra via config, with a fail-closed strict mode that guarantees no egress to Velt for any endpoint they haven't explicitly provided. This is the first ("Step 0 / Phase A") delivery of the self-hosting program: the endpoint-routing and Firebase-config seams are live; a fully portable (non-Firebase) transport is a later phase.

**Type:**
```ts
interface SelfHostedConfig {
  strict?: boolean;
  firebaseConfig?: Partial<FirebaseOptions>;
  firebaseNotificationsDatabaseURL?: string;
  cloudFunction?: SelfHostedCloudFunctionConfig;
  enablePortableBackend?: boolean;
  deploymentProfile?: DeploymentModuleId[];
}

interface SelfHostedCloudFunctionConfig {
  validateClient?: string;
  getPlanDetails?: string;
  sa?: string;
  getIceServers?: string;
  chatgptCompletion?: string;
  rewriterAskAi?: string;
  whisperTranscription?: string;
  getAllowedDocuments?: string;
  getNotificationsForDocuments?: string;
  videoBackend?: string;
  convertRecording?: string;
  processRecording?: string;
  sdkProxy?: string;
  screenshot?: string;
  /** Single override that collapses the ×5 regional setEncryptedData split — used for ALL regions when set. */
  setEncryptedData?: string;
  /** Optional per-region overrides (used only if the single setEncryptedData above is unset). */
  regions?: { [region: string]: { setEncryptedData?: string } };
}

// The 13 backend feature-module ids (vendored from the backend deployment-profile manifest).
const DEPLOYMENT_MODULE_IDS = [
  'core', 'notifications', 'recorder-media', 'ai', 'agents', 'huddle-webrtc',
  'integrations-workflow', 'superflow', 'billing-stripe', 'analytics-telemetry',
  'migrations', 'velt-internal', 'console',
] as const;

type DeploymentModuleId = typeof DEPLOYMENT_MODULE_IDS[number];
```

**HTML:**
```ts
// Hybrid mode — override one endpoint, everything else stays on Velt SaaS.
Velt.init('YOUR_API_KEY', {
  selfHosted: {
    cloudFunction: {
      validateClient: 'https://your-infra.example.com/validateclient',
    },
  },
});

// Strict mode — full self-hosting, no egress to Velt for un-provided endpoints.
Velt.init('YOUR_API_KEY', {
  selfHosted: {
    strict: true,
    deploymentProfile: ['core', 'notifications', 'ai'],
    firebaseConfig: { /* your Firebase project config */ },
    firebaseNotificationsDatabaseURL: 'https://your-notifications.example.com',
    cloudFunction: {
      validateClient: 'https://your-infra.example.com/validateclient',
      sdkProxy: 'https://your-infra.example.com/v2/core/a',
      setEncryptedData: 'https://your-infra.example.com/setencrypteddata',
      getNotificationsForDocuments: 'https://your-infra.example.com/getnotifications',
    },
  },
});
```

**React:**
```tsx
// Pass the same selfHosted block through the VeltProvider apiConfig / initConfig options.
<VeltProvider apiKey="YOUR_API_KEY" apiConfig={{
  selfHosted: {
    strict: true,
    deploymentProfile: ['core', 'notifications'],
    firebaseConfig: { /* your Firebase project config */ },
    cloudFunction: {
      validateClient: 'https://your-infra.example.com/validateclient',
      sdkProxy: 'https://your-infra.example.com/v2/core/a',
    },
  },
}}>
  {/* ... */}
</VeltProvider>
```

---

### 2. Optional `config` Argument on `loadVelt()` / `loadSnippyly()`

**What:** The manual loaders `Velt.loadVelt()` and `Velt.loadSnippyly()` now accept an optional `config` argument with the same shape as `init()`. Self-hosting customers who bootstrap the SDK via a manual loader (instead of `init()`) can now pass their `selfHosted` config there so that `selfHosted.firebaseConfig` applies to the default Firebase app at bootstrap.

**Why:** `selfHosted.firebaseConfig` must be known **before** the Angular app (and its default Firebase app) bootstraps, because the default Firebase app cannot be safely re-initialized once services hold instances. `init(config)` stashes the config before bootstrap, but the manual loaders previously took no config and bootstrapped immediately — so a manual-loader flow had no way to inject a Firebase config early enough.

**Impact:** Manual-loader users can now self-host correctly by passing the config to the loader (or by calling `init()` before the loader). If a manual loader bootstraps before an `init()` with a conflicting Firebase config, the SDK now emits a loud, specific console warning instead of silently using the wrong config. This is fully backward-compatible — the argument is optional and a bare `loadVelt()` / `loadSnippyly()` behaves exactly as before.

**Signature:**
```ts
loadVelt(config?: { selfHosted?: SelfHostedConfig }): void
loadSnippyly(config?: { selfHosted?: SelfHostedConfig }): void
```

```ts
// Manual-loader flow with self-hosting:
Velt.loadVelt({ selfHosted: { firebaseConfig: { /* ... */ } } });

// Or call init() first (its config is authoritative), then bootstrap:
Velt.init('YOUR_API_KEY', { selfHosted: { firebaseConfig: { /* ... */ } } });
Velt.loadVelt();
```

---

## API Changes

### 1. New Public Config Types for Self-Hosting

**What:** The `Config` model (consumed by `initConfig`) gains a new optional `selfHosted?: SelfHostedConfig` field, along with the supporting types `SelfHostedConfig`, `SelfHostedCloudFunctionConfig`, `DeploymentModuleId`, and the `DEPLOYMENT_MODULE_IDS` constant.

**Why:** These are the public, customer-facing types that describe the self-hosting configuration surface introduced in Feature #1.

**Impact:** Additive only — all fields are optional, so existing configs typecheck and behave unchanged. See Feature #1 for the full type definitions and usage.

**Used in:** `Config.selfHosted` (the `initConfig` config object).

---

### 2. `ConfigService` Self-Hosting Getters

**What:** `ConfigService` gains two read accessors used by the endpoint-resolution layer:

```ts
getSelfHostedConfig(): SelfHostedConfig | undefined; // returns the injected `selfHosted` block, or `undefined` for default SaaS
getEnablePortableBackend(): boolean; // whether defensive portable-backend consumption is enabled (default `false`)
```

**Why:** The new `EndpointsService` needs a single, safe accessor for the self-hosting config to resolve each endpoint.

**Impact:** Additive service methods that back the self-hosting feature. Both are guarded and return safe defaults on error.

> **Scope:** `getSelfHostedConfig()` and `getEnablePortableBackend()` are **internal service accessors** — they are only reachable within the SDK's Angular DI context (injected `ConfigService`) and are **not** exposed on the global `Velt` / `Snippyly` JS object, which is why they have no element-model counterpart.

---

## Bug Fixes

### 1. Repeated / Concurrent `Velt.init()` Calls No Longer Interfere With Each Other

**What:** Each `Velt.init()` attempt now owns a **private** polling timer and retry counter instead of sharing module-level state. Previously, the init retry interval handle and try count were stored in shared module variables (`snippylyInitInterval`, `snippylyInitTryCount`), so a second `init()` call (e.g. a framework re-mount, or an app that calls `init()` more than once) could overwrite the first call's timer handle and share its retry counter — leaking the earlier interval and corrupting the retry budget.

**Why:** The retry timer state was global to the module rather than scoped per `init()` attempt.

**Impact:** Multiple or rapid `Velt.init()` calls each run their own independent retry loop; a stale attempt can no longer clear a newer attempt's timer or inflate its retry count. Behavior for the common single-`init()` case is unchanged.

---

### 2. A Failed or Timed-Out `init()` No Longer Blocks a Later Self-Hosted Bootstrap

**What:** When `init()` fails or exhausts its retries before the SDK loads, it now cleanly releases its pre-bootstrap "stash authority." Previously a dead `init()` could leave the SDK in a pending state that made a later `loadVelt(config)` / `loadSnippyly(config)` silently skip stashing its `selfHosted` config until a full page reload.

**Why:** The failure and timeout paths of `init()` did not reset the pending-init state that guards the pre-bootstrap self-hosted config stash.

**Impact:** After a failed `init()`, a subsequent manual loader with a `selfHosted` config can still inject it correctly on the same page load. A generation guard ensures a stale attempt's terminal path can never clear a newer attempt's stash. (Affects only self-hosting flows; standard SaaS init is unaffected.)

---

### 3. Manual Loaders Now Stash the Pre-Bootstrap Self-Hosted Config (Split-Brain Prevention)

**What:** `loadVelt()` / `loadSnippyly()` now participate in the pre-bootstrap self-hosted config stash and detect config divergence. If Firebase would bootstrap from one `selfHosted` config while `initConfig` later applies a different one (a "split-brain" where Firebase and cloud-function endpoints point at different backends), the SDK now emits a specific, loud console warning instead of failing silently.

**Why:** The default Firebase app initializes during Angular bootstrap, long before `initConfig` runs; only a pre-bootstrap stash can inject `firebaseConfig` in time. Manual loaders previously did not write that stash, and mismatched configs across `init()`/loader calls produced no diagnostic.

**Impact:** Self-hosting works through the manual-loader path, and any ordering/config mismatch between `init()` and a manual loader is surfaced immediately with actionable guidance (`init()` remains authoritative for `initConfig`). No effect on non-self-hosted usage.

---
