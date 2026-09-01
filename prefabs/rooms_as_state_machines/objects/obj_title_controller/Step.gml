// Release rather than press: whatever key brought you here from the
// results screen is often still down on the frame this room starts.
if (::kernel::kernel_action_pressed("confirm")) room_goto(rm_game);
