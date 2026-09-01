/// @function level_number()
/// @description Which level this is, counting from 1, by walking the room
/// order from its first room.
function level_number() {
    var _n = 1;
    var _r = levels_first();
    while (_r != -1 && _r != room) {
        _r = room_next(_r);
        _n += 1;
    }
    return _n;
}

/// @function levels_total()
/// @description How many rooms the order holds.
function levels_total() {
    var _n = 1;
    var _r = levels_first();
    while (room_next(_r) != -1) {
        _r = room_next(_r);
        _n += 1;
    }
    return _n;
}

/// @function level_is_last()
/// @description Whether finishing this room finishes the run. `room_next`
/// returns -1 past the end, which is the only thing that marks it.
function level_is_last() {
    return room_next(room) == -1;
}

/// @function levels_first()
/// @description The room the order starts in — `room_first`, named for what
/// it means here.
function levels_first() {
    return room_first;
}

/// @function level_goto(state, target_room)
/// @description Change level through the cover. A second call while one is
/// running is ignored, so a held key cannot skip a level.
function level_goto(state, target_room) {
    return ::transition::transition_go(state.transition, target_room);
}

/// @function level_next(state)
/// @description Advance to the next room in the order. Returns false in the
/// last room, where the caller ends the run instead.
function level_next(state) {
    if (level_is_last()) return false;
    return level_goto(state, room_next(room));
}

/// @function level_restart(state)
/// @description Play this level again, through the same cover. The score is
/// the kernel's and is deliberately untouched — a level that refunds its own
/// score on death is a level you can farm by dying.
function level_restart(state) {
    return level_goto(state, room);
}

