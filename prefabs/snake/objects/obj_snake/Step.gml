if (!::kernel::kernel_playing()) exit;
::kernel::kernel_tick();

// Turning is recorded now and applied on the next tick. A reversal onto
// your own neck is rejected outright.
if (keyboard_check_pressed(vk_left)  && dir.col ==  0) next_dir = { col: -1, row: 0 };
if (keyboard_check_pressed(vk_right) && dir.col ==  0) next_dir = { col:  1, row: 0 };
if (keyboard_check_pressed(vk_up)    && dir.row ==  0) next_dir = { col: 0, row: -1 };
if (keyboard_check_pressed(vk_down)  && dir.row ==  0) next_dir = { col: 0, row:  1 };

clock -= delta_time / 1000000;
if (clock > 0) exit;
clock += tick;
dir = next_dir;

var _head = body[0];
var _next = { col: _head.col + dir.col, row: _head.row + dir.row };

// The wall and yourself are the same ending.
if (_next.col < 0 || _next.row < 0 || _next.col >= cols || _next.row >= rows) {
    snake_end();
    exit;
}
for (var i = 0; i < array_length(body); i++) {
    if (body[i].col == _next.col && body[i].row == _next.row) {
        snake_end();
        exit;
    }
}

array_insert(body, 0, _next);
if (_next.col == food.col && _next.row == food.row) {
    ::kernel::kernel_score_add(food_score);
    var _p = snake_cell_centre(board, food.col, food.row);
    ::feel::feel_pop(_p.x, _p.y, "+" + string(food_score), c_yellow);
    tick = max(step_floor,
               tick - step_gain);
    food = snake_place_food();
} else {
    // Not eating means dropping the tail — which is what makes eating grow.
    array_delete(body, array_length(body) - 1, 1);
}
