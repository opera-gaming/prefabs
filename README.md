# GMX Prefabs

The prefab catalog for [gmx](https://github.com/opera-gaming/assetcompiler).
`gmx prefab` commands resolve `gh:opera-gaming/prefabs` by default, so a
prefab published here is reachable as `gmx prefab add <name>`.

```
prefabs/<name>/         one prefab per directory
prefab-index.json       generated — never hand-edit (see Publishing)
```

## What every prefab carries

| File | |
|---|---|
| `prefab.toml` | The manifest. Identity comes from the directory name and git tags, not from this file. |
| `README.md` | What it is and how to use it. Stays in the repo — it is not installed into a project. |
| `LICENSE` | Required. MIT for code prefabs, Apache-2.0 for the art and audio packs. |
| `project.toml` | Makes the prefab runnable on its own: a `[room_order]` naming its demo rooms. Without it `gmx run <dir>` refuses the directory, and there is no way to take a thumbnail. |
| `thumbnail.png` | Produced with `gmx run <dir> --screenshot thumbnail.png --at-frame <n>`. Present wherever there is something to draw — see below. |

A playable prefab also carries `demo.gametest.json` — a test that boots it
and asserts the loop it exists to demonstrate. Run the suite with
`just test-prefabs <catalog>` from the gmx repo; gmx's own CI does.

Everything a thumbnail needs comes from a **demo**: an `obj_demo` and an
`rm_demo` that stand the prefab up on its own, both named in `exclude`.
`exclude` describes what a *dependency* hands its dependent, so a prefab
pulled in through someone else's `requires` never sees them — while
`gmx prefab add <name>` keeps them, because there the prefab is the subject
and its demo is the runnable form of it. A prefab with no demo cannot be run,
so it cannot be pictured — and, less obviously, nothing ever exercises it:
`main_menu` shipped with `[[content.items]]` that had no `id`, so `obj_menu`
died in its own Create the first time it was placed in a room. Writing the
demo is what found that.

Two things the demo has to supply itself, because neither exists until a
consumer installs the prefab:

- **The kernel is not booted.** Anything reaching `::kernel::` reads a
  global that was never set, and dies naming a kernel script rather than
  the caller. The demo calls `::kernel::kernel_boot()` in its Create.
- **`<prefab>_tuning()` is generated at install**, not present in the
  source tree. A demo run straight from the prefab directory cannot call
  it; run it from an installed project instead.

## Two kinds of prefab

**Asset packs** declare `asset_bundle = true` and describe their resources
in `[assets."<kind>/<name>"]` blocks so individual sprites and sounds are
searchable and independently importable.

**Code prefabs** declare `schema_version = 1` and an `install` mode:

- `install = "namespace"` (the default) — a **library**. Lands in
  `prefabs/<name>/` in the target project, every symbol renamed to
  `<name>__<symbol>`, called as `::<name>::thing()`. Refreshed in place
  when a fix ships, so it is not yours to edit.
- `install = "copy"` — a **game or component**. Lands in the project root,
  unnamespaced; the project owns the files from the moment they arrive.
  Rooms are appended to `[room_order]`, and a file the project already has
  is never overwritten — the incoming copy goes to `.gmx/incoming/`.

## Manifest fields

All optional, but the ones a reader depends on are not really.

| Field | |
|---|---|
| `name` | Display name. Falls back to the directory name. |
| `description` | One line, shown in `list` and `search`. |
| `category` | One grouping word. In use: `game`, `component`, `library`, `effects`, `character`, `world`, `online`. |
| `tags` | `facet:value` — `genre:puzzle`, `capability:movement`, `role:library`. A playable game carries a `genre:`; a component does not. |
| `install` | See above. |
| `requires` | Sibling prefabs this one composes, by bare name. Transitive. |
| `exclude` | Resource paths kept on disk so `gmx run` works while authoring, but dropped from the index and from anything a consumer pulls — demo objects, demo rooms, placeholder sprites. |
| `seam` | The one file to edit first. For a `copy` prefab; a library has no seam because you call it rather than edit it. |
| `steps` | What a reader does next, in order. |
| `traps` | Things that fail **quietly**. A trap earns its place by costing real time: writing `x` on a physics body, which the solver discards so the object simply never moves. Not a style guide — only what is both non-obvious and silent. |
| `[roles]` | What each object and room is *for*, keyed by bare resource name. Without it nothing says which object is the game and which room it plays in. |
| `[tuning]` | Scalar knobs, code-generated into `<name>_tuning()`. |
| `[content]` | Data tables, code-generated into `<name>_data(name)`. |
| `[art]` | Slots naming art elsewhere in this catalog, printed on install as `gmx prefab add` lines. |
| `[parent-link]` | Derive from another prefab: `source = "<prefab>@<tag>"`, plus optional `unset`. Version-pinned. |

`exclude` is a **top-level** key. Written after a `[tuning]` or `[content]`
header it becomes a *knob* instead — valid TOML that silently means nothing
and leaks into the generated GML.

Four files never install regardless of `exclude`: `prefab.toml`,
`README.md`, `demo.gametest.json` and `expected.txt`. The gametest is then
deliberately re-added as `<prefab>.gametest.json`, because in the target
project it is that project's test. Listing any of them in `exclude` does
nothing.

## Publishing

Two different tags are involved, and shipping only one of them publishes
nothing.

```sh
gmx prefab reindex .                 # regenerate prefab-index.json
git commit -am "…"                   # commit the tree AND the index
git push origin main                 # the commit itself — `--tags` does not
git tag v<major>.<minor>.<patch>     # the catalog tag: this is the publish
git tag <name>@<version>             # …one per prefab whose version changed
git push --tags
```

**The catalog tag is what consumers read.** `gmx prefab list` and every
`prefab add` load `prefab-index.json` *at the newest tag that has no
`<prefab>@` prefix* — so until a new `vX.Y.Z` exists, a consumer sees the
previous release's index no matter how many per-prefab tags were pushed,
and a prefab added since is simply not there.

**The per-prefab tag is what pins a version.** `<name>@<version>` is how
`gmx prefab add <name>@1.2.0` and a `[parent-link] source` resolve. A
prefab with no tag can be listed but not pinned.

**Push the commit as well.** `git push --tags` uploads tags and nothing
else; a tag whose commit was never pushed resolves to nothing on a clean
clone. Push the branch first so the tags always land on a commit that
already exists on the remote.

Tag only a commit that is on `main`. A tag on an abandoned or unmerged
branch keeps resolving — quietly, to the wrong tree — long after that
branch is gone.

`gmx prefab reindex` measures every sprite for size and colour, so the
index is a build artifact: regenerate it, never hand-edit it, and commit
it in the same change as the tree it describes.

## Checking

```sh
gmx prefab check .                   # dead [art] slots, unsupported README claims
gmx prefab check . --gametests       # also boots each prefab's demo test
```

`check` installs each prefab into a scratch project, so it catches what a
source diff cannot: an `[art]` slot naming a sprite the catalog no longer
has, or a README promising a resource that has since been renamed.
