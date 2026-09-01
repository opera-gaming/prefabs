# camera3d

Trackball orbit camera and ray picking that agrees with it.

Orbit camera as two vectors rather than Euler angles: Rodrigues rotation, an orthonormalised basis, and ray-sphere picking that reuses that basis.

## Quick usage

Once added, the prefab is namespaced under its folder:

```gml
cam = camera3d_make(300, 60);
cam = camera3d_orbit(cam, dx, dy);
var ray = camera3d_ray(cam, mx, my, w, h);
```

Called from inside the prefab's own scripts the names are unqualified;
from your project they take the `::camera3d::` prefix.

## Attribution & license

© Opera Software — MIT (see `LICENSE`).
