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
- `vault/archive/` is the single place for non-active retained material, including processed source evidence and retained records.
- Active node memory lives in `.claude/*.md`.
- SOS system material lives in `.claude/sos/`.
- `.claude/ACTORS.md` is the only canonical actor registry. Vault material may reference actors as evidence, but must not maintain parallel people, team, stakeholder, roster, or actor registries.
- `sos install` is a proposal-first missing-file installer only. It must never overwrite existing project files.
- `.claude/TOOLS.md` is the only canonical adopted-tools registry for an SOS node. The agent must consult it before naming any tool, library, CLI, service, package, or skill in a proposal, plan, or route.
- `/resources/` at the project root is the private input lane. It is Git-ignored. Its contents may inform agent ingestion but must never be copied into `vault/` as raw bytes — only user-approved summaries derived from it may reach `vault/wiki/`.
- `.claude/sos/produce/<type>/` is the canonical location for output-type configuration (house style, output styles, manifest templates). Generated artifacts for each type land in `vault/outbox/<type>/<slug>/`. Both directories grow as new output types are added (presentation, marketing, financial, etc.).

## Non-Negotiable Constraints

- Do not put portable builder/install files loose in `.claude/`.
- Do not use the old inbox-named KB capture folder in new SOS templates; use `vault/triage`.
- Do not create ambiguous active/system files inside `.claude`.
- Do not create actor registry files in `vault/`, including `people.md`, `team.md`, `teams.md`, `roster.md`, `actors.md`, `stakeholders.md`, or similar roster files.
- Do not promote passing mentions, survey respondents, archived authors, or transcript voices into `.claude/ACTORS.md` unless they become actively involved in the node.
- Do not rewrite binary, encrypted, compressed, hash-mapped, generated, or vendor files during archive/unarchive. Preserve bytes and update archive metadata plus manifest.
- Do not let an older running SOS CLI/helper mutate a newer project SOS node.
- Do not treat install as repair. Replacement, merge, or repair actions need a separate explicit approval path.
- Do not rely on a single derived summary for important context transfer.
- Avoid sensitive personal labels in filenames, headings, casual chat, or screen-share-visible generated outputs unless explicitly requested.
- Do not name a specific tool, library, CLI, package, service, or skill in any proposal, plan, route, or recommendation unless one of these is true: (a) it is registered in `.claude/TOOLS.md` with a verified capability statement covering this use, OR (b) the agent has, in this session, read the tool's docs/help/source and confirmed it does what the use requires, then proposed a registry entry. Otherwise, describe what is needed in capability terms ("a tool that fetches timed YouTube transcripts") and ask the user to nominate or confirm a tool. Naming a tool tentatively or with a disclaimer does not satisfy this rule.
- Do not treat a recommendation from a donor source (skill, package readme, third-party doc, search result) as adoption. Donor recommendations are starting candidates only and must follow the verify-and-register path before the agent uses them in a proposal.
- Do not promote a `status: parked` entry in `.claude/TOOLS.md` to "primary", "preferred", "the reference", or any equivalent role in a proposal, plan, or route. Parked entries are user-flagged or agent-surfaced for future investigation only. They may be mentioned to the user as candidates worth re-evaluating when their trigger condition appears, but promotion from `parked` to `vetted` requires the verify-and-register path.
- Do not copy raw bytes from `/resources/` into `vault/triage/`, `vault/wiki/`, `vault/archive/`, or `vault/outbox/`. Only user-approved summaries derived from `/resources/` material may be written into `vault/wiki/`. Before any wiki write that summarises private-source material, the agent must surface that the source is private so the user can verify the summary does not leak specifics.
- Do not claim or auto-move root-level context files (`README.md`, `PRD.md`, `CONTEXT.md`, `BRIEF.md`, `REQUIREMENTS.md`, `SPEC.md`, etc.) during install. `sos install` may detect and surface them as a hint only. Routing happens via explicit `/sos:ingest` invocation by the user.
- Do not overwrite an existing project `.gitignore`. The `sos install` flow may append a clearly-labelled SOS section (currently just `/resources/`) to an existing `.gitignore` if missing, after explicit approval. It must never reorder, modify, or delete existing entries.

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
