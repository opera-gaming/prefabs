draw_set_colour(#B4B2BC);
draw_text(24, 20, "Tap beside him to walk, above his head to jump. R = ragdoll, Space = jump.");
var _c = instance_find(obj_character, 0);
if (_c != noone) {
    draw_text(24, 44, "state: " + (character_is_down(_c) ? "ragdoll" : (_c.getting_up ? "getting up" : (_c.jumping ? "jump" : (is_undefined(_c.walk_target) ? "idle" : "walk")))));
}
draw_set_colour(c_white);
