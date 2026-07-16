# Velt SDK Release Notes - v6.0.0-beta.10
Release Date: July 14, 2026

## Summary
| SDK | Files Changed | Insertions | Deletions |
|-----|--------------|------------|-----------|
| HTML/Vanilla (sdk) | 42 | +3130 | -147 |
| React (sdk-react) | 11 | +130 | -30 |

> This release adds one new public API — **`setUnstyledMode()`**, a headless mode that turns Velt's own styling on or off — plus self-hosting improvements for regional data routing and a batch of comment-sidebar filter fixes. Counts above reflect the code-change footprint. *(Raw PR totals, including lockfile churn, were sdk 43 files / +3681 / -638 and React 12 files / +6431 / -9998; the React numbers are almost entirely `package-lock.json`.)*

## Features

### 1. Headless (Unstyled) Mode — `setUnstyledMode()`

**What:** A new client method lets you switch off all of Velt's built-in visual styling in one call, and switch it back on just as easily. By default Velt keeps a "functional-only" layer so the UI still lays out, positions, and shows/hides correctly — only the look (colors, backgrounds, borders, shadows, fonts, animations) is removed. Pass `keepFunctionalStyles: false` to strip everything down to raw browser defaults. The change is fully reversible at any time.

**Why:** Teams that want to style Velt components entirely with their own CSS previously had to fight against Velt's injected styles. Headless mode gives them a clean slate to build on.

**Impact:** You can now run Velt "unstyled" and apply your own design system on top, then flip styling back on instantly if needed. Works for styles injected into the page head and inside shadow roots, and applies to styles that are injected later too.

**API (React + HTML):**
```ts
client.setUnstyledMode(value: boolean, config?: { keepFunctionalStyles?: boolean }): void;
```

**Example:**
```ts
// Remove Velt's visual styling, but keep layout/positioning intact (default)
client.setUnstyledMode(true);

// Strip everything, including layout styles, down to raw browser defaults
client.setUnstyledMode(true, { keepFunctionalStyles: false });

// Restore all Velt styling
client.setUnstyledMode(false);
```

---

## Improvements

### 1. Self-Hosting: Region-Aware `setEncryptedData` Routing

**What:** Self-hosted deployments can now tell the SDK which regional data endpoints they actually provisioned, using a new optional `dataRegions` field on the self-hosted config. When a write would be routed to a region the deployment did not set up, the SDK now falls back to the base endpoint instead of calling a URL that would fail.

**Why:** Not every self-hosted deployment provisions every regional variant of the encrypted-data endpoint. Without this, a write routed to an unprovisioned region would hit a 404.

**Impact:** Self-hosted customers get predictable, safe routing for encrypted-data writes — unprovisioned regions degrade cleanly to the base endpoint. Leaving `dataRegions` unset keeps today's behavior (all regions assumed available). This release also adds `asiaNorthEast1` (Tokyo) to the set of known regions.

Implementation note: the routing decision is handled inside the endpoints service by two new helpers — `resolveProvisionedSetEncryptedDataRegion` (picks the target region, or falls back to the base endpoint when the requested one isn't in `dataRegions`) and `isStrictSetEncryptedDataCovered` (checks whether a region is actually provisioned).

**Config:**
| Field | Type | Default |
|-------|------|---------|
| `selfHosted.dataRegions` | `string[] \| null` | `undefined` (no region filter) |

---

## Bug Fixes

### 1. Comment Sidebar (V1): Filters No Longer Reset Unexpectedly

**What:** Several cases where the comment sidebar's filters could silently clear or stop working are fixed:
- **Reset button:** After clicking **Reset**, filters applied afterward silently did nothing until the page was reloaded. The Reset flow no longer trips the sidebar into a state that discards all filters.
- **Page/location changes:** Changing the location (via `setLocation`) no longer replays a stale set of filters over the user's manual panel selections. A one-time client filter call (for example, `involved: []`) no longer wipes the user's Involved / Author / Tagged choices on every location change. Only the version filter is synced from the location now.
- **Full session storage:** If the host app's `sessionStorage` was full, the sidebar could re-apply its "fresh session" defaults on every update and wipe the user's filter selections. A one-time guard now prevents this even when storage can't be written.

**Why:** The fresh-session filter setup was gated only on a `sessionStorage` key, and a location change re-pushed the last client-set filters through the full filter merge — so a storage failure or a routine location change could overwrite what the user had chosen. The Reset path also routed through a same-value toggle that flipped the sidebar into a "reset" mode which ignored all filters until reload.

**Impact:** Comment-sidebar filters now behave predictably — they survive Reset, survive location changes, and are not wiped when session storage is unavailable.

---

### 2. React Self-Hosting: `firebaseConfig` Now Applies on First Load

**What:** When using the React SDK with a self-hosted config, the `selfHosted.firebaseConfig` is now stashed before the Velt script is loaded, so it is guaranteed to be in place when the SDK initializes.

**Why:** The SDK's default Firebase app can initialize as the Velt script evaluates — before `Velt.init()` runs — so writing the self-hosted config only at init time was sometimes too late for it to take effect.

**Impact:** Self-hosted React apps reliably pick up their `firebaseConfig` on first load. (Velt still writes the same value at init time; when they match, nothing extra happens.)

---
