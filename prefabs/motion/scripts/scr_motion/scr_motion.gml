/// Movement that stops at walls.
///
/// Every function here resolves one axis at a time. Moving both at once
/// and then backing out of a wall is the classic way to get a player who
/// sticks to ceilings and slides along floors he should stand on — the
/// axes have to be independent so a blocked X never cancels a legal Y.
///
/// Walls can be instances, tiles, or both. An instance works the moment you
/// place one and needs no tileset; a tile layer is one layer the editor can
/// paint instead of one instance per cell, and is what terrain usually wants
/// once there is art. Pass `noone` for whichever you are not using.

/// @function motion_tilemap(layer_name)
/// @description The tilemap id of a layer by name, or `noone` if the room has
/// no such layer. Saves every caller the `layer_tilemap_get_id(layer_get_id(…))`
/// dance, and returns something safe in a room that lacks the layer rather
/// than a -1 that fails much later.
function motion_tilemap(layer_name) {
    if (!layer_exists(layer_get_id(layer_name))) return noone;
    var _tm = layer_tilemap_get_id(layer_get_id(layer_name));
    return (_tm == -1) ? noone : _tm;
}

/// @function motion_tile_solid(tile_data)
/// @description Whether a cell read out of a tilemap is terrain.
///
/// Two different values mean "not terrain" and only one of them is obvious.
/// Tile index 0 is GameMaker's empty tile, but a read outside the layer's
/// extent returns -1, and `-1 != 0` — so testing the raw value walls off
/// everything past the layer's edge. A tile layer smaller than its room
/// then becomes an invisible box around the level: a pit the player is
/// meant to fall out of quietly holds him up, and a patrol probing for the
/// floor ahead finds one where the layer merely stops. The high bits of
/// tile data also carry the mirror/flip flags, which is why the index has
/// to be masked out rather than compared whole.
function motion_tile_solid(tile_data) {
    if (tile_data == -1) return false;
    return tile_get_index(tile_data) != 0;
}

/// @function motion_blocked(obj_solid, tilemap, px, py)
/// @scope instance
/// @description Whether this instance's mask would overlap something solid
/// with its origin at `(px, py)`. The one place that answers it, so the
/// instance and tile cases cannot drift apart — every move and the ground
/// test below go through here.
function motion_blocked(obj_solid, tilemap, px, py) {
    if (obj_solid != noone && place_meeting(px, py, obj_solid)) return true;
    if (tilemap == noone) return false;

    // The mask as it would sit at the candidate position: `bbox_*` describe
    // it where the instance is now, so the offset moves it without moving
    // the instance.
    var _dx = px - x;
    var _dy = py - y;
    var _tw = max(1, tilemap_get_tile_width(tilemap));
    var _th = max(1, tilemap_get_tile_height(tilemap));

    // Every cell the mask touches, not just its corners: a mover taller than
    // one tile would otherwise straddle a wall with a corner either side of
    // it and pass straight through.
    // `bbox_right`/`bbox_bottom` sit one past the last pixel the mask covers,
    // so dividing them straight reads the row or column beyond it: a body
    // resting flush on a tile top reports itself blocked and cannot move.
    var _cx = (bbox_left + _dx) div _tw;
    var _cy = (bbox_top + _dy) div _th;
    var _cx2 = (bbox_right + _dx - 1) div _tw;
    var _cy2 = (bbox_bottom + _dy - 1) div _th;
    for (var _iy = _cy; _iy <= _cy2; _iy++) {
        for (var _ix = _cx; _ix <= _cx2; _ix++) {
            if (motion_tile_solid(tilemap_get(tilemap, _ix, _iy))) return true;
        }
    }
    return false;
}

/// @function motion_solid_at(obj_solid, tilemap, px, py)
/// @scope instance
/// @description Whether the single point `(px, py)` is solid.
///
/// The point form of [motion_blocked]. Use it for probes — "is there floor
/// just ahead of my feet" — where asking about the whole mask answers a
/// different question, and answers it wrong: a mask two cells wide finds
/// floor a mask-width away and a patrol walks off the ledge anyway.
function motion_solid_at(obj_solid, tilemap, px, py) {
    if (obj_solid != noone && position_meeting(px, py, obj_solid)) return true;
    if (tilemap == noone) return false;
    return motion_tile_solid(tilemap_get_at_pixel(tilemap, px, py));
}

/// @function motion_move_x(obj_solid, amount, tilemap)
/// @scope instance
/// @description Move this instance `amount` pixels horizontally, stopping
/// flush against the first solid thing in the way. Returns true if something
/// blocked it.
function motion_move_x(obj_solid, amount, tilemap = noone) {
    if (amount == 0) return false;
    if (!motion_blocked(obj_solid, tilemap, x + amount, y)) {
        x += amount;
        return false;
    }
    // Step in one pixel at a time only once contact is known, so the
    // common (unblocked) case stays a single check however fast you move.
    var _step = sign(amount);
    while (!motion_blocked(obj_solid, tilemap, x + _step, y)) {
        x += _step;
    }
    return true;
}

/// @function motion_move_y(obj_solid, amount, tilemap)
/// @scope instance
/// @description The vertical half of the same. Returns true if blocked.
function motion_move_y(obj_solid, amount, tilemap = noone) {
    if (amount == 0) return false;
    if (!motion_blocked(obj_solid, tilemap, x, y + amount)) {
        y += amount;
        return false;
    }
    var _step = sign(amount);
    while (!motion_blocked(obj_solid, tilemap, x, y + _step)) {
        y += _step;
    }
    return true;
}

/// @function motion_clamp_to_room()
/// @scope instance
/// @description Keep this instance inside the room, measured from its
/// sprite's bounding box rather than its origin — an origin-centred
/// sprite otherwise leaves half of itself outside.
function motion_clamp_to_room() {
    if (sprite_index == -1) {
        x = clamp(x, 0, room_width);
        y = clamp(y, 0, room_height);
        return;
    }
    x = clamp(x, x - bbox_left, x + (room_width - bbox_right));
    y = clamp(y, y - bbox_top, y + (room_height - bbox_bottom));
}

/// @function motion_topdown(obj_solid, dx, dy, speed)
/// @scope instance
/// @description Eight-way movement. `dx`/`dy` are -1..1 direction, not
/// pixels. Diagonals are normalised, so holding two keys is not faster
/// than holding one — the bug you notice only after playtesting.
function motion_topdown(obj_solid, dx, dy, speed, tilemap = noone) {
    var _len = point_distance(0, 0, dx, dy);
    if (_len > 0) {
        dx = dx / _len;
        dy = dy / _len;
    }
    motion_move_x(obj_solid, dx * speed, tilemap);
    motion_move_y(obj_solid, dy * speed, tilemap);
}

