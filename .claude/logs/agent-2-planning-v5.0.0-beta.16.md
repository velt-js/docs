# Release Update Plan for v5.0.0-beta.16

## Overview
- Release Type: Patch (Beta)
- Release Date: February 11, 2026
- Key Changes: Firestore log level control, GSAP performance optimization, autocomplete UX fixes
- Breaking Changes: Yes - enableFormatOptions default changed from true to false

## Areas Requiring Updates

### 1. Data Models - NEW PARAMETER IN CONFIG INTERFACE
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/models/data-models.mdx`
- Changes:
  - Add `firebaseLogLevel` parameter to Config interface table at line ~2910
  - Type: `'debug' | 'error' | 'silent'`
  - Document default value: 'silent'
  - Document priority chain: sessionStorage overrides environment config
- Priority: High
- Effort: 5 minutes

### 2. SDK Initialization - LOG LEVEL CONFIGURATION
- File: `/Users/yoenzhang/Downloads/docs/api-reference/sdk/api/api-methods.mdx`
- Changes:
  - Add note to initConfig() method documentation (line ~2272) explaining firebaseLogLevel config option
  - Document sessionStorage override mechanism: `sessionStorage.setItem('veltFirestoreLogLevel', 'debug')`
  - Link to Config interface for full parameter details
- Priority: Medium
- Effort: 5 minutes

### 3. Migration Guide - BREAKING CHANGE FOR FORMAT OPTIONS
- File: `/Users/yoenzhang/Downloads/docs/release-notes/version-5/sdk-changelog.mdx` (already documented with Warning tag)
- Changes: None needed - breaking change already documented in release note
- Priority: N/A
- Note: enableFormatOptions breaking change is sufficiently documented. No additional migration docs needed since fix involves explicit opt-in.

## Areas NOT Requiring Updates

### Performance Improvements (Internal)
- GSAP animation detection in MutationObserver - internal performance optimization without API surface changes

### Bug Fixes (Internal Behavior)
- Mobile cursor position fixes - behavior correction without API changes
- Hotkey insertion fixes - internal implementation detail
- Autocomplete panel event bubbling - internal event handling
- Bottomsheet cursor position - internal state management
- Attachment component state propagation - internal component architecture

## Implementation Sequence

1. **Data Models** (High Priority)
   - Add firebaseLogLevel to Config interface
   - Effort: 5 minutes

2. **API Methods** (Medium Priority)
   - Document firebaseLogLevel in initConfig() method
   - Effort: 5 minutes
   - Dependency: Requires Config update from step 1

## Breaking Changes

### enableFormatOptions Default Value
- **What Changed**: Default value changed from `true` to `false`
- **Migration Required**: Yes - developers must explicitly enable if needed
- **Impact**: Format options (bold, italic, etc.) will be hidden unless explicitly enabled
- **Documentation Status**: Already documented in release note with Warning tag

## Quality Checklist
- [ ] firebaseLogLevel parameter added to Config interface in data-models.mdx
- [ ] Default value 'silent' documented
- [ ] Type definition documented: 'debug' | 'error' | 'silent'
- [ ] sessionStorage override mechanism documented
- [ ] initConfig() method updated with firebaseLogLevel documentation in api-methods.mdx
- [ ] Code examples include React/Next.js and Other Frameworks tabs
- [ ] Breaking change for enableFormatOptions already documented in release note
- [ ] Planning log written to `.claude/logs/agent-2-planning-v5.0.0-beta.16.md`

## Documentation Patterns to Follow

### Config Interface Pattern (data-models.mdx)
Add to Config table at line ~2920:
```markdown
| `firebaseLogLevel`        | `'debug' \| 'error' \| 'silent'` | No      | Controls Firestore SDK console log output. Default: 'silent'. Can be overridden via sessionStorage: `sessionStorage.setItem('veltFirestoreLogLevel', 'debug')` |
```

### initConfig Method Pattern (api-methods.mdx)
Add note after line ~2277:
```markdown
**Firestore Log Control**: Set `firebaseLogLevel` to control SDK console output ('debug', 'error', or 'silent'). Override via sessionStorage: `sessionStorage.setItem('veltFirestoreLogLevel', 'debug')`. Default: 'silent'.
```

## Notes for Agent-3

### New Configuration Parameter
firebaseLogLevel is a new optional configuration parameter in the Config interface requiring documentation in data-models.mdx.

### Override Mechanism
Document both configuration paths: environment config (via initConfig) and sessionStorage override with clear priority chain.

### Cross-Reference Strategy
- Link initConfig() documentation to Config interface
- Ensure firebaseLogLevel appears in Config table with full type definition
- Document override mechanism in both locations for discoverability

### Pattern Consistency
Follow existing Config parameter documentation patterns in data-models.mdx table format.
