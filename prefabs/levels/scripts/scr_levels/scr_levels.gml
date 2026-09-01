/// A run through several rooms in order, and the exit that ends each one.
///
/// Which level you are on is derived from `[room_order]` rather than stored,
/// so it cannot disagree with the order the game actually plays: adding a
/// level is authoring a room and appending one line to `project.toml`.
/// Advancing goes through ::transition:: so the room changes on the frame the
/// screen is covered, and never re-boots ::kernel:: — a run's score belongs to
/// the run, not to the level.

/// @function levels_make(cover_seconds)
/// @description The state one game needs: how the screen covers, and how many
/// of the thing the exit is waiting for. Hold it in a global rather than on a
/// controller, so it survives the room change it is performing.
function levels_make(cover_seconds = 0.3) {
    return {
        transition: ::transition::transition_make(cover_seconds),
        needed: 0,
        taken: 0,
    };
}

/// @function levels_step(state)
/// @description Advance the transition. Call once a frame from the object
/// that owns the state. Returns true on the frame a change finishes.
function levels_step(state) {
    return ::transition::transition_step(state.transition);
}

/// @function levels_busy(state)
/// @description True while the screen is covering, changing or uncovering.
/// Gameplay reads this and stands still: a player who kept running behind a
/// black screen arrives somewhere the level did not put them.
function levels_busy(state) {
    return ::transition::transition_busy(state.transition);
}

/// @function levels_cover(state)
/// @description How covered the screen is, 0..1, for the object that draws it.
function levels_cover(state) {
    return ::transition::transition_cover(state.transition);
}

