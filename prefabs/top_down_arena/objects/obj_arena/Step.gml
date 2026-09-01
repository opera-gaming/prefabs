if (!::kernel::kernel_playing()) exit;

::kernel::kernel_tick();

// The curve decides when and how many; where they appear is this object's
// business. Spawning happens at a room edge, away from the player, so a
// wave never lands on top of them.
if (::wave::wave_step(curve)) {
    repeat (::wave::wave_budget(curve, 1)) {
        var _edge = irandom(3);
        var _sx = _edge == 0 ? 60 : (_edge == 1 ? room_width - 60 : irandom_range(60, room_width - 60));
        var _sy = _edge == 2 ? 60 : (_edge == 3 ? room_height - 60 : irandom_range(60, room_height - 60));
        instance_create_depth(_sx, _sy, 0, obj_enemy);
    }

    // One coin per wave, away from the edges the enemies arrive at.
    //
    // Nothing kills an enemy in this game — there is no weapon, and survival
    // is the whole loop — so a coin "dropped by a dead enemy" could never
    // appear. Without this the only `kernel_score_add` in the recipe is
    // unreachable and every run ends "score 0", with the `pickup` dependency
    // and the `coin_score` knob along for the ride.
    instance_create_depth(
        irandom_range(120, room_width - 120),
        irandom_range(120, room_height - 120),
        0, obj_coin);
}

// Once per enemy. `ai_separate` pushes the *calling* instance away from its
// peers, so running it from a single instance separated that one enemy from
// the pack and left every other pair fully overlapped — the group rendered as
// one blob. The library's own `_share = 0.5` is what stops the per-pair
// double-count this looks like it would cause.
with (obj_enemy) ::enemy_ai::ai_separate(brain, obj_enemy, 30);
