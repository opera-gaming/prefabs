draw_text(40, 30, "inventory demo — 1 arrow, 2 bomb, 3 rope, 4 key");
draw_text(40, 50, "BACKSPACE removes 2 arrows, DELETE empties it");
draw_text(40, 90, last);

for (var i = 0; i < bag.slots; i++) {
    var _x = 40 + i * 120;
    draw_rectangle(_x, 130, _x + 100, 210, true);
    var _s = inventory_slot(bag, i);
    if (_s == undefined) continue;
    draw_text(_x + 12, 150, _s.item);
    draw_text(_x + 12, 175, string(_s.count) + " / " + string(bag.stack));
}

draw_text(40, 240, inventory_full(bag) ? "every slot used" : "slots free");
draw_text(40, 260, "room for 4 more arrows: "
    + string(inventory_room_for(bag, "arrow", 4)));
