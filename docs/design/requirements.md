---
type: requirements
scope: system
status: active
---

# Requirements

Requirements extracted from `source-ledger.md`.

## Core Requirements

| ID | Requirement | Sources | Status |
|---|---|---|---|
| REQ-001 | SOS must provide a repeatable baseline that can be applied to new and existing projects. | SRC-001 | active |
| REQ-002 | SOS must support any bounded endeavour, not only software. | SRC-003 | active |
| REQ-003 | SOS nodes must be hierarchical and know their node kind and parent relationship. | SRC-002, SRC-024 | active |
| REQ-004 | `.claude` is the active control-plane home for v0.1 because it aligns with Claude Code behavior and prior Workspacer usage. | SRC-004 | active |
| REQ-005 | SOS system material must be separated under `.claude/sos/` to avoid ambiguity with active context files. | SRC-010, SRC-011 | active |
| REQ-006 | Every SOS node must have a `vault/` KB. | SRC-007 | active |
| REQ-007 | The vault lifecycle must use `triage`, `wiki`, `archive`, and `outbox`. | SRC-008, SRC-009 | active |
| REQ-008 | Active node files must define their own purpose and authority clearly. | SRC-014 | active |
| REQ-009 | `STONE.md` must explicitly define STONE as "carved in stone" and high-authority. | SRC-014 | active |
| REQ-010 | Local tools inventory and SOS tool preference policy must remain separate. | SRC-015 | active |
| REQ-011 | Machine-readable SOS metadata must live at `.claude/sos/sos.json`. | SRC-016 | active |
| REQ-012 | SOS command vocabulary must use `/sos:*` and concept-down names. | SRC-019, SRC-020 | active |
| REQ-013 | `sos:summary` must be read-mostly and report status/health. | SRC-017 | active |
| REQ-014 | `sos:audit` must be deeper and may apply approved repairs. | SRC-018 | active |
| REQ-015 | Updates should initially be discovered by `sos:init`, `sos:summary`, or `sos:audit`, not a separate upgrade command. | SRC-021 | active |
| REQ-016 | Initial installation must work by drop-in file and by remote template fetch. | SRC-022, SRC-023 | active |
| REQ-017 | SOS must support federated projects with separate repos and summary-only upward publishing. | SRC-025 | active |
| REQ-018 | Context transfer must be source-backed and traceable, not a single derived summary. | SRC-026 | active |
| REQ-019 | SOS wording and visible filenames must avoid sensitive personal labels. | SRC-027 | active |
| REQ-020 | SOS should support future agentic work automation with solution/project leads, async work, notifications, and human gates. | SRC-028, SRC-029 | active |
| REQ-021 | SOS must standardize documentation/output generation and capture external outputs back into vault/outbox/wiki. | SRC-030 | active |
| REQ-022 | v0.1 must include a preview-first local init helper that skips existing files unless explicitly forced. | SRC-031 | active |
| REQ-023 | v0.1 must include a read-only summary helper that reports node metadata, vault counts, and missing SOS files. | SRC-032 | active |
| REQ-024 | SOS metadata must record the canonical repository and raw manifest URL for future update checks. | SRC-033 | active |
| REQ-025 | SOS-owned Markdown context and KB files must always include YAML frontmatter metadata. | SRC-034 | active |
| REQ-026 | SOS releases must be version-stamped from the beginning in manifest, installed metadata, human-readable version notes, changelog, and git tags. | SRC-035 | active |
| REQ-027 | SOS must support migration assessment for existing messy project-memory/KB setups before applying changes. | SRC-036 | active |
| REQ-028 | Vault lifecycle folders must include manifests so migration, processing, and audit have explicit control files. | SRC-036 | active |
| REQ-029 | Vault lifecycle README files must include enough operational instructions for an agent to act safely from that folder. | SRC-037 | active |
| REQ-030 | Installed SOS nodes must expose a native Claude Code `/sos` entry point. | SRC-038 | active |
| REQ-031 | Installed SOS nodes must include node-local read-only helper scripts for summary, audit, and migration assessment. | SRC-044 | active |

## Non-Requirements For v0.1

| ID | Non-Requirement | Reason |
|---|---|---|
| NREQ-001 | Full CLI implementation | Templates and agent-readable instructions are enough to start. |
| NREQ-002 | Marketplace | Too early; use templates/profiles first. |
| NREQ-003 | Dashboard UI | Workspacer/SOS may later oversee visually, but v0.1 is file-first. |
| NREQ-004 | Autonomous agent swarm | The foundation must be stable before orchestration. |
| NREQ-005 | Separate `sos:upgrade` command | Update behavior can be included in init/summary/audit for now. |
| NREQ-006 | Automatic migration without questions | Existing projects need opt-in/opt-out choices before moving or rewriting material. |
