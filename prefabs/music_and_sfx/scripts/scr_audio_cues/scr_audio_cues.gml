/// Firing a sound from anywhere, and being able to test that you did.
///
/// The controller holds the gains and the music handle, so playing a sound
/// means reaching through it. These wrap that reach: callable from any object
/// without naming `obj_audio`, and safe in a room that has not got one yet —
/// a missing controller is silence, not a crashed frame.

/// @function cue_sfx(snd)
/// @description Fire a one-shot.
function cue_sfx(snd) {
    // Recorded before playing, because the sound itself is unobservable in a
    // headless run: with no audio device `audio_play_sound` returns -1 and
    // `audio_is_playing` is never true, so a test can only check that the
    // right cue was *asked for*. That is what these globals are.
    if (!variable_global_exists("cue_count")) global.cue_count = 0;
    global.last_cue = snd;
    global.cue_count += 1;

    if (!instance_exists(obj_audio)) return;
    with (obj_audio) sfx(snd);
}

/// @function cue_music(snd)
/// @description Start the looping track, replacing whatever is playing.
function cue_music(snd) {
    global.music_wanted = snd;
    if (!instance_exists(obj_audio)) return;
    with (obj_audio) music_play(snd);
}

/// @function cue_music_stop(fade_ms)
/// @description Fade the track out — before a win sting, so it plays over
/// silence rather than over the loop.
function cue_music_stop(fade_ms = 400) {
    global.music_wanted = noone;
    if (!instance_exists(obj_audio)) return;
    with (obj_audio) music_stop(fade_ms);
}
