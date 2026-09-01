# camera3d_basics

A trackball camera you drag to orbit, with picking that agrees with what you see.

## Why two vectors instead of yaw and pitch

The camera stores a direction and an up vector, not Euler angles. Angles
gimbal-lock at the poles, and "rotate around the camera's *current* axes"
— which is what dragging a trackball means — is awkward to express in
them. Two vectors rotate about any axis you hand them and never lock.

## The footgun, and how to actually test for it

Cross-product operand order. Swap it and the right vector flips.

The reason this is worth a section: **at screen centre the error has a
zero coefficient.** A picking ray cast through the middle of the screen
lands correctly with the sign wrong. Everything looks fine, and clicks
miss by more and more the further out you go.

So test picking **off-centre**. Hover something near a corner and confirm
it highlights. If it works dead centre and nowhere else, you have found
this exact bug.

## Why picking and rendering share one basis

`matrix_build_lookat` silently re-orthogonalises whatever you give it, so
a camera with a subtly wrong basis still *renders* correctly and then
throws the pick ray somewhere else. `::camera3d::camera3d_basis` is the
one source both read, which is what makes the mismatch impossible rather
than merely documented.
