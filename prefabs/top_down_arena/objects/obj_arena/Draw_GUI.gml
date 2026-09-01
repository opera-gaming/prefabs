::kernel::kernel_draw_text(16, 16, "score " + string(::kernel::kernel_score()));
::kernel::kernel_draw_text(16, 40, "wave " + string(::wave::wave_number(curve)));
::kernel::kernel_draw_text(16, 64, "time " + string(floor(::kernel::kernel_elapsed())) + "s");

var _p = instance_find(obj_player, 0);
if (_p != noone) ::health::health_draw_bar(16, 96, 220, 18, _p.vitals);
