---
name: sos:unarchive
description: Reactivate or copy archived material out of vault/archive with metadata, manifest update, and human-gated context capture.
disable-model-invocation: true
---

# /sos:unarchive

Use `/sos:unarchive <archive-path-or-description> [context]` when archived material was filed in error or has become relevant again.

## Protocol

1. Read `.claude/sos/COMMANDS.md`, `.claude/WORKFLOW.md`, `.claude/sos/SCHEMA.md`, `vault/archive/README.md`, and `vault/archive/_manifest.md`.
2. Locate the archive item and its metadata/manifest row before proposing any action.
3. If the destination, reason for reactivation, ownership, or desired treatment is unclear, start Q&A before touching files.
4. Present the proposed unarchive action with `(Y)ES`, `(N)O`, `(D)ISCUSS`, and `(C)ANCEL`.
5. On `(C)ANCEL`, stop immediately and leave files unchanged.
6. On approval, copy the archived material to the chosen active location by default. Move it only if the user explicitly asks to remove the archive copy.
7. Update archive metadata and `vault/archive/_manifest.md` in the same change.

## Preservation Rules

- Preserve the archived copy by default; unarchive usually means "copy out and reactivate."
- Do not decode, decrypt, normalize, re-save, pretty-print, or otherwise rewrite binary, encrypted, compressed, hash-mapped, generated, or vendor files.
- Verify SHA-256 hashes where they exist before and after copy/move operations.
- Record destination path, unarchived date, action, reason, and whether the archive copy remains.
- If the item now needs wiki/outbox processing, propose that as a separate follow-up unless the user explicitly includes it in the same instruction.
