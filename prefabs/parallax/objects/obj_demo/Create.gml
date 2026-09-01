sky = parallax_make();
// Back to front: the far band moves least, the near one most.
far = parallax_add(sky, spr_demo_far, 0.15, 200, 0.05);
near = parallax_add(sky, spr_demo_near, 0.45, 280, 0.1);
parallax_drift(sky, far, 6);

