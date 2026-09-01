paused = false;

// A ring of static walls plus a few obstacles, so bounces happen often.
for (var _x = 0; _x < room_width; _x += 40) {
    instance_create_depth(_x, 0, 0, obj_demo_wall);
    instance_create_depth(_x, room_height - 40, 0, obj_demo_wall);
}
for (var _y = 40; _y < room_height - 40; _y += 40) {
    instance_create_depth(0, _y, 0, obj_demo_wall);
    instance_create_depth(room_width - 40, _y, 0, obj_demo_wall);
}
for (var i = 0; i < 5; i++) {
    instance_create_depth(220 + i * 130, 200 + (i mod 2) * 140, 0, obj_demo_wall);
}

ball = instance_create_depth(480, 130, 0, obj_demo_ball);
with (ball) phys_launch(irandom(359), 9);
