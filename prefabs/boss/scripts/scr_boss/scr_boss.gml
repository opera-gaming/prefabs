/// A fight with stages, and attacks you can see coming.
///
/// The telegraph is the whole thing. An attack that fires the instant it is
/// chosen is not difficult, it is unfair — the player loses to something
/// they had no frame in which to react to, and the fight reads as random.
/// Every attack here has a wind-up the player can see and a window in which
/// to move.

/// @function boss_make(hp, phase_count)
/// @description Boss state with `hp` and `phase_count` stages, split evenly
/// down the health bar. Starts idle in phase 1.
function boss_make(hp, phase_count) {
    return {
        hp: hp,
        max: max(1, hp),
        phases: max(1, phase_count),
        phase: 1,
        changed: false,
        move: "",
        telegraph: 0,
        telegraph_span: 0,
        active: 0,
        cooldown: 0,
        invulnerable: false,
    };
}

/// @function boss_hurt(state, amount)
/// @description Take damage unless the boss is invulnerable — which it
/// should be while a phase transition plays, or the player skips a stage by
/// landing a big hit at the wrong moment.
///
/// Returns whether the hit landed.
function boss_hurt(state, amount) {
    if (state.invulnerable || boss_dead(state)) return false;
    state.hp = max(0, state.hp - amount);
    return true;
}

/// @function boss_dead(state)
function boss_dead(state) {
    return state.hp <= 0;
}

/// @function boss_fraction(state)
/// @description Health as 0..1, for the bar across the top.
function boss_fraction(state) {
    return state.hp / state.max;
}

/// @function boss_step(state)
/// @description Advance timers and phase. Call once a frame.
///
/// Returns what happened this frame: "telegraph_end" when the wind-up
/// finishes and the attack should actually fire, "attack_end" when it
/// finishes, "phase" when the boss enters a new stage, or "" for nothing.
/// One return rather than several flags, because each of these should drive
/// exactly one thing and a flag left set is how an attack fires twice.
function boss_step(state) {
    var _dt = delta_time / 1000000;

    var _want = boss_phase_for(state, boss_fraction(state));
    if (_want != state.phase) {
        state.phase = _want;
        state.changed = true;
        return "phase";
    }
    state.changed = false;

    if (state.telegraph > 0) {
        state.telegraph = max(0, state.telegraph - _dt);
        if (state.telegraph <= 0) return "telegraph_end";
        return "";
    }
    if (state.active > 0) {
        state.active = max(0, state.active - _dt);
        if (state.active <= 0) {
            state.move = "";
            return "attack_end";
        }
        return "";
    }
    if (state.cooldown > 0) state.cooldown = max(0, state.cooldown - _dt);
    return "";
}

