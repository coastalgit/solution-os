---
name: sos:about
description: Explain the intent and structure of SOS for this node.
disable-model-invocation: true
---

Run `/sos:about` for this node.

Read `.claude/sos/sos.json`, `.claude/sos/SCHEMA.md`, `.claude/PM.md`, `.claude/STONE.md`, and `.claude/sos/TOOLKITS.md`.

Include the installed SOS version and template version.

Explain SOS as a portable baseline for making a folder understandable, resumable, and AI-operable.

Cover:

- solution/project hierarchy: a root folder can represent the wider solution or endeavour, with subfolders/projects beneath it
- node contents: each solution/project can carry its own `.claude` context, vault, metadata, tools, commands, skills, and parent/child relationship
- spine: context flows through the folder path and node metadata, including what a level owns, inherits, reads upward, or publishes upward
- vault: every SOS solution/project has a vault as the KB, with `triage`, `wiki`, `archive`, `outbox`, and manifests
- metadata: SOS-owned Markdown context and curated wiki files use YAML frontmatter for routing, search, authority, privacy, and automation
- optional views/adapters: Obsidian can sit over the vault, Backlog or other tools can handle work management, and AI tools such as Claude/Codex use their adapters
- automation: repeatable flows such as init, summary, audit, ingest, migration, export/import, and human-gated processing

Keep this explanatory but not long.
