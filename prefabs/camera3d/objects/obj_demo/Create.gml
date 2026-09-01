cam = camera3d_make(300, 60);
dragging = false;
last = { x: 0, y: 0 };

// Three spheres at known positions. Picking one proves the ray and the
// projection agree — which is the only thing this demo is for.
balls = [
    { pos: { x: -90, y: 0, z: 0 }, r: 40, hit: false },
    { pos: { x: 0, y: 0, z: 0 }, r: 40, hit: false },
    { pos: { x: 90, y: 0, z: 0 }, r: 40, hit: false },
];
