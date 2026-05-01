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
| Node.js | available | Primary SOS CLI runtime | `bin/sos.js` exposes `sos install`, `sos audit`, `sos status`, and `sos migrate`. |
| PowerShell | available | Compatibility helper execution | Legacy/source helpers remain in `scripts/` and installed nodes keep read-only scripts under `.claude/sos/scripts/`. |

## Build / Run / Test Commands

| Command | Purpose | Notes |
|---|---|---|
| `node .\bin\sos.js install --target <path>` | Apply SOS baseline to a repository. | Creates missing files and skips existing files unless `--force` is supplied. |
| `node .\bin\sos.js audit --target <path>` | Read-only SOS structure audit. | Reports missing files/dirs, missing SOS frontmatter, and unreachable routing-surface paths. |
| `node .\bin\sos.js status --target <path>` | Read-only SOS health summary. | Reports metadata, vault counts, and audit counts. |
| `node .\bin\sos.js migrate --target <path>` | Read-only migration assessment. | Finds older project-memory and KB structures before migration work. |
| `npm test` | CLI and audit smoke test. | Checks CLI syntax and audits this repo plus `templates/core`. |

## Environments

| Environment | Purpose | Notes |
|---|---|---|

## External Services

| Service | Purpose | Notes |
|---|---|---|

## Known Tool Issues

Record local tool issues here.
