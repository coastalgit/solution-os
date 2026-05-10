---
sos-file: context-router
sos-version: 0.2.0
sos-schema: 1
sos-origin: packaged
sos-managed: true
type: router
scope: node
status: active
authority: high
---

# PM

PM means Project Map / Project Manager / filing cabinet router for this SOS node.

This file is the canonical context router. Keep it concise. Load detail only when the task requires it.

## Active Context

- `.sos/context/STONE.md` - carved-in-stone facts, constraints, decisions, and non-negotiables.
- `.sos/context/ACTORS.md` - people, systems, services, teams, and named roles.
- `.sos/context/TOOLS.md` - local tools, commands, environment, and operational facts.
- `.sos/context/WORKFLOW.md` - default lifecycle, context loading, human gates, and capture rules.

## Knowledge Base

- `vault/triage/` - raw KB material awaiting processing.
- `vault/wiki/` - curated knowledge.
- `vault/wiki/decisions/` - ADRs and other durable decision records.
- `vault/archive/` - processed source evidence and retained records.
- `vault/outbox/` - generated deliverables and exports.

## SOS System Material

Do not read `.sos/system/**`, `.sos/frameworks/**`, or `.claude/sos/**` during normal project work.

Read SOS system material only for `/sos:*` operations such as install, audit, summary, export, import, upgrade, schema inspection, framework changes, or toolset policy review.

## Node Map

Add the node hierarchy and important folders here.

```text
node-root/
  .sos/
  .claude/
  vault/
```

## Current Focus

Record the current focus or link to the relevant wiki note.

## Open Questions

Record or link current open questions.
