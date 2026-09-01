::kernel::kernel_draw_text(16, 16, "score " + string(::kernel::kernel_score()));
::kernel::kernel_draw_text(16, 40,
    "dots " + string(instance_number(obj_dot)) + " / " + string(total_dots));
var _hero = instance_find(obj_hero, 0);
if (_hero != noone) {
    ::kernel::kernel_draw_text(16, 64,
        "lives " + string(_hero.vitals.hp));
}
