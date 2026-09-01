/// @function hazard_checkpoint(state, cx, cy)
/// @description Move the respawn point. Ignores a checkpoint the player is
/// already standing on, so a trigger firing every frame does not reset the
/// grace window over and over.
function hazard_checkpoint(state, cx, cy) {
    if (state.x == cx && state.y == cy) return false;
    state.x = cx;
    state.y = cy;
    return true;
}

/// @function hazard_respawn(state, grace_seconds)
/// @scope instance
/// @description Put the calling instance back at the checkpoint, stop it
/// dead, and start a window of `grace_seconds`. Stopping the motion matters:
/// respawning at speed walks the player straight back into what killed them.
function hazard_respawn(state, grace_seconds) {
    x = state.x;
    y = state.y;
    speed = 0;
    state.deaths += 1;
    state.since = grace_seconds;
}

/// @function hazard_deaths(state)
function hazard_deaths(state) {
    return state.deaths;
}
