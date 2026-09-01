if (!instance_exists(owner)) exit;

// Position is a pure function of where the song is, so a note is never
// integrated frame by frame and can never drift away from its own beat.
x = owner.lane_x[lane];
y = owner.hit_y - (time - owner.song_time) * owner.scroll_px;

if (y > room_height + 64) instance_destroy();
