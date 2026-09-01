if (!::kernel::kernel_playing()) exit;

// The only thing that damages the boss. Without a weapon its hp never moves,
// so `boss_dead` is unreachable, the cleared ending never fires, and because
// the phase is derived from the hp fraction the fight stays in phase one —
// every later pattern, and the phase-invulnerability path, is dead code.
var _boss = ::projectile::projectile_step(obj_boss);
if (_boss == noone) exit;

if (::boss::boss_hurt(_boss.fight, damage)) {
    ::feel::feel_pop(x, y, string(damage), c_aqua);
}
instance_destroy();
