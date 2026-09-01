/// Score and combo. Lives in the kernel rather than a pack because
/// every pack writes to it and packs may not call each other.

/// @function kernel_score()
function kernel_score() {
    return global.kernel_score;
}

/// @function kernel_score_add(points)
/// @description Add `points`, scaled by the current combo multiplier.
/// Returns what was actually added, so a caller can show the number it
/// awarded rather than the number it asked for.
function kernel_score_add(points) {
    var _gained = round(points * kernel_combo_multiplier());
    global.kernel_score += _gained;
    return _gained;
}

/// @function kernel_combo()
function kernel_combo() {
    return global.kernel_combo;
}

/// @function kernel_combo_multiplier()
/// @description 1.0 at combo 0, rising by a tenth per step. Capped so a
/// long run cannot run away with the scoreboard.
function kernel_combo_multiplier() {
    return min(1 + global.kernel_combo * 0.1, 4);
}

/// @function kernel_combo_bump()
/// @description Extend the combo by one and track the run's best.
function kernel_combo_bump() {
    global.kernel_combo += 1;
    global.kernel_combo_best = max(global.kernel_combo_best, global.kernel_combo);
}

/// @function kernel_combo_break()
function kernel_combo_break() {
    global.kernel_combo = 0;
}

/// @function kernel_combo_best()
function kernel_combo_best() {
    return global.kernel_combo_best;
}
