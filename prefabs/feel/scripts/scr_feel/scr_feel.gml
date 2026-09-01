/// Juice: the difference between a loop that works and one that feels
/// finished.
///
/// This pack requires nothing on purpose. Everything here is a pure
/// function of its arguments or of feel's own controller, so retuning a
/// curve never forces a kernel release — and every template can take a
/// feel update without taking anything else.

/// @function feel_ease(t, kind)
/// @description Remap a 0..1 progress through an easing curve.
/// Unknown kinds fall through to linear rather than erroring: a typo in
/// a tuning file should look wrong, not crash the game.
function feel_ease(t, kind = "out_quad") {
    t = clamp(t, 0, 1);
    switch (kind) {
        case "in_quad":   return t * t;
        case "out_quad":  return 1 - (1 - t) * (1 - t);
        case "in_out":    return (t < 0.5) ? 2 * t * t : 1 - power(-2 * t + 2, 2) / 2;
        case "out_back":  return 1 + 2.70158 * power(t - 1, 3) + 1.70158 * power(t - 1, 2);
        case "out_elastic":
            if (t == 0 || t == 1) return t;
            return power(2, -10 * t) * sin((t * 10 - 0.75) * (2 * pi / 3)) + 1;
    }
    return t;
}

/// @function feel_tween(from, to, t, kind)
/// @description Interpolate `from`..`to` at eased progress `t`.
function feel_tween(from, to, t, kind = "out_quad") {
    return from + (to - from) * feel_ease(t, kind);
}

/// @function feel_ensure()
/// @description Make sure feel's controller exists. Called by every
/// entry point below, so a template never has to place the object.
function feel_ensure() {
    if (!instance_exists(obj_feel)) instance_create_depth(0, 0, -9000, obj_feel);
    return obj_feel;
}

