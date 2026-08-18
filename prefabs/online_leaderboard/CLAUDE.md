# CLAUDE.md

> **Generated with gmx version 0.3.27.** If you're running a newer
> `gmx` (check `gmx --version`), ask the user whether to update this file by
> running `gmx refresh`. `gmx refresh` regenerates everything **above** the
> `<!-- gmx:notes:begin -->` marker in the "Notes" section near the end of
> this file — everything from that marker to the end of the file is your
> project's own and is never touched. Put per-project notes there, not in a
> separate file.

This is a GameMaker project in TOML form. `gmx` is the CLI; Source
of truth is the `*.toml` and `*.gml` files in this tree — never
write `.yy` or `.yyp`.

## gmx commands

The most useful subset, with the flags you'll reach for first:

```
gmx build <dir>                  produce <dir>.wad
gmx build <dir> --no-cache       bypass the incremental _BLD cache
gmx run <dir>                    build + launch the host runner. Quiet by
                                 default: prints a one-line verdict, not the
                                 runner's ~20KB boot log. -v for the full log
                                 (a failed run shows the log tail regardless).
gmx run <dir> --for 8            watch mode: boot, scan for fatal
                                 errors, exit non-zero on crash or
                                 zero after 8s clean run. Use this
                                 for any non-interactive workflow —
                                 the runner's modal error dialog
                                 would otherwise hang the session.
gmx run <dir> --headless         run the native runner windowless (renders
                                 offscreen, background-only process). Pair
                                 with --for/--timeout for CI/agents — no
                                 on-screen window to absorb stray clicks/keys.
gmx run <dir> --screenshot s.png boot headless, grab one PNG at frame 2, exit —
                                 the quickest "see the result". Deterministic
                                 (same pixels every run); no window, no daemon.
gmx run <dir> --screenshot s.png --at-frame 2,60,120
                                 capture several frames (→ s-002.png, s-060.png,
                                 s-120.png) to watch a transition settle. Bump
                                 the frame past a splash/fade. Reaching a game
                                 *state* (menus, input) needs gametest instead.
gmx run <dir> --wasm             run the gx.games (wasm) build locally in a
                                 browser instead of the host runner; add
                                 --headless --timeout 10 for CI/agents
gmx gametest run <t> --game <dir>
                                 deterministic headless test: bake inline-GML
                                 chunks, build, run, assert; exits 0 iff passed.
                                 For CI/agents — see "Gametests" below
gmx gametest bake <t> [-o <out>] compile a logical gametest to baked JSON only
gmx validate <dir>               schema + load + compile checks
gmx validate <dir> --no-compile  loader-only validation (faster)
gmx rename <dir> <old> <new>     rename a resource and propagate
gmx rename <dir> <old> <new> --dry-run
gmx import <yyp|yyz> <dir>       ingest a GameMaker IDE project
gmx new <kind> <name>            scaffold a resource (object, room,
                                 sprite, sound, script, font, shader,
                                 tileset) with the correct #:schema path;
                                 shader scaffolds a GLSL ES 3.00
                                 pass-through. run
                                 from the project dir or pass
                                 --project-dir <dir>. sprite/sound take
                                 --source <file>, tileset --source <spr>.
                                 set common fields at scaffold time instead
                                 of hand-editing afterward: object --parent
                                 <name> --persistent --solid; room
                                 --persistent; sound --audio-group <name>
                                 --volume <n>; font --mode ttf --source
                                 <file> (bundles source.ttf so the font
                                 validates clean immediately — default mode
                                 is "system", no file needed)
gmx new instance <room> <obj>    append a placed instance to the room's
                                 instances layer (--x/--y, --layer);
                                 the unique id is generated for you
```

Reference for GML built-ins **and** the gmx-authored toolchain
pages (events, variables, layers, scripts, prefab-spec,
vk_constants, getting-started, common-gml-patterns):

```
gmx docs lookup <name>           single-page reference
gmx docs search <query>          fuzzy search names + summaries
gmx docs list --category gmx     all first-party gmx pages
gmx docs list --kind recipe      end-to-end recipes for common patterns
gmx docs list --kind function    GML reference, by kind
gmx docs categories              every category in the index
```

`vk_left`, `vk_space`, etc. resolve to the `vk_constants` page
via keyword fallback. `gmx docs lookup` works on a fresh binary
with no setup — the full manual is embedded.

**Recipes are the canonical "how do I build X" implementations.**
Before generating GML or scaffolding objects from scratch for a
common feature (title screen, main menu, pause menu, audio, room
transitions, state-machine flow, custom cursor, …), check
`gmx docs list --kind recipe` first. When a recipe matches what
you're about to build, follow it verbatim — recipes encode
hard-won wisdom (compression modes, persistence patterns, input
event choices, frame-rate independence) that's easy to get wrong
from first principles. `gmx docs lookup anatomy-of-a-complete-game`
sketches how the recipes compose into a complete game.

## Gametests (automated testing)

