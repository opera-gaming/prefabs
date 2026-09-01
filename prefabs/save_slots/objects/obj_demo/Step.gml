if (keyboard_check_pressed(vk_up)) level += 1;
if (keyboard_check_pressed(vk_down)) level = max(1, level - 1);

for (var i = 0; i < 3; i++) {
    if (keyboard_check_pressed(ord(string(i + 1)))) {
        note = save_slots_write(i, { level: level, played: current_time div 1000 })
            ? "wrote slot " + string(i) : "slot " + string(i) + " would not write";
    }
}
if (keyboard_check_pressed(vk_space)) {
    var _s = save_slots_read(0, { level: -1 });
    note = "slot 0 holds level " + string(_s.level);
}
if (keyboard_check_pressed(vk_backspace)) {
    for (var i = 0; i < 3; i++) save_slots_delete(i);
    note = "all cleared";
}
