// The song is the clock. Every note position and every judgement below is
// measured against `audio_sound_get_track_position`, never against a frame
// count, so a stutter moves the picture and never the beat.

depth = 100;

// The kernel owns run state, score and combo, and has to be booted before
// anything reads them.
::kernel::kernel_boot();
::kernel::kernel_state_set(::kernel::kernel_states().play);
// This game draws its own HUD, because the song clock belongs beside the
// score rather than under it.
::kernel::kernel_hud_visible(false);
// And it owns pausing or nothing does: the kernel's pause stops the game
// while the track keeps playing, and the chart is never in step again.
::kernel::kernel_pause_enabled(false);

var _t = rhythm_tuning();
song_length = _t.song_length;
bpm         = _t.bpm;
beat        = 60 / bpm;

lanes     = 4;
lane_x    = [200, 280, 360, 440];
lane_key  = [vk_left, vk_down, vk_up, vk_right];
lane_name = ["left", "down", "up", "right"];
hit_y     = 400;
// Pixels a note travels per second of lead time. With hit_y at 400 a note is
// on screen for a little over a second and a half before it lands.
scroll_px = _t.scroll_px;

// Seconds either side of the note. `miss_window` is also the width of the
// press that registers at all, so it is the outer edge of `good`.
perfect_window = _t.perfect_window;
good_window    = _t.good_window;
miss_window    = _t.miss_window;

// One note per beat from beat 4, lanes cycling. Beats 0-3 are the count-in.
chart = [];
for (var b = 4; b < 16; b++) {
    array_push(chart, [b * beat, (b - 4) % lanes]);
}
spawned = 0;

voice     = audio_play_sound(snd_song, 10, false);
song_time = 0;
finished  = false;

hits = 0;
misses = 0;
judgement = "";
judgement_at = -99;

// Mirrored to globals because a gametest can only assert on globals, and
// because "did the transport actually run" is the question this game exists
// to answer.
global.rh_voice      = voice;
global.rh_time       = 0;
global.rh_time_max   = 0;
global.rh_hits       = 0;
global.rh_misses     = 0;
global.rh_score      = 0;
global.rh_best_combo = 0;
global.rh_finished   = false;
global.rh_notes_max  = 0;
global.rh_end_time   = -1;
