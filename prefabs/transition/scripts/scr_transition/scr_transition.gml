/// Covering the screen while the room changes.
///
/// A room change is instant, and instant reads as a glitch. The other half
/// is that `room_goto` must happen while the screen is covered — going first
/// and fading after shows the new room for a frame, which is worse than no
/// transition at all.

/// @function transition_make(seconds)
/// @description Transition state, idle, with each half taking `seconds`.
function transition_make(seconds) {
    return { phase: "idle", t: 0, span: max(0.01, seconds), target: -1 };
}

/// @function transition_go(state, target_room)
/// @description Start covering the screen, then enter `target_room` once it
/// is fully covered. Ignored while one is already running, so a held key
/// cannot stack two transitions.
function transition_go(state, target_room) {
    if (state.phase != "idle") return false;
    state.phase = "out";
    state.t = 0;
    state.target = target_room;
    return true;
}

/// @function transition_step(state)
/// @description Advance one frame and perform the room change at the covered
/// moment. Returns true on the frame the transition finishes.
function transition_step(state) {
    if (state.phase == "idle") return false;
    state.t += delta_time / 1000000;

    if (state.phase == "out") {
        if (state.t < state.span) return false;
        // Fully covered: the only safe frame to change room on.
        if (state.target >= 0 && room_exists(state.target)) {
            room_goto(state.target);
        }
        state.phase = "in";
        state.t = 0;
        return false;
    }

    if (state.t < state.span) return false;
    state.phase = "idle";
    state.t = 0;
    state.target = -1;
    return true;
}

/// @function transition_busy(state)
/// @description Whether one is running. Gate input on this, or the player
/// keeps playing a room they are leaving.
function transition_busy(state) {
    return state.phase != "idle";
}

/// @function transition_cover(state)
/// @description How covered the screen is, 0..1 — 0 clear, 1 opaque.
function transition_cover(state) {
    if (state.phase == "idle") return 0;
    var _f = clamp(state.t / state.span, 0, 1);
    return state.phase == "out" ? _f : 1 - _f;
}

