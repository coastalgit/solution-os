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
| `vault/archive/` | Non-active retained source evidence and records. |
| `vault/archive/_manifest.md` | Archive traceability, retention, and reactivation manifest. |
| `vault/outbox/` | Generated deliverables/exports. |
| `vault/outbox/_manifest.md` | Outbox deliverables manifest. |
| `.claude/PM.md` | Active context router / filing cabinet. |
| `.claude/STONE.md` | Carved-in-stone facts and non-negotiables. |
| `.claude/ACTORS.md` | People, systems, teams, services, roles. |
| `.claude/TOOLS.md` | Local tools/environment facts. |
| `.claude/WORKFLOW.md` | Lifecycle and human gates. |
| `.claude/skills/sos/SKILL.md` | Native Claude Code `/sos` skill router. |
| `.claude/commands/sos/` | Native Claude Code `/sos:*` branch commands. |
| `.claude/sos/` | SOS system material. |

## Routing Contract

Required files are not enough if a fresh agent cannot find them by following the documented route. SOS calls the discoverable set of required context, system, and vault paths the **SOS surface**.

Adapters and routers must satisfy this contract:

- `CLAUDE.md` MUST reference `.claude/PM.md`.
- `AGENTS.md` MUST reference `.claude/PM.md`.
- `AGENTS.md` MUST reference `.claude/sos/COMMANDS.md` so Codex-style agents can find the fallback command vocabulary.
- `.claude/PM.md` is the canonical node map and MUST reference:
  - `.claude/STONE.md`
  - `.claude/ACTORS.md`
  - `.claude/TOOLS.md`
  - `.claude/WORKFLOW.md`
  - `.claude/sos/`
  - `.claude/skills/sos/`
  - `.claude/commands/sos/`
  - `vault/triage/`
  - `vault/wiki/`
  - `vault/archive/`
  - `vault/outbox/`

`/sos:audit` SHOULD report missing files, missing metadata, missing PM references, missing adapter delegation, and unreachable SOS surface paths. A node can have every file present and still need attention if the routing chain does not expose the SOS surface.

## Required SOS System Files

| Path | Purpose |
|---|---|
| `.claude/sos/sos.json` | Machine-readable node/install metadata. |
| `.claude/sos/README.md` | Explains SOS system directory. |
| `.claude/sos/VERSION.md` | Human-readable installed SOS/template version stamp. |
| `.claude/sos/COMMANDS.md` | Official command vocabulary. |
| `.claude/sos/ASSISTANT.md` | Guided user-facing SOS assistant/router reference. |
| `.claude/sos/SOS-VISUAL.html` | Local static visual map of the SOS agentic operating layer. |
| `.claude/sos/SCHEMA.md` | This schema. |
| `.claude/sos/TOOLKITS.md` | SOS toolset preferences and adoption rules. |
| `.claude/sos/template/concept-binding.md` | Template for binding repeated named concepts to a canonical note. |
| `.claude/sos/scripts/README.md` | Node-local helper script notes. |
| `.claude/sos/scripts/sos-summary.ps1` | Read-only node summary helper. |
| `.claude/sos/scripts/sos-audit.ps1` | Read-only structure and metadata audit helper. |
| `.claude/sos/scripts/sos-migrate-assess.ps1` | Read-only legacy memory/KB migration assessment helper. |
| `.claude/sos/export/SOS-BUILDER.md` | Portable export builder file. |
| `.claude/sos/export/SOS-INSTALL.md` | Installed-node install reference and fallback. |

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

## Version And Install Safety

Every local audit/status/action should report the project SOS version from `.claude/sos/sos.json` and the running SOS CLI/helper version.

Write actions must follow this policy:

- Project version newer than running tool: stop before writing.
- Project version same as running tool: normal operation.
- Project version older than running tool: missing-file install may proceed, but existing files are still skipped.
- Project version missing, unreadable, or not comparable: stop before writing.

`sos install` is never an overwrite command. It creates missing files and skips existing files. Replacing, merging, repairing, or upgrading existing files requires a separate explicit approval path.

## Assistant Contract

`/sos:assistant` is the guided front door for users who do not know which SOS command, folder, or workflow to use.

`.claude/sos/ASSISTANT.md` is the canonical assistant guide. It must:

- explain SOS in plain language before command jargon
- map common user intents to the correct SOS workflows
- route to existing commands instead of inventing parallel behavior
- ask Q&A when intent, context, paths, or risk are unclear
- preserve all target workflow human gates

