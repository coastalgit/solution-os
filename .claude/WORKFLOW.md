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

## Assistant Front Door

Use `/sos:assistant` when the user is asking how to interact with SOS, does not know which command to use, or wants to work conversationally.

Assistant should ask what the user is trying to do, explain the next safe choice in plain English, and route to an existing SOS workflow. It must not become a separate process with separate rules.

If assistant continues into another workflow in-place, it must name that workflow and follow the workflow's human gates.

## Metadata Rule

New SOS-owned Markdown context and KB files must include YAML frontmatter.

Use `.claude/sos/SCHEMA.md` for the exact rule and minimum fields.

## Install And Version Safety

Before any install/update/repair action, compare the running SOS CLI/helper version with `.claude/sos/sos.json`.

- If the project version is newer than the running tool, stop before writing and ask the user to update the tool.
- If the project version is missing, unknown, or unreadable, stop before writing and run audit/status first.
- `sos install` may create missing files only. It must not overwrite existing files.
- Replacement or repair needs a separate explicit approval path.

## Actor And Concept Capture

When a person, team, organisation, system, service, project, role, or named concept is mentioned and appears operationally relevant, check `.claude/ACTORS.md` and existing concept-binding notes before continuing.

If the actor or concept is not registered, propose one of these before using it as durable context:

- add an active actor row to `.claude/ACTORS.md`
- add or update a `type: concept-binding` note in `vault/wiki/`
- leave it as source evidence only

Passing mentions, survey respondents, archived authors, transcript voices, and source-only references stay in vault/source material unless they become actively involved.

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
- Non-active retained material goes to `vault/archive/`.
- Generated deliverables go to `vault/outbox/`.
- Vault content may mention actors as source evidence, but `.claude/ACTORS.md` is the only actor registry.
- Do not create vault-level people/team/roster/stakeholder registry files.

## Archive And Unarchive

Use `/sos:archive <path-or-description> [context]` when material should be retained but should not remain active working context.

Use `/sos:unarchive <archive-path-or-description> [context]` when archived material was filed in error or becomes relevant again.

Archive candidates can include source evidence and retained records such as email trails, meeting notes, old docs/temp folders, and dated correspondence. They all live directly under `vault/archive/` and are distinguished by manifest metadata, not by a separate history folder.

If the agent is unsure what the material is, why it matters, whether it should be copied or moved, or where it should return during unarchive, it must start Q&A before touching files.

Archive/unarchive choices use `(Y)ES`, `(N)O`, `(D)ISCUSS`, and `(C)ANCEL`. `(C)ANCEL` stops the process and leaves files unchanged.

Archive is preservation first, interpretation second. Binary, encrypted, compressed, hash-mapped, generated, and vendor files must be copied or moved byte-for-byte. Do not decode, decrypt, normalize, re-save, pretty-print, or otherwise rewrite them.

Archive and unarchive must update archive metadata and `vault/archive/_manifest.md` in the same change as the file operation.

## Session Close

At the end of substantial work:

- update current state or PM notes
- update wiki where durable knowledge changed
- archive processed source material where relevant
- list open questions and next action
