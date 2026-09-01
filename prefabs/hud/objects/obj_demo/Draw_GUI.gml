var _tl = hud_anchor("tl", 40, 30);
draw_text(_tl.x, _tl.y, "hud demo — SPACE damages, L costs a life, ENTER resets");

hud_panel(_tl.x, _tl.y + 40, 320, 96, 0.45);
draw_text(_tl.x + 12, _tl.y + 50, "health");
hud_bar_lagged(_tl.x + 12, _tl.y + 74, 280, 18, hp, lag, c_lime);
draw_text(_tl.x + 12, _tl.y + 100, "lives");
hud_pips(_tl.x + 70, _tl.y + 100, 3, hearts, 14, 6);

var _tr = hud_anchor("tr", 40, 30);
hud_label(_tr.x, _tr.y, "anchored right", fa_right);
var _br = hud_anchor("br", 40, 40);
hud_label(_br.x, _br.y, "anchored bottom-right", fa_right);
var _bt = hud_anchor("bottom", 0, 90);
hud_label(_bt.x, _bt.y, "these stay put when the window resizes", fa_center);
