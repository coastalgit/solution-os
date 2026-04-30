---
type: schema
scope: system
status: active
---

# SOS Schema

This is the human-readable schema for an SOS node.

## Required Root Files

| Path | Purpose |
|---|---|
| `CLAUDE.md` | Claude adapter/router into SOS. |
| `AGENTS.md` | Codex adapter/router into SOS. |
| `vault/triage/` | Raw KB processing lane. |
| `vault/wiki/` | Curated KB. |
| `vault/archive/` | Processed source evidence. |
| `vault/outbox/` | Generated deliverables/exports. |
| `.claude/PM.md` | Active context router / filing cabinet. |
| `.claude/STONE.md` | Carved-in-stone facts and non-negotiables. |
| `.claude/ACTORS.md` | People, systems, teams, services, roles. |
| `.claude/TOOLS.md` | Local tools/environment facts. |
| `.claude/WORKFLOW.md` | Lifecycle and human gates. |
| `.claude/sos/` | SOS system material. |

## Required SOS System Files

| Path | Purpose |
|---|---|
| `.claude/sos/sos.json` | Machine-readable node/install metadata. |
| `.claude/sos/README.md` | Explains SOS system directory. |
| `.claude/sos/COMMANDS.md` | Official command vocabulary. |
| `.claude/sos/SCHEMA.md` | This schema. |
| `.claude/sos/TOOLKITS.md` | SOS toolset preferences and adoption rules. |
| `.claude/sos/export/SOS-BUILDER.md` | Portable export builder file. |
| `.claude/sos/export/SOS-INSTALL.md` | Portable install/init file. |

## Node Metadata

`sos.json` must define:

- SOS version
- template version
- node name
- node kind
- visibility
- parent relationship
- vault paths
- remote repository URL if configured
- remote manifest URL if configured
- default remote branch if configured

## Frontmatter Minimum

Spine-owned Markdown notes should include minimal frontmatter:

```yaml
---
type:
scope:
status:
---
```

Use more fields only when they help routing, authority, privacy, or automation.
