if (!::kernel::kernel_playing()) exit;
// Ages and destroys itself off-screen; without that a long fight
// accumulates thousands of them.
::projectile::projectile_step(noone);
