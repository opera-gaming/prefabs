/// Someone says something, and you press a key.
///
/// The typing effect is not decoration: it gives the player a reason for the
/// box to stay up, and it gives the first key press something to do other
/// than skip the line unread. So the first press completes the line and the
/// second advances — anything else loses text to a double tap.

/// @function dialogue_make(lines, chars_per_second)
/// @description A conversation from an array of `{who, text}` structs,
/// revealed at `chars_per_second`. Pass 0 to show each line whole.
function dialogue_make(lines, chars_per_second) {
    return {
        lines: lines,
        at: 0,
        shown: 0,
        rate: chars_per_second,
        done: array_length(lines) == 0,
    };
}

/// @function dialogue_step(state, advance)
/// @description Advance one frame. `advance` is the key press. Returns true
/// on the single frame the conversation ends.
///
/// A press with text still appearing completes the line instead of skipping
/// it, so an impatient player reads everything.
function dialogue_step(state, advance) {
    if (state.done) return false;

    var _text = dialogue_text(state);
    var _full = string_length(_text);
    if (state.rate > 0 && state.shown < _full) {
        state.shown = min(_full, state.shown + state.rate * delta_time / 1000000);
        if (advance) state.shown = _full;
        return false;
    }
    state.shown = _full;
    if (!advance) return false;

    state.at += 1;
    state.shown = 0;
    if (state.at >= array_length(state.lines)) {
        state.done = true;
        return true;
    }
    return false;
}

/// @function dialogue_restart(state)
/// @description Back to the first line. A conversation that can only happen
/// once is a conversation you cannot test.
function dialogue_restart(state) {
    state.at = 0;
    state.shown = 0;
    state.done = array_length(state.lines) == 0;
}
/// @function dialogue_active(state)
/// @description Whether the box should be on screen. Gate the game's own
/// input on this, or the player walks around while talking.
function dialogue_active(state) {
    return !state.done;
}

