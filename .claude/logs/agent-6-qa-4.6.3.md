## QA Summary for v4.6.3

### Issues Found: 4

1. **self-host-data/comments.mdx** - Missing debugging section for `dataProvider` event
   - Fix: Added debugging section with `Velt.on('dataProvider')` subscription examples for React and Other Frameworks

2. **self-host-data/reactions.mdx** - Missing debugging section for `dataProvider` event
   - Fix: Added debugging section with `Velt.on('dataProvider')` subscription examples for React and Other Frameworks

3. **self-host-data/attachments.mdx** - Missing debugging section for `dataProvider` event
   - Fix: Added debugging section with `Velt.on('dataProvider')` subscription examples for React and Other Frameworks

4. **self-host-data/users.mdx** - Missing debugging section for `dataProvider` event
   - Fix: Added debugging section with `Velt.on('dataProvider')` subscription examples for React and Other Frameworks

### Verification Results

**Terminology Consistency**:
- `expandOnSelection` (React) and `expand-on-selection` (HTML) used correctly across all files
- `dataProvider` event name consistent in all contexts
- `DataProviderEvent` interface properly documented and linked

**Cross-References**:
- `/api-reference/sdk/models/data-models#dataproviderevent` link verified in get-started/advanced.mdx
- DataProviderEvent interface definition present in data-models.mdx with sub-event types
- All prop placements correct (expandOnSelection after dialogSelection)

**Code Pattern Consistency**:
- React tabs use `client` for API methods
- Other Frameworks tabs use `Velt` for API methods
- All debugging examples follow established patterns
- Import statements consistent (`useVeltClient` from '@veltdev/react')

**Documentation Completeness**:
- Release notes properly document both features
- Comments Sidebar customize-behavior.mdx includes expandOnSelection with correct default (true)
- Event subscriptions table in advanced.mdx includes dataProvider entry
- All four self-host-data files now have debugging sections

### Summary

- Files corrected: 4 (all in self-host-data/)
- Critical issues: 4 (missing debugging sections identified by Agent-5)
- Terminology alignments: 0 (all terminology already consistent)
- Total debugging sections added: 4 (comments, reactions, attachments, users)

All documentation is now aligned for v4.6.3 release. Agent-1 ready for next release note processing.
