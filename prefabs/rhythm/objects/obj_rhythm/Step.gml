song_time = audio_sound_get_track_position(voice);

// Spawn a note once it is within one screen's approach of the line.
var lead = (hit_y + 40) / scroll_px;
while (spawned < array_length(chart) && chart[spawned][0] - song_time <= lead) {
    var n = instance_create_layer(0, 0, "Instances", obj_note);
    n.time  = chart[spawned][0];
    n.lane  = chart[spawned][1];
    n.owner = id;
    spawned += 1;
}

// A press judges the nearest unjudged note in that lane.
for (var l = 0; l < lanes; l++) {
    if (!keyboard_check_pressed(lane_key[l])) continue;
    var best = noone;
    var best_d = 9999;
    with (obj_note) {
        if (lane != l || judged) continue;
        var d = abs(time - other.song_time);
        if (d < best_d) { best_d = d; best = id; }
    }
    if (best == noone || best_d > miss_window) continue;
    best.judged = true;
    hits += 1;
    // Bump before scoring: `kernel_score_add` scales by the combo multiplier,
    // so the hit that extends a run is the one that benefits from it.
    ::kernel::kernel_combo_bump();
    ::kernel::kernel_score_add((best_d <= perfect_window) ? 100 : 50);
    judgement = (best_d <= perfect_window) ? "PERFECT" : "GOOD";
    judgement_at = song_time;
    audio_play_sound(snd_hit, 5, false);
    instance_destroy(best);
}

// A note the song has left behind is a miss.
with (obj_note) {
    if (judged) continue;
    if (other.song_time - time <= other.miss_window) continue;
    judged = true;
    other.misses += 1;
    ::kernel::kernel_combo_break();
    other.judgement = "MISS";
    other.judgement_at = other.song_time;
    instance_destroy();
}

if (!finished && song_time >= song_length - 0.02) {
    finished = true;
    global.rh_end_time = song_time;
    ::kernel::kernel_game_over("song cleared");
}

global.rh_time       = song_time;
global.rh_time_max   = max(global.rh_time_max, song_time);
global.rh_hits       = hits;
global.rh_misses     = misses;
global.rh_score      = ::kernel::kernel_score();
global.rh_best_combo = ::kernel::kernel_combo_best();
global.rh_finished   = finished;
global.rh_notes_max  = max(global.rh_notes_max, instance_number(obj_note));
