---
type: produce-style
scope: node
status: active
---

# Presentation House Style

This file defines the defaults the agent loads into the `/sos:presentation-generate` Q&A. Edit it to encode the node's house style for presentation outputs.

If a field is left blank or as `(unset)`, the agent will ask during the Q&A.

## Audience

- **Primary:** (unset — e.g. board, leadership team, customers, investors, internal team, public)
- **Secondary:** (unset)
- **Background assumed:** (unset — e.g. technical depth, industry knowledge)

## Tone

- **Default:** (unset — e.g. professional, technical, persuasive, casual)
- **Avoid:** (unset — e.g. jargon, marketing language, hedging)

## Visual preferences

- **Brand colours:** (unset — list hex codes or named palette)
- **Logo / wordmark:** (unset — path to file or "do not include")
- **Typography:** (unset — e.g. sans-serif, specific font family)
- **Imagery style:** (unset — e.g. photographic, illustrated, abstract, none)

## Always include

- (unset — e.g. cover slide with title + date, an "agenda" slide, a "next steps" slide, a sources/credits slide)

## Never include

- (unset — e.g. team photos, internal financial figures, embargoed claims)

## Default output preferences

| Output | Default settings |
|---|---|
| Slide deck | format: presenter; length: medium |
| Infographic | orientation: landscape; detail: medium |
| Audio overview | format: brief; length: short |
| Video overview | format: explainer; visual style: corporate |
| Report | template: briefing |
| Quiz | quantity: default; difficulty: medium |

## Source rules

- **Default include from vault:** `vault/wiki/`, `vault/archive/`
- **Default include from outside vault:** (unset — e.g. specific paths)
- **Never include:** (unset — e.g. private notes, draft material)

## Custom instructions appendix

(unset — free-text appended to every generation prompt; use sparingly. E.g. "always cite the data source for any quoted figure.")
