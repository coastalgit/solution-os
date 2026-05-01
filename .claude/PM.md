---
type: router
scope: node
status: active
authority: high
---

# PM

PM means Project Map / Project Manager / filing cabinet router for this SOS node.

This file routes agents to the right context. It is not a dumping ground and should stay concise.

## SOS Surface

These paths are the canonical routing surface for incoming agents and audits. Keep this surface listed even when the node-specific map grows.

### Active Context

- `.claude/STONE.md` - carved-in-stone facts, constraints, decisions, and non-negotiables.
- `.claude/ACTORS.md` - people, systems, services, teams, and named roles.
- `.claude/TOOLS.md` - local tools, commands, environment, and operational facts.
- `.claude/WORKFLOW.md` - default lifecycle, context loading, human gates, and capture rules.

### Knowledge Base

- `vault/triage/` - raw KB material awaiting processing.
- `vault/wiki/` - curated knowledge.
- `vault/archive/` - processed source evidence.
- `vault/outbox/` - generated deliverables and exports.

### SOS System Material

Do not read `.claude/sos/**` during normal project work.

Read `.claude/sos/**` only for `/sos:*` operations such as init, summary, audit, export, import, schema inspection, template update, or toolset policy review.

- `.claude/sos/` - installed SOS system material, schema, command vocabulary, tool policy, scripts, and export/install files.
- `.claude/skills/sos/` - native Claude Code `/sos` skill router.
- `.claude/commands/sos/` - native Claude Code `/sos:*` branch commands.

## Node Map

Add the node hierarchy and important folders here.

```text
node-root/
  .claude/
  vault/
  bin/sos.js
  docs/design/
  package.json
  scripts/
  templates/core/
```

## Current Focus

Seed SolutionOS v0.1 from the source-backed discussion:

- design docs in `docs/design/`
- curated product history in `vault/wiki/history.md`
- primary CLI entry point in `bin/sos.js`
- package metadata in `package.json`
- install template in `templates/core/`
- compatibility helpers in `scripts/`
- actor/concept integrity rules in `ACTORS.md`, `STONE.md`, `WORKFLOW.md`, and `SCHEMA.md`
- dogfooded active node files in `.claude/`
- node KB in `vault/`

## Open Questions

See `docs/design/open-questions.md`.
