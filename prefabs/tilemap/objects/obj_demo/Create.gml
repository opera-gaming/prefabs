// The map is the readable part: change a character and the level changes.
level = [
    "##########################",
    "#           o            #",
    "#   ####        ####     #",
    "#        o           o   #",
    "#  ####      @    ####   #",
    "#                        #",
    "##########################",
];
cell = 32;
built = tilemap_build(level, cell, { "#": obj_demo_block });
start = tilemap_first(level, cell, "@", 100, 100);
coins = tilemap_count(level, "o");
