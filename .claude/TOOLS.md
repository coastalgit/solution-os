---
type: tools
scope: node
status: active
---

# TOOLS

TOOLS is the canonical adopted-tools registry for this SOS node.

It is local project/environment fact: the tools, libraries, CLIs, packages, services, and skills that this node has actually verified and adopted, plus the operational commands and environments available here.

For SOS-wide toolset preferences and adoption rules, read `.claude/sos/TOOLKITS.md` only during `/sos:*` or tool-choice tasks.

## Tool-Naming Discipline

The agent must consult this file before naming any tool, library, CLI, package, service, or skill in a proposal, plan, route, or recommendation.

A tool may be named in a proposal only if it has an entry below with `status: vetted` and a capability statement covering the proposed use.

If the tool is missing, has `status: unverified`, has `status: parked`, has no capability statement covering the use, or is `status: rejected` or `status: deprecated`, the agent must either:

- verify in-session by reading docs/help/source and propose an entry below, or
- propose in capability terms ("a tool that does X") and ask the user to nominate or confirm a tool.

Donor recommendations from skills, package readmes, third-party docs, or search results are candidates only. Surface them with source, mark them unverified, and follow the verify-and-register path before using them.

See `.claude/STONE.md` and `.claude/WORKFLOW.md` for the full discipline rule.

## Adopted Tools

Each entry must use this format:

```markdown
### <tool-name>

- **status:** vetted | unverified | parked | rejected | deprecated
- **kind:** library | cli | service | mcp | skill | package | api | environment
- **capabilities:** what it does well, in capability terms (one or more bullets)
- **limits:** what it cannot do, known failure modes, or coverage gaps (one or more bullets)
- **install / auth:** how to install or authenticate, plus current state in this node
- **source:** authoritative docs URL or repo
- **last-verified:** YYYY-MM-DD
- **parked-reason:** required when `status: parked`; explains the trigger that would justify re-evaluating
- **rejected-reason:** required when `status: rejected`; explains why so future sessions do not re-propose
- **notes:** optional
```

Use `status: unverified` for tools that have been recorded but whose capabilities have not been confirmed in-session. The agent must not name an unverified tool in a proposal without first re-verifying.

Use `status: parked` for tools the user has flagged for later investigation, or that the agent has surfaced as worth a future look — but that have not been evaluated yet and have not been adopted. A parked entry must include a `parked-reason` explaining the trigger ("if TypeScript becomes the project pivot", "fallback if Firecrawl rate-limits", etc.). The agent may mention a parked tool to the user as "user-flagged candidate" with its source and reason, but must not name it in any proposal, plan, or route as if it were adopted, and must not describe it as the "primary" or "preferred" anything. Promotion from `parked` to `vetted` requires the verify-and-register path.

Use `status: rejected` or `status: deprecated` to record tools that were evaluated and not adopted, so they are not re-proposed.

Re-verify entries when documentation moves, the tool changes major version, or `last-verified` is older than the node's verification cadence.

### Node.js

- **status:** vetted
- **kind:** environment
- **capabilities:** primary SOS CLI runtime; runs `bin/sos.js` for `sos install`, `sos audit`, `sos status`, `sos migrate`.
- **limits:** does not own external fetch, scraping, transcription, OCR, or LLM inference.
- **install / auth:** Node.js 18 or later required; no auth.
- **source:** https://nodejs.org/
- **last-verified:** 2026-05-05
- **notes:** required for the SOS CLI in this node.

### PowerShell

- **status:** vetted
- **kind:** environment
- **capabilities:** runs the read-only compatibility helpers under `scripts/` (source) and `.claude/sos/scripts/` (installed-node copies).
- **limits:** Windows-first; not the primary product surface; no SOS write actions.
- **install / auth:** preinstalled on Windows; no auth.
- **source:** https://learn.microsoft.com/powershell/
- **last-verified:** 2026-05-05
- **notes:** legacy/source helpers; the `sos` Node CLI is preferred for new install/audit/status/migrate work.

### nlm-presentation

