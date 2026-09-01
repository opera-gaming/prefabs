// Entering `play` resets score, combo and the run clock — see the kernel.
::kernel::kernel_state_set(::kernel::kernel_states().play);

cols = ::kernel::kernel_tuning("cols", 24);
rows = ::kernel::kernel_tuning("rows", 16);
cell = ::kernel::kernel_tuning("cell", 30);
board = ::grid::grid_make(cols, rows, cell, cell,
    (room_width - cols * cell) / 2, (room_height - rows * cell) / 2);

// The body is a list of cells, head first. Growing is not removing the tail.
body = [];
for (var i = 0; i < ::kernel::kernel_tuning("start_length", 4); i++) {
    array_push(body, { col: 8 - i, row: 8 });
}
dir = { col: 1, row: 0 };
// Buffered so a fast double-tap cannot reverse you into your own neck
// between two ticks.
next_dir = { col: 1, row: 0 };

tick = ::kernel::kernel_tuning("step_seconds", 0.16);
clock = tick;
food = { col: 16, row: 8 };

// Tuning read once here rather than every frame: one visible block
// of every knob this object answers to, and no struct lookup in Step.
food_score = ::kernel::kernel_tuning("food_score", 10);
step_floor = ::kernel::kernel_tuning("step_floor", 0.06);
step_gain = ::kernel::kernel_tuning("step_gain", 0.004);
