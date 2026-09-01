/// @function dialogue_draw_box(state, x, y, width, height)
/// @description A panel with the speaker above it and the revealed text
/// wrapped inside. Draw it in a GUI event so it does not scroll with the room.
function dialogue_draw_box(state, x, y, width, height) {
    if (state.done) return;
    draw_set_colour(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(x, y, x + width, y + height, false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
    draw_rectangle(x, y, x + width, y + height, true);

    var _who = dialogue_speaker(state);
    if (_who != "") draw_text(x + 12, y - 22, _who);
    draw_text_ext(x + 12, y + 12, dialogue_visible(state), 22, width - 24);
    if (dialogue_complete(state)) draw_text(x + width - 24, y + height - 24, ">");
}

