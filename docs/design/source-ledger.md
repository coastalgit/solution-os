# Source Ledger

This is the source-backed ledger for the initial SolutionOS design.

It captures user statements and decisions from the originating discussion. Derived documents should trace back here instead of relying on a lossy summary.

## Source Items

| ID | Source Statement / Correction | Design Implication |
|---|---|---|
| SRC-001 | The target operator wants a reliable baseline that can be applied to old and new projects so any project can be opened, put into a known shape, trusted, and resumed. | SOS must provide repeatable initialization, summary, audit, and structure repair. |
| SRC-002 | The target operating model is hierarchical: root solution/endeavour with subprojects or nodes beneath it. | SOS nodes must support solution/project/module/other node kinds and parent relationships. |
| SRC-003 | The same setup should apply beyond software, including workshops, trips, research, and side-interest projects. | SOS must be domain-general; code-specific behavior belongs in profiles, not the core. |
| SRC-004 | `.claude` is preferred because Claude Code naturally uses it, and prior generic AI folders risk being forgotten by agents. | v0.1 installs active control-plane files under `.claude`. |
| SRC-005 | Workspacer is not separate from this idea; it was the early initializer/overseer concept. | Treat Workspacer as predecessor to `sos:init` and SOS oversight. |
| SRC-006 | Workspacer is preferred as installer/upgrader/overseer, not the brain. | SOS should install, audit, update, and validate the spine; agents/tools do the work. |
| SRC-007 | Vault must exist in every solution or project. It is the KB. | `vault/` is mandatory in every SOS node. |
| SRC-008 | Rename vault `inbox` to `triage`; triage gets emptied into wiki and archive. | Vault lifecycle is `triage -> wiki/archive/outbox`. |
| SRC-009 | Inbox can remain a later node/team concept, but not the KB capture lane. | Do not use `inbox` in the v0.1 vault template. |
| SRC-010 | No ambiguity inside `.claude`; active files and SOS system material must be separated by directory/file naming. | Active context files live at `.claude/*.md`; system material lives under `.claude/sos/`. |
| SRC-011 | No loose SOS-BUILDER file beside active `.claude/*.md` context files; builder/export files must not sit beside active context. | Portable export/install files live under `.claude/sos/export/`. |
| SRC-012 | `SOS-BUILDER.md` is for exporting/building context into an SOS setup. | `SOS-BUILDER.md` is an export/bootstrap contract, not an install file. |
| SRC-013 | `SOS-INSTALL.md` can also live in export; no extra install folder needed. | Use `.claude/sos/export/SOS-INSTALL.md`. |
| SRC-014 | `STONE.md` must explicitly explain that STONE means carved in stone. | STONE template must define its own purpose and authority at the top. |
| SRC-015 | Tool preferences should live under SOS system material as `TOOLKITS`, plural. | Use `.claude/sos/TOOLKITS.md`; keep `.claude/TOOLS.md` for local tool facts. |
| SRC-016 | `sos.json` should live in the SOS system directory, not loose in `.claude`. | Use `.claude/sos/sos.json`. |
| SRC-017 | `sos:summary` should inspect and report project state without applying changes by default. | Define summary as read-mostly status/health command. |
| SRC-018 | `sos:audit` should inspect deeply and apply approved changes if allowed. | Define audit as deeper repair-capable command with human approval. |
| SRC-019 | Commands should be namespaced as `/sos:*`; loose skills/commands are avoided when the assigned agent is unclear. | All SOS command vocabulary uses `sos:` prefix. |
| SRC-020 | Concept-down command names are preferred for autocomplete, e.g. `sos:inbox-process` style. | Use domain-first command names such as `sos:vault-process`, `sos:context-export`, `sos:toolkits-summary`. |
| SRC-021 | Keep it simple early; no separate upgrade command unless infrastructure warrants it. | Update checks can be part of `sos:init`, `sos:summary`, and `sos:audit`. |
| SRC-022 | Initial install should support drop-in file and/or GitHub grab. | Provide `SOS-INSTALL.md` as portable file plus manifest-based remote update model. |
| SRC-023 | Drop-in file can mostly point to the repo but should have a small fallback. | `SOS-INSTALL.md` should explain SOS, point to remote templates, and include minimal offline layout. |
| SRC-024 | A project should know if it is possibly part of a solution even if it does not need to read upward. | Node metadata must include parent relationship and read/publish policy. |
| SRC-025 | Separate repos may exist inside project directories, with a solution repo ignoring them. | SOS must support federated nodes and summary-only upward publishing. |
| SRC-026 | Derived handoff summaries often omit important details. | SOS context export must be source-backed, with source ledger, requirements, decisions, open questions, and traceability. |
| SRC-027 | Avoid visible personal diagnostic labels in filenames, chat, or screen-share-visible references. | Public-safe wording should use focus-friendly/context-first/restartable workflow phrasing. |
| SRC-028 | Automation includes workflow automation and agentic work automation, with particular interest in the latter. | SOS should define automation layers and eventually coordinate async agent work with human gates. |
| SRC-029 | Agentic OS means persistent operating layer over projects, tools, agents, inboxes/triage, outputs, and human gates. | SOS is operating layer, not just template scaffold. |
| SRC-030 | Documentation must be updated autonomously and reliably, and outputs should be consumable by humans or external agents. | SOS must standardize vault/outbox and context export behavior. |
| SRC-031 | Initial SOS must remain simple but useful immediately. | Provide templates plus a preview-first local init helper; avoid a full CLI/runtime for v0.1. |
| SRC-032 | `sos:summary` should reveal version, setup, vault state, tool/context structure, and drift without making changes. | Provide a read-only local summary helper before a full command runtime exists. |
| SRC-033 | Canonical SolutionOS repo is `https://github.com/coastalgit/solution-os.git`. | Configure repository and manifest URLs in `manifest.json` and SOS metadata. |
