// Lower depth draws on top. This is an instance variable, so it wins over
// whatever depth the layer sets.
depth = -9999;

// Hide the OS cursor. Do this here rather than in a boot object so the
// object is self-contained and can be dropped into any project.
window_set_cursor(cr_none);

size = custom_mouse_pointer_tuning().size_px;
