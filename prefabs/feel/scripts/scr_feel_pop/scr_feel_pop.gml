/// @function feel_pop(x, y, text, colour)
/// @description A floating label that rises and fades. GUI-space
/// coordinates, matching where scores are drawn.
function feel_pop(x, y, text, colour = c_white) {
    feel_ensure();
    array_push(obj_feel.pops, {
        x: x, y: y, text: string(text), colour: colour, life: 0, span: 0.8
    });
}

/// @function feel_squash(amount)
/// @description Squash-and-stretch scale pair for `amount` 0..1, as
/// {xscale, yscale}. Volume-preserving, which is what stops it reading
/// as a plain resize.
function feel_squash(amount) {
    return { xscale: 1 + amount, yscale: 1 - amount * 0.6 };
}
