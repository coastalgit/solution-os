---
type: decisions
scope: system
status: active
---

# Decisions

## Active Decisions

| ID | Decision | Sources | Rationale |
|---|---|---|---|
| DEC-001 | Use `SolutionOS` as the project identity and `sos` as the command namespace. | SRC-019 | Gives one coherent operating layer rather than tool-specific command names. |
| DEC-002 | Treat Workspacer as predecessor/initializer concept, not as a competing product name. | SRC-005, SRC-006 | Workspacer's core idea survives as `sos:init` and oversight behavior. |
| DEC-003 | Use `.claude` for active SOS/Workspacer context in v0.1. | SRC-004 | Aligns with Claude Code and existing projects. |
| DEC-004 | Put SOS system material under `.claude/sos/`. | SRC-010, SRC-011 | Avoids ambiguity between active context and system/export/templates. |
| DEC-005 | Put `sos.json` under `.claude/sos/sos.json`. | SRC-016 | Keeps machine metadata with system material. |
| DEC-006 | Every node has `vault/` with `triage`, `wiki`, `archive`, and `outbox`. | SRC-007, SRC-008 | The vault is the KB in every solution/project/node. |
| DEC-007 | Use `triage`, not `inbox`, for the vault capture lane. | SRC-008, SRC-009 | Inbox remains available for future node/team/agent work queues. |
| DEC-008 | Use `TOOLKITS.md` under `.claude/sos/`, plural. | SRC-015 | Captures global toolset preferences/policies without bloating local `TOOLS.md`. |
| DEC-009 | Use `.claude/sos/export/SOS-BUILDER.md` for SOS-compatible context export. | SRC-012 | Builder is for exporting/building a package for SOS. |
| DEC-010 | Use `.claude/sos/export/SOS-INSTALL.md` for portable install/init instructions. | SRC-013, SRC-022 | Install and export are both copy-out portable assets. |
| DEC-011 | Keep command set small initially. | SRC-021 | Avoids recreating another sprawling unfinished system. |
| DEC-012 | Source-backed ledger is mandatory for major context transfer/design work. | SRC-026 | Prevents lossy summary failure. |
| DEC-013 | Provide `scripts/sos-init.ps1` as a preview-first local helper, not the final command runtime. | SRC-031 | Makes v0.1 usable immediately while preserving the file-first direction. |
| DEC-014 | Provide `scripts/sos-summary.ps1` as a read-only helper, not the final command runtime. | SRC-032 | Gives immediate project orientation without creating another source of truth. |
| DEC-015 | Use `https://github.com/coastalgit/solution-os.git` as the canonical SolutionOS repository. | SRC-033 | Enables installed nodes to know where update checks should originate. |
| DEC-016 | Require YAML frontmatter on SOS-owned Markdown context and KB files. | SRC-034 | Makes routing, audit, indexing, Obsidian use, and AI context loading predictable. |
| DEC-017 | Start release stamping at `0.1.0` and move the current installable baseline to `0.1.1`. | SRC-035 | Allows legacy projects to record exactly which SOS baseline was applied. |
| DEC-018 | Add `/sos:migrate` as a human-gated migration assessment path. | SRC-036 | Existing project setups need discovery and choices before applying SOS changes. |
| DEC-019 | Add `_manifest.md` files to each vault lifecycle folder. | SRC-036 | Manifests make triage/wiki/archive/outbox state explicit and auditable. |
