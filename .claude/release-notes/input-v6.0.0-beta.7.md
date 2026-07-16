# Velt SDK Release Notes - v6.0.0-beta.7
Release Date: July 8, 2026

## Summary
| SDK | Files Changed | Insertions | Deletions |
|-----|--------------|------------|-----------|
| HTML/Vanilla (sdk) | 8 | +393 | -10 |
| React (sdk-react) | 4 | +11 | -11 |

> This release is a **single bug fix**: when an auth proxy (`proxyConfig.authHost`) is configured, Firebase Auth no longer leaks a direct `accounts:lookup` request to Google's endpoints on page reload. There are **no new public APIs and no breaking changes**. The React SDK change is a version bump only.

## Bug Fixes

### 1. Auth proxy no longer leaks a direct `accounts:lookup` request to Google on page reload

**What:** When a customer configures an auth proxy via `proxyConfig.authHost` in `initConfig`, all Firebase Auth traffic is supposed to route through the proxy host. In practice, one `POST https://identitytoolkit.googleapis.com/v1/accounts:lookup` request still escaped directly to Google's endpoint on **every page reload with a cached Firebase user**, bypassing the proxy — even though token refreshes, `signInWithCustomToken`, and all Firestore/RTDB traffic went through the proxy correctly on the same load. This release closes that leak.

**Why:** The moment `initializeAuth()` runs (in the `provideAuth` factory), Firebase Auth begins its asynchronous cached-user restore: read the persisted user from IndexedDB → `user.reload()` → `POST /v1/accounts:lookup`. That request uses whatever `auth.config.apiHost` holds at the instant it fires, and Firebase exposes no public API to override it. The proxy host was previously applied inside the `AuthService` constructor, which — in production builds — lives in a lazily-loaded chunk that loads roughly **510ms after** `initializeAuth()`. By then the `accounts:lookup` request had already fired with the default Google host, so it lost the race and leaked. In `ng serve` dev builds that gap is only ~8ms, so the patch won the race and the bug never reproduced during development — which is why it went unnoticed until production HAR captures were compared.

**Impact:** Customers using `proxyConfig.authHost` no longer leak `accounts:lookup` requests to `identitytoolkit.googleapis.com` on reload; that boot-time request now routes through the configured proxy host like the rest of the auth traffic. The fix is fully transparent — **no API changes and no configuration changes are required**. Customers who transition a session from proxy-enabled to proxy-disabled are also handled: the current session's Firebase hosts are reset back to the defaults (`identitytoolkit.googleapis.com` / `securetoken.googleapis.com`) as soon as the proxy-disabled config is known, and the next reload self-heals.

*Affects every production SDK build up to and including `6.0.0-beta.6`.*

---
