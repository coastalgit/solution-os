---
name: sos:vault-process
description: Process vault triage items through human-gated decisions.
disable-model-invocation: true
---

Run `/sos:vault-process` for this node.

Read `.claude/sos/COMMANDS.md`, `.claude/sos/SCHEMA.md`, `vault/triage/README.md`, and `vault/triage/_manifest.md`. Present `(Y)ES`, `(N)O`, `(D)ISCUSS`, or `(C)ANCEL` decisions before writing, moving, archiving, or updating manifests. If the approved route is archive, follow the `/sos:archive` preservation and metadata rules.
