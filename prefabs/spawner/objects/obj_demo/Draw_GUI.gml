// obj_spawner draws its own wave read-out at the top left, so this sits
// clear of it rather than on top.
draw_text(40, 400, "spawner demo - `spawns` is wired to obj_mote; the wave curve");
draw_text(40, 430, "shortens the interval, so the room fills faster as it goes.");
draw_text(40, 480, "alive " + string(instance_number(obj_mote)));
