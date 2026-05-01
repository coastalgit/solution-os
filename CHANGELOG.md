---
type: changelog
scope: system
status: active
---

# Changelog

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
