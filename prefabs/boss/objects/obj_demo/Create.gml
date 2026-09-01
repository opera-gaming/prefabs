// Three stages down one health bar, with the harder moves gated behind
// the later ones.
fight = boss_make(300, 3);
moves = [
    { move: "sweep",  phase: 1 },
    { move: "volley", phase: 2 },
    { move: "slam",   phase: 3 },
];
log_lines = [];
shots = [];
