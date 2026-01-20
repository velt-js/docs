# Release Update Plan for Version 4.6.9

## Overview
- Release Type: Minor (Feature Addition)
- CRDT Package Version: 4.5.9-beta.5
- Release Date: December 25, 2025
- Key Changes: Webhook support for CRDT data changes via `updateData` event
- Breaking Changes: No

## Areas Requiring Updates

### 1. Data Models
**File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`

**Changes Required**:
- Add `CrdtUpdateDataEvent` interface in Core Collaboration section
- Add `CrdtUpdateDataPayload` interface in Core Collaboration section

**Priority**: High

**Details**:
```markdown
#### CrdtUpdateDataEvent
---
| Property      | Type                      | Required | Description                                    |
|---------------|---------------------------|----------|------------------------------------------------|
| `methodName`  | `string`                  | Yes      | Method that triggered the update               |
| `uniqueId`    | `string`                  | Yes      | Unique identifier for the event                |
| `timestamp`   | `number`                  | Yes      | Unix timestamp of the event                    |
| `source`      | `string`                  | Yes      | Source of the data change                      |
| `payload`     | `CrdtUpdateDataPayload`   | Yes      | Data change payload                            |

#### CrdtUpdateDataPayload
---
| Property         | Type                  | Required | Description                                    |
|------------------|-----------------------|----------|------------------------------------------------|
| `id`             | `string`              | Yes      | Store identifier                               |
| `data`           | `unknown`             | Yes      | Updated data value                             |
| `lastUpdatedBy`  | `string`              | Yes      | User ID who made the last update               |
| `sessionId`      | `string \| null`      | Yes      | Session ID or null                             |
| `lastUpdate`     | `string`              | Yes      | ISO timestamp of last update                   |
```

**Location**: Insert after line 3629 (after DecryptConfig section, within Core Collaboration section)

---

### 2. API Methods
**File**: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`

**Changes Required**:
- Add `enableWebhook()` method documentation
- Add `disableWebhook()` method documentation
- Add `setWebhookDebounceTime()` method documentation
- Add `useCrdtEventCallback()` hook documentation
- Add `getCrdtElement()` client method documentation
- Add `useCrdtUtils()` hook documentation
- Add `on()` event subscription method documentation

**Priority**: High

**Details**:
Insert in Collaboration section (after line 2275):

```markdown
#### enableWebhook()
Enable webhook notifications for CRDT data changes.
- Params: `none`
- Returns: `void`
- React Hook: `crdtUtils.enableWebhook()`
- [Full Documentation →](/realtime-collaboration/crdt/setup/core#webhooks)

#### disableWebhook()
Disable webhook notifications for CRDT data changes.
- Params: `none`
- Returns: `void`
- React Hook: `crdtUtils.disableWebhook()`
- [Full Documentation →](/realtime-collaboration/crdt/setup/core#webhooks)

#### setWebhookDebounceTime()
Configure webhook debounce interval (minimum 5000ms).
- Params: `debounceTime: number`
- Returns: `void`
- React Hook: `crdtUtils.setWebhookDebounceTime()`
- [Full Documentation →](/realtime-collaboration/crdt/setup/core#webhooks)

#### getCrdtElement()
Get the CRDT element instance from the client.
- Params: `none`
- Returns: `CrdtElement`
- React Hook: `n/a`
- [Full Documentation →](/realtime-collaboration/crdt/setup/core#webhooks)

#### useCrdtUtils()
React Hook to access CRDT utility methods.
- Params: `none`
- Returns: `CrdtUtils`
- React Hook: `Yes`
- [Full Documentation →](/realtime-collaboration/crdt/setup/core#webhooks)

#### useCrdtEventCallback()
React Hook to subscribe to CRDT events.
- Params: `eventName: 'updateData'`
- Returns: `CrdtUpdateDataEvent | null`
- React Hook: `Yes`
- [Full Documentation →](/realtime-collaboration/crdt/setup/core#webhooks)

#### on()
Subscribe to CRDT events (non-React usage).
- Params: `eventName: 'updateData'`
- Returns: `Observable<CrdtUpdateDataEvent>`
- React Hook: `n/a`
- [Full Documentation →](/realtime-collaboration/crdt/setup/core#webhooks)
```

---

### 3. Main Documentation - Webhooks Feature
**File**: `/Users/yoenzhang/Downloads/docs/realtime-collaboration/crdt/setup/core.mdx`

**Changes Required**:
- Add new section "Webhooks" under Setup steps (after Step 6)
- Document webhook configuration methods
- Document event subscription patterns
- Include default behavior and configuration options

**Priority**: High

**Details**:
Insert new section after line 200 (after Step 6, before APIs section):

