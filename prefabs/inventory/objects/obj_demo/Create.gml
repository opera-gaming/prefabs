// Four slots of five, so the interesting cases are reachable by hand:
// a part-used stack filling before a new slot opens, and an add that
// only partly fits.
bag = inventory_make(4, 5);
last = "";
