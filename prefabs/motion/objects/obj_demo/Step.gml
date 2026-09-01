var _dx = keyboard_check(vk_right) - keyboard_check(vk_left);
motion_platformer_step(
    jump, obj_demo_wall, _dx,
    keyboard_check(vk_space), keyboard_check_pressed(vk_space)
);
motion_clamp_to_room();