A **gametest** (distinct from the docs "recipes" above — those are
how-to guides; a gametest is an executable test) is a JSON file that runs
the game **deterministically and headlessly** for a fixed number of frames,
plays scripted input, runs inline GML at chosen frames, and asserts on game
state — emitting a pass/fail `results.json` and a `0`/non-zero exit code.
Use it to verify behaviour without a human at the keyboard (CI, agent
loops, regression checks).

```
gmx gametest run mytest.gametest.json --game .     # bake + build + run + assert
```

Author a logical gametest (inline GML in `chunks`, a frame `timeline` of
`inputs`/`code`/`assert`/`screenshot`), then `gmx gametest run` bakes it,
builds the WAD, runs the runner headless, and prints `results.json`. Full
schema, field rules, and determinism notes: `gmx docs lookup gametest`.

## Prefabs (reusable assets from a catalog)

A **catalog** is a git repo whose `prefabs/<name>/` directories each hold a
prefab (sprites, objects, rooms, scripts, …), discovered via git tags
(`<name>@<version>`). Commands default to the `gh:opera-emoller/prefabs`
catalog; override any command with `--catalog gh:<user>/<repo>` (the only
catalog form — always a GitHub repo).

```
gmx prefab list                          every prefab in the catalog
gmx prefab list --tag <t> --category <c> filter (flags combine)
gmx prefab search <q>                     free-text over resources
                                          (name, kind, tags, description)
gmx prefab search <q> --kind sprite       restrict to one resource kind
gmx prefab show <prefab>                  manifest + resource list
gmx prefab tags                           every tag in use, with counts
gmx prefab versions <prefab>              published versions, newest first
gmx prefab add <ref> --into <dir>         add a prefab or one resource
gmx prefab sync --into <dir>              re-resolve linked prefabs' caches
```

**A ref is either a whole prefab or a single resource inside one:**

```
<prefab>                     a whole prefab   (e.g. iconic-animals)
<prefab>/<kind>/<name>       one resource     (e.g. iconic-animals/sprites/spr_cat)
gh:<user>/<repo>/<prefab>…   full form, names the catalog explicitly
…@<version>                  pin a version   (omit for the latest)
```

- `gmx prefab add <prefab> --into .` writes `prefabs/<prefab>/link.toml`
  (a pinned source); an implicit `sync` resolves it into a gitignored
  `.cache/`. Add `--vendor` to materialise the full resolved tree in place
  instead of linking.
- `gmx prefab add <prefab>/<kind>/<name> --into .` vendors just that one
  resource into `prefabs/<prefab>/<kind>/<name>` and writes a minimal
  `prefabs/<prefab>/prefab.toml` so the resource is **namespaced** (that
  manifest is what makes `::<prefab>::<resource>` resolve — see below).
  Add `--centre-origin` to set `origin = "centre"` on the vendored sprite(s)
  (gameplay usually wants this; catalog sprites often ship `top_left`).

**Worked example — grab a background + a player sprite and wire them up:**

```
gmx prefab add space-rocks-hd/sprites/spr_sky_nebula1 --into .
gmx prefab add iconic-animals/sprites/spr_cartoon_cat_ginger --into . --centre-origin
gmx new room  rm_main   --background "::space_rocks_hd::spr_sky_nebula1"
gmx new object obj_player --sprite    "::iconic_animals::spr_cartoon_cat_ginger"
gmx new instance rm_main obj_player --x 960 --y 540
# then author objects/obj_player/Step.gml for arrow-key movement
gmx validate . && gmx run . --screenshot boot.png
```

(Catalogs change — run `gmx prefab list` / `search` to see what yours actually
has, and `gmx prefab show <prefab>` to list a prefab's resource names. `add`
prints the exact `::ns::resource` ref to paste into TOML/GML.)

**Discovering ready-made behaviour.** Some prefabs are effectively
libraries — drop-in GML for common effects (screen shake, flashes, room
transitions). Prefer them over hand-rolling. There are no guaranteed prefab
names, so **discover what the catalog actually has** with `gmx prefab list`
and `gmx prefab search <effect>`, then `gmx prefab show <prefab>` for its
resources and API before writing your own.

**Prefab sprites usually need scale (and sometimes rotation)
adjustments per use case.** Catalog assets are original artwork —
they have no canonical "in-game size" or "facing direction":

- **Scale.** Catalog sprites often ship at the original artwork
  resolution (commonly 256–1024 px on a side), which is rarely the
  size you want at gameplay scale. Multiply at draw time with
  `image_xscale` / `image_yscale`. The swap-resilient idiom is to
  derive the scale from the sprite's actual width so swapping
  assets keeps the same on-screen size:
  `image_xscale = 48 / sprite_get_width(spr_X);`
- **Rotation.** There's no library-wide convention for which way a
  sprite "faces" — top-down characters / vehicles / projectiles
  in different packs may point up, right, or whatever the original
  artist chose. View the first frame after import and set
  `image_angle` in `Create.gml` if it doesn't already match your
  gameplay axis.
