---
sos-file: system-readme
sos-version: 0.2.0
sos-schema: 1
sos-origin: packaged
sos-managed: true
type: readme
scope: node
status: active
---

# .sos

This is the tool-neutral SolutionOS project core.

Normal agents should start from `AGENTS.md`, `CLAUDE.md`, or another tool-native adapter. Those adapters point here when SOS context is needed.

Do not bulk-load `.sos/system/**` or framework internals during ordinary project work. Use them only for SOS install, audit, summary, upgrade, import, export, schema, or framework operations.
