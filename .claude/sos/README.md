---
type: sos-readme
scope: system
status: active
---

# SOS System Directory

This directory contains SolutionOS system material.

It is not normal project context.

Do not read or follow files here during ordinary project work unless the user invokes an `/sos:*` task or asks to install, summarize, audit, export, import, update, inspect schemas, or review toolsets.

## Contents

- `sos.json` - machine-readable SOS install/node metadata.
- `VERSION.md` - human-readable SOS/template version stamp.
- `COMMANDS.md` - official SOS command vocabulary.
- `SCHEMA.md` - human-readable schema for node files and metadata.
- `TOOLKITS.md` - SOS-wide toolset preferences and adoption rules.
- `template/` - local template support material.
- `export/` - portable single-file assets intended to be copied out.

Migration assessment is part of SOS operations. Use `/sos:migrate` or `scripts/sos-migrate-assess.ps1` before moving older Workspacer, KB, spine, command, skill, or inbox-style material into the active SOS structure.

Native Claude Code invocation is provided by `.claude/skills/sos/SKILL.md`.
