if (ramp <= 0.001) exit;

var _cfg = pause_menu_tuning();
var _w = ::kernel::kernel_gui_width();
var _h = ::kernel::kernel_gui_height();

// The world is deactivated, so nothing is drawing it — the snapshot is
// the only thing keeping the game on screen behind the dim.
if (snap != -1 && surface_exists(snap)) {
    draw_surface_stretched(snap, 0, 0, _w, _h);
}

::kernel::kernel_draw_panel(0, 0, _w, _h, c_black, _cfg.dim * ramp);
draw_set_alpha(ramp);
::kernel::kernel_draw_text(_w / 2, _h / 2 - 12, "- paused -", c_white, fa_center);
::kernel::kernel_draw_text(_w / 2, _h / 2 + 16, "P to resume", c_ltgray, fa_center);
draw_set_alpha(1);
