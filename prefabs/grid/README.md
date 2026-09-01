# grid

A board of cells: conversion, neighbours, row collapse, undo.

A cell container with cell/pixel conversion and neighbour queries, occupancy tests, row detection and collapse, and snapshot/restore for undo. Four small concepts in one pack because a puzzle is not real without undo.

## Quick usage

Once added, the prefab is namespaced under its folder:

```gml
board = grid_make(10, 18, 26, 26);
if (grid_row_full(board, y)) grid_collapse_row(board, y);
```

Called from inside the prefab's own scripts the names are unqualified;
from your project they take the `::grid::` prefix.

## Requires

- `kernel`

These install alongside rather than being folded in, so several
prefabs requiring the same one share a single copy.

## Attribution & license

© Opera Software — MIT (see `LICENSE`).
