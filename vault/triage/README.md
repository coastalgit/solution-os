---
type: vault-triage-readme
scope: node
status: active
---

# Triage

`vault/triage/` is the raw processing lane for this node's knowledge base.

Triage is not permanent storage. It is where raw, bulky, ambiguous, or not-yet-classified material waits until a human-gated `/sos:vault-process` pass decides what to do with it.

## Control Files

Do not process these as triage items:

- `README.md`
- `_manifest.md`

They describe and track the lane itself.

## What Belongs Here

Use triage for:

- pasted notes
- raw meeting notes
- rough ideas that need classification
- source captures
- unprocessed research
- failed or partial ingestion output
- files that may become wiki, archive, outbox, or work items

Do not use triage for clear durable notes. Put those directly in `vault/wiki/`.

## Processing Command

Use:

```text
/sos:vault-process
```

Default behaviour is proposal-first. The agent must not move, rewrite, archive, index, or create tasks until the user approves an item.

## Processing Protocol

1. List triage items, excluding control files.
2. Group obviously related files.
3. For each item/group, identify what it appears to be.
4. Propose one route.
5. Ask for `(Y)ES`, `(N)O`, `(D)ISCUSS`, or `(C)ANCEL`.
6. Apply only approved items.
7. Update the relevant manifests and indexes.
8. Leave rejected or deferred items untouched unless the user asks otherwise.

## Decision Key

| Choice | Meaning |
|---|---|
| `(Y)ES` | Apply the proposed route for this item. |
| `(N)O` | No action. Leave untouched. |
| `(D)ISCUSS` | Discuss this item before deciding. |
| `(C)ANCEL` | Cancel the whole process run. |

## Route Rules

| Route | Use When | Required Follow-Up |
|---|---|---|
| `wiki` | The item contains durable knowledge, decisions, methods, or reference material. | Create/update a concise `vault/wiki/` note with metadata and index reachability. |
| `archive` | The item is source evidence, a retained record, already processed, or worth preserving but not turning into active knowledge. | Follow `/sos:archive`: move/copy byte-for-byte, write archive metadata, and update `vault/archive/_manifest.md`. |
| `outbox` | The item is or should become a deliverable/export/report. | Place output in `vault/outbox/` and update `vault/outbox/_manifest.md`. |
| `task` | The item is actionable work. | Use the adopted task system only. If none is adopted, record in wiki/planning instead. |
| `leave` | The item is unclear, premature, or needs a user decision. | Keep it in triage and record status in `_manifest.md` if useful. |

## Wiki Output Rules

When creating or updating wiki notes:

- include YAML frontmatter
- use lowercase hyphenated filenames
- add a clear H1
- keep the note concise
- link from `vault/wiki/index.md` or the adopted primary index
- preserve source traceability to the original triage/archive path

## Normal Flow

```text
vault/triage
  -> /sos:vault-process proposal
  -> human decision
  -> vault/wiki, vault/archive, vault/outbox, or adopted task system
  -> manifest/index updates
```
