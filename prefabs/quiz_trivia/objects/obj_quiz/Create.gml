// Hand the generated content and tuning to the kernel. Every component
// reads through ::kernel::kernel_data / kernel_tuning from here on, so
// none of them needs to know this template's name.
::kernel::kernel_boot();
::kernel::kernel_data_source(quiz_trivia_data, quiz_trivia_tuning());

questions = ::kernel::kernel_data("questions");
board = ::ui_board::ui_board_make();

index = -1;
lives_left = ::kernel::kernel_tuning("lives", 3);
time_left = 0;
verdict = "";
verdict_left = 0;
chosen = -1;

/// Build the answer board for question `n`, or end the run when the
/// questions run out.
next_question = function(n) {
    if (n >= array_length(questions)) {
        ::kernel::kernel_game_over("cleared");
        return;
    }
    index = n;
    chosen = -1;
    verdict = "";
    time_left = ::kernel::kernel_tuning("question_time", 12);

    var _q = questions[n];
    ::ui_board::ui_clear(board);
    for (var i = 0; i < array_length(_q.answers); i++) {
        ::ui_board::ui_add(board, "a" + string(i), 0, 0, 0, 0, _q.answers[i], i);
    }
    // Two columns: four answers read as a block rather than a list, and
    // the layout is the same code for three answers or six.
    ::ui_board::ui_layout_grid(board, 2, 160, 250, 300, 76, 16);
};

/// Resolve `pick` against the current question. `pick` of -1 is a
/// timeout, which counts as wrong but is worth distinguishing in the
/// verdict line.
answer = function(pick) {
    var _q = questions[index];
    chosen = pick;
    var _right = (pick == _q.correct);

    if (_right) {
        ::kernel::kernel_combo_bump();
        var _base = ::kernel::kernel_tuning("points_correct", 100)
                  + ::kernel::kernel_tuning("streak_bonus", 25) * (::kernel::kernel_combo() - 1);
        var _gained = ::kernel::kernel_score_add(_base);
        verdict = "correct";
        ::feel::feel_pop(480, 300, "+" + string(_gained), c_lime);
        ::feel::feel_hitstop(0.06);
    } else {
        ::kernel::kernel_combo_break();
        lives_left -= 1;
        verdict = (pick == -1) ? "out of time" : "wrong";
        ::feel::feel_shake(0.3, 10);
        ::feel::feel_pop(480, 300, verdict, c_red);
    }

    // Tint the board so the right answer is visible during the pause,
    // and stop it accepting a second click.
    for (var i = 0; i < array_length(_q.answers); i++) {
        ::ui_board::ui_set_enabled(board, "a" + string(i), false);
        if (i == _q.correct) ::ui_board::ui_set_tint(board, "a" + string(i), c_lime);
        else if (i == pick)  ::ui_board::ui_set_tint(board, "a" + string(i), c_red);
    }

    verdict_left = 0.9;
    if (lives_left <= 0) ::kernel::kernel_game_over("out of lives");
};

next_question(0);
::kernel::kernel_state_set(::kernel::kernel_states().play);

// Tuning read once here rather than every frame: one visible block
// of every knob this object answers to, and no struct lookup in Step.
question_time = ::kernel::kernel_tuning("question_time", 12);
