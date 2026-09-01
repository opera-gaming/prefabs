/// @function levels_gate(state, needed)
/// @description Say how many of the thing this level's exit is waiting for —
/// coins, keys, switches. Call at the start of a level, once the room's
/// contents exist; `instance_number(obj_coin)` is the usual argument.
function levels_gate(state, needed) {
    state.needed = needed;
    state.taken = 0;
}

/// @function levels_take(state)
/// @description Count one toward the gate. Returns true on the one that opens
/// it, which is the moment worth telling the player about.
function levels_take(state) {
    state.taken += 1;
    return state.taken == state.needed;
}

/// @function levels_gate_open(state)
/// @description Whether the exit is open. A level that asked for nothing is
/// open from the start, which is what `>=` buys over `==`.
function levels_gate_open(state) {
    return state.taken >= state.needed;
}

/// @function levels_remaining(state)
/// @description How many are still out there, for the HUD.
function levels_remaining(state) {
    return max(0, state.needed - state.taken);
}
