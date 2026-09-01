# iso

Isometric projection, its inverse, and the depth key.

Grid-to-screen isometric projection, the inverse, and the depth key that makes a tile skirt occlude correctly.

## Quick usage

Once added, the prefab is namespaced under its folder:

```gml
iso = iso_make(96, 48, 480, 120);
var p = iso_to_screen(iso, col, row);
depth = iso_depth(col, row);
```

Called from inside the prefab's own scripts the names are unqualified;
from your project they take the `::iso::` prefix.

## Attribution & license

© Opera Software — MIT (see `LICENSE`).
