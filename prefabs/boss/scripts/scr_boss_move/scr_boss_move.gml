/// @function boss_move(state)
/// @description Which attack is running, or "" for none.
function boss_move(state) {
    return state.move;
}

/// @function boss_pick(state, moves)
/// @description Choose an attack for the current phase from an array of
/// `{ move, phase }` structs, where `phase` is the earliest stage it can
/// appear in. Returns "" when nothing is available.
///
/// Gating by phase rather than picking freely is what makes a later stage
/// feel like an escalation rather than the same fight with more health.
function boss_pick(state, moves) {
    var _ok = [];
    for (var i = 0; i < array_length(moves); i++) {
        if (moves[i].phase <= state.phase) array_push(_ok, moves[i].move);
    }
    if (array_length(_ok) == 0) return "";
    return _ok[irandom(array_length(_ok) - 1)];
}
