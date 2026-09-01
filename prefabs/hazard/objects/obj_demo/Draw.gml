// Flashing while safe is what tells the player why nothing is hurting them.
if (hazard_safe(respawn) && (current_time div 100) mod 2 == 0) exit;
draw_self();
