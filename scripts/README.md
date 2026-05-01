# Scripts

PowerShell helpers retained for compatibility, development, and installed-node self-checks.

The primary user-facing interface is the `sos` CLI:

```bash
sos install
sos audit
sos status
sos migrate
```

## Compatibility Helpers

### `sos-init.ps1`

Legacy preview/apply helper for copying `templates/core/` into a target folder. Prefer `sos install`.

### `sos-summary.ps1`

Read-only summary helper. Mirrors `sos status`.

### `sos-audit.ps1`

Read-only structure and routing-surface audit helper. Mirrors `sos audit`.

### `sos-migrate-assess.ps1`

Read-only migration discovery helper. Mirrors the early `sos migrate` assessment behaviour.

Installed nodes also carry these read-only helpers under `.claude/sos/scripts/` so a node remains auditable even where the global CLI is unavailable.
