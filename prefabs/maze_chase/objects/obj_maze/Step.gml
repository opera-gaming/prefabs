if (!::kernel::kernel_playing()) exit;
::kernel::kernel_tick();

if (instance_number(obj_dot) == 0) {
    ::kernel::kernel_game_over("cleared");
    ::kernel::kernel_save_high_score(::kernel::kernel_score());
    room_goto(rm_results);
    exit;
}

var _hero = instance_find(obj_hero, 0);
if (_hero != noone && ::health::health_dead(_hero.vitals)) {
    ::kernel::kernel_game_over("caught");
    ::kernel::kernel_save_high_score(::kernel::kernel_score());
    room_goto(rm_results);
}
