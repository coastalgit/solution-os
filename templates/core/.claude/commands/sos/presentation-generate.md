---
name: sos:presentation-generate
description: Generate presentation outputs (slides, audio, video, report, infographic, quiz, etc.) from this node's vault material via the global nlm-presentation skill.
disable-model-invocation: true
---

Run `/sos:presentation-generate [natural-language args]` for this node.

This command is a thin SOS wrapper around the global `nlm-presentation` skill, which drives Google NotebookLM via the `notebooklm-py` CLI.

## Tool registry check (mandatory)

Before naming `nlm-presentation`, `notebooklm-py`, or any other tool in your proposal, consult `.claude/TOOLS.md` per the Tool-Naming Discipline rule (see `.claude/STONE.md` and `.claude/WORKFLOW.md`). Both `nlm-presentation` and `notebooklm-py` should be registered with `status: vetted`. If they are not, propose registry entries before proceeding, or describe the need in capability terms and ask the user to nominate.

## Inputs

1. Read `.claude/sos/produce/presentation/house-style.md` for default audience, tone, brand, visual preferences, and source rules.
2. Read `.claude/sos/produce/presentation/output-styles.md` for the menu of output types and their styling knobs.
3. Read `.claude/sos/produce/presentation/manifest-template.md` for the per-job contract format.

## Small confirmatory Q&A

Parse the user's natural-language args (e.g. *"slides for the board on the migration project"*). Then run a small confirmatory pass — three to five questions maximum, only for fields the args did not cover:

- **Output type(s)?** (slide deck, infographic, audio, video, report, quiz, flashcards, mind map, data table — multi-select OK)
- **Audience and tone?** (default from house style if set)
- **Sources?** (default to `vault/wiki/`, `vault/archive/`; user may add or restrict)
- **Slug for this job?** (used as the folder name under `vault/outbox/presentations/`)
- **Anything to emphasise, exclude, or frame differently?** (custom instructions)

Then summarise the planned job in five lines and ask `(Y)ES / (N)O / (D)ISCUSS / (C)ANCEL`.

## Build

On `(Y)ES`:

1. Create `vault/outbox/presentations/<slug>/` if missing.
2. Copy `manifest-template.md` to `vault/outbox/presentations/<slug>/nlm-manifest.md` and fill in the answers from the Q&A.
3. Hand off to the global `nlm-presentation` skill, which runs the full per-output Q&A (slide length, infographic detail, etc.), executes `notebooklm` commands, and downloads results into `vault/outbox/presentations/<slug>/`.
4. Update the manifest's `Status` section as generation progresses.

On `(D)ISCUSS`: enter free-form Q&A about the job before re-summarising.

On `(N)O` or `(C)ANCEL`: stop. No files are written.

## Prerequisites

- `notebooklm-py[browser]` installed: `pip install "notebooklm-py[browser]"`
- Playwright Chromium: `playwright install chromium`
- One-time auth: `notebooklm login`
- Verify: `notebooklm auth check --test`

If any prerequisite is missing, walk the user through setup before generation.

## Sources from `/resources/`

If the user wants to include private material from `/resources/`, surface that explicitly: the source bytes do not enter the vault, and any generated output that quotes specifics from `/resources/` should be reviewed before publication. See `.claude/commands/sos/ingest.md` for the private-source mode rules.

## Sibling commands (future)

The `/sos:presentation-*` namespace can grow as needed:

- `/sos:presentation-list` — list existing presentation jobs in `vault/outbox/presentations/`
- `/sos:presentation-regenerate <slug>` — rebuild from an existing manifest, optionally with edits
- `/sos:presentation-style` — interactive editor for `house-style.md`

These are not part of the current build; add only when there is a real repeated need.
