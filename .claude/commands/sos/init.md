---
name: sos:init
description: Install missing SOS files in this node, then offer to ingest any context files at the project root.
disable-model-invocation: true
---

Run `/sos:init` for this node. Keep all output concise. No multi-tier "repair opportunity" proposals. No "verify canonical content" theatre. No append-only-upgrade essays. Audience-readable.

## What this command does — four steps, brief at each

1. **Set up missing baseline files.** Compare this node against `.claude/sos/SCHEMA.md`. List the missing files in a short bullet list (path only, no commentary). Ask once: `(Y)ES / (N)O — create N missing files?` On `(Y)`, create them from the SOS template (the running CLI bundles `templates/core/`). On `(N)`, stop.
2. **Ensure the `/resources/` lane.** If `resources/README.md` is missing, create it with the standard "Git-ignored private input lane" content. If `.gitignore` is absent, create one with `/resources/`. If `.gitignore` exists and lacks `/resources/`, append the entry. One Y/N total for this whole step.
3. **Scan the project root** for `README.md`, `PRD.md`, `CONTEXT.md`, `BRIEF.md`, `REQUIREMENTS.md`, `SPEC.md`. For each one present, ask **one line per file**:
   - `Found PRD.md. Ingest as product requirements? (Y / N / type a custom intent)`
   - On `(Y)` or a custom intent: invoke `/sos:ingest <file> as <intent>` immediately, then move to the next file.
   - On `(N)`: skip silently.
4. **End** with a three-line summary: files created, files ingested, anything left.

## Constraints — non-negotiable

- **Existing files are never overwritten.** Skipped silently. Do not narrate this.
- **If the project SOS version is newer than the running tool**, stop with one line: *"project at vX, CLI at vY — update CLI first."* Do not propose anything further.
- **If a template file cannot be read locally**, do not ask the user to paste content. Skip that single file with a one-line note and continue. Two-line files like `.gitignore` can be created with sensible defaults inline.
- **Do not enumerate drift in existing files** beyond the missing-file list. Drift inspection is `/sos:audit`'s job, and even there it is read-only state, not multi-tier proposals.
- **Do not invoke the tool-naming-discipline rule for SOS-baseline file creates.** That rule applies to user-facing tool/library/CLI/skill references in proposals, not to SOS's own bundled templates.
- **No "Tier A" / "Tier B" structure. No `B1 / B2 / B1+B2` choice menus.** This command writes or skips. It does not deliberate.

## Goal of the command

A user with a fresh project should run `/sos:init`, answer two or three quick prompts, and have an SOS-shaped node within thirty seconds. The audience for a workshop demo should see clean, brief output — not pages of agent commentary.
