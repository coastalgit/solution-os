---
type: changelog
scope: system
status: active
---

# Changelog

## 0.1.19 - 2026-05-05

Added guided `/sos:spec` for creating draft feature spec packs from either a local idea or an existing GitHub issue.

- Added `/sos:spec` command files to the source node and install template.
- Registered `/sos:spec` in the SOS command vocabulary and native `/sos` router.
- Added the command to the CLI install/audit required file list.
- Defined the v1 output as `specs/<id-slug>/spec.md` only; planning, tasks, and contracts remain later workflow outputs.
- Version-stamped manifest, template metadata, and human-readable version files for 0.1.19.

## 0.1.18 - 2026-05-05

Stripped the agent-driven `/sos:init` and `/sos:audit` theatre that 0.1.16's discipline rule had inadvertently amplified. Workshop-demo-ready: concise output, no scrolling agent commentary.

- **`/sos:init` rewritten** as a four-step concise flow:
  1. Create missing baseline files (one Y/N batch prompt).
  2. Ensure the `/resources/` lane exists (auto-create directory + README, append `/resources/` to `.gitignore` or create it).
  3. Scan project root for context files (`README.md`, `PRD.md`, `CONTEXT.md`, `BRIEF.md`, `REQUIREMENTS.md`, `SPEC.md`); for each one found, ask **one line per file**: *"Found PRD.md. Ingest as product requirements? (Y / N / type a custom intent)"*. On Y or custom intent, invoke `/sos:ingest` immediately.
  4. End with a three-line summary.
- **Constraints baked into the init spec:** never overwrite, never narrate skipped files, never enumerate drift in existing files, never invoke the tool-naming-discipline rule for SOS-baseline file creates, never emit "Tier A / Tier B / B1+B2" choice menus, never ask the user to paste canonical content.
- **`/sos:audit` rewritten** as strictly read-only state. Five-line maximum output: versions, missing-file count, vault counts, actor/concept gap count, single next-action pointer. **No multi-tier repair proposals. No prompts. No enumerations.** If the user wants to fix anything, they run `/sos:init` (for missing files) or read `CHANGELOG.md` (for upgrade actions).
- **`resources/README.md` trimmed** from 30 lines to 6. Conveys the same rules in a third of the space.
- Version-stamped manifest, template metadata, and human-readable version files for 0.1.18.

## 0.1.17 - 2026-05-05

Added the first SOS-routed output command (`/sos:presentation-generate`), the `produce/<type>/` output-config pattern, the `/resources/` private input lane, and install-time conveniences (append-only `.gitignore` handling, root context-file detection).

- Added `/sos:presentation-generate` command — a thin SOS wrapper around the global `nlm-presentation` skill (NotebookLM via `notebooklm-py`). Loads defaults from `.claude/sos/produce/presentation/`, routes outputs into `vault/outbox/presentations/<slug>/`.
- Added the `.claude/sos/produce/<type>/` directory pattern. Each output type carries `house-style.md`, `output-styles.md`, `manifest-template.md`, and a `README.md`. The first registered type is `presentation`. Future types (marketing, financial, manual, etc.) follow the same shape.
- Added the `/resources/` private input lane at the project root. Git-ignored. Material here may be private/sensitive/copyrighted. The agent may read it for ingestion but must never copy raw bytes into `vault/`. Only user-approved summaries derived from `/resources/` material may reach `vault/wiki/`.
- Updated `sos install` to:
  - auto-create `/resources/` if missing (with a README explaining the lane)
  - ship a default `.gitignore` (with `/resources/`) when none exists at the project root
  - **append-only** `/resources/` to an existing `.gitignore` if missing the pattern, gated by an explicit `(Y)/(N)` prompt or `--yes`/`--apply`. Existing entries are never reordered, modified, or deleted. Idempotent across re-runs (detection accepts `/resources/`, `resources/`, and `**/resources/`)
  - scan the project root for known context files (`README.md`, `PRD.md`, `CONTEXT.md`, `BRIEF.md`, `REQUIREMENTS.md`, `SPEC.md`) and print a one-line hint per finding suggesting `/sos:ingest <file> as <intent>`. Never claims, moves, or modifies these files.
- Updated `/sos:ingest` spec to define routing rules:
  - `README.md` stays at root (public surface). Wiki may receive a curated note that references it; the file itself is not relocated.
  - Other internal-context files (`PRD.md`, `BRIEF.md`, `SPEC.md`, etc.) move to `vault/archive/<YYYY-MM-DD>-<name>.md` as `source-evidence` with archive metadata sidecar; a curated wiki note is created summarising the content and pointing back at the archive entry. New versions are archived alongside; the wiki note tells the version story.
  - `/resources/` paths trigger **private-source mode**: read but never copy raw bytes; produce summaries with explicit user verification before any wiki write; default to `(D)ISCUSS` for material that looks like financials, PII, customer data, or copyrighted material.
