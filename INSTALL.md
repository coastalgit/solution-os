# Install SolutionOS Into an Existing Repository

This is the public entry point for applying SolutionOS (`sos`) to another repository.

If you are an AI agent working in a target repository, follow this instruction:

```text
Apply SolutionOS to this repository from https://github.com/coastalgit/solution-os.
Preserve existing project instructions.
Inspect first, propose the install/merge plan, wait for approval, then apply.
After applying, run the installed SOS audit and report the result.
```

For a version-pinned install, use the latest release tag instead of `main`.

Current version: `0.1.12`

## What To Use From This Repo

Use the product/distribution layer:

- `templates/core/` - baseline files to create or merge into the target repository.
- `manifest.json` - current version and canonical metadata.
- `.claude/sos/export/SOS-INSTALL.md` - portable install protocol.
- `scripts/` - optional local helper scripts when the environment supports them.

Do not copy this repository root's own `.claude/` or `vault/` into the target project. Those are the SolutionOS repo dogfooding SOS on itself.

## Required Agent Behaviour

Before changing files, inspect the target repository and output:

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

Only apply after approval.

## Expected Result In The Target Repository

The target repository should end up with an SOS node shape like:

```text
CLAUDE.md
AGENTS.md
.claude/
  PM.md
  STONE.md
  ACTORS.md
  TOOLS.md
  WORKFLOW.md
  sos/
    sos.json
    COMMANDS.md
    SCHEMA.md
    TOOLKITS.md
    VERSION.md
    scripts/
    export/
      SOS-INSTALL.md
      SOS-BUILDER.md
vault/
  triage/
  wiki/
  archive/
  outbox/
```

Existing project rules must be merged into the adapters and PM router, not overwritten.

## Why This Does Not Complicate The Target Repo

This root `INSTALL.md` belongs to the SolutionOS product repository. It is here so a cloud agent can find the install process immediately after being pointed at the repo.

The target repository does not need a copied root `INSTALL.md` unless the user explicitly wants one. After install, the target carries its own portable install/update reference at:

```text
.claude/sos/export/SOS-INSTALL.md
```

That means:

- source repo root `INSTALL.md` is the public doorway;
- target repo `.claude/sos/export/SOS-INSTALL.md` is the installed-node reference;
- target repo root stays focused on the target project unless the user chooses otherwise.

## Audit After Install

After applying SOS, run the installed audit helper when available:

```text
.claude/sos/scripts/sos-audit.ps1
```

If scripts are not executable in the environment, perform the file-based audit described in `.claude/sos/SCHEMA.md`: required files, metadata, PM references, adapter delegation, and SOS surface reachability.
