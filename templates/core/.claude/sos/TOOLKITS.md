---
type: toolkits
scope: system
status: active
---

# TOOLKITS

TOOLKITS means SOS-wide toolset preferences, tool categories, adoption rules, and parked/rejected tool guidance.

This is system policy, not local environment inventory.

Use `.claude/TOOLS.md` for local available tools, commands, services, and environment facts.

## What SOS Records About Tools

SOS does not make tools the source of truth. Tools are capabilities that may read, write, or act on the solution/project spine and vault.

Record tools by practical use:

| Area | Meaning | Examples |
|---|---|---|
| AI harnesses | Tools that operate on the folder. | Claude Code, Codex, Cursor |
| Knowledge ingestion | Tools that fetch, clip, scrape, extract, or transcribe sources. | Firecrawl, browser clipper, Medium script, PDF/OCR tools |
| Knowledge view | Tools that display or navigate the vault. | Obsidian |
| Task/planning adapters | Optional systems for tasks, issues, tickets, or delivery tracking. | Backlog.md, GitHub Issues, Jira, Linear |
| Source control/release | Tools for checkpoints, branches, PRs, CI, and deployment. | Git, GitHub, GitHub Actions |
| Automation | Tools that repeat flows or connect systems. | hooks, scheduled jobs, n8n, scripts, APIs |

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

These are placeholders for the installed solution/project to fill or override:

| Tool Category | Default |
|---|---|
| AI coding harness | Claude Code primary, Codex compatible |
| Knowledge base | `vault/` |
| Work management | Project-specific |
| Automation | Manual first, hooks/actions later |
