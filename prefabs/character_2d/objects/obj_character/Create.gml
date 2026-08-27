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

// --- the world, if there is one ---------------------------------------------
ground_y = y;
walk_left = 0;
walk_right = room_width;
if (variable_global_exists("sidescroller_ground_y")) {
    ground_y = global.sidescroller_ground_y;
    walk_left = global.sidescroller_left;
    walk_right = global.sidescroller_right;
}
// Box2D only generates contacts between objects that have a collision event
// for each other, and a world's floor belongs to another prefab that cannot
// know this one. So the character brings its own invisible colliders (obj_solid,
// which its bodies do have events for), laid on the world's ground line and
// room edges -- created once, shared by every character.
character_ensure_solids(ground_y);

// --- the rig -----------------------------------------------------------------
rig = rig_create(rig_asset);
rig_set_scale(rig, char_scale);
rig_set_position(rig, x, ground_y);
rig_set_facing(rig, facing);
rig_set_clip(rig, clip_idle, true);
rig_set_root_motion(rig, true);     // the clips carry the walk and the jump

// The capsule is authored for 0.8; the instance scale carries any other size.
image_xscale = char_scale / 0.8;
image_yscale = char_scale / 0.8;
phy_position_x = x;
phy_position_y = ground_y;

// Height in px, for "above the head" and for a hit-test that scales with it.
char_height = 1.8 * 300 * char_scale;

// --- state -------------------------------------------------------------------
ragdoll = undefined;        // the doll while down, see character_2d_api
getting_up = false;         // playing a get-up clip, stopped at its `upright` marker
jumping = false;
walk_target = undefined;    // room x a tap asked for; undefined idles
walk_dir = 0;
walk_stop = 14;             // close enough, px
blend_walk = 0.25;          // idle -> walk crossfade, seconds
blend_idle = 0.30;          // walk -> idle
blend_jump = 0.12;
