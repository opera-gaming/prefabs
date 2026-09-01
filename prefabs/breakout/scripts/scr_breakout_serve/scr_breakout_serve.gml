/// @function breakout_serve()
/// @description Put a ball back in play above the paddle. Called at the
/// start of the round and after every drop, so the two paths cannot drift
/// apart.
function breakout_serve() {
    var _pad = instance_find(obj_paddle, 0);
    var _x = _pad == noone ? room_width / 2 : _pad.x;
    instance_create_depth(_x, room_height - 90, 0, obj_ball);
}
