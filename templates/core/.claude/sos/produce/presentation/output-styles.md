---
type: produce-style
scope: system
status: active
---

# Presentation Output Styles

Reference menu of NotebookLM output types and the styling knobs available for each. The agent reads this to know what to ask during the Q&A and what to write into the per-job manifest.

## Slide Deck

- **format:** `detailed` (more text per slide) | `presenter` (sparse slides + speaker notes)
- **length:** `short` (~5–10 slides) | `medium` (~15–25) | `long` (~30+)
- **CLI:** `notebooklm generate slide-deck "<instructions>" --format <format> --wait`
- **Download:** `notebooklm download slide-deck <path>.pptx`

## Infographic

- **orientation:** `portrait` | `landscape` | `square`
- **detail:** `low` (clean, minimal text) | `medium` | `high` (data-dense)
- **CLI:** `notebooklm generate infographic "<instructions>" --orientation <o> --detail <d> --wait`
- **Download:** `notebooklm download infographic <path>.png`

## Audio Overview

- **format:** `deep-dive` (long-form podcast) | `brief` (5–8 min) | `critique` (analytical) | `debate` (multi-voice)
- **length:** short | medium | long
- **CLI:** `notebooklm generate audio "<instructions>" --format <format> --wait`
- **Download:** `notebooklm download audio <path>.mp3`

## Video Overview

- **format:** `explainer` | `brief` | `cinematic`
- **visual style:** `corporate` | `casual` | `editorial`
- **CLI:** `notebooklm generate video --format <format> --style <style> --wait`
- **Download:** `notebooklm download video <path>.mp4`

## Report

- **template:** `briefing` | `study-guide` | `blog-post` | `custom`
- **CLI:** `notebooklm generate report "<instructions>" --template <template> --wait`
- **Download:** `notebooklm download report <path>.md`

## Quiz

- **quantity:** `fewer` | `default` | `more`
- **difficulty:** `easy` | `medium` | `hard`
- **CLI:** `notebooklm generate quiz --quantity <q> --difficulty <d> --wait`
- **Download:** `notebooklm download quiz <path>.json` (or `.md` / `.html`)

## Flashcards

- **quantity:** `fewer` | `default` | `more`
- **difficulty:** `easy` | `medium` | `hard`
- **CLI:** `notebooklm generate flashcards --quantity <q> --difficulty <d> --wait`
- **Download:** `notebooklm download flashcards <path>.json` (or `.md` / `.html`)

## Mind Map

- **CLI:** `notebooklm generate mind-map --wait`
- **Download:** `notebooklm download mind-map <path>.json`
- **Notes:** hierarchical structure; no styling knobs.

## Data Table

- **rows / columns:** described via natural-language prompt
- **CLI:** `notebooklm generate data-table "<row/column description>" --wait`
- **Download:** `notebooklm download data-table <path>.csv`

## Sequencing notes

- Each `generate` call takes 30–120 seconds. Always pass `--wait`.
- NotebookLM throttles parallel requests — run sequentially.
- Authenticate once via `notebooklm login` (browser session) before any generation.
