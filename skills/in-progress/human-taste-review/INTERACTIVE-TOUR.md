# Building the tour

Do not write HTML, CSS, or JavaScript. Copy
[TOUR-TEMPLATE.html](./TOUR-TEMPLATE.html) into the scratchpad, replace the one
JSON block at the top, and `open` it.

```
cp TOUR-TEMPLATE.html "$SCRATCH/pr-4821-tour.html"
# edit only the <script type="application/json" id="tour-data"> block
open "$SCRATCH/pr-4821-tour.html"
```

The template is the design. A tour that looks different from the last one is a
bug, not a flourish.

## The data contract

```json
{
  "repo": "wandb/core",
  "pr": 4821,
  "url": "https://github.com/wandb/core/pull/4821",
  "headline": "The backfill sensor stops seeing its own runs",
  "whyMissing": false,
  "stations": [
    {
      "title": "Why this change",
      "narration": ["One sentence.", "Another sentence."],
      "excerpt": {
        "label": "the guard that misreads an empty list",
        "file": "sensors/backfill.py",
        "code": "-    if not runs:\n+    if runs is None:"
      }
    }
  ]
}
```

| field | required | notes |
|---|---|---|
| `repo`, `pr` | yes | rendered as `wandb/core #4821` |
| `url` | no | derived from `repo` and `pr` when absent |
| `headline` | yes | your sentence, not the PR title, if the title is useless |
| `whyMissing` | no | `true` renders the honesty-rule callout above station one |
| `stations[].title` | yes | short. It is a wall label, not a summary |
| `stations[].narration` | yes | **one string per sentence** |
| `stations[].excerpt` | no | omit it when the prose carries the point alone |

`narration` is an array because the array *is* the speech chunking — long
utterances get truncated by the speech API, and the per-sentence split is also
what drives the progress line. One long string per station breaks both. Do not
put an identifier, a path, or a line number in a narration string; those belong
in `excerpt`, which is never spoken.

`excerpt.code` is raw diff text. Lines starting with `+` or `-` are coloured
automatically. Show the changed lines and just enough around them to parse.

## What the template already handles

Left alone, so no session re-solves it:

- Station tracking, the numbered rail, click-to-jump.
- Listen mode: narration drives, the page follows. Sentence-by-sentence
  highlight and the progress line across the card.
- The speech API's two traps — `getVoices()` empty on first call, and stale
  `onend` handlers firing after `cancel()` and double-advancing the cursor.
- Light and dark palettes, down-to-mobile layout, visible keyboard focus,
  `prefers-reduced-motion`.
- Narration is visible text that speech reads, never audio-only.

## Design tokens

Cool gallery light, not warm paper. The whole page is grey and ink; `--signal`
appears only where something is active.

| token | light | role |
|---|---|---|
| `--paper` | `#EDEFF2` | gallery wall |
| `--card` | `#FFFFFF` | the label card |
| `--ink` | `#16202B` | body text |
| `--ink-soft` | `#5A6B7C` | unspoken sentences, secondary |
| `--signal` | `#2F5BD0` | active station, listening, disclosure |
| `--vitrine` | `#DDE3E9` | glass behind code |

Optima for station titles — the gallery typeface, on every Mac, no webfont
needed because the tour opens from `file://`. Charter for narration: a serif
built for legibility, at a 62ch measure. Code is set small on purpose.

## The check

Open the file. Station one is active in the rail, an excerpt opens and closes,
and the Listen toggle starts narration on station one and stops it on
toggle-off. That is the whole check.
