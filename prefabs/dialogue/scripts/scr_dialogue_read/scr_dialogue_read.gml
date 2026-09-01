/// @function dialogue_speaker(state)
function dialogue_speaker(state) {
    if (state.done || state.at >= array_length(state.lines)) return "";
    var _l = state.lines[state.at];
    return variable_struct_exists(_l, "who") ? _l.who : "";
}

/// @function dialogue_text(state)
/// @description The current line in full, however much of it is visible.
function dialogue_text(state) {
    if (state.done || state.at >= array_length(state.lines)) return "";
    return state.lines[state.at].text;
}

/// @function dialogue_visible(state)
/// @description As much of the current line as has been revealed — what to
/// actually draw.
function dialogue_visible(state) {
    return string_copy(dialogue_text(state), 1, floor(state.shown));
}

/// @function dialogue_complete(state)
/// @description Whether the current line is fully revealed, so a caller can
/// show a "press for more" prompt only once there is more to press for.
function dialogue_complete(state) {
    return state.shown >= string_length(dialogue_text(state));
}

