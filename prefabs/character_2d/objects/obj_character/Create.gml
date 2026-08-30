/// A side-view rig character that idles until tapped somewhere, walks there and
/// idles again; tapped above its head it jumps. character_ragdoll() drops it as
/// a Box2D ragdoll and it gets back up on its own. The instance's x,y is where
/// its FEET are: the rig's root is anchored on the ground line.
///
/// Stands alone in any physics room with an obj_solid floor. In a
/// sidescroller_world it reads the world's hand-off globals: ground level,
/// walkable range, the wall object to collide with, and reports its position
/// for the camera (world_focus).

if (rig_asset == -1) rig_asset = rig_mannequin;
// -1: size to the world's scene scale (a rig is 300 px per metre at scale 1), else 0.8.
if (char_scale == -1) {
    char_scale = variable_global_exists("sidescroller_px_per_m") ? global.sidescroller_px_per_m / 300 : 0.8;
}

// --- the world, if there is one ---------------------------------------------
ground_y = y;
walk_left = 0;
walk_right = room_width;
if (variable_global_exists("sidescroller_ground_y")) {
    ground_y = global.sidescroller_ground_y;
    walk_left = global.sidescroller_left;
    walk_right = global.sidescroller_right;
}
// Box2D contacts need a collision event pair, and the world's floor is another
// prefab's object; the character brings its own colliders (obj_solid) instead,
// laid on the ground line and room edges -- created once, shared by all.
character_ensure_solids(ground_y);
// floor_y is the world's ground line; ground_y is where the feet are now -- a
// platform under the placement, and whatever it lands on later.
floor_y = ground_y;
ground_y = character_ground_below(id, x, y);

// --- the rig -----------------------------------------------------------------
rig = rig_create(rig_asset);
rig_set_scale(rig, char_scale);
rig_set_position(rig, x, ground_y);
rig_set_facing(rig, facing);
rig_set_clip(rig, clip_idle, true);
rig_set_root_motion(rig, true);     // the clips carry the walk and the jump

// The capsule is authored for 0.8; the body was built at creation, before the
// scale was known, so it is rebuilt at the right size here.
physics_shape_set_scale(id, char_scale / 0.8, char_scale / 0.8);
phy_position_x = x;
phy_position_y = ground_y;

// Height in px, for "above the head" and for a hit-test that scales with it.
char_height = 1.8 * 300 * char_scale;

// --- state -------------------------------------------------------------------
ragdoll = undefined;        // the doll while down, see character_2d_api
getting_up = false;         // playing a get-up clip, stopped at its `upright` marker
jumping = false;
jump_phase = "";            // "takeoff" | "air" | "land" while jumping
vy = 0;                     // px/s, +down; the game owns the position in the air
vx = 0;
// A metre is 300 px at scale 1; gravity is jump_gravity_g times Earth's.
jump_gravity = jump_gravity_g * 9.8 * 300 * char_scale;
blend_air = 0.1;
blend_land = 0.08;
walk_target = undefined;    // room x a tap asked for; undefined idles
walk_dir = 0;
walk_stop = 14;             // close enough, px
walk_run = false;           // the walk_to asked to run
kicking = false;
markers_fired = [];         // the clip markers this step's rig_update crossed
flash = 0;                  // seconds of white left to draw
flash_blink = 0;            // on/off phase length while it flashes; 0 is solid
blend_walk = 0.25;          // idle -> walk crossfade, seconds
blend_run = 0.2;
blend_kick = 0.12;
blend_idle = 0.30;          // walk -> idle
blend_jump = 0.12;