- Registered the new files and directories in `bin/sos.js` (`requiredFiles`, `requiredDirs`) so `sos audit` reports drift if they go missing.
- Added new STONE.md non-negotiable constraints: no raw-bytes leak from `/resources/` into vault; no auto-claim of root context files; no overwrite of existing `.gitignore` (append-only with approval).
- Added new SCHEMA.md sections: `Private Input Lane`, `Output Production Pattern`, `Install-time append-only operations`, `Install-time root context-file detection`.
- Registered `nlm-presentation` (skill) and `notebooklm-py` (cli) in this node's `.claude/TOOLS.md` as `vetted` per the 0.1.16 tool-naming discipline.
- Version-stamped manifest, template metadata, and human-readable version files for 0.1.17.

## 0.1.16 - 2026-05-05

Added the tool-naming discipline rule and promoted `.claude/TOOLS.md` into a structured adopted-tools registry.

- Added a non-negotiable rule to `STONE.md`: agents must consult `.claude/TOOLS.md` before naming any tool, library, CLI, package, service, or skill in a proposal, plan, route, or recommendation, and must not satisfy the rule with a tentative or disclaimer-wrapped name.
- Added a `Tool-Naming Lookup` section to `WORKFLOW.md` that fires at the moment of drafting any route or proposal, not after pushback, and added "naming any tool not in `.claude/TOOLS.md`" to the human-gates list.
- Restructured `.claude/TOOLS.md` into an adopted-tools registry with required per-tool fields (`status`, `kind`, `capabilities`, `limits`, `install / auth`, `source`, `last-verified`, optional `parked-reason` or `rejected-reason`).
- Added five tool states: `vetted`, `unverified`, `parked`, `rejected`, `deprecated`. `parked` covers user-flagged or agent-surfaced entries that are not adopted and must not be promoted to "primary" or "preferred" without verify-and-register.
- Added a `Tools Registry Rule` to `SCHEMA.md` defining the entry schema and naming the audit checks `/sos:audit` should report (missing fields, stale `last-verified`, missing `parked-reason` or `rejected-reason`).
- Updated `/sos:tools` command spec to own the registry lifecycle with `list`, `verify`, `add`, `park`, `promote`, `reject`, and `gaps` actions.
- Updated `/sos:vault-process` and `/sos:ingest` command specs to require a `TOOLS.md` lookup before naming any tool in a route or proposal.
- Clarified that donor-source recommendations (skill files, package readmes, third-party docs, search results) are starting candidates only and must follow the verify-and-register path before adoption.
- Version-stamped manifest, template metadata, and human-readable version files for 0.1.16.

## 0.1.15 - 2026-05-01

Made install approval explicit and tightened older-node upgrade wording.

- Changed `sos install` to report the missing files it would create and require an interactive `(Y)ES` or `--yes`/`--apply` before writing.
- Kept install strictly missing-file only: existing files are skipped, never replaced, deleted, or repaired by install.
- Clarified `/sos:init`, `/sos:audit`, schema, and install docs so older SOS nodes are described as upgrade opportunities, with any existing-file changes proposed as append-only amendments.
- Version-stamped manifest, template metadata, and human-readable version files for 0.1.15.

## 0.1.14 - 2026-05-01

Added actor/concept integrity protection, install safety, and archive lifecycle controls.

- Made `.claude/ACTORS.md` the only canonical actor registry and forbade parallel people/team/roster/stakeholder registries in `vault/`.
- Added active-engagement guidance so passing mentions stay in source/vault material instead of bloating `ACTORS.md`.
- Added aliases to ACTORS tables and documented naming discipline in the SOS schema.
- Added `type: concept-binding` and a generic concept-binding template.
- Extended CLI and PowerShell audit checks to report missing actor alias columns, reserved vault actor registries, and repeated unregistered actor/concept candidates.
- Hardened install/version safety so `sos install` never overwrites existing files and blocks writes when an existing project SOS version is newer than the running tool.
- Added `/sos:archive` and `/sos:unarchive` workflows with Q&A/cancel gates, byte-preserving file handling, archive metadata, and manifest update rules.
- Added `/sos:assistant` and `.claude/sos/ASSISTANT.md` as a guided front door for users who want SOS to route them conversationally.
- Added `.claude/sos/SOS-VISUAL.html` as a simple local visual map referenced by `/sos:help` and `/sos:about`.
- Extended CLI and PowerShell audit checks to report missing archive manifest columns, unindexed archive items, and loose archive candidates without moving files automatically.
- Version-stamped manifest, template metadata, and human-readable version files for 0.1.14.

## 0.1.13 - 2026-05-01

Added the real GitHub-backed `sos` CLI package model.

- Added `package.json` and `bin/sos.js` with `sos install`, `sos audit`, `sos status`, `sos migrate`, and `sos version`.
- Removed root `INSTALL.md` to avoid presenting installation as a markdown-file ritual.
- Reworked the root README around the clean model: run `sos` from GitHub or install it locally from GitHub, then run `sos install` inside a target project.
- Reframed PowerShell scripts as compatibility helpers rather than the primary product surface.
- Replaced bare triage gate letters with readable `(Y)ES`, `(N)O`, `(D)ISCUSS`, and `(C)ANCEL` choices.
- Version-stamped manifest, template metadata, and human-readable version files for 0.1.13.

## 0.1.12 - 2026-05-01

Added a root install entry point.

