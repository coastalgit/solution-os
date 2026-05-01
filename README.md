# SolutionOS

SolutionOS (`sos`) is a portable operating layer for AI-operable workspaces.

It installs, summarizes, audits, and exports a consistent project/endeavour memory structure so humans and AI agents can work from the same durable context instead of relying on chat history or tool-specific memory.

## Use SOS

Install the `sos` tool once in the machine or agent environment:

```bash
npm install -g @coastalgit/solution-os
```

Then apply SOS inside any repository:

```bash
cd path/to/project
sos install
sos audit
```

That is the primary model:

- install the **tool** globally;
- run `sos install` to apply missing **project-local SOS node files**;
- run `sos audit` to verify the node.

The project-local SOS state records its own installed baseline in `.claude/sos/sos.json`.

## CLI

```text
sos install   Apply missing core SOS baseline files to the current repository.
sos audit     Check required files, metadata, PM routing, surface reachability, actor/concept integrity, and archive integrity.
sos status    Show installed version, node metadata, vault counts, and health.
sos migrate   Detect older memory/KB structures that may need migration.
sos version   Print the installed tool version.
```

Useful options:

```text
--target <path>       Operate on another directory instead of the current one.
--node-kind <kind>    solution, project, module, workshop, research, learning, other.
--node-name <name>    Set node name when creating `.claude/sos/sos.json`.
--dry-run             Preview `sos install` without writing files.
--json                Emit machine-readable output for audit/status/migrate.
```

`sos install` never overwrites existing files. It creates missing files and skips anything already present, including `CLAUDE.md`, `AGENTS.md`, `.claude/`, and `vault/` content.

When run over an existing SOS node, the CLI checks `.claude/sos/sos.json` before writing:

- same project version as the running CLI: safe missing-file refresh
- older project version than the running CLI: missing files may be added, existing files are still skipped
- newer project version than the running CLI: write commands are blocked
- unreadable or missing project version metadata: write commands are blocked

When the CLI is launched through a one-shot cloud/package command, the running CLI version is treated as the package/cloud version for this safety check.

## Repository

Canonical repo:

```text
https://github.com/coastalgit/solution-os.git
```

Manifest:

```text
https://raw.githubusercontent.com/coastalgit/solution-os/main/manifest.json
```

Current version:

```text
0.1.14
```

## Product Repo and SOS Node

This repository is doing two jobs:

1. It is the **SolutionOS product/source repository**.
2. It is also an **SOS node for the work of building SolutionOS itself**.

That is deliberate dogfooding, but the layers are different.

### Product / Distribution Layer

These files are the product source used to install or update SOS elsewhere:

- `package.json` and `bin/sos.js` - the global CLI package.
- `templates/core/` - the installable baseline copied into other nodes.
- `manifest.json` - published version and update metadata.
- `docs/design/` - source-backed design ledger, requirements, decisions, architecture, and open questions.
- `scripts/` - legacy/source helper scripts retained for compatibility and installed-node checks.

When applying SOS to another repository, use the `sos` CLI and `templates/core/`. Do not copy this repo root's own `.claude/` or `vault/` by hand.

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

## Current Project Shape

```text
bin/
  sos.js
docs/
  design/
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
package.json
```

## First Principles

- The project memory must be source-backed.
- Summaries are views, not authority.
- `vault/` exists in every SOS node and is the KB.
- `vault/triage/` is the raw processing lane.
- `vault/archive/` is the single place for non-active retained material, including processed source evidence and retained records.
- `.claude/` contains active control-plane context for agents.
- `.claude/sos/` contains SOS system material, not normal work context.
- Every node knows whether it may belong to a parent solution.
- Workspacer was the early installer/overseer idea; `sos install`, `sos audit`, and `sos update` are the cleaner product surface.
- This repository dogfoods SOS; root `.claude/` and root `vault/` are this repo's own node memory, not the install payload.

## Compatibility Helpers

The `scripts/` PowerShell helpers remain for compatibility and for installed-node self-checks, but the primary user-facing path is the `sos` CLI.

Installed nodes also carry read-only helper scripts locally under:

```text
.claude/sos/scripts/
```

## SOS Slash Workflows

Installed nodes include `.claude/sos/SOS-VISUAL.html`, a tiny local visual map of the SOS agentic operating layer. `/sos:help` and `/sos:about` point to it when a user wants to see the shape of the system rather than only read command text.

Installed nodes include `/sos:assistant` as the friendly front door. Users can ask what they are trying to do in plain language, and the assistant routes them to the right SOS workflow without requiring command memorization.

Installed nodes include `/sos:archive` and `/sos:unarchive` command files for agent-driven archive operations. They are human-gated workflows, not blind file moves: agents must ask Q&A when context is unclear, offer `(Y)ES`, `(N)O`, `(D)ISCUSS`, and `(C)ANCEL`, preserve binary/hash-sensitive files byte-for-byte, and update `vault/archive/_manifest.md` plus archive metadata in the same change.
