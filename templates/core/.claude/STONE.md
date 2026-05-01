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

Add confirmed facts here.

- `vault/archive/` is the single place for non-active retained material, including processed source evidence and retained records.
- `.claude/ACTORS.md` is the only canonical actor registry. Vault material may reference actors as evidence, but must not maintain parallel people, team, stakeholder, roster, or actor registries.
- `sos install` is a missing-file installer only. It must never overwrite existing project files.

## Non-Negotiable Constraints

Add constraints here.

- Do not create actor registry files in `vault/`, including `people.md`, `team.md`, `teams.md`, `roster.md`, `actors.md`, `stakeholders.md`, or similar roster files.
- Do not promote passing mentions, survey respondents, archived authors, or transcript voices into `.claude/ACTORS.md` unless they become actively involved in the node.
- Do not rewrite binary, encrypted, compressed, hash-mapped, generated, or vendor files during archive/unarchive. Preserve bytes and update archive metadata plus manifest.
- Do not let an older running SOS CLI/helper mutate a newer project SOS node.
- Do not treat install as repair. Replacement, merge, or repair actions need a separate explicit approval path.

## Approved Direction

Add approved direction here.

## Explicitly Rejected Paths

Add rejected paths here.

## Revisit Only If User Says So

Add items that should not be re-opened casually.
