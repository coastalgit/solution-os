---
type: commands
scope: system
status: active
---

# SOS Commands

All SolutionOS operations use the `/sos:*` namespace.

Keep command names concept-down so autocomplete groups related commands.

## v0.1 Commands

| Command | Purpose | Default Behavior |
|---|---|---|
| `/sos:init` | Install or refresh SOS in the current node. | Propose changes first. Apply only with approval. |
| `/sos:summary` | Summarize SOS/node health and current state. | Read-mostly. Do not apply changes. |
| `/sos:audit` | Inspect deeply for drift, missing files, missing metadata, stale adapters, and repair opportunities. | May propose/apply approved changes. |
| `/sos:vault-process` | Process `vault/triage` items into wiki/archive/outbox. | Human-gated triage. |
| `/sos:vault-summary` | Summarize vault state and pending triage. | Read-only. |
| `/sos:context-export` | Create source-backed context export for another node/tool/agent. | Uses export rules. |
| `/sos:context-import` | Import source-backed context into this node. | Propose mapping first. |
| `/sos:session-close` | Close a substantial session by updating state, questions, and next action. | Updates with approval if needed. |
| `/sos:toolkits-summary` | Summarize preferred/parked/allowed toolsets. | Read-only. |

## Update Behavior

No separate upgrade command is required for v0.1.

`/sos:init`, `/sos:summary`, and `/sos:audit` may detect remote template/version drift and suggest updates.