- **Origin.** Most gameplay code assumes a centred origin so
  `draw_self()` pivots around the centre and collisions feel right.
  Some packs ship sprites with `origin = "centre"` already set in
  `sprite.toml`; others default to `top_left`. Check the imported
  `sprite.toml`, or just pass `--centre-origin` to `gmx prefab add` to set
  it on vendored sprites at add time.

**Making changes to a linked prefab (patching)**

A linked prefab keeps its pinned `source` in `prefabs/<prefab>/link.toml` and
resolves the full tree into a gitignored `prefabs/<prefab>/.cache/`. Never edit
`.cache/` (it's regenerated on every sync) — instead **overlay** from the
prefab folder: a file you place under `prefabs/<prefab>/` at a resolved file's
relative path wins over the source.

- **Patch a file:** copy it out of `.cache/` to the matching path in
  `prefabs/<prefab>/` and edit the copy in full — the copy replaces the
  source file wholesale, `*.toml` included, so it must carry every field you
  want kept, not just the ones you're changing.
- **Remove/reset:** add the resource's path to `unset` in `link.toml`:

  ```toml
  source = "gh:opera-emoller/prefabs/cam-shake@1.2.0"
  unset  = ["sprites/spr_legacy"]
  ```

Sync runs automatically before validate/build/run, or re-resolve manually with
`gmx prefab sync --into .`. Track the overlay files and `link.toml` in git
(`.cache/` is gitignored); or re-add with `--vendor` to take full local
ownership (no `link.toml`).

## Referencing prefab resources: `::prefab::resource`

A prefab added under `prefabs/<prefab>/` is namespaced: refer to any
resource inside it with the `::<prefab>::<resource>` notation. The
leading `::`, the prefab folder name, `::`, then the resource name
(the prefab folder's `-`/`.` are normalised to `_`, so
`prefabs/camera-shake/` is the namespace `camera_shake`).

**The same spelling works in both TOML and GML** — one rule:

```toml
# objects/obj_x/object.toml — a prefab sprite as a resource ref
sprite = "::camera_shake::spr_asteroid"
```

`gmx new object <name> --sprite "::camera_shake::spr_asteroid"` writes that
`sprite =` field for you at scaffold time, so you don't hand-edit the TOML.

```gml
// Create.gml / Draw.gml — same reference in code
draw_sprite(::camera_shake::spr_asteroid, 0, x, y);
show_debug_message(sprite_get_name(::camera_shake::spr_asteroid));
::camera_shake::camera_shake(0.5, 0.1, 0.1, 0.1);  // call a prefab function
```

It lowers to the internal mangled name (`camera_shake__spr_asteroid`);
you always write the `::prefab::resource` surface form. Full rules:
`gmx docs lookup prefab-spec --category gmx`.

### A prefab sprite as a room background

The same `::prefab::resource` ref goes in a background layer's `[background]`
table, and `gmx new room --background` accepts it directly (auto-sizing the
room to the sprite — so pick a sprite whose aspect ratio matches the game you
want; a tall/portrait backdrop yields a tall/portrait room):

```
gmx new room rm_main --background "::scifi_space_shooter::sprBackground5"
```

```toml
# rooms/rm_main/layers/Background.toml
#:schema ../../../.gm-schema/v1.json#layer
kind = "background"
depth = 100

[background]
sprite = "::scifi_space_shooter::sprBackground5"
```

**Background layers don't auto-scale the sprite** — it's drawn at native size
from the top-left. Either size the room to the sprite (what `--background`
does, using `gmx sprite info <sprite-dir>` for the dimensions), or set
`tiled_x`/`tiled_y` on the `[background]` table to repeat it across a larger
room. A background sprite with alpha also needs an opaque fill behind it (see
"Common runtime traps").

## Project layout

```
.gm-schema/v1.json            JSON schema for every TOML file
project.toml                  schema_version, name, [room_order]
sprites/<name>/
  sprite.toml                 optional — #:schema …#sprite; omit for an all-default sprite
  frame_000.png               first frame (PNG or JPEG: .png/.jpg/.jpeg),
                              or a single vector frame_000.svg
  frame_001.png               (more frames as the sprite needs)
objects/<name>/
  object.toml                 #:schema ../../.gm-schema/v1.json#object
  Create.gml                  event scripts (one per event)
  Step.gml
  Draw.gml
rooms/<name>/
  room.toml                   #:schema ../../.gm-schema/v1.json#room
  layers/
    Instances.toml            #:schema ../../../.gm-schema/v1.json#layer
    Background.toml
    Tiles.toml
    Assets.toml
sounds/<name>/
  sound.toml                  optional — #:schema …#sound; omit for an all-default sound
  source.<wav|mp3|ogg>
scripts/<name>/
  <name>.gml                  the whole asset — there is no script.toml
shaders/<name>/
  vertex.vsh                  vertex source (required)
  fragment.fsh                fragment source (required)
  shader.toml                 optional — no configuration; just a schema anchor
fonts/<name>/
  font.toml                   #:schema ../../.gm-schema/v1.json#font
                              # mode = "frozen": needs sibling
                              #   atlas.png + glyphs.toml.
                              # mode = "ttf":    needs sibling
                              #   source.ttf (literal name);
                              #   rasterised at compile time.
                              #   Required: size. Optional:
                              #   bold, italic, anti_alias (bool),
                              #   texture_group, charset_ranges, sdf.
```

## Editing rules

- Every TOML's first line is
  `#:schema <relative-path>/.gm-schema/v1.json#kind`. Preserve it —
  that's how editors and `gmx validate` know the schema.
- `frame_NNN.png` (or `frame_NNN.jpg` / `frame_NNN.jpeg`) filenames
  are positional (zero-padded). Don't rename them. To reorder frames,
  change which file holds which bytes. A sprite may instead be a single
  vector `frame_000.svg` (tessellated at build). JPEG frames decode to opaque
  RGBA (handy for backgrounds) and may be mixed with PNG frames.
- For room layers: the `depth = N` field decides rendering
  z-order at runtime AND the on-disk order — layers are sorted
  by depth-ascending at load. The layer's name in
  `instance_create_layer(...)` etc. is the file stem
  (`Instances.toml` → `"Instances"`). Background layers stash
  their body under a `[background]` table inside a
  `kind = "background"` layer file. Full reference:
  `gmx docs lookup layers --category gmx`.
- Room order: `[room_order].order` in `project.toml` lists the
  rooms in play order — the first entry is the room the game
  opens with. It's optional: with a single room the order is
  implicit, so omit `[room_order]` entirely. The **first room's
  `size`** (`room.toml`'s `size = { width, height }`) sets the
  game's display/window dimensions — make the starting room the
  size you want the window to be. `window_set_fullscreen()` /
  `window_set_size()` calls have **no reliable effect under
  `gmx run`**'s dev runner — don't chase workarounds for this;
  see `gmx docs lookup window-fullscreen --category gmx`.
- Object event filenames are a closed grammar.
  `gmx init` ships the **native** form (`Create.gml`),
  `gmx import` the **imported** form (`Create_0.gml`). Match
  whichever the project already uses; full grammar at
  `gmx docs lookup events --category gmx`.
- Shaders are GLSL ES. They default to **GLSL ES 1.00**
  (`attribute`/`varying`/`gl_FragColor`); to write a **GLSL ES
  3.00** shader make `#version 300 es` the first line of the
  source (`in`/`out` + your own fragment output). `shader.toml`
  carries no configuration and may be omitted. **Match the
  project's existing shaders** — if they're ES 3.00, author new
  ones ES3 too; don't mix an ES1 shader into an ES3 project
  (it forfeits ES3 features and is inconsistent). Prefer ES 3.00
  when the project/runner supports it. Full reference:
  `gmx docs lookup shaders --category gmx`.
- **Never draw text with the default font.** The built-in font
  (`draw_set_font(-1)`) is a tiny bitmap; scaling it up for
  headings/labels is blurry and ugly. Create a sized font asset
  (`gmx new font <name>`, `fonts/<name>/font.toml` at the intended
  size), `draw_set_font(<name>)`, and draw at scale 1.
- Object-scope `[[variables]]` and the always-string
  room-instance override gotcha:
  `gmx docs lookup variables --category gmx`.
- An invisible "controller" object (game manager, spawner) can
  have an `object.toml` with only the `#:schema` line — no
  `sprite =` field needed.
- `gmx docs lookup <name>` covers GML built-ins **and** the
  first-party gmx pages above. `vk_left`, `vk_space`, … resolve
  to `vk_constants` via keyword fallback. `gmx docs list
--category gmx` enumerates the toolchain set.

## Physics shapes (declarative)

`[physics.body.shape]` in `object.toml` handles every Box2D fixture
case — no `bind_*_fixture` / `physics_fixture_set_*` calls needed in
`Create.gml`. Variants:

- `circle`, `aabb`, `polygon`, `edge`, `wire` (passthrough escape
  hatch).
- `polygon` accepts **any simple polygon** — convex or concave. The
  compiler decomposes inputs to fit the 32-vertex convex Box2D limit.
- `edge` defines a single line segment via `from = [x, y]` and
  `to = [x, y]`. Used for invisible barriers (one-way gates).
- Every variant supports `scale = "instance"` — when set, the runner
  multiplies vertices (and circle radius) by `image_xscale` /
  `image_yscale` at fixture-create time and reverses polygon winding
  for negative-on-one-axis scale (mirroring).

Points are in sprite-top-left coordinates; the runner subtracts the
sprite's origin (from `sprite.toml`'s `origin` / `custom_origin`)
before handing vertices to Box2D, so polygon authoring matches what a
tracing tool sees on the sprite image. Spriteless objects (e.g.
`edge` barriers) use body-local coords directly.

`gmx docs lookup physics-shapes --category gmx` has the full reference
with worked examples.

## Build-time TOML references in GML (`::path`)

GML can reference TOML values as compile-time literals via the `::`
sigil. The build resolves these to literal expressions before the GML
compiler sees the source.

```gml
// In obj_foo/Create.gml — resolves against the current object's TOML:
drag_hull   = ::physics.body.shape.points;
my_sprite   = ::sprite;

// Cross-resource form names another resource:
ball_origin = spr_ball::custom_origin;
game_name   = project::name;
```

Project-wide constants live in a `[constants]` table in `project.toml` and
are read with `project::constants.<key>` — the idiomatic way to avoid
duplicating a value (server URL, tuning number, flag) across objects:

```toml
# project.toml
[constants]
server_url = "https://api.example.com"
```

```gml
url = project::constants.server_url;
```

Constants resolve to literals at build time, so they're baked into the
compiled game and are **not** hot-reloadable: editing `[constants]` and
hot-reloading through the debugger won't change a running game (rebuild to
pick it up). Use `[constants]` for build-fixed values. For something you
want to tweak live while the game runs, put it on `global.<foo>` or a game
object's instance variable instead — those are runtime state hot reload can
change.

