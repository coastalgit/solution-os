---
name: sos:spec
description: Create a guided feature spec pack from either a local idea or an existing GitHub issue.
disable-model-invocation: true
---

Run `/sos:spec` for this node.

This command creates one draft feature spec pack:

```text
specs/<id-slug>/spec.md
```

It creates `spec.md` only. `plan.md`, `tasks.md`, and `contracts/` are later workflow outputs.

## Step 1 - Choose source

Ask first, before reading tools or creating files:

```text
What kind of spec are we creating?

1. Local spec
   From a short idea. Creates specs/001-<slug>/spec.md.

2. Issue-backed spec
   From an existing GitHub issue. Creates specs/<issue-number>-<slug>/spec.md.
```

## Step 2A - Local spec

Ask for a short idea or title.

Create:

```text
specs/<next-local-id>-<slug>/spec.md
```

Use the next available three-digit local id by scanning existing `specs/` folders that begin with `001-`, `002-`, etc. Start at `001` if none exist.

The spec frontmatter must include:

```yaml
---
type: feature-spec
status: draft
controller: local-spec
source: local-idea
---
```

## Step 2B - Issue-backed spec

Ask for the issue number or issue URL.

Before using any issue-reading tool, consult `.claude/TOOLS.md` and follow the tool-naming discipline in `.claude/STONE.md` and `.claude/WORKFLOW.md`.

If issue content can be read from an available, permitted integration, use it as source evidence. If not, continue from the issue number or URL and ask the user for the missing issue title/body.

Create:

```text
specs/<issue-number>-<slug>/spec.md
```

The spec frontmatter must include:

```yaml
---
type: feature-spec
status: draft
controller: github-issue
source: github-issue
issue: <number>
issue_url: <url-or-blank>
---
```

## Slug rules

Derive `<slug>` from the title or issue title:

- lowercase
- kebab-case
- only `a-z`, `0-9`, and `-`
- replace spaces and punctuation with `-`
- collapse repeated `-`
- trim leading/trailing `-`
- maximum 50 characters

If a target folder already exists, append `-01`, `-02`, etc. Do not overwrite.

## Spec body

Use this structure:

```markdown
# Spec: <Title>

## Source

- Controller: <local-spec|github-issue>
- Source: <local idea or issue reference>

## Problem

Describe the problem or opportunity.

## Goal

Describe the intended outcome.

## Non-Goals

List what is intentionally out of scope.

## Users / Actors

List affected users, systems, or roles.

## Requirements

- ...

## Success Criteria

- ...

## Questions

- ...
```

Unknowns must go under `Questions`; do not guess. Do not add technical implementation details, code examples, or architecture decisions unless the issue/source already states them.

## Final output

After saving, respond only with:

```text
Spec pack: specs/<id-slug>/
Spec file: specs/<id-slug>/spec.md
Controller: <local-spec|github-issue>
Status: draft
```
