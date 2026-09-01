var _ctl = instance_find(obj_demo, 0);
if (_ctl != noone && _ctl.paused) exit;

// Impact first, before anything else touches the velocity.
// Threshold well under the cap, or it can never fire — the two are
// the same scale on purpose.
var _hit = phys_impact(body, 3);
if (_hit > 0) {
    squash = min(1, _hit / 14);
    hits += 1;
}
squash *= 0.86;

phys_clamp_speed(body);

// A ball at rest somewhere unreachable ends no run, so nudge it.
if (phys_stalled(body, 1.5, 1.2)) phys_nudge(irandom(359), 0.35);

// Escaping through a seam happens; put it back rather than losing it.
if (phys_out_of_bounds(80)) {
    phys_pin(room_width / 2, room_height / 2);
    phys_launch(irandom(359), 12);
}
