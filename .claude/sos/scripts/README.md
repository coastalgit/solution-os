---
type: sos-scripts-readme
scope: system
status: active
---

# SOS Node Scripts

These are node-local, read-only helper scripts for normal SOS checks.

They are installed with the SOS baseline so summary, audit, and migration assessment do not depend on the SolutionOS source repository being present.

## Commands

```powershell
.\.claude\sos\scripts\sos-summary.ps1 -TargetPath .
.\.claude\sos\scripts\sos-audit.ps1 -TargetPath .
.\.claude\sos\scripts\sos-migrate-assess.ps1 -TargetPath .
```

These scripts report only. They must not move, rewrite, or delete project files.

`sos-summary.ps1` and `sos-audit.ps1` include routing-surface checks: PM references, adapter delegation, and unreachable SOS surface paths.

`sos-audit.ps1` also reports actor/concept integrity findings: missing ACTORS alias columns, reserved vault actor-registry files, and repeated unregistered actor/concept candidates.

`sos-audit.ps1` reports archive integrity findings: missing archive manifest columns, archive items not indexed in `vault/archive/_manifest.md`, and loose archive candidates outside the vault. It reports candidates only; it does not move files.
