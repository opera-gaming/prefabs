levels_step(run);
if (levels_busy(run)) exit;

if (keyboard_check_pressed(vk_space)) levels_take(run);

// The exit only answers once the gate is open, which is the whole point of
// having one.
if (keyboard_check_pressed(vk_enter) && levels_gate_open(run)) {
    if (level_is_last()) {
        ::kernel::kernel_game_over(true);
    } else {
        level_next(run);
        // The next level asks for its own.
        levels_gate(run, 1);
    }
}

if (keyboard_check_pressed(ord("R"))) level_restart(run);
