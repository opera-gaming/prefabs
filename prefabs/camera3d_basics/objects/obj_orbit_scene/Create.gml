var _cfg = camera3d_basics_tuning();

cam = ::camera3d::camera3d_make(_cfg.distance, _cfg.fov);
dragging = false;
last = { x: 0, y: 0 };
picked = -1;

// Your scene goes here. Each entry needs a position and a radius for
// picking; swap the drawing for real geometry when you have it.
things = [
    { pos: { x: -90, y: 0, z: 0 }, r: 40 },
    { pos: { x: 0, y: 0, z: 0 }, r: 40 },
    { pos: { x: 90, y: 0, z: 0 }, r: 40 },
];
