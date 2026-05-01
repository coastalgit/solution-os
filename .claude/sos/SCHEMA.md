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
| `vault/triage/_manifest.md` | Triage item manifest. |
| `vault/wiki/` | Curated KB. |
| `vault/wiki/_manifest.md` | Wiki lifecycle manifest. |
| `vault/archive/` | Processed source evidence. |
| `vault/archive/_manifest.md` | Archive traceability manifest. |
| `vault/outbox/` | Generated deliverables/exports. |
| `vault/outbox/_manifest.md` | Outbox deliverables manifest. |
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
| `.claude/sos/VERSION.md` | Human-readable installed SOS/template version stamp. |
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

## Metadata Rule

SOS-owned Markdown context and KB files must include YAML frontmatter.

This applies to:

- `.claude/*.md`
- `.claude/sos/*.md`
- `.claude/sos/export/*.md`
- `.claude/sos/template/*.md`
- curated `vault/wiki/*.md` notes
- vault lifecycle README and manifest files under `vault/triage`, `vault/wiki`, `vault/archive`, and `vault/outbox`

This does not apply to:

- source code
- scripts
- JSON/config files
- generated files
- vendor files
- copied external docs
- ordinary public-facing README files unless they are acting as SOS context files

## Frontmatter Minimum

Required minimum:

```yaml
---
type:
scope:
status:
---
```

Use more fields only when they help routing, authority, privacy, or automation.

## Common Optional Fields

| Field | Use |
|---|---|
| `authority` | When one file should outrank ordinary notes. |
| `privacy` | When visibility or sharing risk matters. |
| `created` | For durable wiki notes. |
| `updated` | For durable wiki notes. |
| `tags` | For Obsidian/search/indexing. |
| `aliases` | For alternate names. |
