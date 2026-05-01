# SolutionOS

SolutionOS (`sos`) is a portable operating layer for AI-operable workspaces.

It installs, summarizes, audits, and exports a consistent project/endeavour memory structure so humans and AI agents can work from the same durable context instead of relying on chat history or tool-specific memory.

## Repository

Canonical repo:

```text
https://github.com/coastalgit/solution-os.git
```

Manifest URL once `main` is published:

```text
https://raw.githubusercontent.com/coastalgit/solution-os/main/manifest.json
```

## Read This First: Product Repo and SOS Node

To install SOS into another repository, start with [`INSTALL.md`](INSTALL.md).

This repository is doing two jobs:

1. It is the **SolutionOS product/source repository**.
2. It is also an **SOS node for the work of building SolutionOS itself**.

That is deliberate dogfooding, but it can look recursive until the layers are separated.

### Product / Distribution Layer

These files are the product source used to install or update SOS elsewhere:

- `templates/core/` - the installable baseline copied into other nodes.
- `INSTALL.md` - public source-repo install entry point for agents and humans.
- `scripts/` - source-repo helper scripts, including preview/apply init.
- `manifest.json` - published version and update metadata.
- `docs/design/` - source-backed design ledger, requirements, decisions, architecture, and open questions.
- `.claude/sos/export/SOS-INSTALL.md` - portable install instruction file for cloud/agent use.
- `.claude/sos/export/SOS-BUILDER.md` - portable context-export builder instruction file.

When applying SOS to another repository, treat `templates/core/` and the exported install instructions as the product payload. Do not treat this repo root's own `.claude/` and `vault/` as files to copy by hand.

For cloud-agent installation into another repository, the root entry point is:

```text
https://raw.githubusercontent.com/coastalgit/solution-os/main/INSTALL.md
```

The portable installed-node protocol remains at `.claude/sos/export/SOS-INSTALL.md`.

### This Repo's Own SOS Node

These files are this repository's working memory for developing SolutionOS:

- `.claude/PM.md`, `.claude/STONE.md`, `.claude/ACTORS.md`, `.claude/TOOLS.md`, `.claude/WORKFLOW.md` - active context for this product repo.
- `.claude/sos/` - the installed SOS system material for this product repo.
- `vault/` - the knowledge base for the SolutionOS product project itself.

In short: `templates/core/` is what other projects receive; root `.claude/` and root `vault/` are this repo using SOS on itself.

## Core Idea

Every bounded endeavour can be treated as an SOS node:

- software solution
- standalone project
- legacy codebase
- workshop
- research effort
- learning programme
- non-code plan

Each node gets:

- `.claude/` for active AI control-plane files
- `vault/` for the node knowledge base
- adapter files such as `CLAUDE.md` and `AGENTS.md`
- SOS system material under `.claude/sos/`

## v0.1 Scope

Keep this small:

- define the SOS node layout
- define the vault lifecycle
- define command vocabulary
- define install/export bootstrap files
- define source-backed context transfer
- provide templates that can be copied into projects
- provide a small preview-first local init helper

Do not build a full CLI, marketplace, cloud service, dashboard, or autonomous agent swarm yet.

## Current Project Shape

```text
docs/
  design/
INSTALL.md
templates/
  core/
scripts/
vault/
  triage/
  wiki/
    history.md
  archive/
  outbox/
.claude/
  skills/
    sos/
  commands/
    sos/
  PM.md
  STONE.md
  ACTORS.md
  TOOLS.md
  WORKFLOW.md
  sos/
    scripts/
manifest.json
```

Current version:

```text
0.1.12
```

## First Principles

- The project memory must be source-backed.
- Summaries are views, not authority.
- `vault/` exists in every SOS node and is the KB.
- `vault/triage/` is the raw processing lane.
- `.claude/` contains active control-plane context for agents.
- `.claude/sos/` contains SOS system material, not normal work context.
- Every node knows whether it may belong to a parent solution.
- Workspacer was the early installer/overseer idea; `sos:init` is the cleaner evolution.
- This repository dogfoods SOS; root `.claude/` and root `vault/` are this repo's own node memory, not the install payload.

## Local Bootstrap

Preview an install into another folder:

```powershell
.\scripts\sos-init.ps1 -TargetPath <path-to-node> -NodeKind project
```

Apply it:

```powershell
.\scripts\sos-init.ps1 -TargetPath <path-to-node> -NodeKind project -Apply
```

Existing files are skipped unless `-Force` is supplied.

Summarize an installed node:

```powershell
.\scripts\sos-summary.ps1 -TargetPath <path-to-node>
```

Audit structure and metadata:

```powershell
.\scripts\sos-audit.ps1 -TargetPath <path-to-node>
```

Assess migration sources in an existing project:

```powershell
.\scripts\sos-migrate-assess.ps1 -TargetPath <path-to-node>
```

Installed nodes also carry the read-only helpers locally:

```powershell
.\.claude\sos\scripts\sos-summary.ps1 -TargetPath .
.\.claude\sos\scripts\sos-audit.ps1 -TargetPath .
.\.claude\sos\scripts\sos-migrate-assess.ps1 -TargetPath .
```
