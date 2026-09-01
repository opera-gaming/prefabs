x += lengthdir_x(spd, dir);
y += lengthdir_y(spd, dir);
if (x < -32 || x > room_width + 32 || y < -32 || y > room_height + 32) {
    instance_destroy();
}
