/// Action-based input. A pack asks "is confirm pressed", never "is
/// vk_space pressed", so keyboard, gamepad and pointer stay one
/// concern and a template can rebind without touching a pack.

/// @function kernel_action_pressed(action)
/// @description True on the frame `action` is first pressed.
/// Actions: left, right, up, down, confirm, cancel, pause, rotate.
function kernel_action_pressed(action) {
    switch (action) {
        case "left":   return keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"));
        case "right":  return keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
        case "up":     return keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W"));
        case "down":   return keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"));
        case "confirm":return keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)
                           || mouse_check_button_pressed(mb_left);
        case "cancel": return keyboard_check_pressed(vk_escape);
        case "pause":  return keyboard_check_pressed(ord("P"));
        case "rotate": return keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W"));
    }
    return false;
}

/// @function kernel_action_held(action)
/// @description True while `action` is held.
function kernel_action_held(action) {
    switch (action) {
        case "left":   return keyboard_check(vk_left)  || keyboard_check(ord("A"));
        case "right":  return keyboard_check(vk_right) || keyboard_check(ord("D"));
        case "up":     return keyboard_check(vk_up)    || keyboard_check(ord("W"));
        case "down":   return keyboard_check(vk_down)  || keyboard_check(ord("S"));
        case "confirm":return keyboard_check(vk_space) || mouse_check_button(mb_left);
    }
    return false;
}

/// @function kernel_pointer()
/// @description Pointer position in GUI space, as {x, y}. GUI space,
/// not room space: everything the UI pack hit-tests is drawn there.
function kernel_pointer() {
    return { x: device_mouse_x_to_gui(0), y: device_mouse_y_to_gui(0) };
}
