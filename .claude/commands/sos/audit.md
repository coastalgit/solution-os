---
name: sos:audit
description: Read-only state report for this SOS node. Reports only — never proposes or applies changes.
disable-model-invocation: true
---

Run `/sos:audit` for this node. Read-only. Report only.

## Output — five lines maximum

1. **Versions.** Project SOS version (from `.claude/sos/sos.json`) and running CLI version. State whether they match.
2. **Missing required files.** One count, drawn from comparison against `.claude/sos/SCHEMA.md`.
3. **Vault counts.** Triage / wiki / archive / outbox item counts.
4. **Actor / concept gaps.** Count only — do not enumerate.
5. **Next action.** One pointer:
   - Files missing → *"Run `/sos:init` to create them."*
   - Versions drift → *"See `CHANGELOG.md` for upgrade notes."*
   - Otherwise → *"Healthy."*

## Constraints — non-negotiable

- **No multi-tier repair proposals.** No `Tier A / Tier B` structure. No `B1 / B2 / B1+B2` enumerations.
- **No prompts, no questions, no choice menus.** Read, report, exit.
- **No file writes.** Audit never modifies the node.
- **Do not invoke the tool-naming-discipline rule.** Audit is static state; nothing is being named in a proposal.
- **Do not propose append-only amendments to existing files.** Drift in existing-file content is reported as a single line ("project at v0.1.X, current is v0.1.Y") and the user is pointed at `CHANGELOG.md`. Audit does not enumerate file-by-file diffs.

If the user wants to fix anything reported, they run `/sos:init` (for missing files) or read `CHANGELOG.md` (for upgrade actions). Audit itself never writes and never deliberates.
