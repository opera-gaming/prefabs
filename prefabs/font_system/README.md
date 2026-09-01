# font_system

Reference an installed host font by family name — no TTF in the repo.

## When this is the wrong choice

The compiler rasterises at **build** time, so the runtime needs no host
fonts — but the build machine does. If CI does not have the family, the
build silently falls back to something else and your text changes shape
between your machine and the release.

Three ways out, in increasing order of commitment:

- **A fallback chain.** Make `family` a list; the first one present on the
  build machine wins.
- **A CSS generic** — `"sans-serif"`, `"serif"`, `"monospace"`. Always
  resolves, never exactly what you designed against.
- **`gmx tools font-freeze --project .`** bakes the rasterised glyphs into the repo. The
  font stops depending on the build machine entirely, at the cost of a
  binary in your tree and a re-freeze whenever the size changes.

Use a real `mode = "ttf"` font instead when the typeface is part of the
game's identity — a licensed display face is not something to leave to
whatever the build agent happens to have installed.
