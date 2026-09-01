// A room four times the view, so the clamp and the deadzone both have
// somewhere to show themselves.
cam = camera_follow_make(960, 540, { ease: 0.12 });
camera_follow_snap(cam, x, y);
