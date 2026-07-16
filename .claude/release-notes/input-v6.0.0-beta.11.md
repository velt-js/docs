# Velt SDK Release Notes - v6.0.0-beta.11
Release Date: July 15, 2026

> **Maintenance release.** `6.0.0-beta.11` is a version-bump and release-infrastructure release. It ships **no public API changes, no new components, no prop/attribute/event changes, and no runtime behavior changes** for either the HTML/Vanilla or React SDK. The substantive change is on the release-pipeline side: the SDK's CI now mirrors each published npm tarball to Velt's self-host release registry so self-host installs can fetch a byte-identical copy. Everything else is documentation and version/integrity-hash bumps. Existing integrations are unaffected — upgrading only moves you to the `6.0.0-beta.11` build.

## Summary
| SDK | Files Changed | Insertions | Deletions |
|-----|--------------|------------|----------|
| HTML/Vanilla (sdk) | 4 | +152 | -9 |
| React (sdk-react) | 3 | +4 | -4 |

> Counts reflect the code-change footprint. The React SDK's raw PR totals, including the `package-lock.json` churn, were 4 files / +11 / -11.
