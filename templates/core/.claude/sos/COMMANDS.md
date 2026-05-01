---
type: commands
scope: system
status: active
---

# SOS Commands

All SolutionOS operations use the `/sos:*` namespace.

Keep command names concept-down so autocomplete groups related commands.

## Claude Code Invocation

Project-level Claude Code skills expose `/sos`, with the subcommand as the first argument.
Project-level Claude Code command files are also installed under `.claude/commands/sos/` so branch commands can appear as `/sos:*` entries where Claude Code supports named command discovery.

Examples:

- `/sos summary` means `/sos:summary`.
- `/sos vault-process` means `/sos:vault-process`.
- `/sos migrate` means `/sos:migrate`.

If `/sos:*` entries do not appear immediately after install/update, restart or reload Claude Code so it re-scans project commands. `/sos <subcommand>` remains the fallback.

## v0.1 Commands

| Command | Purpose | Default Behavior |
|---|---|---|
| `/sos:help` | Show a quick SOS command reference, including installed version. | Read-only. |
| `/sos:about` | Explain the intent and structure of SOS, including solution/project spine, vault, metadata, and optional tools. | Read-only. |
| `/sos:init` | Install or refresh SOS in the current node. | Propose changes first. Apply only with approval. |
| `/sos:summary` | Summarize SOS/node health and current state. | Read-mostly. Do not apply changes. |
| `/sos:audit` | Inspect deeply for drift, missing files, missing metadata, stale adapters, and repair opportunities. | May propose/apply approved changes. |
| `/sos:tools` | Explain current tools, preferences, parked options, gaps, and possible additions. | Conversational; ask before adopting tools. |
| `/sos:ingest <source> <intent>` | Ingest a website, PDF, repo, video, doc, or pasted source into the vault. | Use available extraction tools; ask or triage when unclear. |
| `/sos:migrate` | Assess and plan migration from older project memory/KB setups into SOS. | Read-only assessment first; apply only after explicit choices. |
| `/sos:vault-process` | Process `vault/triage` items into wiki/archive/outbox. | Human-gated triage. |
| `/sos:vault-summary` | Summarize vault state and pending triage. | Read-only. |
| `/sos:context-export` | Create source-backed context export for another node/tool/agent. | Uses export rules. |
| `/sos:context-import` | Import source-backed context into this node. | Propose mapping first. |
| `/sos:session-close` | Close a substantial session by updating state, questions, and next action. | Updates with approval if needed. |

## Update Behavior

No separate upgrade command is required for v0.1.

`/sos:init`, `/sos:summary`, and `/sos:audit` may detect remote template/version drift and suggest updates.
