draw_text(40, 30, "music_and_sfx demo - every sound goes through cue_sfx / cue_music");

draw_text(40, 90, "controller: " + (instance_exists(obj_audio)
    ? "obj_audio (persistent, survives room changes)" : "absent"));

// A headless run has no audio device, so `audio_is_playing` reports false
// for everything. The cue counters are the only thing a test can read.
draw_text(40, 140, "cues fired:  " + string(variable_global_exists("cue_count")
    ? global.cue_count : 0));
draw_text(40, 180, "last cue:    " + (variable_global_exists("last_cue")
    ? string(global.last_cue) : "none yet"));

draw_text(40, 260, "music_gain " + string(music_and_sfx_tuning().music_gain));
draw_text(40, 300, "sfx_gain   " + string(music_and_sfx_tuning().sfx_gain));
