var _cfg = isometric_basics_tuning();
var _dt = delta_time / 1000000;

// Pan by moving the projection origin. Nothing else has to know.
if (::kernel::kernel_action_held("left"))  iso.ox += _cfg.pan_speed * _dt;
if (::kernel::kernel_action_held("right")) iso.ox -= _cfg.pan_speed * _dt;
if (::kernel::kernel_action_held("up"))    iso.oy += _cfg.pan_speed * _dt;
if (::kernel::kernel_action_held("down"))  iso.oy -= _cfg.pan_speed * _dt;

var _c = ::iso::iso_to_cell(iso, mouse_x, mouse_y);
hover = { col: round(_c.col), row: round(_c.row) };
