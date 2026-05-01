---
name: sos:help
description: Show available SOS commands for this node.
disable-model-invocation: true
---

Run `/sos:help` for this node.

Read `.claude/sos/COMMANDS.md`, `.claude/sos/SCHEMA.md`, `.claude/PM.md`, and `.claude/STONE.md`.

Start with this compact SOS shape:

```text
SOS shape

Solution / Project
  A root folder can describe the whole endeavour. Subfolders can describe projects or parts.

Spine
  The folder path and node metadata explain what each level is, owns, inherits, and publishes.

.claude context
  PM, STONE, ACTORS, TOOLS, WORKFLOW, CLAUDE, AGENTS, commands, and skills.

Vault
  The knowledge base at each level: triage, wiki, archive, outbox, manifests, and metadata.

Tools
  Available/preferred/parked tools that can act on the spine and vault without becoming truth.

Automation
  Repeatable flows such as init, ingest, audit, export, migration, and human-gated processing.
```

Then show the available SOS commands and current safe next action. Mention restart/reload only if Claude Code command discovery appears stale.
