---
name: sos:summary
description: Summarize SOS and node health. Read-only.
disable-model-invocation: true
---

Run `/sos:summary` for this node.

Read `.claude/sos/sos.json` and `.claude/sos/COMMANDS.md`, then summarize SOS version, template version, node metadata, vault counts, missing files, and safe next action. Prefer available SOS scripts; otherwise use the file-based protocol.
