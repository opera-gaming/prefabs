/// @function ai_patrol_set(state, points)
/// @description Give it a route: an array of `[x, y]` pairs, walked in order
/// and looped.
function ai_patrol_set(state, points) {
    state.route = points;
    state.leg = 0;
}

/// @function ai_patrol(state)
/// @scope instance
/// @description Walk the route one frame. Advances to the next leg on
/// arrival and wraps at the end. Does nothing without a route.
function ai_patrol(state) {
    var _n = array_length(state.route);
    if (_n == 0) return;
    var _p = state.route[state.leg mod _n];
    ai_move_towards(state, _p[0], _p[1], 1);
    if (point_distance(x, y, _p[0], _p[1]) < 1) {
        state.leg = (state.leg + 1) mod _n;
    }
}

