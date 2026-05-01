# Scripts

Small local helpers for early SolutionOS development.

## `sos-init.ps1`

Preview a core SOS install into another folder:

```powershell
.\scripts\sos-init.ps1 -TargetPath <path-to-node> -NodeKind project
```

Apply the install:

```powershell
.\scripts\sos-init.ps1 -TargetPath <path-to-node> -NodeKind project -Apply
```

The script does not overwrite existing files unless `-Force` is supplied.

This is a temporary local helper, not the final SOS command runtime.

The read-only helpers are also shipped inside installed SOS nodes under
`.claude/sos/scripts/` so `/sos:summary`, `/sos:audit`, and `/sos:migrate`
do not depend on the source repository being present.

## `sos-summary.ps1`

Read the SOS shape of a folder without changing files:

```powershell
.\scripts\sos-summary.ps1 -TargetPath <path-to-node>
```

The script reports node metadata, vault counts, missing required SOS files, and routing-surface reachability counts.

## `sos-audit.ps1`

Inspect SOS structure and mandatory metadata without changing files:

```powershell
.\scripts\sos-audit.ps1 -TargetPath <path-to-node>
```

The script reports missing required files/directories, SOS-owned Markdown files missing YAML frontmatter, missing PM references, missing adapter delegation, and unreachable SOS surface paths.

## `sos-migrate-assess.ps1`

Inspect older project-memory and KB structures without changing files:

```powershell
.\scripts\sos-migrate-assess.ps1 -TargetPath <path-to-node>
```