- **status:** vetted
- **kind:** skill
- **capabilities:** drives Google NotebookLM (via `notebooklm-py`) to generate slides, infographics, audio overviews, video overviews, reports, quizzes, flashcards, mind maps, and data tables from source documents and YouTube URLs; runs a Q&A flow that produces a per-job manifest then executes generation; supports Mode 1 (new project) and Mode 2 (export capability into an existing project — fits SOS nodes).
- **limits:** requires interactive browser session for one-time `notebooklm login`; depends on the unofficial `notebooklm-py` automation against the NotebookLM web UI (breakage risk on UI changes); generation runs sequentially, 30–120s per output; not headless-CI-friendly.
- **install / auth:** installed globally via the `presenter-builder` repo at `C:\airesources\claudecode\projects\presenter-builder` (`python install.py`); already present in `~/.claude/skills/nlm-presentation/`. Requires `pip install "notebooklm-py[browser]"` and `playwright install chromium`. One-time `notebooklm login`.
- **source:** https://github.com/coastalgit/presenter-builder (local copy at `C:\airesources\claudecode\projects\presenter-builder`); upstream skill: `skills/nlm-presentation/SKILL.md`.
- **last-verified:** 2026-05-05
- **notes:** for SOS nodes, Mode 2 should target `vault/outbox/presentations/<slug>/` rather than `docs/presentation/`. The local SOS wrapper is `/sos:presentation-generate`, which loads defaults from `.claude/sos/produce/presentation/`.

### notebooklm-py

- **status:** vetted
- **kind:** cli
- **capabilities:** Python CLI that automates Google NotebookLM via Playwright; commands include `login`, `auth check`, `create`, `use`, `source add`, `generate <type>`, `download <type>`. Supported generation types: slide-deck, infographic, audio, video, report, quiz, flashcards, mind-map, data-table.
- **limits:** unofficial wrapper around the NotebookLM web UI; subject to breaking changes when Google updates the UI; sequential generation only (no parallel requests); auth state lives in a browser session; requires Chromium via Playwright.
- **install / auth:** `pip install "notebooklm-py[browser]"`; `playwright install chromium`; `notebooklm login` (browser, one-time).
- **source:** PyPI `notebooklm-py`
- **last-verified:** 2026-05-05
- **notes:** invoked by the `nlm-presentation` skill; not typically called directly by SOS commands.

## Build / Run / Test Commands

| Command | Purpose | Notes |
|---|---|---|
| `node .\bin\sos.js install --target <path>` | Propose missing SOS baseline files for a repository. | Writes only after prompt approval or `--yes`; never overwrites existing files; blocks writes when project version is newer or unreadable. |
| `node .\bin\sos.js audit --target <path>` | Read-only SOS structure audit. | Reports missing files/dirs, missing SOS frontmatter, and unreachable routing-surface paths. |
| `node .\bin\sos.js status --target <path>` | Read-only SOS health summary. | Reports metadata, vault counts, and audit counts. |
| `node .\bin\sos.js migrate --target <path>` | Read-only migration assessment. | Finds older project-memory and KB structures before migration work. |
| `npm test` | CLI and audit smoke test. | Checks CLI syntax and audits this repo plus `templates/core`. |

## Environments

| Environment | Purpose | Notes |
|---|---|---|

## External Services

| Service | Purpose | Notes |
|---|---|---|

## Parked / For Later Investigation

Record tools, libraries, packages, services, repos, or skills that the user or agent has flagged for future investigation but that have not been evaluated yet and are not adopted.

Each entry must use the same field set as adopted tools, with `status: parked` and a `parked-reason` explaining the trigger that would justify re-evaluating ("if TypeScript becomes the project pivot", "fallback if current Firecrawl rate-limits prove painful", etc.).

The agent must not name a parked entry in a proposal, plan, route, or recommendation as if it were adopted. The agent may surface a parked entry to the user as a candidate worth re-evaluating when its trigger condition appears, but the language must make the parked status explicit.

(none yet)

## Rejected / Deprecated

Record tools that have been evaluated and not adopted, or tools that were once adopted and are no longer recommended. Each entry must include a `rejected-reason` so future sessions do not re-propose them.

(none yet)

## Known Tool Issues

Record local tool issues here.

<!-- SOS:BEGIN adapter-shim v0.2.0 -->
This project uses SolutionOS.

Read `.sos/context/TOOLS.md` as the canonical SOS context for this file.

This Claude-shaped compatibility shim is version-controlled and may be updated by SOS, but only inside this managed block. Existing content outside the block must be preserved.
<!-- SOS:END adapter-shim -->
