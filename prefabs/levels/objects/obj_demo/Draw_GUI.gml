var _y = 24;
::kernel::kernel_draw_text(24, _y, "level " + string(level_number()) + " of "
    + string(levels_total()), c_white, fa_left);
::kernel::kernel_draw_text(24, _y + 28, levels_gate_open(run)
    ? "exit open — ENTER"
    : "SPACE to collect " + string(levels_remaining(run)) + " more", c_white, fa_left);
::kernel::kernel_draw_text(24, _y + 56, "R restarts the level", c_white, fa_left);

// Drawn last so the cover sits over the HUD as well as the room.
::transition::transition_draw_fade(run.transition, make_colour_rgb(0x0C, 0x0E, 0x16));
