/// @function runner_emit_column()
/// @description Add one column of world at the right-hand edge — either a
/// floor tile or part of a gap. Runs from `obj_runner`, so `cell`,
/// `next_x` and `gap_left` are its variables.
///
/// One column at a time rather than whole chunks, because a gap that
/// straddles a chunk boundary is the case that generates something
/// unjumpable.
function runner_emit_column() {
    // The opening stretch is always solid. Generating a gap under the
    // start drops the player before they have pressed anything, which
    // reads as the game being broken rather than as a hard game.
    if (safe_left > 0) {
        safe_left -= 1;
        instance_create_depth(next_x + cell / 2, 420, 0, obj_ground);
        next_x += cell;
        return;
    }
    if (gap_left > 0) {
        gap_left -= 1;
    } else if (random(1) < ::kernel::kernel_tuning("gap_chance", 0.22)) {
        // Capped so the gap is always clearable at the current speed.
        gap_left = irandom_range(1, ::kernel::kernel_tuning("gap_max_cells", 3));
    } else {
        instance_create_depth(next_x + cell / 2, 420, 0, obj_ground);
    }
    next_x += cell;
}

/// @function runner_distance()
/// @description How far the world has scrolled, in points rather than
/// pixels — the number worth showing.
function runner_distance() {
    return floor(travelled / ::kernel::kernel_tuning("distance_per_point", 10));
}
