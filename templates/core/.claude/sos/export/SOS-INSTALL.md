---
type: sos-install
scope: portable
status: active
sos_name: SolutionOS
sos_version: 0.1.15
---

# SOS Install Reference

SOS means **SolutionOS**.

SolutionOS is a portable, AI-readable workspace operating layer. It helps agents and humans initialize, summarize, audit, maintain, export, and upgrade durable context for software projects, workshops, research, and other bounded work.

This file is installed inside SOS nodes as a reference. It is not the primary product entry point.

## Primary Install Model

Run the `sos` tool from the canonical GitHub repo inside the project that should receive SOS:

```text
npx --yes --package github:coastalgit/solution-os#main sos install
npx --yes --package github:coastalgit/solution-os#main sos audit
```

That is the normal path. It uses GitHub as the distribution source and does not require npm registry publishing.

Optional local/global install from GitHub:

```text
npm install -g github:coastalgit/solution-os#main
sos install
sos audit
```

The source repository's root `.claude/` and `vault/` are the SolutionOS project's own working memory. They are not copied into target projects.

## What `sos install` Does

`sos install` proposes the baseline from `templates/core/` for the current project, then creates approved missing files only.

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

Existing files are always skipped. `sos install` must not overwrite project files.

By default, `sos install` reports the missing files it would create and asks before writing. For reviewed automation, use `sos install --yes` or `sos install --apply`.

Before writing, `sos install` checks `.claude/sos/sos.json` when it exists:

- if the project version matches the running CLI, it may add missing files only
- if the project version is older than the running CLI, it may add missing files only after approval
- if the project version is newer than the running CLI, it must stop before writing
- if project version metadata is missing or unreadable, it must stop before writing

An older project version is an upgrade opportunity, not an automatic refresh or repair. Existing SOS files must not be replaced or deleted by install. If an existing memory file needs newer content, propose an append-only amendment with exact paths and no information loss, or leave the upgrade unapplied.

## Safety Rules

- Preserve existing project instructions.
- Do not delete or move existing project files during install.
- Do not replace existing `CLAUDE.md`, `AGENTS.md`, `.claude/`, or `vault/` files unless the user explicitly requests replacement.
- Do not use install as a repair/overwrite mechanism. Repairs need a separate explicit approval path.
- If older Workspacer, knowledge-base, command, skill, or session-memory material exists, run `sos migrate` first and review the assessment.
- Route project-specific guidance into `.claude/PM.md` instead of burying it in installer notes.

## Existing Project Flow

For an existing project:

1. Run `sos status`.
2. Run `sos migrate` if old knowledge or memory folders exist.
3. Run `sos install`.
4. Review the proposed missing-file creates and approve only if they are wanted.
5. Run `sos audit`.
6. Fill in `.claude/PM.md` with project-specific context.

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
