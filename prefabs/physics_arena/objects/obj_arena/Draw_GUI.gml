::kernel::kernel_draw_text(16, 16, "score " + string(::kernel::kernel_score()));
::kernel::kernel_draw_text(16, 40,
    "targets " + string(instance_number(obj_target)) + " / " + string(total_targets));

var _a = ::hud::hud_anchor("tr", 220, 16);
::kernel::kernel_draw_text(_a.x, _a.y,
    "time " + ::timer::timer_format(::timer::timer_seconds(clock)));
::hud::hud_bar(_a.x, _a.y + 26, 200, 14,
    ::timer::timer_fraction(clock), c_aqua);
