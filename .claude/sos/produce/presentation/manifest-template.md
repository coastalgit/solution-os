---
type: produce-manifest
scope: job
status: draft
---

# Presentation Manifest

This is the contract for one presentation generation job. The agent fills it during the `/sos:presentation-generate` Q&A and saves it to `vault/outbox/presentations/<slug>/nlm-manifest.md`. Generation reads it. If the user changes a selection later, only the affected section is updated — the full Q&A does not re-run.

## Job

- **slug:** (e.g. `2026-q3-board-update`)
- **created:** YYYY-MM-DD
- **node:** (this SOS node's name)

## Topic

- **subject:** (1–2 sentences)
- **audience:** (board / team / customers / investors / public)
- **tone:** (professional / technical / persuasive / casual)

## Outputs requested

Tick all that apply:

- [ ] Slide Deck — format: `presenter` / `detailed`; length: `short` / `medium` / `long`
- [ ] Infographic — orientation: `portrait` / `landscape` / `square`; detail: `low` / `medium` / `high`
- [ ] Audio Overview — format: `deep-dive` / `brief` / `critique` / `debate`; length: `short` / `medium` / `long`
- [ ] Video Overview — format: `explainer` / `brief` / `cinematic`; style: `corporate` / `casual` / `editorial`
- [ ] Report — template: `briefing` / `study-guide` / `blog-post` / `custom`
- [ ] Quiz — quantity: `fewer` / `default` / `more`; difficulty: `easy` / `medium` / `hard`
- [ ] Flashcards — quantity: `fewer` / `default` / `more`; difficulty: `easy` / `medium` / `hard`
- [ ] Mind Map
- [ ] Data Table — row/column description: (free text)

## Sources

- **From vault:** (paths under `vault/wiki/` and `vault/archive/`)
- **From outside vault:** (paths or URLs — YouTube URLs are valid sources)
- **Excluded:** (anything explicitly out of scope)

## Style

- **Inherits from:** `.claude/sos/produce/presentation/house-style.md`
- **Overrides for this job:** (any deviations from house style)

## Design reference

- **Reference image / deck:** (path or "none")
- **Conclusions to apply:** (orientation, density, palette, etc.)

## Custom instructions

(free text — anything to emphasise, exclude, or frame differently for this job)

## Output destination

- **Folder:** `vault/outbox/presentations/<slug>/`
- **Naming:** default — see `output-styles.md`

## Status

- **Manifest written:** YYYY-MM-DD
- **Generation started:** (set when generation begins)
- **Generation completed:** (set when last download finishes)
- **Notes:** (any retries, fallbacks, or issues encountered)
