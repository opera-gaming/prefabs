# ui-board

A screenful of things you can click, with hover and layout.

Pointer-driven hotspots with hover, press and disabled states, grid and row layouts, selection and answer slots. The catalog holds roughly 1,500 UI and icon sprites with no gameplay layer that can use them; this is that layer.

## Quick usage

Once added, the prefab is namespaced under its folder:

```gml
board = ui_board_make();
::ui_board::ui_add(board, "play", 0, 0, 0, 0, "Play");
::ui_board::ui_layout_grid(board, 1, 320, 200, 320, 64);
```

Called from inside the prefab's own scripts the names are unqualified;
from your project they take the `::ui_board::` prefix.

## Requires

- `kernel`
- `feel`

These install alongside rather than being folded in, so several
prefabs requiring the same one share a single copy.

## Attribution & license

© Opera Software — MIT (see `LICENSE`).
