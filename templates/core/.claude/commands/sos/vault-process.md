---
name: sos:vault-process
description: Process vault triage items through human-gated decisions.
disable-model-invocation: true
---

Run `/sos:vault-process` for this node.

Read `.claude/sos/COMMANDS.md`, `.claude/sos/SCHEMA.md`, `vault/triage/README.md`, and `vault/triage/_manifest.md`.

Before drafting any route or proposal that involves a tool, library, CLI, package, service, or skill, consult `.claude/TOOLS.md` and follow the Tool-Naming Lookup rule in `.claude/WORKFLOW.md`. Do not name a tool in a route unless it is registered with `status: vetted` and a capability statement covering the use. Otherwise verify in-session and propose a registry entry, or propose in capability terms and ask the user to nominate.

Donor-source recommendations (skill files, package readmes, third-party docs) are candidates, not adoption. Surface the source and route them through verify-and-register before they appear in a proposal.

Present `(Y)ES`, `(N)O`, `(D)ISCUSS`, or `(C)ANCEL` decisions before writing, moving, archiving, or updating manifests. If the approved route is archive, follow the `/sos:archive` preservation and metadata rules.
