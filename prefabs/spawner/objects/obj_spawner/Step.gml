if (!::kernel::kernel_playing()) exit;

var _t = spawner_tuning();
wave_timer -= 1;
if (wave_timer <= 0) {
    wave += 1;
    wave_timer = _t.wave_frames;
    interval = max(_t.interval_min, interval * _t.interval_scale);
}
