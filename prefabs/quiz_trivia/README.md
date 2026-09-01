# quiz_trivia

A whole quiz game — questions against the clock, streak scoring, lives, results.

## What you change first

**The questions.** They are a table in `prefab.toml`, compiled into
`scripts/scr_quiz_trivia_data/`. Edit the generated script for a one-off,
or the prefab if you want `gmx prefab check --write` to keep producing them.

**`obj_quiz`.** Everything about how this particular game plays — the
verdict pause, the timer bar, what a streak is worth — is in that one
object, and it is yours.

## What you do not have to maintain

Score, combo, lives, the save store and the high score are `::kernel::`.
Hover, press and layout are `::ui_board::`. Hit-stop, shake and the score
popups are `::feel::`. Those are prefabs: call them, do not read them.

Two answers or nine is the same code — `ui_layout_grid` places whatever
you added, so adding an answer is adding a row to the table.
