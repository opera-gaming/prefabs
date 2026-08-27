/// The world: a tileable backdrop drawn at bg_scale, a floor at the backdrop's
/// ground line, walls at the room's edges, and a camera that follows whatever
/// calls world_focus(). Nothing here knows what a character is: the hand-off is
/// three globals (see below), so the world runs with or without one.

// bg_sprite = -1 in the variable definitions means "the prefab's own backdrop";
// override per instance with any 16:9 sprite (the generating-backgrounds skill
// makes them) to change the scene without touching this object.
if (bg_sprite == -1) bg_sprite = spr_bg;
bg_w = sprite_get_width(bg_sprite) * bg_scale;
bg_h = sprite_get_height(bg_sprite) * bg_scale;
// The backdrop sits on the room's floor; a taller room just gets more sky.
bg_y = room_height - bg_h;
// ground_frac is where the backdrop's ground line is, as a fraction of its
// height (0.73 for skill-generated backdrops).
ground_y = round(bg_y + bg_h * ground_frac);

// --- colliders ---------------------------------------------------------------
// A floor at the ground line and walls at the edges. Thick, so a fast body
// cannot tunnel through.
// Scale goes in with the creation struct: a fixture is sized when the instance
// is created, and image_xscale set afterwards does not resize it.
var _t = wall_t;
floor_inst = instance_create_layer(room_width * 0.5, ground_y + _t * 0.5, layer, obj_wall,
                                   { image_xscale: room_width, image_yscale: _t });
wall_l = instance_create_layer(_t * 0.5, room_height * 0.5, layer, obj_wall,
                               { image_xscale: _t, image_yscale: room_height });
wall_r = instance_create_layer(room_width - _t * 0.5, room_height * 0.5, layer, obj_wall,
                               { image_xscale: _t, image_yscale: room_height });
ceiling = instance_create_layer(room_width * 0.5, -_t * 0.5, layer, obj_wall,
                                { image_xscale: room_width, image_yscale: _t });

// --- the hand-off ------------------------------------------------------------
// Read by whatever walks on the floor: where it is, and how far it may go.
global.sidescroller_ground_y = ground_y;
global.sidescroller_left  = _t + walk_margin;
global.sidescroller_right = room_width - _t - walk_margin;

// --- camera ------------------------------------------------------------------
// Whatever wants following sets world_focus(x, y) each step (character_2d
// does); with no focus the view stays where it started: bottom-left.
view_w = camera_get_view_width(view_camera[0]);
view_h = camera_get_view_height(view_camera[0]);
cam_x = 0;
cam_y = room_height - view_h;
camera_set_view_pos(view_camera[0], cam_x, cam_y);
global.sidescroller_focus_x = undefined;
global.sidescroller_focus_y = undefined;

// Behind everything except the room's background colour: just in front of the
// deepest background layer (a background layer paints over anything deeper).
// Last, because the colliders above were created on `layer`, which an
// instance loses once it has a depth of its own.
var _layers = layer_get_all();
var _bg_depth = 10000;
for (var i = 0; i < array_length(_layers); i++) {
    if (layer_background_get_id(_layers[i]) != -1) _bg_depth = min(_bg_depth, layer_get_depth(_layers[i]));
}
depth = _bg_depth - 1;