- Added root `INSTALL.md` so a cloud agent pointed at the repository can discover the install process immediately.
- Clarified that root `INSTALL.md` belongs to the SolutionOS source repo and should not be copied into every target repository by default.
- Updated the root README to point cloud agents at `INSTALL.md`.
- Recorded the install-entry decision in the design ledger, decisions file, PM router, and vault history.
- Version-stamped manifest, template metadata, and human-readable version files for 0.1.12.

## 0.1.11 - 2026-05-01

Clarified the self-hosted repository model.

- Updated the root README to explain that this repository is both the SolutionOS product/source repository and a dogfooded SOS node.
- Distinguished the product/distribution layer (`templates/`, `scripts/`, `manifest.json`, `docs/design/`, portable exports) from this repo's own `.claude/` and `vault/` memory.
- Added `vault/wiki/history.md` as the curated product history entry point.
- Linked the history note from the vault index and PM router.
- Version-stamped manifest, template metadata, and human-readable version files for 0.1.11.

## 0.1.10 - 2026-05-01

Defined and audited the SOS routing surface.

- Added an explicit routing contract to `SCHEMA.md`.
- Made `.claude/PM.md` the canonical SOS surface map in the core template.
- Updated `CLAUDE.md` and `AGENTS.md` adapters to point to PM and the SOS command vocabulary.
- Extended `sos-audit.ps1` and `sos-summary.ps1` to report missing PM references, missing adapter delegation, and unreachable SOS surface paths.
- Version-stamped manifest, template metadata, and human-readable version files for 0.1.10.

## 0.1.9 - 2026-05-01

Shipped node-local SOS helper scripts.

- Added read-only helper scripts to the install template under `.claude/sos/scripts/`.
- Updated script hints to point at installed node-local scripts instead of a missing project-root `scripts/` folder.
- Updated summary/audit required-file checks so missing node-local helper scripts are reported as SOS drift.
- Version-stamped manifest, template metadata, and human-readable version files for 0.1.9.

## 0.1.8 - 2026-05-01

Trimmed `/sos:about`.

- Reduced `/sos:about` to a short explanation of the solution/project spine, vault, metadata, and adapters.

## 0.1.7 - 2026-05-01

Split quick help from explanatory about.

- Added `/sos:about` for the longer SOS intent and structure explanation.
- Reduced `/sos:help` to a compact command reference.
- Required help, about, and summary to mention installed SOS/template version.
- Added `about.md` to summary/audit required command files.

## 0.1.6 - 2026-05-01

Corrected the command/help model back to the concrete SOS baseline.

- Updated `/sos:help` to start from solution/project spine, `.claude` context, vault KB, metadata, tools, and automation.
- Added `/sos:tools` as the conversational tool-layer entry point.
- Added single natural-language `/sos:ingest <source> <intent>` command.
- Removed `/sos:toolkits-summary` from the visible command surface.
- Reworked `TOOLKITS.md` away from abstract layers and toward practical tool use.

## 0.1.5 - 2026-05-01

Visible SOS branch commands and safer command-facing metadata.

- Added `.claude/commands/sos/*.md` command files for `/sos:*` branch discovery.
- Kept `/sos <subcommand>` as the fallback router path.
- Removed personal names from SOS slash-menu metadata.
- Updated summary/audit helpers to require the SOS command files.

## 0.1.4 - 2026-05-01

Native Claude Code `/sos` router.

- Added `.claude/skills/sos/SKILL.md` so typing `/so` in Claude Code exposes `/sos`.
- Mapped `/sos <subcommand>` to the canonical `/sos:<subcommand>` vocabulary.
- Updated schema and audit/summary required files to include the SOS router skill.
- Documented that true `/sos:*` autocomplete requires a plugin or MCP command layer.

## 0.1.3 - 2026-05-01

Triage README made operational.

- Replaced the vague triage folder description with a concrete `/sos:vault-process` protocol.
- Added control-file exclusions so `README.md` and `_manifest.md` are not treated as triage items.
- Added route rules for wiki, archive, outbox, task, and leave decisions.
- Added manifest/index follow-up expectations.

## 0.1.2 - 2026-05-01

Migration-aware baseline for existing projects.

- Added vault lifecycle manifests to the core template.
- Added `scripts/sos-migrate-assess.ps1` for read-only migration discovery.
- Added `/sos:migrate` to the command vocabulary.
- Updated summary/audit helpers to require vault manifests.
- Updated summary counts so manifests are not counted as triage/wiki/outbox items.

## 0.1.1 - 2026-04-30

Version-stamped baseline for applying SOS to existing projects.

- Added explicit metadata requirement for SOS-owned Markdown context and KB files.
- Added `scripts/sos-audit.ps1`.
- Tightened audit scope so generated worktrees/session-memory folders are not treated as SOS-owned context.
- Added remote repository and manifest metadata.
- Added human-readable SOS version file.

## 0.1.0 - 2026-04-30

Initial public seed.

- Added core SOS node template.
- Added `sos-init.ps1` preview/apply helper.
- Added `sos-summary.ps1` read-only summary helper.
- Added source-backed design docs.
- Added portable install/export files.
