---
sos-file: context-workflow
sos-version: 0.2.0
sos-schema: 1
sos-origin: packaged
sos-managed: true
type: workflow
scope: node
status: active
authority: high
---

# WORKFLOW

WORKFLOW means the default lifecycle for capture, triage, planning, execution, verification, documentation, and human gates.

## Default Lifecycle

```text
capture -> triage -> map/context -> plan -> human gate -> execute -> verify -> capture learning
```

## Context Loading Rule

Read routers first. Load detail only when needed.

## Agentic SDLC

When enabled, the Agentic SDLC framework uses:

```text
Inspect -> Plan -> Prove -> Implement -> Verify -> Review -> Capture
```

This framework is optional and upgradeable. Its applied state is recorded under `.sos/frameworks/agentic-sdlc/`.

## Decision Records

Use ADRs for durable decisions where future agents need to know why a direction was chosen.

ADRs live in `vault/wiki/decisions/` and use `.sos/templates/adr.md`. They should stay short: context, decision, consequences, and status.

## Human Gates

Ask before structural changes, risky file edits, tool adoption, external communication, deletion/moves, task-adapter changes, and applying audit repairs.
