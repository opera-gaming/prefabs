# kernel

Run lifecycle, score and save — the floor every game shares.

The floor every game shares: run lifecycle on a seeded RNG, an action-based input map, score and combo, a save store with flags, HUD helpers, audio buses, and the data/tuning accessors a generated template feeds.

## Quick usage

Once added, the prefab is namespaced under its folder:

```gml
::kernel::kernel_boot();
::kernel::kernel_state_set(kernel_states().play);
::kernel::kernel_score_add(100);
```

Called from inside the prefab's own scripts the names are unqualified;
from your project they take the `::kernel::` prefix.

## Attribution & license

© Opera Software — MIT (see `LICENSE`).
