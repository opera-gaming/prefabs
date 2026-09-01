// Turn at a wall, and at the edge of the platform — without the second test
// a patrol walks off the ledge it was placed on and the level empties itself
// within a few seconds.
var _cell = platformer_tuning().cell;
var _ahead_x = x + facing * _cell * 0.6;
var _wall = ::motion::motion_blocked(noone, walk.tilemap, x + facing * walk.run_speed, y);
// A point under the foot ahead, not the whole body: the mask is wider than
// the gap it is meant to notice.
var _floor_ahead = ::motion::motion_solid_at(
    noone, walk.tilemap, _ahead_x, bbox_bottom + _cell * 0.5);
if (_wall || (walk.on_ground && !_floor_ahead)) facing = -facing;

::motion::motion_platformer_step(walk, noone, facing, false, false);

// Put a fallen patrol back where it started rather than letting it drop
// forever. The ledge test above keeps a *placed* enemy on its platform, but
// one dropped into open air — an enemy added at a guessed coordinate, or a
// block deleted out from under it — otherwise falls out of the level and is
// gone, with nothing on screen and nothing in any log to say so.
if (y > room_height + _cell * 4) {
    x = start_x;
    y = start_y;
    walk.vy = 0;
}
