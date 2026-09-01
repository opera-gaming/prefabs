var _press = keyboard_check_pressed(vk_space);
if (dialogue_step(chat, _press)) {
    // Ended this frame. A conversation that can only happen once is one
    // you cannot test, so it loops.
    alarm[0] = 60;
}
if (keyboard_check_pressed(vk_enter)) dialogue_restart(chat);
