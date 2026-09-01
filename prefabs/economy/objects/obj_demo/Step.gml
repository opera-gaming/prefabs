if (keyboard_check_pressed(vk_space)) economy_earn(purse, 250);

if (keyboard_check_pressed(vk_enter)) {
    // Check-and-charge in one step, so the grant only happens on a true.
    var _cost = economy_price(50, level, 1.15);
    note = economy_spend(purse, _cost)
        ? "bought level " + string(level + 1) + " for " + economy_format(_cost)
        : "cannot afford " + economy_format(_cost);
    if (string_pos("bought", note) == 1) level += 1;
}
if (keyboard_check_pressed(vk_backspace)) {
    economy_reset(purse, 500);
    level = 0;
    note = "reset";
}
