/// Hit points, damage and the window of safety after a hit.
///
/// State is a struct rather than instance variables so one instance can own
/// several bars — a shield alongside health, a vehicle alongside its driver
/// — and so the caller picks the variable name.

/// @function health_make(max_hp, iframe_seconds)
/// @description Health state with `max_hp` points and `iframe_seconds` of
/// invulnerability granted by each hit that lands. Pass 0 for no window.
function health_make(max_hp, iframe_seconds) {
    return {
        hp: max_hp,
        max: max(1, max_hp),
        grace: max(0, iframe_seconds),
        iframes: 0,
    };
}

/// @function health_step(state)
/// @description Count the invulnerability window down. Call once a frame,
/// or the window never expires and nothing can be hurt twice.
function health_step(state) {
    if (state.iframes > 0) {
        state.iframes = max(0, state.iframes - delta_time / 1000000);
    }
}

/// @function health_hurt(state, amount)
/// @description Take `amount` unless still invulnerable. Returns whether the
/// hit landed, so a caller can flash, shake or play a sound only when it did
/// rather than on every frame of contact.
function health_hurt(state, amount) {
    if (state.iframes > 0 || health_dead(state)) return false;
    state.hp = max(0, state.hp - amount);
    state.iframes = state.grace;
    return true;
}

/// @function health_heal(state, amount)
/// @description Restore `amount`, never above the maximum. Returns how much
/// was actually restored.
function health_heal(state, amount) {
    var _before = state.hp;
    state.hp = min(state.max, state.hp + amount);
    return state.hp - _before;
}

/// @function health_reset(state)
/// @description Back to full, window cleared. What a new run needs.
function health_reset(state) {
    state.hp = state.max;
    state.iframes = 0;
}

