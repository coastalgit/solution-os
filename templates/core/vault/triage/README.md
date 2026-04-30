---
type: vault-triage-readme
scope: node
status: active
---

# Triage

`vault/triage/` is the raw processing lane for this node's knowledge base.

Use it for:

- pasted notes
- raw meeting notes
- rough ideas
- source captures
- unprocessed research
- files that need classification
- material that may become wiki, archive, outbox, or work items

Triage is not permanent storage.

Processing flow:

```text
vault/triage
  -> classify
  -> update vault/wiki
  -> preserve evidence in vault/archive
  -> create outputs in vault/outbox when needed
```

