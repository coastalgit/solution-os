---
name: sos:about
description: Explain the intent and structure of SOS for this node.
disable-model-invocation: true
---

Run `/sos:about` for this node.

Read `.claude/sos/sos.json` and `.claude/sos/SCHEMA.md`.

Give a short explanation only. Include the installed SOS version and template version.

Required shape:

```text
SOS is a portable baseline for making a folder understandable, resumable, and AI-operable.

Root folders can be solutions or wider endeavours.
Subfolders can be projects or parts.
The spine is the path and metadata that explain how those levels relate.

Each level can carry:
- `.claude` context for AI tools
- `vault` as the KB: triage, wiki, archive, outbox
- Markdown metadata/frontmatter for routing and automation
- optional adapters such as Obsidian, Backlog, Claude, Codex, Firecrawl, or local scripts
```

End by pointing to `/sos:help` for commands.
