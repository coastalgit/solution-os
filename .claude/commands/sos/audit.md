---
name: sos:audit
description: Audit SOS drift, required files, metadata, actor/concept integrity, archive integrity, and repair opportunities.
disable-model-invocation: true
---

Run `/sos:audit` for this node.

Read `.claude/sos/COMMANDS.md` and `.claude/sos/SCHEMA.md`. Inspect required files, folders, metadata, stale adapters, actor/concept integrity, archive manifest/index integrity, loose archive candidates, and repair opportunities. Report first; apply only approved changes.

Separate missing-file install proposals, append-only upgrade proposals, and true repair proposals. Do not describe an older SOS node as needing a "refresh" that adopts or removes files as one coherent change. If existing files need newer SOS content, propose exact append-only amendments with no deletion or information loss, or state that no safe upgrade action is available.
