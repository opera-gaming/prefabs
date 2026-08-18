#version 300 es
precision highp float;

// sh_transition — effect: water-drop.
// Adapted from gl-transitions `WaterDrop.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/WaterDrop.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float amplitude;   // knob; default in scr_transition_defaults
uniform float speed;       // knob; default in scr_transition_defaults

vec4 transition(vec2 p) {
  float amp = amplitude;
  float spd = speed;

  vec2 dir = p - vec2(0.5,0.5);
  float dist = length(dir);

  if (dist > progress) {
    return mix(getFromColor( p), getToColor( p), progress);
  } else {
    vec2 offset = dir * sin(dist * amp - progress * spd);
    return mix(getFromColor( p + offset), getToColor( p), progress);
  }
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
