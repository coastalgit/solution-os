---
type: workflow
scope: node
status: active
authority: high
---

# WORKFLOW

WORKFLOW means the default lifecycle for capture, triage, planning, execution, verification, documentation, and human gates in this SOS node.

## Default Lifecycle

```text
capture
  -> triage
  -> map/context
  -> plan
  -> human gate
  -> execute
  -> verify
  -> capture learning
```

## Context Loading Rule

Read routers first. Load detail only when needed.

Avoid preloading whole directories or large documents unless the task requires it.

## Human Gates

Ask before:

- structural changes
- risky file edits
- tool adoption
- deployment/publishing
- external communication
- deleting or moving files
- changing project memory conventions
- applying audit repairs

## Vault Rules

- Raw material goes to `vault/triage/`.
- Curated knowledge goes to `vault/wiki/`.
- Processed evidence goes to `vault/archive/`.
- Generated deliverables go to `vault/outbox/`.

## Session Close

At the end of substantial work:

- update current state or PM notes
- update wiki where durable knowledge changed
- archive processed source material where relevant
- list open questions and next action

