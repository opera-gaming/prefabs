var _n = array_length(sounds);
var _old = sel;
if (keyboard_check_pressed(vk_up))   sel = max(0, sel - 1);
if (keyboard_check_pressed(vk_down)) sel = min(_n - 1, sel + 1);
// Moving to a different sound stops the one currently playing.
if (sel != _old && playing != -1) {
    if (audio_is_playing(playing)) audio_stop_sound(playing);
    playing = -1;
}
if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
    if (playing != -1 && audio_is_playing(playing)) audio_stop_sound(playing);
    var _idx = asset_get_index(sounds[sel]);
    if (_idx != -1) playing = audio_play_sound(_idx, 1, false);
}
// keep selection in the visible window
if (sel < view_top) view_top = sel;
if (sel > view_top + 24) view_top = sel - 24;
