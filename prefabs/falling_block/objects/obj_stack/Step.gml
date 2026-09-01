if (!::kernel::kernel_playing()) exit;

var _dt = delta_time / 1000000;

// The row-clear flash is a pause in the simulation, not an animation
// layered over it — the board has already collapsed underneath.
if (flash_left > 0) {
    flash_left -= _dt;
    if (flash_left <= 0) flash_rows = [];
    exit;
}

// Hit-stop freezes gravity and input together, so a lock never eats a move.
if (::feel::feel_frozen()) exit;

if (::kernel::kernel_action_pressed("left")  && fits(piece, rot, px - 1, py)) px -= 1;
if (::kernel::kernel_action_pressed("right") && fits(piece, rot, px + 1, py)) px += 1;

if (::kernel::kernel_action_pressed("rotate")) {
    var _next = (rot + 1) % 4;
    // Wall kick: try the rotation in place, then nudged one cell either
    // way. Without this, rotating against a wall silently does nothing.
    if (fits(piece, _next, px, py)) rot = _next;
    else if (fits(piece, _next, px - 1, py)) { rot = _next; px -= 1; }
    else if (fits(piece, _next, px + 1, py)) { rot = _next; px += 1; }
}

var _interval = ::kernel::kernel_action_held("down")
    ? soft_drop
    : fall_interval();

fall_timer += _dt;
if (fall_timer >= _interval) {
    fall_timer = 0;
    if (fits(piece, rot, px, py + 1)) py += 1;
    else lock_piece();
}
