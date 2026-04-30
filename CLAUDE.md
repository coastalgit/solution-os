---
type: adapter
scope: node
status: active
tool: claude-code
---

# CLAUDE.md

This file is the Claude Code adapter for an SOS node.

## SOS Routing

This node uses SolutionOS (`sos`) project memory.

Read `.claude/PM.md` first for context routing. Do not preload every file.

Use:

- `.claude/PM.md` for context routing and maps
- `.claude/STONE.md` for carved-in-stone facts and non-negotiables
- `.claude/ACTORS.md` for people, systems, teams, services, and roles
- `.claude/TOOLS.md` for local tools/environment facts
- `.claude/WORKFLOW.md` for work lifecycle and human gates
- `vault/triage/` for raw KB material awaiting processing
- `vault/wiki/` for curated knowledge
- `vault/archive/` for processed source evidence
- `vault/outbox/` for generated deliverables and exports

## SOS System Directory

`.claude/sos/` contains SOS system material: metadata, templates, schemas, command vocabulary, toolset policy, and portable export/install files.

Do not read or follow `.claude/sos/**` during normal project work unless the user invokes an `/sos:*` task or explicitly asks to install, audit, summarize, export, import, update, or inspect SOS.

## Working Rules

- Inspect before editing.
- Keep context loading on demand.
- Separate facts, hypotheses, guesses, and open questions.
- Do not overwrite project files without approval.
- Do not commit, push, deploy, or publish unless explicitly asked.
- Preserve the current project structure unless an `/sos:*` audit/init task approves changes.
- Update vault/wiki or active `.claude` files only when the task requires durable context capture.

## Privacy / Visibility Rule

Avoid surfacing private personal labels or sensitive context in filenames, headings, casual chat, generated docs, or screen-share-visible outputs unless the user explicitly asks.
