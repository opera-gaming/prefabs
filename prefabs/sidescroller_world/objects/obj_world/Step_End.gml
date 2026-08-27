// Camera, after everything has moved this step. Anchored on the focus the
// world was given (world_focus), with a safe zone so ordinary walking does not
// drag the whole scene.
if (!is_undefined(global.sidescroller_focus_x)) {
    cam_x = world_cam_follow_x(cam_x, global.sidescroller_focus_x, view_w);
    cam_y = world_cam_follow_y(cam_y, global.sidescroller_focus_y, view_h);
    camera_set_view_pos(view_camera[0], cam_x, cam_y);
}
