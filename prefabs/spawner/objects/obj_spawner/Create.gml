// What to spawn. Set this to your own object — it is left as `noone` so a
// freshly applied recipe cannot silently spawn the wrong thing.
spawns = noone;

var _t = spawner_tuning();
interval = _t.interval_start;
wave = 1;
wave_timer = _t.wave_frames;
spawned = 0;

// Alarms are frame counters, not repeating timers: an alarm that is not
// re-armed inside its own event fires exactly once. Re-arming is the whole
// mechanism, and forgetting it is why a spawner "works" for one enemy.
alarm[0] = interval;
