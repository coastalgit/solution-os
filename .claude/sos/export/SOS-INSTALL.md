---
type: sos-install
scope: portable
status: active
sos_name: SolutionOS
sos_version: 0.1.3
---

# SOS-INSTALL

SOS means **SolutionOS**.

SolutionOS is a portable, AI-readable workspace operating layer. It helps agents and humans initialize, summarize, audit, maintain, export, and upgrade durable context for software projects, workshops, research, and other bounded work.

This file is a portable installer/bootstrap instruction file.

Use it when a project does not already have SOS and you want an AI agent to propose a safe SOS initialization plan.

## Important Safety Rules

- Do not edit anything until the user approves the install plan.
- Do not overwrite existing `CLAUDE.md`, `AGENTS.md`, `.claude/`, or `vault/` content without showing the diff/merge plan.
- Do not delete or move existing project files.
- If a legacy inbox-named KB capture folder exists, propose migration to `vault/triage/` but do not perform it without approval.
- If old Workspacer, KB, spine, command, skill, or session-memory material exists, run migration assessment before proposing file moves.
- Keep the install minimal.
- Preserve existing project instructions and route them into SOS rather than replacing them blindly.

## Preferred Install Source

If remote access is available, fetch the latest SOS template from the configured SolutionOS repository:

```text
https://github.com/coastalgit/solution-os.git
```

If a full SolutionOS repo is available locally, preview installation first:

```powershell
.\scripts\sos-init.ps1 -TargetPath <node-root> -NodeKind project
```

Apply only after review:

```powershell
.\scripts\sos-init.ps1 -TargetPath <node-root> -NodeKind project -Apply
```

For an existing project with older memory or KB structures, assess migration first:

```powershell
.\scripts\sos-migrate-assess.ps1 -TargetPath <node-root>
```

If no repository URL is configured, ask the user for the official template source or use the fallback minimal layout below.

## Detection Steps

Before proposing changes, inspect:

1. Does `.claude/PM.md` exist?
2. Does `.claude/sos/sos.json` exist?
3. Does `vault/` exist?
4. Does `vault/triage/` exist, or is there a legacy inbox-named KB capture folder to migrate?
5. Do `CLAUDE.md` and `AGENTS.md` exist?
6. Are there existing tool-specific instruction files such as `GEMINI.md`, Cursor rules, or old Workspacer files?
7. Is this a git repo?
8. Does this folder appear to be a solution, project, module, workshop, research effort, or unknown node?

## Minimal SOS Layout

If approved, create or merge toward:

```text
node-root/
  CLAUDE.md
  AGENTS.md
  vault/
    triage/
      _manifest.md
    wiki/
      _manifest.md
    archive/
      _manifest.md
    outbox/
      _manifest.md
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

## Required Install Output

Before changing files, output:

```text
SOS detection summary
Existing files that must be preserved
Proposed node kind
Proposed parent relationship
Proposed files to create
Proposed files to merge/update
Risks
Questions for user
Approval request
```

## Node Metadata Questions

Ask or infer cautiously:

- node name
- node kind: solution, project, module, workshop, research, learning, other
- parent relationship
- whether this node may read upward
- whether this node may publish upward
- visibility: private, shared, public, summary-only

## After Install

After approved installation:

1. Create/update the SOS files.
2. Summarize what changed.
3. Run a basic SOS summary.
4. Record open questions in `.claude/PM.md` or `vault/wiki/index.md`.
