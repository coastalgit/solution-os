---
name: sos
description: SolutionOS command router for this node. Use when the user invokes /sos to run SOS assistant, help, about, init, summary, audit, tools, ingest, migration, vault, archive, context, spec, or session workflows.
argument-hint: "[assistant|help|about|init|summary|audit|tools|ingest|migrate|vault-process|vault-summary|archive|unarchive|context-export|context-import|session-close|spec]"
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

For `/sos assistant`, also read `.claude/sos/ASSISTANT.md`.

Do not load all of `.claude/sos/` unless the selected subcommand needs it.

## Subcommands

| Invocation | Canonical Meaning |
|---|---|
| `/sos` | Show the available SOS subcommands and current safe next action. Offer `/sos assistant` for guided help. |
| `/sos assistant` | `/sos:assistant` - guided front door that routes the user to the right SOS workflow. |
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
| `/sos archive <path-or-description> [context]` | `/sos:archive` - preserve non-active material in `vault/archive/` with metadata and manifest update. |
| `/sos unarchive <archive-path-or-description> [context]` | `/sos:unarchive` - copy archived material back to an active location and update archive metadata. |
| `/sos context-export` | `/sos:context-export` - create a source-backed export package. |
| `/sos context-import` | `/sos:context-import` - import source-backed context. Proposal first. |
| `/sos session-close` | `/sos:session-close` - close a substantial session and update state. |
| `/sos spec` | `/sos:spec` - create a guided draft feature spec pack from a local idea or existing GitHub issue. |

## Safety Rules

- Default to read-only for `summary`, `tools`, `vault-summary`, and `migrate`.
- `assistant` is a conversational router. It can continue into another SOS protocol only after naming the routed workflow and following that workflow's safety rules.
- For `init`, `audit`, `ingest`, `context-import`, `vault-process`, `archive`, `unarchive`, and `spec`, propose or ask the command's required questions before editing unless the user gave a clear direct-write instruction.
- For `archive` and `unarchive`, use `(Y)ES`, `(N)O`, `(D)ISCUSS`, and `(C)ANCEL`; preserve binary, encrypted, compressed, hash-mapped, generated, and vendor files byte-for-byte.
- Never process `vault/triage/README.md` or `vault/triage/_manifest.md` as triage items.
- Do not initialize Backlog.md unless the user explicitly approves that tool adoption.
- If `/sos:*` entries do not appear in the slash menu, explain that Claude Code may need to reload/restart after new project command files are added. Use `/sos <subcommand>` as the fallback.

## Script Hints

Installed SOS nodes include read-only helper scripts:

```powershell
.\.claude\sos\scripts\sos-summary.ps1 -TargetPath .
.\.claude\sos\scripts\sos-audit.ps1 -TargetPath .
.\.claude\sos\scripts\sos-migrate-assess.ps1 -TargetPath .
```

If scripts are missing, report SOS drift and then perform the file-based protocol from `.claude/sos/COMMANDS.md` and `.claude/sos/SCHEMA.md`.
