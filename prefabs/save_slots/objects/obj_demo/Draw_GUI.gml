draw_text(40, 30, "save-slots demo — UP/DOWN sets the level, 1-3 saves to a slot");
draw_text(40, 50, "SPACE reads slot 0, BACKSPACE deletes every slot");
draw_text(40, 90, "level to save: " + string(level));

// A slot-select screen reads summaries, not whole saves.
for (var i = 0; i < 3; i++) {
    var _sum = save_slots_summary(i, ["level", "played"]);
    var _y = 140 + i * 40;
    draw_rectangle(40, _y, 460, _y + 30, true);
    draw_text(52, _y + 6, _sum.used
        ? "slot " + string(i) + " — level " + string(_sum.level)
            + ", " + string(_sum.played) + "s"
        : "slot " + string(i) + " — empty");
}
draw_text(40, 300, note);
