---
type: architecture
scope: system
status: active
---

# Architecture

## Definition

SolutionOS (`sos`) is an operating layer for AI-operable workspaces.

It is not a single agent, dashboard, or PM tool. It is a convention plus templates that make a project understandable, resumable, auditable, and exportable across AI tools.

## Responsibilities

SOS owns:

- node layout
- vault lifecycle
- control-plane file meanings
- command vocabulary
- template/update metadata
- context export/import contracts
- toolset policy
- audit/summary expectations

SOS delegates:

- coding to Claude Code, Codex, Cursor, or other agents
- work management to Backlog, GitHub Issues, Jira, or another configured tool
- business workflow automation to n8n/GitHub Actions/hooks/etc.
- source synthesis to tools such as NotebookLM where configured

## Node Model

Every bounded endeavour is a node.

Node kinds include:

- solution
- project
- module
- workshop
- research
- trip
- learning
- other

Node kind is metadata, not a separate command family.

## Installed Node Shape

```text
node-root/
  CLAUDE.md
  AGENTS.md
  vault/
    triage/
    wiki/
    archive/
    outbox/
  .claude/
    PM.md
    STONE.md
    ACTORS.md
    TOOLS.md
    WORKFLOW.md
    sos/
      sos.json
      README.md
      TOOLKITS.md
      COMMANDS.md
      SCHEMA.md
      template/
      export/
        SOS-BUILDER.md
        SOS-INSTALL.md
```

## Separation Of Concerns

```text
CLAUDE.md / AGENTS.md
  adapter files that route tool-specific agents into SOS

.claude/*.md
  active project/node context and policies

.claude/sos/
  SOS system material, templates, schemas, export files, metadata

vault/
  node knowledge base lifecycle
```

## Parent / Child Relationships

A node can know it is part of a parent solution without reading upward by default.

Policies:

- `read_upward`: whether this node may load parent context
- `publish_upward`: whether this node may publish summary to parent
- `visibility`: private, shared, public, summary-only, etc.

This supports standalone projects, nested projects, and separate git repos.

## Command Philosophy

All SOS tasks use `/sos:*`.

Commands are concept-down for autocomplete and visual grouping:

```text
sos:vault-process
sos:vault-summary
sos:context-export
sos:context-import
sos:toolkits-summary
```

Keep v0.1 command set small.

## Automation Roadmap

Phase 1:

- file templates
- agent-readable install/export instructions
- preview-first local init helper
- read-only local summary helper
- manual use

Phase 2:

- `sos:summary`
- `sos:audit`
- safe patch plans
- update checks against manifest

Phase 3:

- CLI/plugin/slash-command implementation
- profile packs
- source-backed exports

Phase 4:

- async agentic work automation
- human gates
- notifications
- worktrees/branches
- documentation/output pipelines
