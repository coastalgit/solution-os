---
type: lane-readme
scope: node
status: active
---

# resources/

Git-ignored private input lane. Drop private, sensitive, copyrighted, or pre-release material here.

The agent may read material from `/resources/` during ingestion but must never copy raw bytes into `vault/`. Only user-approved summaries reach `vault/wiki/`.

To ingest: `/sos:ingest /resources/<file> as <intent>`.
