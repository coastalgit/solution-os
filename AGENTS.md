# AGENTS.md

This file is the Codex adapter for an SOS node.

## SOS Routing

This node uses SolutionOS (`sos`) project memory.

Read `.claude/PM.md` first for context routing. Treat `.claude/*.md` as active node memory and policy.

Do not load `.claude/sos/**` unless the task is explicitly about `/sos:*`, installation, audit, summary, export, import, update, schemas, templates, or toolsets.

## Knowledge Lifecycle

The node knowledge base lives in `vault/`:

- `vault/triage/` - raw material awaiting processing
- `vault/wiki/` - curated knowledge
- `vault/archive/` - processed source evidence
- `vault/outbox/` - generated deliverables and exports

## Working Rules

- Inspect before editing.
- Ask before structural changes.
- Keep changes small and scoped.
- Separate facts, hypotheses, guesses, and questions.
- Follow `.claude/STONE.md` as highest-authority project context.
- Follow `.claude/WORKFLOW.md` for lifecycle and human gates.
- Do not use SOS system files as ordinary project context.

