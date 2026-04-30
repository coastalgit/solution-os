---
type: toolkits
scope: system
status: active
---

# TOOLKITS

TOOLKITS means SOS-wide toolset preferences, tool categories, adoption rules, and parked/rejected tool guidance.

This is system policy, not local environment inventory.

Use `.claude/TOOLS.md` for local available tools, commands, services, and environment facts.

## Tool Layers

| Layer | Purpose | Examples |
|---|---|---|
| Solution spine | Durable context and memory | SOS/Workspacer files |
| Project memory | Local maps, current state, decisions | `.claude/*.md`, vault wiki |
| Work management | Tasks/specs/status | Backlog, GitHub Issues, Jira |
| Agent instructions | Tool adapters | CLAUDE.md, AGENTS.md, GEMINI.md |
| Tooling layer | AI workers | Claude Code, Codex, Cursor |
| Automation layer | Repeated/async workflows | hooks, GitHub Actions, n8n |

## Adoption Rule

No new tool becomes part of the node workflow unless:

1. It solves a repeated pain.
2. It can read, write, or reference SOS context safely.
3. It does not create a competing source of truth without explicit approval.
4. It can be removed without losing project memory.
5. It has a documented human gate.
6. The user approves adoption.

## Tool Experiment Protocol

Before adopting a new tool, record:

- problem it solves
- files/folders it creates
- source of truth implications
- failure modes
- removal path
- adopt/park/reject recommendation

## Current Defaults

These are placeholders for the installed node to fill or override:

| Tool Category | Default |
|---|---|
| AI coding harness | Claude Code primary, Codex compatible |
| Knowledge base | `vault/` |
| Work management | Project-specific |
| Automation | Manual first, hooks/actions later |

