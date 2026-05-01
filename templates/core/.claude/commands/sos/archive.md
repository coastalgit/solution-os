---
name: sos:archive
description: Preserve non-active material in vault/archive with metadata, manifest update, and human-gated context capture.
disable-model-invocation: true
---

# /sos:archive

Use `/sos:archive <path-or-description> [context]` when material should be retained but should not remain active project working context.

## Protocol

1. Read `.claude/sos/COMMANDS.md`, `.claude/WORKFLOW.md`, `.claude/sos/SCHEMA.md`, `vault/archive/README.md`, and `vault/archive/_manifest.md`.
2. Inspect the target path without rewriting it. Identify whether it is `source-evidence` or `retained-record`.
3. If the context, value, ownership, date/period, or target archive name is unclear, start Q&A before touching files.
4. Present the proposed archive action with `(Y)ES`, `(N)O`, `(D)ISCUSS`, and `(C)ANCEL`.
5. On `(C)ANCEL`, stop immediately and leave files unchanged.
6. On approval, copy or move the material into `vault/archive/` using byte-preserving file operations.
7. Write archive metadata immediately and update `vault/archive/_manifest.md` in the same change.

## Preservation Rules

- Treat archive as preservation first, interpretation second.
- Do not decode, decrypt, normalize, re-save, pretty-print, or otherwise rewrite binary, encrypted, compressed, hash-mapped, generated, or vendor files.
- For hash-sensitive material, copy by default unless the user explicitly approves a move.
- Record SHA-256 hashes where practical, plus original path, archive path, action, archived date, kind, period, status, and notes.
- Do not extract current wiki knowledge automatically. Propose a follow-up wiki/outbox step if the archive material also needs processing.

## Manifest

Every archived item must be represented in `vault/archive/_manifest.md`.

Use `Processed Into` only when the archived item has already fed a wiki note, outbox item, decision, or other current artifact. Use `-` when the item is retained for history/context only.
