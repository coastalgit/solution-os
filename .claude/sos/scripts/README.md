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
