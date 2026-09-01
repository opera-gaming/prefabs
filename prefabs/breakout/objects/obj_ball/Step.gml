if (!::kernel::kernel_playing()) exit;

// Walls. The room edge is not an object, so this is a bounds test rather
// than a collision.
if (x < 8 && lengthdir_x(1, direction) < 0) direction = 180 - direction;
if (x > room_width - 8 && lengthdir_x(1, direction) > 0) direction = 180 - direction;
if (y < 8 && lengthdir_y(1, direction) < 0) direction = -direction;

var _brick = instance_place(x, y, obj_brick);
if (_brick != noone) {
    direction = -direction;
    speed += ball_speed_gain;
    ::kernel::kernel_score_add(brick_score);
    ::feel::feel_pop(_brick.x, _brick.y,
        "+" + string(brick_score), c_yellow);
    ::feel::feel_shake(0.12, 4);
    instance_destroy(_brick);
}

// The paddle bends the bounce by where the ball lands on it. Without this
// the paddle is a wall and every rally repeats.
//
// Minus, not plus: `direction` is 0 right, 90 up, 180 left, so adding a
// negative offset steers a ball that hit the left of the paddle to the
// right. The game still plays, which is exactly why the sign is worth
// stating — a measured aim is the only way to notice.
var _pad = instance_place(x, y, obj_paddle);
if (_pad != noone && lengthdir_y(1, direction) > 0) {
    var _offset = (x - _pad.x) / (_pad.sprite_width / 2);
    var _steer = steer;
    direction = 90 - clamp(_offset, -1, 1) * _steer;
    y = _pad.bbox_top - 8;
}
