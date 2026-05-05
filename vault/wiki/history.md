---
type: vault-note
scope: node
status: active
created: 2026-05-01
updated: 2026-05-05
tags:
  - history
  - dogfooding
  - release-notes
---

# SolutionOS History

This note is the curated history entry point for the SolutionOS product project.

For detailed release notes, see `CHANGELOG.md`. For source-backed design statements, see `docs/design/source-ledger.md`. For formal decisions, see `docs/design/decisions.md`.

## Origin

SolutionOS came from the Workspacer idea: a repeatable way to initialize, audit, and maintain AI-operable workspaces without relying on chat history or tool-specific memory.

The early design decisions were:

- use `.claude/` for active agent control-plane files because Claude Code already notices that folder;
- keep SOS system material under `.claude/sos/` so it does not mix with active project context;
- make `vault/` mandatory in every SOS node as the durable knowledge base;
- use `vault/triage/`, `vault/wiki/`, `vault/archive/`, and `vault/outbox/` as the knowledge lifecycle;
- keep install/export bootstrap files under `.claude/sos/export/`;
- provide a normal global CLI entry point (`sos`) for applying SOS elsewhere;
- keep the initial product small: templates, scripts, manifest, portable instructions, summary, audit, and migration assessment.

## Dogfooding Clarification

The SolutionOS repository is also an SOS node. That means the repo intentionally contains:

- `.claude/` as active context for building SolutionOS;
- `.claude/sos/` as this repo's installed SOS system material;
- `vault/` as the knowledge base for the SolutionOS product project.

This is self-hosting, not the install payload for other repositories. Other projects receive the baseline from `templates/core/` or follow `.claude/sos/export/SOS-INSTALL.md`.

In 0.1.12, root `INSTALL.md` briefly acted as the public install doorway. That was superseded in 0.1.13 because it made the product feel like a markdown-file ritual rather than a normal framework/tool. The primary model is now: install the `sos` tool globally, then run `sos install` inside a target repository.

This clarification was added after confusion during a 2026-05-01 field test: the repository looked like an ordinary project using SOS, and the root documentation did not make the product/source layer versus self-hosted-node layer obvious enough.

## Release Timeline

| Version | Date | Main change |
|---|---|---|
| 0.1.0 | 2026-04-30 | Initial public seed: core template, init helper, summary helper, source-backed design docs, portable install/export files. |
| 0.1.1 | 2026-04-30 | Version-stamped baseline, metadata rules, audit helper, remote manifest metadata. |
| 0.1.2 | 2026-05-01 | Migration-aware baseline with vault manifests and read-only migration assessment. |
| 0.1.3 | 2026-05-01 | Operational triage README and concrete `/sos:vault-process` protocol. |
| 0.1.4 | 2026-05-01 | Native Claude Code `/sos` skill router. |
| 0.1.5 | 2026-05-01 | Visible `/sos:*` command files and safer command-facing metadata. |
| 0.1.6 | 2026-05-01 | Concrete command/help model, `/sos:tools`, `/sos:ingest`, and tool-policy cleanup. |
| 0.1.7 | 2026-05-01 | Split quick `/sos:help` from explanatory `/sos:about`; surfaced version info. |
| 0.1.8 | 2026-05-01 | Shortened `/sos:about`. |
| 0.1.9 | 2026-05-01 | Shipped node-local helper scripts under `.claude/sos/scripts/`. |
| 0.1.10 | 2026-05-01 | Defined the SOS surface routing contract and audited PM/adapters for reachability. |
| 0.1.11 | 2026-05-01 | Clarified the self-hosted repository model in the root README and added this curated history note. |
| 0.1.12 | 2026-05-01 | Added root `INSTALL.md` as the obvious cloud-agent install entry point and clarified that it is not target-repo payload. |
| 0.1.13 | 2026-05-01 | Removed root `INSTALL.md` from the current product surface and added the real `sos` CLI package model. |
| 0.1.14 | 2026-05-01 | Added actor registry protection, concept-binding, aliases, conservative semantic audit warnings, no-overwrite install guards, archive/unarchive lifecycle controls, a guided `/sos:assistant` front door, and a local SOS visual map. |
| 0.1.15 | 2026-05-01 | Made `sos install` proposal-first with explicit approval before missing-file creation and clarified older-node upgrades as append-only opportunities. |
| 0.1.16 | 2026-05-05 | Added the tool-naming discipline rule and promoted `.claude/TOOLS.md` into a structured adopted-tools registry with vetted/unverified/parked/rejected/deprecated states, capability statements, and last-verified dates. |
| 0.1.17 | 2026-05-05 | Added `/sos:presentation-generate` (NLM-driven outputs) and the `produce/<type>/` output-config pattern; added the `/resources/` private input lane (Git-ignored) with auto-create + append-only `.gitignore` handling on install; added root context-file detection hints (README/PRD/etc.) without claiming files. |
| 0.1.18 | 2026-05-05 | Stripped agent theatre from `/sos:init` and `/sos:audit`. Init becomes concise four-step flow with one-line-per-file ingest prompts. Audit becomes strict read-only five-line state. `resources/README.md` trimmed from 30 to 6 lines. Workshop-demo-ready output. |

## Current Documentation Rule

The root README must make the two-layer repository model explicit:

- product/distribution layer: `package.json`, `bin/sos.js`, `templates/`, `scripts/`, `manifest.json`, `docs/design/`, portable exports;
- self-hosted node layer: root `.claude/` and root `vault/`.

If that distinction becomes unclear again, update the root README before adding more install or command machinery.
