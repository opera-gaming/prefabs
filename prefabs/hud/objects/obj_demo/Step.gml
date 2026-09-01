if (keyboard_check_pressed(vk_space)) hp = max(0, hp - 0.22);
if (keyboard_check_pressed(vk_enter)) { hp = 1; lag = 1; hearts = 3; }
if (keyboard_check_pressed(ord("L"))) hearts = max(0, hearts - 1);

// The chase bar catches up slowly, which is what makes a big hit readable.
lag = hud_chase(lag, hp, 0.35);