`gmx validate` flags broken references with a span pointing at the
failing token. `gmx-project-lsp` surfaces the same as a red squiggle.
`gmx rename <old> <new>` rewrites the resource prefix in
`<resource>::path` references for free (the lexer treats the prefix as
a plain identifier).

`gmx docs lookup tomlref --category gmx` for the syntax + scoping +
error cases.

## Runner version pin

When a project depends on runner features that are newer than vanilla
GameMaker (declarative concave polygons, edge shapes, `scale =
"instance"`), declare it in `project.toml`:

```toml
[runner]
min_version = "0.1.0.24"
```

The value is the four-part gmx runner version (e.g. `0.1.0.24`).
`gmx run` enforces it: if your installed runner is older it downloads a
new-enough one, and it errors if no available runner satisfies the
requirement. Omit `[runner]` for projects that run on any runner build.

## Publishing a prefab

A catalog is just a git repository, so publishing is just:

1. Place your prefab's source tree at `prefabs/<name>/` in a catalog repo you
   control (it must carry a `prefab.toml` at its root).
2. Run `gmx prefab reindex` at the repo root to (re)generate the committed
   `prefab-index.json`. Consumers fetch that one file instead of walking the
   whole tree, so regenerate it whenever prefabs change — before you tag.
3. Commit both (`prefabs/<name>/` and `prefab-index.json`) and push.
4. Tag the release following the `<name>@<version>` convention (e.g.
   `git tag iconic-animals@1.0.0 && git push --tags`). `gmx prefab versions`
   and `add …@<version>` discover versions from these tags; an untagged
   catalog resolves to its newest tag overall. The index is fetched _at_ the
   tag, so tag only after committing a fresh `prefab-index.json`.

