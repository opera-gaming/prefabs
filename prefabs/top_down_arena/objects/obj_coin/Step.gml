if (!::kernel::kernel_playing()) exit;

var _who = ::pickup::pickup_step(loot, obj_player);
if (_who == noone) exit;

// Score, feedback, then destroy — in that order, because the popup wants
// the coin's position and the instance is about to stop having one.
var _t = top_down_arena_tuning();
::kernel::kernel_score_add(_t.coin_score);
::feel::feel_pop(x, y, "+" + string(_t.coin_score), c_yellow);
instance_destroy();
