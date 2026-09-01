var _t = platformer_tuning();
jump = ::motion::motion_platformer_make({
    run_speed: _t.run_speed,
    jump_strength: _t.jump_strength,
    gravity_per_frame: _t.gravity_per_frame,
    // Terrain is the `Tiles` layer, not one instance per cell: it is a layer
    // an editor can paint, and it is what the level map compiles into.
    tilemap: ::motion::motion_tilemap("Tiles")
});
cam = ::camera::camera_follow_make(camera_get_view_width(view_camera[0]),
                                   camera_get_view_height(view_camera[0]));
::camera::camera_follow_snap(cam, x, y);
won = false;
