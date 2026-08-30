draw_rig_shadow(rig);
// A flash paints every pixel white: fog at zero range is the whole-sprite tint the rig honours.
var _white = flash > 0 && (flash_blink <= 0 || (floor(flash / flash_blink) mod 2) == 0);
if (_white) gpu_set_fog(true, c_white, 0, 0);
draw_rig(rig);
if (_white) gpu_set_fog(false, c_black, 0, 0);
