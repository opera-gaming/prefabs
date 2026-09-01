// A persistent object's Create runs again if a second one is ever placed;
// guarding on the global keeps the track playing instead of restarting it
// on every room change.
if (!variable_global_exists("music_handle")) global.music_handle = -1;

/// @function music_play(snd)
/// @description Loop `snd`, replacing whatever is playing.
music_play = function(snd) {
    if (global.music_handle != -1) audio_stop_sound(global.music_handle);
    global.music_handle = audio_play_sound(snd, 100, true);
    audio_sound_gain(global.music_handle, music_and_sfx_tuning().music_gain, 0);
};

/// @function music_stop(fade_ms)
music_stop = function(fade_ms = 400) {
    if (global.music_handle == -1) return;
    audio_sound_gain(global.music_handle, 0, fade_ms);
    global.music_handle = -1;
};

/// @function sfx(snd)
/// @description One-shot. Not looped, not tracked — fire and forget.
sfx = function(snd) {
    var _h = audio_play_sound(snd, 50, false);
    audio_sound_gain(_h, music_and_sfx_tuning().sfx_gain, 0);
    return _h;
};
