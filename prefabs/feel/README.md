# feel

Juice: tweens, hit-stop, screen shake, floating popups.

Tweens and easing, hit-stop, screen shake, floating score popups and squash-and-stretch. Deliberately depends on nothing, so it can be retuned and re-released without moving the kernel.

## Quick usage

Once added, the prefab is namespaced under its folder:

```gml
::feel::feel_hitstop(0.08);
::feel::feel_shake(0.3, 8);
::feel::feel_pop(x, y, "+100", c_yellow);
```

Called from inside the prefab's own scripts the names are unqualified;
from your project they take the `::feel::` prefix.

## Attribution & license

© Opera Software — MIT (see `LICENSE`).
