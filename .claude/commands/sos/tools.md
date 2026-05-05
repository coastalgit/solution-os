---
name: sos:tools
description: Show, verify, add, reject, and re-verify entries in the adopted-tools registry for this node.
disable-model-invocation: true
---

Run `/sos:tools` for this node.

`.claude/TOOLS.md` is the canonical adopted-tools registry. This command owns its lifecycle.

Read `.claude/TOOLS.md` and `.claude/sos/TOOLKITS.md`. Put the chat into a tools narrative and offer the following actions:

- **list**: show current adopted tools, their status, capabilities, limits, and `last-verified` dates.
- **verify**: pick an entry and re-confirm it against its source (docs/help/source). Update `last-verified` and any drifted fields. Flag entries older than 365 days.
- **add**: propose a new entry only after verifying capabilities in-session. Required fields: `status`, `kind`, `capabilities`, `limits`, `install / auth`, `source`, `last-verified`. Default new entries to `status: unverified` until capability is confirmed for the intended use.
- **park**: record a tool the user has flagged for later investigation, or that the agent has surfaced as worth a future look. Required: `status: parked`, `parked-reason` explaining the trigger that would justify re-evaluating. A parked entry must not be named in any proposal as adopted, primary, or preferred.
- **promote**: move a `parked` or `unverified` entry to `vetted` only after verifying capabilities in-session and recording `last-verified`.
- **reject**: move a tool to `## Rejected / Deprecated` with a `rejected-reason` so future sessions do not re-propose it.
- **gaps**: surface capability needs that have no covering entry, and ask the user to nominate or defer.

Do not name a tool in a proposal unless it is in `.claude/TOOLS.md` with `status: vetted` and a capability statement covering the use. See `.claude/STONE.md` and `.claude/WORKFLOW.md` for the full Tool-Naming Discipline rule.

Donor-source recommendations (skill files, package readmes, third-party docs) are candidates only. Surface the source and route them through verify-and-register before adoption.
