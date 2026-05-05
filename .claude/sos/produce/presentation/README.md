---
type: produce-config
scope: system
status: active
---

# Produce: Presentation

This directory holds the configuration for **presentation-style outputs** generated from this SOS node — slide decks, infographics, audio overviews, video summaries, reports, quizzes, flashcards, mind maps, and data tables.

Generation is driven by the global `nlm-presentation` skill (which wraps Google NotebookLM via the `notebooklm-py` CLI). The `/sos:presentation-generate` command in this node loads the files here as defaults and routes outputs into `vault/outbox/presentations/<slug>/`.

## Files in this directory

| File | Purpose |
|---|---|
| `house-style.md` | Defaults for audience, tone, brand, visual preferences. The agent loads these into the Q&A as starting points. Edit to encode the node's house style. |
| `output-styles.md` | Reference menu of the output types and their styling knobs (length, format, orientation, detail, etc.). The agent reads this to know what knobs are available. |
| `manifest-template.md` | Blank manifest template. Per generation job, a copy is filled in and saved to `vault/outbox/presentations/<slug>/nlm-manifest.md`. The manifest is the contract for that specific build. |

## Pattern for other output types

Future output types (marketing summaries, financial briefs, manual extracts) will follow the same shape:

```text
.claude/sos/produce/<type>/
├── house-style.md
├── output-styles.md
├── manifest-template.md
└── README.md
```

with corresponding artifacts in `vault/outbox/<type>/<slug>/` and a sibling command at `.claude/commands/sos/<type>-<verb>.md`.

## Tool registry requirement

Per the tool-naming discipline rule (see `.claude/STONE.md` and `.claude/WORKFLOW.md`), the agent must consult `.claude/TOOLS.md` before naming `nlm-presentation` or `notebooklm-py` in any proposal. Both should be registered with `status: vetted` and capability statements before `/sos:presentation-generate` is used.
