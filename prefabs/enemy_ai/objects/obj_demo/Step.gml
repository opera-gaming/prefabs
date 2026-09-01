// Once per enemy. `ai_separate` pushes the *calling* instance away from its
// peers, so running it from one instance separated that enemy from the pack
// and left every other pair fully overlapped. The library's own `_share = 0.5`
// is what stops the per-pair double-count this looks like it would cause.
with (obj_demo_enemy) {
    ai_separate(ai, obj_demo_enemy, 36);
}