Consumers then add it with `gmx prefab add gh:<owner>/<repo>/<name>`
(or `<name>` with `--catalog gh:<owner>/<repo>`).

## Verify before claiming done

```
gmx validate <dir>          # schema + loader + GML compile pass
gmx run <dir>                # launches the host runner interactively
gmx run <dir> --for 8        # watch mode, exits cleanly after 8s
```

A clean `gmx validate` is the strongest signal that an edit is
correct — it runs the full compile pipeline and surfaces any GML
lex/parse/codegen errors. It also emits GML lint **warnings**
(e.g. `draw-event-mutation`); when a flagged pattern is genuinely
intentional — like building a surface in a Draw event — silence
that one line with a trailing `//gmx-lint-ignore <code>` (or bare
`//gmx-lint-ignore` for all codes on the line / the next line).
For any non-interactive runtime check
(CI, agent, smoke test) use `gmx run --for <secs>` — it spawns
the runner with debug-log capture, scans for fatal patterns
("ERROR in action", "Unable to find function", "Failed to load",
premature exit), force-quits on detection, and exits non-zero
with the captured log. On a clean run it boots, lets the game
tick for `<secs>`, then quits zero. Without `--for`, a runtime
crash pops a modal dialog that will hang any non-interactive
workflow.

The Mac runner prints unconditional `NSLog` lines before any
game code runs (`Nil context detected`, `!!!!######## rendersize=…`).
They're cosmetic, not warnings — ignore them when scanning for
real `Warning!` / `ERROR` lines.

## Debugging and driving a running game

`gmx debug` runs a live runner and lets you inspect and _modify_ a
running game from the CLI — use it to verify behaviour, not just
`gmx run`. Verbs target the current directory's project by default; pass
`--project <dir>` to target another.

