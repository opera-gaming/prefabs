if (!::kernel::kernel_playing()) exit;

var _p = instance_find(obj_player, 0);
if (_p == noone) exit;

if (::enemy_ai::ai_sees(brain, _p.x, _p.y)) {
    ::enemy_ai::ai_chase(brain, _p.x, _p.y);
} else {
    ::enemy_ai::ai_wander(brain, 1.5);
}
