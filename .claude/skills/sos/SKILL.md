---
name: sos
description: SolutionOS command router for this node. Use when the user invokes /sos to run SOS help, about, init, summary, audit, tools, ingest, migration, vault, context, or session workflows.
argument-hint: "[help|about|init|summary|audit|tools|ingest|migrate|vault-process|vault-summary|context-export|context-import|session-close]"
disable-model-invocation: true
---

# SOS Router

This skill is the native Claude Code entry point for SolutionOS in this project.

Claude Code exposes this as:

```text
/sos <subcommand>
```

Treat that as equivalent to the canonical SOS vocabulary:

```text
/sos:<subcommand>
```

Visible branch commands are also installed under `.claude/commands/sos/` for Claude Code command discovery.

## First Step

Read these before acting:

1. `.claude/sos/COMMANDS.md`
2. `.claude/PM.md`
3. `.claude/STONE.md`
4. `.claude/WORKFLOW.md`

Do not load all of `.claude/sos/` unless the selected subcommand needs it.

## Subcommands

| Invocation | Canonical Meaning |
|---|---|
| `/sos` | Show the available SOS subcommands and current safe next action. |
| `/sos help` | `/sos:help` - quick command reference, including installed version. |
| `/sos about` | `/sos:about` - explain SOS intent and structure. |
| `/sos init` | `/sos:init` - install or refresh SOS. Proposal first. |
| `/sos summary` | `/sos:summary` - summarize SOS/node health. Read-only. |
| `/sos audit` | `/sos:audit` - inspect drift, missing files, metadata, stale adapters, repair opportunities. |
| `/sos tools` | `/sos:tools` - explain current tools, preferences, parked options, gaps, and possible additions. |
| `/sos ingest <source> <intent>` | `/sos:ingest` - ingest an external source into the vault using the user's intent. |
| `/sos migrate` | `/sos:migrate` - assess older project memory/KB structures before migration. Read-only first. |
| `/sos vault-process` | `/sos:vault-process` - process `vault/triage` items through human-gated decisions. |
| `/sos vault-summary` | `/sos:vault-summary` - summarize vault state and pending triage. |
| `/sos context-export` | `/sos:context-export` - create a source-backed export package. |
| `/sos context-import` | `/sos:context-import` - import source-backed context. Proposal first. |
| `/sos session-close` | `/sos:session-close` - close a substantial session and update state. |

## Safety Rules

- Default to read-only for `summary`, `tools`, `vault-summary`, and `migrate`.
- For `init`, `audit`, `ingest`, `context-import`, and `vault-process`, propose changes before editing unless the user gave a clear direct-write instruction.
- Never process `vault/triage/README.md` or `vault/triage/_manifest.md` as triage items.
- Do not initialize Backlog.md unless the user explicitly approves that tool adoption.
- If `/sos:*` entries do not appear in the slash menu, explain that Claude Code may need to reload/restart after new project command files are added. Use `/sos <subcommand>` as the fallback.

## Script Hints

If the SolutionOS repo scripts are available, use them for checks:

```powershell
.\scripts\sos-summary.ps1 -TargetPath .
.\scripts\sos-audit.ps1 -TargetPath .
.\scripts\sos-migrate-assess.ps1 -TargetPath .
```

If scripts are not available, perform the file-based protocol from `.claude/sos/COMMANDS.md` and `.claude/sos/SCHEMA.md`.
