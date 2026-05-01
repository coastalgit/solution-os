---
name: sos:help
description: Show a quick SOS command reference for this node.
disable-model-invocation: true
---

Run `/sos:help` for this node.

Read `.claude/sos/sos.json` and `.claude/sos/COMMANDS.md`.

Show a compact quick reference only:

- installed SOS version and template version
- node name and node kind
- available `/sos:*` commands with one-line purposes
- current safe next action
- pointer to `/sos:about` for the longer explanation of intent, solution/project spine, vault, metadata, and optional tools

Mention restart/reload only if Claude Code command discovery appears stale.
