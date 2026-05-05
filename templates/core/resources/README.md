---
type: lane-readme
scope: node
status: active
---

# resources/

This is the **private input lane** for an SOS node.

It is **Git-ignored** by default. Place private, sensitive, copyrighted, or pre-release material here when you do **not** want the source bytes to enter the public-facing vault or the Git history.

Examples of material that belongs here:

- financial documents
- marketing assets that are not yet public
- customer or PII material
- copyrighted reference material
- internal manuals or third-party docs you cannot redistribute
- pre-release decks, drafts, embargoed material

## What happens to material in `/resources/`

- The agent may **read** it during ingestion.
- The agent may write **user-approved summaries** of it into `vault/wiki/` — that summary is what goes into Git, not the source.
- The agent **must not** copy raw bytes from `/resources/` into `vault/triage/`, `vault/wiki/`, `vault/archive/`, or `vault/outbox/`.
- The agent **must surface** that the source is private before any wiki write, so you can verify the summary does not leak specifics that need to stay private.

## How to ingest from here

```text
/sos:ingest /resources/<file-or-folder> as <intent>
```

The `/sos:ingest` command detects the `/resources/` path and switches into **private-source mode** — extra approval gates, no raw-bytes leak, summary-only flow into the wiki.

## Removing this directory

If you do not want a private-source lane in this node, you can simply delete `/resources/` and remove the corresponding entry from `.gitignore`. SOS does not require this lane to be present — it only auto-creates it on install if missing, and never touches its contents afterwards.
