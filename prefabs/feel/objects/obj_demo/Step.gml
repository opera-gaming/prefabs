if (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space)) {
    n += 1;
    feel_hitstop(0.09);
    feel_shake(0.25, 8);
    feel_pop(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), "+" + string(n * 10), c_yellow);
}
