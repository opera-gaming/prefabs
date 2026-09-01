// The demo now runs inside a project that installs grid's `requires`, so
// it can use the kernel the way a real grid game would — gating on the
// run state rather than hand-rolling one.
::kernel::kernel_boot(7);
::kernel::kernel_state_set(::kernel::kernel_states().play);

board = grid_make(10, 8, 40, 40, 40, 90);
for (var i = 0; i < 12; i++) grid_set(board, irandom(9), 4 + irandom(3), 1);

// One snapshot taken up front is all undo and restart both need.
start = grid_snapshot(board);
