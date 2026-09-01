/// @function hell_emit(move)
/// @description Fire one pattern from the boss. Runs in `obj_boss`, so `x`
/// and `y` are its position.
///
/// Each pattern is a loop over `::projectile::projectile_launch`, which
/// gives every bullet its lifetime — the part that keeps a long fight from
/// accumulating thousands of instances.
function hell_emit(move) {
    var _n = ::kernel::kernel_tuning("ring_count", 18);
    var _spd = ::kernel::kernel_tuning("bullet_speed", 3.5);
    var _life = ::kernel::kernel_tuning("bullet_life", 8);
    var _ship = instance_find(obj_ship, 0);

    switch (move) {
        case "ring":
            for (var i = 0; i < _n; i++) {
                ::projectile::projectile_launch(
                    obj_bullet, x, y, i * 360 / _n, _spd, _life);
            }
            break;

        case "spiral":
            // Offset per shot rather than per ring, so the wall has gaps
            // that move — a solid ring is a wall you cannot thread.
            for (var i = 0; i < _n * 2; i++) {
                ::projectile::projectile_launch(
                    obj_bullet, x, y, i * 360 / _n + i * 7, _spd, _life);
            }
            break;

        case "aimed":
            if (_ship == noone) break;
            var _at = ::projectile::projectile_aim(x, y, _ship.x, _ship.y);
            for (var i = -3; i <= 3; i++) {
                ::projectile::projectile_launch(
                    obj_bullet, x, y, _at + i * 9, _spd * 1.3, _life);
            }
            break;
    }
    ::feel::feel_shake(0.12, 4);
}
