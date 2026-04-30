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

## `sos-summary.ps1`

Read the SOS shape of a folder without changing files:

```powershell
.\scripts\sos-summary.ps1 -TargetPath <path-to-node>
```

The script reports node metadata, vault counts, and missing required SOS files.
