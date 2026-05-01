---
type: changelog
scope: system
status: active
---

# Changelog

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
