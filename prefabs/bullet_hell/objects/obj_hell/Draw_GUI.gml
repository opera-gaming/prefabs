::kernel::kernel_draw_text(16, 16, "score " + string(::kernel::kernel_score()));
::kernel::kernel_draw_text(16, 40,
    "survived " + ::timer::timer_format_ms(::timer::timer_seconds(survived)));
::kernel::kernel_draw_text(16, 64, "bullets " + string(instance_number(obj_bullet)));

if (!instance_exists(overlord)) exit;
var _f = overlord.fight;
::kernel::kernel_draw_text(16, 96,
    "phase " + string(_f.phase) + " of " + string(_f.phases));
draw_rectangle(16, 120, 16 + 500 * ::boss::boss_fraction(_f), 134, false);
draw_rectangle(16, 120, 516, 134, true);
