frame += 1;
var _c = instance_find(obj_character, 0);
if (_c == noone) exit;
// A scripted tour: walk right, jump, walk back, fall over, get up.
if (frame == 30)  character_walk_to(_c, 1000);
if (frame == 200) character_jump(_c);
if (frame == 330) character_walk_to(_c, 500);
if (frame == 480) character_ragdoll(_c, 4, -6);
if (keyboard_check_pressed(ord("R"))) character_ragdoll(_c, 4, -6);
if (keyboard_check_pressed(vk_space)) character_jump(_c);
