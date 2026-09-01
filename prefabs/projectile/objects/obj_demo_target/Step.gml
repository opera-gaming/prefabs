// Drifts up and down so `projectile_lead` has something to lead.
if (y < 120 || y > 420) direction = -direction;
flash = max(0, flash - delta_time / 1000000);
