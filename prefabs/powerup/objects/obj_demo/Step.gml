// Three keys, three stacking rules — the whole point of the library is
// that a repeat pickup does something different in each.
if (keyboard_check_pressed(ord("1"))) powerup_grant(buffs, "speed", 4, "refresh");
if (keyboard_check_pressed(ord("2"))) powerup_grant(buffs, "shield", 4, "extend");
if (keyboard_check_pressed(ord("3"))) powerup_grant(buffs, "damage", 4, "stack");
if (keyboard_check_pressed(vk_backspace)) powerup_clear(buffs);

// Expiries come back once, so an effect is undone exactly once.
var _ended = powerup_step(buffs);
for (var i = 0; i < array_length(_ended); i++) {
    array_push(log_lines, _ended[i] + " ended");
}
while (array_length(log_lines) > 6) array_delete(log_lines, 0, 1);
