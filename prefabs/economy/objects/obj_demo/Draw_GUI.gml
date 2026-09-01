draw_text(40, 30, "economy demo — SPACE earns 250, ENTER buys, BACKSPACE resets");
draw_text(40, 80, "balance  " + economy_format(economy_balance(purse)));
draw_text(40, 105, "level    " + string(level));
draw_text(40, 130, "next     " + economy_format(economy_price(50, level, 1.15)));
draw_text(40, 155, "affordable now: "
    + string(economy_afford_count(purse, 50, level, 1.15)));
draw_text(40, 200, note);
draw_text(40, 240, "earned " + economy_format(purse.earned)
    + "   spent " + economy_format(purse.spent));