Assistant may continue a routed workflow in-place if the platform cannot invoke another slash command, but it must name the routed protocol and follow that protocol's rules.

## Visual Aid

`.claude/sos/SOS-VISUAL.html` is a local static visual aid referenced by `/sos:help` and `/sos:about`.

It is not a source of truth. If the HTML conflicts with Markdown protocols, manifests, or schema, the Markdown protocols, manifests, and schema win.

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

## Archive Lifecycle

`vault/archive/` stores non-active retained material. It does not require a separate history folder.

Allowed archive kinds:

- `source-evidence`: raw input that has fed wiki notes, outbox items, decisions, or other current project artifacts.
- `retained-record`: email trails, meetings, correspondence, old docs/temp folders, and dated snapshots kept for retrospective context even when they are not currently feeding wiki/outbox work.

`vault/archive/_manifest.md` MUST use these columns:

| Path | Kind | Period | Status | Processed Into | Hash | Notes |
|---|---|---|---|---|---|---|

Use `Processed Into` only when the archive item has been processed into another durable artifact. Use `-` when the item is retained for context only.

Archive metadata sidecars SHOULD use `type: archive-metadata` and record:

- original path
- archive path
- action (`copied`, `moved`, `unarchived-copy`, or `unarchived-move`)
- kind
- period
- status
- SHA-256 hash where practical
- archived/unarchived date
- destination path when unarchived
- notes and user-approved context

Archive and unarchive actions are human-gated. If context is unclear, the agent must ask Q&A before touching files and offer `(Y)ES`, `(N)O`, `(D)ISCUSS`, and `(C)ANCEL`. `(C)ANCEL` stops the process and leaves files unchanged.

Archive is preservation first, interpretation second. Binary, encrypted, compressed, hash-mapped, generated, and vendor files must be copied or moved byte-for-byte. Agents must not decode, decrypt, normalize, re-save, pretty-print, or otherwise rewrite them.

`/sos:archive` moves or copies non-active material into `vault/archive/` and updates metadata plus manifest in the same change.

`/sos:unarchive` copies archived material back to an active location by default and updates metadata plus manifest in the same change. The archive copy remains unless the user explicitly approves removing it.

## Actor Registry Rule

`.claude/ACTORS.md` is the only canonical actor registry in an SOS node.

Vault content may reference people, organisations, teams, systems, and roles as source evidence, but vault files must not maintain parallel rosters, people lists, stakeholder registers, team registers, or actor registries.

Reserved vault registry filenames include:

- `people.md`
- `person.md`
- `team.md`
- `teams.md`
- `roster.md`
- `actors.md`
- `stakeholders.md`
- `stakeholder-register.md`
- `stakeholder-registry.md`

`ACTORS.md` is for active engagement only: people, teams, organisations, systems, services, agents, or roles actively involved in operating, deciding, reviewing, building, funding, governing, or maintaining the node. Passing mentions, survey respondents, archived authors, transcript voices, and source-only references stay in vault/source material unless they become operationally relevant.

## Naming Discipline

Actor registries and concept-binding notes must support aliases.

Use aliases when a name has plausible spelling variants, shorthand, initials, former names, product names, organisation variants, or common mistakes.

For tabular files such as `.claude/ACTORS.md`, use an `Aliases` column. For Markdown notes, use frontmatter:

```yaml
aliases:
  - Example shorthand
  - Example alternate spelling
```

Aliases are not required for ordinary notes where no naming variation is plausible.

## Concept-Binding Notes

A concept-binding note gives a repeated named idea one canonical home before, during, or after source material is available.

Use `type: concept-binding` for repeated named ideas, methods, initiatives, workstreams, labels, or phrases that agents need to resolve consistently.

Required frontmatter:

```yaml
---
type: concept-binding
scope: node
status: source-pending
aliases: []
occurrences: []
source: ""
---
```

Allowed status values:

- `source-pending`
- `source-bound`
- `archived`

Trigger rule: when a named concept appears more than once and has no canonical note, actor row, or source-bound home, propose a concept-binding note before treating it as durable context.

## Common Optional Fields

| Field | Use |
|---|---|
| `authority` | When one file should outrank ordinary notes. |
| `privacy` | When visibility or sharing risk matters. |
| `created` | For durable wiki notes. |
| `updated` | For durable wiki notes. |
| `tags` | For Obsidian/search/indexing. |
| `aliases` | For alternate names. |
