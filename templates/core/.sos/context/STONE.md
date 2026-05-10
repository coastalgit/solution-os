---
sos-file: context-stone
sos-version: 0.2.0
sos-schema: 1
sos-origin: packaged
sos-managed: true
type: stone
scope: node
status: active
authority: highest
---

# STONE

STONE means carved-in-stone facts, constraints, decisions, and non-negotiables for this SOS node.

If another file conflicts with this one, pause and ask before proceeding.

## Carved-In-Stone Facts

- `.sos/context/ACTORS.md` is the only canonical actor registry.
- `.sos/context/TOOLS.md` is the only canonical adopted-tools registry.
- `vault/archive/` is the single place for non-active retained material.
- `/resources/` is the private input lane. Its raw bytes must not be copied into `vault/`.
- `sos install` and `sos upgrade` must preserve user content outside SOS-managed blocks.

## Non-Negotiable Constraints

- Do not let an older running SOS CLI/helper mutate a newer SOS node.
- Do not replace, merge, or repair user-modified files without an explicit approval path.
- Do not auto-initialize task systems such as Backlog.md.
- Do not switch task adapters without warning when an existing adapter is detected.

## Approved Direction

Add approved direction here.

## Explicitly Rejected Paths

Add rejected paths here.
