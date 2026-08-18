// Redirect the frame's rendering into a capture surface: the outgoing room on
// the first frame, then the incoming room once we've switched.
surface_set_target(in_target ? to_surface : from_surface);
