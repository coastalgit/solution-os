---
type: changelog
scope: system
status: active
---

# Changelog

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
