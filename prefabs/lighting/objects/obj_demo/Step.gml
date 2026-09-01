torch_dir = point_direction(mouse_x, mouse_y, room_width / 2, room_height / 2);
if (keyboard_check_pressed(vk_space)) night.dark = night.dark > 0.5 ? 0.35 : 0.92;

// Lights are declared every frame by whoever owns them — in Step, so the
// query below is per-frame logic rather than per-draw.
for (var i = 0; i < array_length(lamps); i++) {
    light_add(night, lamps[i][0], lamps[i][1], 130, 0.9);
}
light_add_cone(night, mouse_x, mouse_y, 260, torch_dir, 40, 1);

// Ask before drawing — `light_draw` clears the queue.
lit_lamp = light_lit(night, lamps[0][0], lamps[0][1]);
