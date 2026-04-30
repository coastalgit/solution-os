---
type: stone
scope: node
status: active
authority: highest
---

# STONE

STONE means **carved in stone**.

This file contains high-authority facts, constraints, decisions, and non-negotiables for this SOS node.

Agents must treat this file as stronger than normal notes, investigations, summaries, hypotheses, guesses, or generated outputs.

Do not reinterpret, revisit, rename, soften, or ignore anything in this file unless the user explicitly asks.

If another file conflicts with `STONE.md`, pause and ask before proceeding.

## Carved-In-Stone Facts

- SolutionOS is the project identity.
- The canonical remote repository is `https://github.com/coastalgit/solution-os.git`.
- `sos` is the command namespace.
- Workspacer is treated as the earlier installer/overseer concept, not as a competing product.
- Every SOS node has a `vault/` KB with `triage`, `wiki`, `archive`, and `outbox`.
- Active node memory lives in `.claude/*.md`.
- SOS system material lives in `.claude/sos/`.

## Non-Negotiable Constraints

- Do not put portable builder/install files loose in `.claude/`.
- Do not use the old inbox-named KB capture folder in new SOS templates; use `vault/triage`.
- Do not create ambiguous active/system files inside `.claude`.
- Do not rely on a single derived summary for important context transfer.
- Avoid sensitive personal labels in filenames, headings, casual chat, or screen-share-visible generated outputs unless explicitly requested.

## Approved Direction

- v0.1 is file-first and template-first.
- `sos:summary` is read-mostly.
- `sos:audit` is deeper and may apply approved repairs.
- `sos:init`, `sos:summary`, and `sos:audit` may detect update opportunities before a dedicated upgrade command exists.

## Explicitly Rejected Paths

- A separate spine directory or command namespace in v0.1.
- Placing project folders inside the root `.claude` as a mirror of the solution tree.
- Making `SOS-BUILDER.md` the install file.
- Requiring GitHub/cloud access for basic bootstrap.

## Revisit Only If User Says So

- The vault exists in every SOS node.
- `STONE` means carved in stone and should retain that concept.
