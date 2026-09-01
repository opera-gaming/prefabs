if (global.kernel_hud) kernel_draw_hud();

if (global.kernel_pause && kernel_state() == kernel_states().pause) {
    kernel_draw_panel(0, 0, kernel_gui_width(), kernel_gui_height(), c_black, 0.6);
    kernel_draw_text(kernel_gui_width() / 2, kernel_gui_height() / 2 - 10,
        "PAUSED", c_white, fa_center);
    kernel_draw_text(kernel_gui_width() / 2, kernel_gui_height() / 2 + 14,
        "P to resume", c_ltgray, fa_center);
}
