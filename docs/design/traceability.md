---
type: traceability
scope: system
status: active
---

# Traceability

Traceability from source statements to requirements, decisions, and template files.

| Source | Requirements | Decisions | Template / Design Outputs |
|---|---|---|---|
| SRC-001 | REQ-001 |  | README, architecture |
| SRC-002 | REQ-003 |  | `.claude/sos/sos.json`, SCHEMA |
| SRC-003 | REQ-002 |  | README, SCHEMA |
| SRC-004 | REQ-004 | DEC-003 | templates/core/.claude |
| SRC-005 |  | DEC-002 | README, architecture |
| SRC-006 |  | DEC-002 | architecture |
| SRC-007 | REQ-006 | DEC-006 | templates/core/vault |
| SRC-008 | REQ-007 | DEC-007 | templates/core/vault/triage |
| SRC-009 | REQ-007 | DEC-007 | templates/core/vault |
| SRC-010 | REQ-005 | DEC-004 | templates/core/.claude/sos |
| SRC-011 | REQ-005 | DEC-004 | templates/core/.claude/sos/export |
| SRC-012 |  | DEC-009 | SOS-BUILDER.md |
| SRC-013 |  | DEC-010 | SOS-INSTALL.md |
| SRC-014 | REQ-008, REQ-009 |  | STONE.md |
| SRC-015 | REQ-010 | DEC-008 | TOOLKITS.md, TOOLS.md |
| SRC-016 | REQ-011 | DEC-005 | sos.json |
| SRC-017 | REQ-013 |  | COMMANDS.md |
| SRC-018 | REQ-014 |  | COMMANDS.md |
| SRC-019 | REQ-012 | DEC-001 | COMMANDS.md |
| SRC-020 | REQ-012 |  | COMMANDS.md |
| SRC-021 | REQ-015 | DEC-011 | COMMANDS.md |
| SRC-022 | REQ-016 |  | SOS-INSTALL.md |
| SRC-023 | REQ-016 |  | SOS-INSTALL.md |
| SRC-024 | REQ-003 |  | sos.json, SCHEMA |
| SRC-025 | REQ-017 |  | SCHEMA, architecture |
| SRC-026 | REQ-018 | DEC-012 | source-ledger, SOS-BUILDER.md |
| SRC-027 | REQ-019 |  | WORKFLOW.md, TOOLKITS.md |
| SRC-028 | REQ-020 |  | architecture |
| SRC-029 | REQ-020 |  | architecture |
| SRC-030 | REQ-021 |  | vault/outbox, SOS-BUILDER.md |
| SRC-031 | REQ-022 | DEC-013 | scripts/sos-init.ps1, README |
| SRC-032 | REQ-023 | DEC-014 | scripts/sos-summary.ps1, README |
| SRC-033 | REQ-024 | DEC-015 | manifest.json, `.claude/sos/sos.json`, templates/core/.claude/sos/sos.json |
| SRC-034 | REQ-025 | DEC-016 | `.claude/sos/SCHEMA.md`, `.claude/WORKFLOW.md`, templates/core |
| SRC-035 | REQ-026 | DEC-017 | manifest.json, `.claude/sos/VERSION.md`, CHANGELOG.md, git tags |
| SRC-036 | REQ-027, REQ-028 | DEC-018, DEC-019 | `scripts/sos-migrate-assess.ps1`, COMMANDS.md, SCHEMA.md, vault manifests |
| SRC-037 | REQ-029 | DEC-020 | `vault/triage/README.md`, `templates/core/vault/triage/README.md` |
| SRC-038 | REQ-030 | DEC-021 | `.claude/skills/sos/SKILL.md`, `templates/core/.claude/skills/sos/SKILL.md`, scripts/audit required files |
| SRC-044 | REQ-031 | DEC-022 | `.claude/sos/scripts/`, `templates/core/.claude/sos/scripts/`, summary/audit required files |
| SRC-045 |  | DEC-023 | README, `vault/wiki/history.md` |
| SRC-046 |  | DEC-024 | Superseded root `INSTALL.md` experiment; historical only |
| SRC-047 | REQ-032 | DEC-025 | `package.json`, `bin/sos.js`, README |
| SRC-048 | REQ-033 |  | `/sos:vault-process`, `vault/triage/README.md`, `templates/core/vault/triage/README.md` |
| SRC-049 | REQ-034, REQ-036 | DEC-026 | `SCHEMA.md`, `ACTORS.md`, `concept-binding.md`, audit helpers |
| SRC-050 | REQ-035, REQ-036 | DEC-026 | `STONE.md`, `WORKFLOW.md`, `ACTORS.md`, audit helpers |
| SRC-051 | REQ-037 | DEC-027 | `bin/sos.js`, `scripts/sos-init.ps1`, `SCHEMA.md`, `WORKFLOW.md`, README |
| SRC-052 | REQ-038 | DEC-028 | `/sos:archive`, `/sos:unarchive`, `vault/archive/_manifest.md`, `SCHEMA.md`, `WORKFLOW.md`, audit helpers |
| SRC-053 | REQ-039 | DEC-029 | `/sos:assistant`, `.claude/sos/ASSISTANT.md`, `COMMANDS.md`, `SKILL.md`, `WORKFLOW.md` |
| SRC-054 | REQ-040 | DEC-030 | `.claude/sos/SOS-VISUAL.html`, `/sos:help`, `/sos:about`, `SCHEMA.md`, README |
