# Velt SDK Release Notes - v6.0.0-beta.12
Release Date: July 17, 2026

> **Maintenance release.** `6.0.0-beta.12` is a version-bump and release-infrastructure release. It ships **no public API changes, no new components, no prop/attribute/event changes, and no runtime behavior changes** for either the HTML/Vanilla or React SDK. The substantive work is on the release-pipeline side: the self-host registry mirror job introduced in `6.0.0-beta.11` is hardened (correct gating on partial build failures, a verify-only resume mode for retries, a Trivy vulnerability gate, an SBOM attestation, restored `contents: read` permission, and a Slack failure alert), and the mirror target moves to a dedicated customer-visible registry project. Everything else is documentation and version/integrity-hash bumps. Existing integrations are unaffected — upgrading only moves you to the `6.0.0-beta.12` build.

## Summary
| SDK | Files Changed | Insertions | Deletions |
|-----|--------------|------------|----------|
| HTML/Vanilla (sdk) | 4 | +315 | -19 |
| React (sdk-react) | 3 | +4 | -4 |

> Counts reflect the code-change footprint. The React SDK's raw PR totals, including the `package-lock.json` churn, were 4 files / +11 / -11. The HTML/Vanilla footprint is dominated by CI workflow (`.github/workflows/main.yml`) and internal journal/doc changes; no SDK source or public API files were touched.
