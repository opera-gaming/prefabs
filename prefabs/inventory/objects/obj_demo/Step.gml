if (keyboard_check_pressed(ord("1"))) last = "arrow x3 → fit " + string(inventory_add(bag, "arrow", 3));
if (keyboard_check_pressed(ord("2"))) last = "bomb x7 → fit " + string(inventory_add(bag, "bomb", 7));
if (keyboard_check_pressed(ord("3"))) last = "rope x1 → fit " + string(inventory_add(bag, "rope", 1));
if (keyboard_check_pressed(ord("4"))) last = "key x1 → fit " + string(inventory_add(bag, "key", 1));
if (keyboard_check_pressed(vk_backspace)) last = "arrow -2 → took " + string(inventory_remove(bag, "arrow", 2));
if (keyboard_check_pressed(vk_delete)) { inventory_clear(bag); last = "cleared"; }
