---
type: sos-install
scope: portable
status: active
sos_name: SolutionOS
sos_version: 0.1.13
---

# SOS Install Reference

SOS means **SolutionOS**.

SolutionOS is a portable, AI-readable workspace operating layer. It helps agents and humans initialize, summarize, audit, maintain, export, and upgrade durable context for software projects, workshops, research, and other bounded work.

This file is installed inside SOS nodes as a reference. It is not the primary product entry point.

## Primary Install Model

Install the `sos` tool once, then run it from the project that should receive SOS:

```text
sos install
sos audit
```

That is the normal path. The source repository's root `.claude/` and `vault/` are the SolutionOS project's own working memory. They are not copied into target projects.

## What `sos install` Does

`sos install` applies the baseline from `templates/core/` into the current project.

It creates the standard SOS surface:

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
```

Existing files are skipped by default. Use force only when the user has explicitly accepted replacement of existing SOS files.

## Safety Rules

- Preserve existing project instructions.
- Do not delete or move existing project files during install.
- Do not replace existing `CLAUDE.md`, `AGENTS.md`, `.claude/`, or `vault/` files unless the user explicitly requests replacement.
- If older Workspacer, knowledge-base, command, skill, or session-memory material exists, run `sos migrate` first and review the assessment.
- Route project-specific guidance into `.claude/PM.md` instead of burying it in installer notes.

## Existing Project Flow

For an existing project:

1. Run `sos status`.
2. Run `sos migrate` if old knowledge or memory folders exist.
3. Run `sos install`.
4. Run `sos audit`.
5. Fill in `.claude/PM.md` with project-specific context.

## Node Metadata

The installer may infer these, but the user can override them:

- node name
- node kind: solution, project, module, workshop, research, learning, other
- parent relationship
- whether this node may read upward
- whether this node may publish upward
- visibility: private, shared, public, summary-only

## Fallback

If the `sos` command is not available, use the official SolutionOS repository as the source of truth and copy `templates/core/` into the target project without overwriting existing files. After that, run the closest available audit command and record any manual follow-up in `.claude/PM.md`.