**Prefer headless verification.** Default to a windowless run unless you
expect the _user_ to drive the window: `gmx debug start --headless`,
`gmx run --headless`, `gmx gametest` (always headless), or
`gmx debug start --wasm --headless`. A windowed runner left on screen
absorbs the user's clicks/keys into the debug-input channel
(`keyboard_lastkey`, mouse state) and corrupts your readings — you will
chase phantom bugs that came from the user's stray input, not the game.
`--headless` renders offscreen as a background-only process, so
`screenshot`/`capture` and every other verb still work exactly the same.
Only run windowed when you specifically need the user to play the game
and report what they see.

There are **two ways to drive it** — pick by how you need to react:

**A. Discrete steps (most tasks): per-verb `--json`.** Each verb is one
command that returns one JSON envelope — issue it, read the result,
decide the next. Simplest and most common:

```
gmx debug start --headless              # build --debug, launch windowless, attach
                                        # (preferred default — see "Prefer
                                        # headless verification" above)
gmx debug start                         # same, but windowed (only when the user
                                        # drives the game)
gmx debug bp set objects/obj_player/Step.gml:14
gmx debug continue
gmx debug wait --timeout 5 --json       # block until the next stop
gmx debug describe --json               # where am I: state, location, stacks, globals, log tail
gmx debug eval 'global.score' --json
gmx debug stop
```

**B. Event-driven (react to stops without polling): a backgrounded
session.** Run `gmx debug session --json` as a _background_ process and
write `ClientRequest` lines to its stdin. It streams newline-JSON events
on stdout — `stopped` (with `file`/`line`/`reason`), `log`, `running`,
`exited` — so you get woken when a breakpoint hits instead of burning a
turn on `wait`. Use this when you set a breakpoint, `continue`, and want
to be told when it fires. The session owns the runner and reaps it on
exit, so you don't leak a hung session.

```
# (run in background) gmx debug session --json
# stdin:  {"verb":"bp_set","location":"objects/obj_player/Step.gml:14"}
# stdin:  {"verb":"continue"}
# stdout: {"schema":"gmx-debug/1","type":"event","event":"stopped","reason":"breakpoint","file":"...","line":14}
```

