---
type: open-questions
scope: system
status: active
---

# Open Questions

| ID | Question | Status | Notes |
|---|---|---|---|
| OQ-001 | What remote repository URL should SOS use for manifest/update checks? | answered | Canonical repo: `https://github.com/coastalgit/solution-os.git`; manifest URL targets `main`. |
| OQ-002 | Should initial installed projects use flat `.claude/*.md` forever or later migrate to a nested active context folder? | open | Current decision is flat active files plus `.claude/sos/` system material. |
| OQ-003 | What should the first command runtime be after templates and the local helper: CLI, Codex/Claude plugin, or slash-command pack? | open | v0.1 now has templates plus `scripts/sos-init.ps1`; runtime comes later. |
| OQ-004 | Should `sos:audit` be allowed to modify files directly after approval, or only produce patch plans in v0.1? | open | Safer first behavior is proposed patches/plans. |
| OQ-005 | How should parent/child federated nodes publish summaries upward? | open | Need a simple summary file convention. |
| OQ-006 | Should `CLAUDE.md` and `AGENTS.md` be installed always, or only on request? | open | Current template includes both. |
| OQ-007 | What are the first profiles beyond core: legacy-code, workshop, research, greenfield-app? | open | Legacy-code likely first field test. |
