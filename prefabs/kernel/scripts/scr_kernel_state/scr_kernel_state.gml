/// The run lifecycle. Five states, one seeded RNG, one place that
/// decides what "playing" means — so a pack never has to ask.
///
/// States are a struct from a function rather than an enum: enums are
/// not namespaced and share one flat global table across every
/// installed prefab, so two components declaring `State` would collide
/// and hard-error at load.

/// @function kernel_states()
/// @description The five lifecycle states, as a struct of ints.
function kernel_states() {
    static _s = { boot: 0, title: 1, play: 2, pause: 3, over: 4 };
    return _s;
}

/// @function kernel_boot(seed)
/// @description Initialise every kernel global. Call once, from the
/// project's boot object, before anything else touches the kernel.
/// A seed of -1 picks a random one and records it, so a run is always
/// reproducible after the fact.
function kernel_boot(seed = -1) {
    if (seed < 0) seed = irandom(999999);
    global.kernel_seed = seed;
    random_set_seed(seed);

    global.kernel_state = kernel_states().boot;
    global.kernel_elapsed = 0;
    global.kernel_score = 0;
    global.kernel_combo = 0;
    global.kernel_combo_best = 0;
    global.kernel_flags = {};
    global.kernel_save = {};
    global.kernel_data_fn = undefined;
    global.kernel_tuning = {};
    global.kernel_result = "";

    // Chrome is on by default — a score on screen from the first frame is
    // worth real time — but a prefab must never be the last word on what
    // the player sees, so both are switchable.
    global.kernel_hud = true;
    global.kernel_pause = true;

    kernel_save_load();
}

/// @function kernel_state()
/// @description The current lifecycle state.
function kernel_state() {
    return global.kernel_state;
}

/// @function kernel_state_set(state)
/// @description Move to `state`. Entering `play` resets the run's score
/// and clock; entering `over` records the result for the results screen.
function kernel_state_set(state) {
    var _s = kernel_states();
    if (state == _s.play && global.kernel_state != _s.pause) {
        global.kernel_score = 0;
        global.kernel_combo = 0;
        global.kernel_combo_best = 0;
        global.kernel_elapsed = 0;
    }
    global.kernel_state = state;
}

/// @function kernel_playing()
/// @description True while the game should simulate. Every pack gates
/// its Step on this, which is the whole reason pause works everywhere
/// without a pack knowing pause exists.
function kernel_playing() {
    return global.kernel_state == kernel_states().play;
}

/// @function kernel_tick()
/// @description Advance the run clock. Call once per step from the
/// kernel controller; frame-rate independent.
function kernel_tick() {
    if (kernel_playing()) global.kernel_elapsed += delta_time / 1000000;
}

/// @function kernel_elapsed()
/// @description Seconds spent in `play` this run.
function kernel_elapsed() {
    return global.kernel_elapsed;
}

/// @function kernel_game_over(result)
/// @description End the run with a short result string ("cleared",
/// "out of time") and bank the score.
function kernel_game_over(result = "") {
    global.kernel_result = result;
    kernel_save_high_score(global.kernel_score);
    kernel_state_set(kernel_states().over);
}

/// @function kernel_result()
/// @description Why the last run ended.
function kernel_result() {
    return global.kernel_result;
}

/// @function kernel_hud_visible(on)
/// @description Turn the built-in HUD off when you draw your own. The
/// kernel still tracks score and combo; it just stops drawing them.
function kernel_hud_visible(on) {
    global.kernel_hud = on;
}

/// @function kernel_pause_enabled(on)
/// @description Turn off the kernel's own pause — both the key and the
/// overlay. Anything that owns pausing itself (a freeze menu, say) must
/// call this, or one keypress drives two pause systems at once.
function kernel_pause_enabled(on) {
    global.kernel_pause = on;
}
