var _w = ::kernel::kernel_gui_width();
var _cfg = title_screen_tuning();

// The logo breathes; the prompt pulses on the same clock so they read as
// one object rather than two things animating independently.
var _bob = sin(t * _cfg.wiggle_hz * 2 * pi) * _cfg.wiggle_px;
::kernel::kernel_draw_text(_w / 2, 190 + _bob, _cfg.game_title, c_white, fa_center);

draw_set_alpha(0.55 + 0.45 * ::feel::feel_ease((sin(t * 2) + 1) / 2, "in_out"));
::kernel::kernel_draw_text(_w / 2, 300, _cfg.prompt, c_ltgray, fa_center);
draw_set_alpha(1);
