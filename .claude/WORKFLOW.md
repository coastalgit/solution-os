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
- `sos install` may create missing files only after approval. It must not overwrite existing files.
- Replacement or repair needs a separate explicit approval path.

## Actor And Concept Capture

When a person, team, organisation, system, service, project, role, or named concept is mentioned and appears operationally relevant, check `.claude/ACTORS.md` and existing concept-binding notes before continuing.

If the actor or concept is not registered, propose one of these before using it as durable context:

- add an active actor row to `.claude/ACTORS.md`
- add or update a `type: concept-binding` note in `vault/wiki/`
- leave it as source evidence only

Passing mentions, survey respondents, archived authors, transcript voices, and source-only references stay in vault/source material unless they become actively involved.

## Tool-Naming Lookup

Before drafting any proposal, plan, or route that involves a tool, library, CLI, package, service, or skill:

- consult `.claude/TOOLS.md` first
- if the tool is registered with a verified capability statement covering the use, name it
- if the tool is missing, has `status: unverified`, has `status: parked`, has no capability statement covering the use, or is `status: rejected` or `status: deprecated`, do not name it as adopted in a proposal
- in that case, either (a) verify in-session by reading docs/help/source and propose a `TOOLS.md` entry, or (b) propose in capability terms ("a tool that does X") and ask the user to nominate

This rule fires at the moment of drafting, not after the user pushes back.

A recommendation from a donor source (skill, package readme, third-party doc, search result) is a candidate, not adoption. Surface it to the user with its source, mark it unverified, and follow the verify-and-register path before using it in a proposal.

A `status: parked` entry is user-flagged or agent-surfaced for future investigation only. It may be mentioned to the user as a candidate worth re-evaluating when its trigger condition appears, but it must not be named in a proposal as if it were adopted, primary, or preferred. Promotion from `parked` to `vetted` requires the verify-and-register path.

If `.claude/TOOLS.md` is missing or empty, treat every tool as unverified and follow the same path.

## Human Gates

Ask before:

- structural changes
- risky file edits
- tool adoption
- naming any tool not in `.claude/TOOLS.md`
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
