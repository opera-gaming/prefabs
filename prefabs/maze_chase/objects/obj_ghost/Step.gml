if (!::kernel::kernel_playing()) exit;

var _hero = instance_find(obj_hero, 0);
var _ctl = instance_find(obj_maze, 0);
if (_hero == noone || _ctl == noone) exit;

// Recomputing every frame is wasted work; too rarely and it walks into a
// wall you have already left.
repath -= delta_time / 1000000;
if (repath <= 0) {
    repath = repath_seconds;
    var _from = ::pathgrid::pathgrid_cell_of(_ctl.nav, x, y);
    var _to = ::pathgrid::pathgrid_cell_of(_ctl.nav, _hero.x, _hero.y);
    route = ::pathgrid::pathgrid_find(_ctl.nav, _from.col, _from.row, _to.col, _to.row);
}

// An empty route is normal — the player is standing in a wall cell, or
// there is genuinely no way round.
var _next = ::pathgrid::pathgrid_next_point(_ctl.nav, route);
if (_next == undefined) exit;

var _dir = point_direction(x, y, _next.x, _next.y);
x += lengthdir_x(move_speed, _dir);
y += lengthdir_y(move_speed, _dir);
if (point_distance(x, y, _next.x, _next.y) < move_speed) array_delete(route, 0, 1);
