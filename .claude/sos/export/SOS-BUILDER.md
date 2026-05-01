---
type: sos-builder
scope: portable
status: active
sos_name: SolutionOS
sos_version: 0.1.9
---

# SOS-BUILDER

SOS means **SolutionOS**.

SolutionOS is a portable, AI-readable workspace operating layer. It keeps project context durable, structured, source-backed, and reusable across tools and agents.

This file is a portable export builder.

Use it when a non-SOS project, chat, folder, or external context needs to produce an SOS-compatible context export.

It is not the SOS installer. For installation, use `SOS-INSTALL.md`.

## Core Rule

Do not create only a polished summary.

Create a source-backed export package that preserves the important source statements, derived requirements, decisions, open questions, and traceability.

## Export Use Cases

- Move context from a long chat into an SOS project.
- Export legacy project facts into a new SOS spine.
- Package research for another agent.
- Transfer project state to another workspace.
- Prepare input for a future `sos:context-import`.

## Required Export Folder

Create:

```text
sos-export/
  manifest.md
  source-ledger.md
  requirements.md
  decisions.md
  open-questions.md
  current-state.md
  traceability.md
  files-inspected.md
```

Use a dated folder if multiple exports may exist:

```text
sos-export/2026-04-29-context/
```

## Export File Purposes

| File | Purpose |
|---|---|
| `manifest.md` | What this export is, source scope, date, intended destination. |
| `source-ledger.md` | Actual source statements, observations, or evidence. |
| `requirements.md` | Requirements extracted from source ledger. |
| `decisions.md` | Confirmed decisions only. |
| `open-questions.md` | Unresolved questions and ambiguities. |
| `current-state.md` | Where things stand now. |
| `traceability.md` | Source -> requirement -> decision/output mapping. |
| `files-inspected.md` | Local files inspected, if any. |

## Source Ledger Rules

- Preserve important corrections and objections.
- Record source items with stable IDs.
- Do not convert everything into vague prose.
- Separate source statements from your interpretation.
- If something is inferred, label it as inference.

## Required Export Output

After creating the export, report:

```text
Export path
Source scope
Number of source items
Number of requirements
Number of decisions
Open questions
Known omissions
Suggested import target
```

## Safety Rules

- Do not modify the source project unless explicitly approved.
- Do not create or overwrite an SOS installation unless the user asks.
- Do not include secrets, private credentials, or unnecessary personal details.
- Avoid sensitive personal labels in filenames, headings, or generated outputs unless explicitly requested.
