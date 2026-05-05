---
name: sos:ingest
description: Ingest an external source into the vault using the user's natural-language intent.
disable-model-invocation: true
---

Run `/sos:ingest <source> <intent>` for this node.

Use one command only. Identify the source type, infer the intended use, and route the result to wiki, triage, archive, outbox, or a relevant existing note.

## Tool-naming discipline

Before naming or invoking any fetch/extraction/transcription/scraping tool, library, CLI, package, service, or skill, consult `.claude/TOOLS.md` and follow the Tool-Naming Lookup rule in `.claude/WORKFLOW.md`. Do not name a tool unless it is registered with `status: vetted` and a capability statement covering the use. Otherwise verify in-session and propose a registry entry, or describe the need in capability terms ("a tool that fetches timed YouTube transcripts") and ask the user to nominate.

Donor-source recommendations (skill files, package readmes, third-party docs) are candidates, not adoption. Surface the source and route them through verify-and-register before they appear in a proposal.

## Routing rules by source location

The source path determines the default routing behaviour. The user can override any default with explicit instruction.

### Root-level context files

When the source is a recognised root-level context file — `README.md`, `PRD.md`, `CONTEXT.md`, `BRIEF.md`, `REQUIREMENTS.md`, `SPEC.md`, or similar — apply the following defaults:

- **`README.md`**: stays at root, untouched. It is the project's public surface; moving it would break tooling and contributor expectations. The wiki may receive a curated note referencing the README, but the file itself is not relocated.
- **Other internal-context files (`PRD.md`, `BRIEF.md`, `SPEC.md`, etc.)**: copy the source into `vault/archive/<YYYY-MM-DD>-<name>.md` as `source-evidence` (with archive metadata sidecar and `vault/archive/_manifest.md` row). Create or update a curated wiki note in `vault/wiki/` summarising the content and pointing back at the archive entry. Ask the user whether to remove the original from root once the archive copy is verified — never auto-remove.

### Versioning over time

When a new version of an internal-context file arrives at root (`PRD.md` v2, etc.), archive the new version as a new dated entry alongside the existing one (do not overwrite or remove old archive entries). Update the wiki note's narrative to describe what changed. The archive trail and the wiki note together tell the version story.

### `/resources/` private-source mode

When the source path begins with `/resources/` or `resources/`, switch into **private-source mode**:

- Read the material to understand it.
- Do **not** copy raw bytes into `vault/triage/`, `vault/wiki/`, `vault/archive/`, or `vault/outbox/`.
- Produce a summary that captures the intent without leaking specifics that should remain private. Surface to the user that this is private-source material and explicitly ask them to verify the summary before any wiki write.
- Use `(Y)ES / (N)O / (D)ISCUSS / (C)ANCEL` per-item gates. Default to discuss if the material contains anything that looks like financials, PII, customer data, or copyrighted material.
- The wiki note that lands in `vault/wiki/` should reference `/resources/<file>` as the source so future readers know the original is local-only and not in Git.

### Triage / triage-folder sources

Sources already in `vault/triage/` follow the standard `/sos:vault-process` route (Y/N/D/C decisions, route to wiki / archive / outbox / leave / task).

### Other external sources

URLs, repository paths, pasted content, etc. — identify the source type, choose available extraction tools (subject to the tool-naming discipline above), and route the result. If extraction fails, intent is unclear, or no registered tool covers the required capability, explain the issue and recommend fallback options before writing.
