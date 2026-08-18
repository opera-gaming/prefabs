// One-shot async image fetch, spawned by gx_load_image() with a struct
// carrying: image_url, callback, default_image, timeout. Destroys itself
// once the image loads (or the timeout fires).
alarm_set(0, game_get_speed(gamespeed_fps) * timeout);
request_id = sprite_add(image_url, 0, 0, 0, 0, 0);
