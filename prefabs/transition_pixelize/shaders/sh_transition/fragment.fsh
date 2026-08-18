#version 300 es
precision highp float;

// sh_transition — effect: pixelize.
// Adapted from gl-transitions `pixelize.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/pixelize.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

// squaresMin/steps are int/vec2 params (default [20,20] / 50) — baked as consts.
const vec2 squares_min = vec2(20.0, 20.0); // minimum number of squares
const int steps = 50;                      // zero disables the stepping

vec4 transition(vec2 uv) {
  float d = min(progress, 1.0 - progress);
  float dist = steps > 0 ? ceil(d * float(steps)) / float(steps) : d;
  vec2 squareSize = 2.0 * dist / vec2(squares_min);
  vec2 p = dist > 0.0 ? (floor(uv / squareSize) + 0.5) * squareSize : uv;
  return mix(getFromColor(p), getToColor(p), progress);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
