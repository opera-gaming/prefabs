// Trigger a screen shake (and explosion sfx) anywhere the player clicks.
if (mouse_check_button_pressed(mb_left)) {
    camera_shake(0.75, 0.1, 0.15, 0.25);
    audio_play_sound(snd_explosion, 1, false);
}