**Read values — use the `json` field.** `eval '<expr>'` evaluates one GML
expression. Responses carry a `value` display string AND a structured
**`json`** field: scalars as native JSON, and arrays followed + recursed,
so `eval 'global.angles' --json` gives `[0,90,180]` instead of
`array @0x…`. Prefer `json`. (Expansion needs the value to persist —
introspect stored state, not a throwaway literal, which may be GC'd.)

**Dump instances.** `gmx debug instances <obj> --json` returns every live
instance of an object with its built-in (x, y, image_angle, …) and user
variables as JSON — one call instead of N per-instance probes:

```
gmx debug instances obj_enemy --json
```

**Modify live state.** `runscript` runs full GML _statements_ for their
side effects — assignment, `var`, `with`, loops, new globals — and an
optional trailing `return <expr>;` reads a value back:

```
gmx debug runscript 'global.score = 0;'
gmx debug runscript 'with (obj_enemy) hp = 50;'
gmx debug runscript 'repeat (5) instance_create_depth(64, 64, 0, obj_coin);'
gmx debug runscript 'global.n = instance_number(obj_coin); return global.n;'
```

A failed `eval`/`runscript` returns `kind:"error"` and a non-zero exit —
trust the exit code; a silent no-op won't read as success.

**Hot-reload code without a rebuild.** Edit an object event's
`objects/<obj>/<event>.gml`, then push it into the _already-running_ game:

```
gmx debug reload obj_player Step          # the edited Step runs next frame
gmx debug reload obj_player Step --revert  # restore the original
```

No `gmx build`, no relaunch — iterate on behaviour in seconds against the
live world (the enemies are still on screen, the score is still 9000).
`runscript` mutates _state_; `reload` swaps _code_. Together they let you
test a fix without losing the game state that triggered the bug.

**Hot-reload art without a rebuild.** `reload-sprite` swaps a sprite's
pixels live — every instance and asset-layer entry drawing it updates next
frame:

```
gmx debug reload-sprite spr_player            # re-read sprites/spr_player/ and push it
gmx debug reload-sprite spr_player --from new.png   # swap in an arbitrary image
```

Tweak a PNG in `sprites/<name>/` and see it in the running game without a
build. (Prefab-provided sprites aren't in the project `sprites/` tree —
use `--from` for those.)

**See what's on screen.** `gmx debug screenshot -o shot.png` captures the
live frame — read the PNG back to _verify your hot-reload actually looks
right_, not just that the call succeeded.

A typical live-debug loop: `bp set` → `continue` → inspect with
`describe`/`instances`/`eval` → fix with `runscript` (state) or `reload`
(code) → `screenshot` to confirm → `continue`. All without rebuilding.

**Debug the gx.games (wasm) build in a browser.** `gmx debug start --wasm`
runs the game in a Chromium-family browser (the actual gx.games target) and
attaches the debugger over a WebSocket — **every verb above works exactly the
same** (`eval`, `runscript`, `instances`, breakpoints, …). Add `--headless`
for CI/agents. Use this to reproduce browser-only behaviour; the native
`gmx debug start --headless` stays the default for everyday work.

**One-shot verbs** (also usable standalone against a `gmx debug start`
daemon):

```
gmx debug start --headless       build --debug, launch windowless, attach (preferred default)
gmx debug start                  same, but windowed (only when the user drives the game)
gmx debug start --wasm [--headless]   debug the gx.games (wasm) build in a browser; all verbs work the same
gmx debug session [--json]       owned, event-streaming session (preferred)
gmx debug describe --json        one-shot orientation snapshot (paused state, location, stacks, globals, watches, log tail)
gmx debug bp set <file:line> [--cond <expr>]   set a (conditional) breakpoint
gmx debug continue / pause / step [in|over|out]
gmx debug wait [--timeout secs]  block until the next stop event
gmx debug eval '<expr>'          evaluate a GML expression; response has a structured `json` field
gmx debug runscript '<gml>'      run GML statements (assignment, with, loops); trailing `return <expr>;` reads a value back
gmx debug instances <obj> --json dump every live instance of an object with its vars as JSON
gmx debug reload <obj> <event> [--revert]   hot-reload an event's GML into the running game
gmx debug reload-sprite <spr> [--from x.png]   live-swap a sprite's pixels (no rebuild)
gmx debug screenshot -o shot.png grab the whole game screen to a PNG
gmx debug stack / locals / selfvars / globals   inspect the paused frame
gmx debug watch add '<expr>'     persistent watch, re-evaluated on every stop
gmx debug input key <key>        synthesise a keypress
gmx debug input mouse <btn> --at X Y   synthesise a click
gmx debug stop                   tear down daemon + runner
```

Drop into an unknown session with `gmx debug describe --json` for a
single-shot snapshot before issuing more verbs.

## Common runtime traps

These produce a successfully-validated, successfully-built game
that renders empty / wrong on launch. `gmx validate` won't catch
them — they're runtime semantics, not schema or compile errors.

- **`enable_views = true` in `room.toml`** turns on GameMaker's
  view-camera system. Without per-view fields configured
  (`camera_*`, `viewport_*`) the runtime renders nothing visible.
  Leave `enable_views` unset (= default `false`) unless you actually
  need cameras — most small games don't, and the room's `view`
  size already controls the rendered area.
- **Transparent sprite on a Background layer** lets whatever's in
  the framebuffer show through the alpha pixels — usually garbage.
  If your background sprite has an alpha channel (parallax /
  overlay sprites — stars, fog, light shafts, weather — are
  commonly authored to layer _on top of_ something else), add a
  second `Background.toml` at a HIGHER `depth` (drawn first /
  further back) with `[background] colour = "#0a0014"` (or any
  opaque colour) to fill behind it. The transparent sprite then
  composites correctly over the solid colour.

## If stuck

- Read sibling files of the same kind to see the expected shape.
- `gmx schema show <kind>` prints the JSON-schema definition
  for any TOML kind (`object`, `sprite`, `room`, `layer`,
  `sound`, `script`, `font`, `tileset`, `sequence`,
  `particle_system`, …). `gmx schema show` (no argument) lists
  every kind.
- `gmx docs lookup <name>` covers GML built-ins **and** the
  first-party gmx pages. Try `gmx docs list --category gmx` for
  the toolchain set; `gmx docs lookup getting-started --category
gmx` for a first-five-minutes walkthrough.
- `gmx prefab show <prefab>` lists a catalog prefab's resources;
  `gmx prefab search <q>` finds assets to reuse.

## Prefab authoring (this is a prefab project)

This project is a **prefab** — authored to be published to a gmx prefab
catalog and reused in other projects, not just run as a standalone game.

**What makes it a prefab** is the `prefab.toml` at the project root. Its
presence is what namespaces the prefab's resources when a consumer adds it —
there is no export list and no public/private tier. Namespacing is uniform, so
every resource is referable as `::<prefab>::<name>` once added.

**`prefab.toml` (discovery metadata only; all fields optional):**

```toml
name = "Camera Shake"                      # falls back to the folder name
description = "Smooth camera trauma and shake."   # one-line, for list/search
category = "effects"                       # optional single grouping
tags = ["camera:shake", "style:juice"]     # discovery tags, `facet:value`
asset_bundle = false                       # true = individual assets can be imported independently;
                                           # false = assets have dependencies and must be imported as a whole

# Demo-only resources: present so `gmx run` works here, but kept out of the
# published index and out of what consumers pull. `<kind-dir>/<name>` keys.
exclude = ["objects/obj_demo", "rooms/rm_demo"]

# Optional per-asset metadata (surfaced in search), keyed by "<kind-dir>/<name>":
[assets."scripts/scr_cam_shake"]
description = "camera_shake(time, mag) — trauma-based shake."
tags = ["role:api"]
```

Curate `description` / `category` / `tags` by hand — that's your job as the
agent; gmx doesn't generate them.

**The demo is demo-only.** `rm_demo` and its driver object let you `gmx run` /
`gmx validate` the prefab standalone while authoring. The scaffold lists them
in `exclude` (above), so they stay in your tree but never reach the published
index or a consumer. Add any other author/test-only resources to `exclude`
too; drop the list once a resource becomes part of the real surface.

## Deriving from a parent (`[parent-link]`)

A variant prefab derives from a published (or sibling, still-unpublished)
base instead of duplicating it, by adding a `[parent-link]` table to its own
`prefab.toml`:

```toml
name = "Camera Shake (Heavy)"
description = "A heavier variant of Camera Shake."

[parent-link]
source = "cam-shake"                 # see the two forms below
unset  = ["scripts/scr_cam_legacy"]  # optional: drop inherited files/resources
```

At resolve time the parent's whole tree is fetched and your own files are
overlaid on top: any file you carry at a given path replaces the parent's
file there wholesale (`*.toml` included — there's no field-level merging, so
a file overriding an inherited one must carry every field it needs, not just
the ones that differ). `unset` works exactly like a consumer `link.toml`'s:
a path (`sprites/spr_legacy`) drops an inherited file/resource.

**`source` has two forms:**

```toml
source = "cam-shake"                              # implicit: same catalog as this prefab
source = "gh:<owner>/<repo>/cam-shake@1.0.0"      # explicit: any catalog
```

The **implicit** form (no `gh:` prefix) is only legal inside `[parent-link]`
— it means "the parent lives in this same catalog", and is what makes
authoring and testing a derived prefab possible with **no catalog at all**
(see below). The **explicit** form names any catalog and always resolves over
the network; use it to derive from a prefab published somewhere else.

### Testing a derivation — fully offline, no catalog required

With the implicit form, `gmx run` / `gmx validate` / `gmx build` /
`gmx gametest` resolve `[parent-link]` **in place**, straight from your
working tree: they look for the parent as a **plain sibling directory**
(a folder of the same name next to your prefab dir, carrying its own
`prefab.toml`) and merge it in on disk — no `--catalog`, no `gh:` ref, no
network, no publishing. This is the easiest way to verify a derivation while
authoring, and it's what makes the implicit form worth reaching for even for
a prefab you never intend to publish standalone.

```sh
# The base: a normal scaffolded prefab, so it runs standalone and has
# something to inherit from.
gmx init --prefab sandbox/cam-shake

# The derived variant: just a prefab.toml, next to it.
mkdir sandbox/cam-shake-heavy
cat > sandbox/cam-shake-heavy/prefab.toml <<'EOF'
name = "Camera Shake (Heavy)"

[parent-link]
source = "cam-shake"
EOF

gmx validate sandbox/cam-shake-heavy   # resolves cam-shake from the sibling dir, offline
```

`sandbox/cam-shake-heavy/.cache/` now holds the merged tree (gitignored,
regenerated on every run — never hand-edit it). This only stays offline while
every hop in the chain uses the implicit form and has a real sibling
directory; the moment a hop names an explicit `gh:...` source, resolution
falls through to the network for that hop (and every hop above it) — which
also means the same mechanism verifies a real multi-catalog chain once you
point `source` at a published parent.

## Publishing

A catalog is a git repo of `prefabs/<name>/` directories:

1. Place this prefab's tree at `prefabs/<name>/` in your catalog repo.
2. Run `gmx prefab reindex` at the catalog root to regenerate
   `prefab-index.json` — consumers fetch that one file instead of walking the
   whole tree.
3. Commit both, then tag the release `<name>@<version>` (e.g.
   `git tag cam-shake@1.0.0 && git push --tags`). The index is fetched *at* the
   tag, so tag only after committing a fresh `prefab-index.json`.

Consumers then add it from any project:

```sh
gmx prefab add gh:<owner>/<repo>/cam-shake --into <consumer-project>
```

This writes a pinned `prefabs/cam-shake/link.toml` and namespaces every
resource under the folder name — call it as `::cam_shake::<name>` in TOML and
GML (folder `-`/`.` normalised to `_`). Add a single resource with
`gmx prefab add gh:<owner>/<repo>/cam-shake/<kind>/<name>`, or `--vendor` to
copy the resolved tree in instead of linking. A derived prefab's
`[parent-link]` chain resolves the same way for a consumer as it does for you
locally — the consumer never has to know the prefab is derived.

Keep `README.md` and `LICENSE` present, and finalise them before publishing.

## Version Control (Git)

This project is structured for Git. To initialize your repository and track changes:

```bash
git init
git add .
git commit -m "Initial commit from gmx scaffold"
```

Before committing large binary assets, ensure you configure a .gitignore file

## Notes

<!-- gmx:notes:begin -->
Add project-specific notes below this line. `gmx refresh` regenerates everything above `<!-- gmx:notes:begin -->` from the installed gmx version's template but never touches anything from that marker to the end of the file, so hand-written notes here are always safe.
<!-- gmx:notes:end -->
