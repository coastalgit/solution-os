---
type: vault-archive-readme
scope: node
status: active
---

# Archive

`vault/archive/` stores non-active retained material.

Use it for:

- `source-evidence`: source files, raw captures, transcripts, exports, and other evidence after they have been processed into curated `vault/wiki/` knowledge, `vault/outbox/` deliverables, or decisions.
- `retained-record`: dated email trails, meeting notes, correspondence, old docs/temp folders, and other snapshots kept for retrospective value even when they are not feeding current wiki/outbox work.

Archive is preservation first and interpretation second. Do not rewrite binary, encrypted, compressed, hash-mapped, generated, or vendor files when archiving or unarchiving.

Use `/sos:archive <path-or-description> [context]` to move or copy material in with metadata and a manifest row.

Use `/sos:unarchive <archive-path-or-description> [context]` to copy material back out when it was filed in error or becomes relevant again. Keep the archive copy unless the user explicitly approves removing it.
