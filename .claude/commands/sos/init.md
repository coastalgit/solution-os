---
name: sos:init
description: Install missing SOS files in this node. Proposal first.
disable-model-invocation: true
---

Run `/sos:init` for this node.

Read `.claude/sos/COMMANDS.md`, `.claude/sos/SCHEMA.md`, `.claude/sos/sos.json`, and `.claude/PM.md`. Propose changes before writing. Never overwrite existing files. Stop before writing if the project SOS version is newer than the running tool or if version metadata is missing/unreadable.

If the project SOS version is older than the running tool, call it an upgrade opportunity, not a refresh or repair. `sos install` may create missing SOS-owned files only. For existing files, offer append-only amendments with exact paths and no deletion or information loss, or leave the upgrade unapplied.
