---
type: tools
scope: node
status: active
---

# TOOLS

TOOLS means the tools, environments, commands, services, and operational constraints available in this node.

This is local project/environment fact, not global SOS tool policy.

For SOS-wide toolset preferences and adoption rules, read `.claude/sos/TOOLKITS.md` only during `/sos:*` or tool-choice tasks.

## Available Tools

| Tool | Status | Purpose | Notes |
|---|---|---|---|
| PowerShell | available | Local SOS helper execution | Used for preview/apply init and read-only summary scripts. |

## Build / Run / Test Commands

| Command | Purpose | Notes |
|---|---|---|
| `.\scripts\sos-init.ps1 -TargetPath <path>` | Preview SOS template install. | Add `-Apply` to write files; existing files are skipped unless `-Force` is used. |
| `.\scripts\sos-summary.ps1 -TargetPath <path>` | Read-only SOS health summary. | Reports metadata, vault counts, and missing required files/dirs. |
| `.\scripts\sos-audit.ps1 -TargetPath <path>` | Read-only SOS structure audit. | Reports missing required files/dirs and missing SOS frontmatter. |
| `.\scripts\sos-migrate-assess.ps1 -TargetPath <path>` | Read-only migration assessment. | Finds older project-memory and KB structures before a migration plan. |
| `.\.claude\sos\scripts\sos-summary.ps1 -TargetPath .` | Installed-node summary helper. | Mirrors the source helper path inside an applied SOS node. |

## Environments

| Environment | Purpose | Notes |
|---|---|---|

## External Services

| Service | Purpose | Notes |
|---|---|---|

## Known Tool Issues

Record local tool issues here.