```markdown
### Step 7: Configure Webhooks (Optional)

Control webhook notifications for CRDT data changes. Webhooks are enabled by default with a 5-second debounce interval.

#### Enable/Disable Webhooks

<Tabs>
<Tab title="React / Next.js">

```jsx
import { useCrdtUtils } from "@veltdev/react";
import { useEffect } from "react";

function Component() {
  const crdtUtils = useCrdtUtils();

  useEffect(() => {
    if (crdtUtils) {
      // Enable webhook notifications
      crdtUtils.enableWebhook();

      // Disable webhook notifications
      crdtUtils.disableWebhook();

      // Configure debounce time (minimum 5000ms)
      crdtUtils.setWebhookDebounceTime(10 * 1000); // 10 seconds
    }
  }, [crdtUtils]);

  return null;
}
```

</Tab>
<Tab title="Other Frameworks">

```js
const crdtElement = client.getCrdtElement();

// Enable webhook notifications
crdtElement.enableWebhook();

// Disable webhook notifications
crdtElement.disableWebhook();

// Configure debounce time (minimum 5000ms)
crdtElement.setWebhookDebounceTime(10 * 1000); // 10 seconds
```

</Tab>
</Tabs>

#### Subscribe to Data Change Events

Listen to `updateData` events when CRDT data changes occur.

<Tabs>
<Tab title="React / Next.js">

```jsx
import { useCrdtEventCallback } from "@veltdev/react";
import { useEffect } from "react";

function Component() {
  const crdtUpdateData = useCrdtEventCallback("updateData");

  useEffect(() => {
    if (crdtUpdateData) {
      console.log("[CRDT] Data changed:", crdtUpdateData);
      // Access event properties:
      // - crdtUpdateData.methodName
      // - crdtUpdateData.uniqueId
      // - crdtUpdateData.timestamp
      // - crdtUpdateData.source
      // - crdtUpdateData.payload (id, data, lastUpdatedBy, sessionId, lastUpdate)
    }
  }, [crdtUpdateData]);

  return null;
}
```

</Tab>
<Tab title="Other Frameworks">

```js
const crdtElement = client.getCrdtElement();

// Subscribe to updateData events
const subscription = crdtElement.on("updateData").subscribe((eventData) => {
  console.log("[CRDT] Data changed:", eventData);
  // Event structure:
  // {
  //   methodName: string,
  //   uniqueId: string,
  //   timestamp: number,
  //   source: string,
  //   payload: {
  //     id: string,
  //     data: unknown,
  //     lastUpdatedBy: string,
  //     sessionId: string | null,
  //     lastUpdate: string
  //   }
  // }
});

// Unsubscribe when done
subscription.unsubscribe();
```

</Tab>
</Tabs>

**Default Configuration**:
- Webhooks: Enabled by default
- Debounce Time: 5000ms (5 seconds, minimum allowed value)
```

---

## Implementation Sequence

1. **Update data-models.mdx** - Add `CrdtUpdateDataEvent` and `CrdtUpdateDataPayload` interfaces (Effort: Low, 10 minutes)
2. **Update api-methods.mdx** - Add 7 new method/hook entries in Collaboration section (Effort: Low, 15 minutes)
3. **Update core.mdx** - Add comprehensive Webhooks section with examples (Effort: Medium, 20 minutes)

**Total Estimated Effort**: 45 minutes

---

## Quality Checklist

- [ ] All new interfaces added to data-models.mdx (`CrdtUpdateDataEvent`, `CrdtUpdateDataPayload`)
- [ ] All new methods documented in api-methods.mdx (`enableWebhook`, `disableWebhook`, `setWebhookDebounceTime`, `getCrdtElement`, `useCrdtUtils`, `useCrdtEventCallback`, `on`)
- [ ] Code examples include React and Other Frameworks tabs
- [ ] Default behavior documented (webhook: true, debounceTime: 5000ms)
- [ ] Event structure clearly documented with inline comments
- [ ] Cross-references added between api-methods.mdx and core.mdx
- [ ] Minimum debounce time constraint (5000ms) documented
- [ ] Breaking changes: None (no documentation needed)
- [ ] Log file written to `.claude/logs/agent-2-planning-4.6.9.md`

---

## Additional Notes

**Pattern Compliance**:
- All code examples follow existing `<Tabs>` structure (React / Next.js first, Other Frameworks second)
- API method documentation follows pattern: Description → Params → Returns → React Hook → Full Documentation link
- Data model documentation follows pattern: Interface name → Table with Property/Type/Required/Description columns
- Webhook configuration documented in main feature docs (core.mdx), not ui-customization

**No Wireframe Updates Required**:
- This is a backend/API feature (webhooks and events)
- No UI components or visual elements affected

**Link Pattern Verification**:
- All links use standard Velt URL pattern: `/realtime-collaboration/crdt/setup/core#webhooks`
- Cross-references between api-methods.mdx and core.mdx use consistent anchor: `#webhooks`
