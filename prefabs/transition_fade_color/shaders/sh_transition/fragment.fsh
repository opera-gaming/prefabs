#version 300 es
precision highp float;

// sh_transition — effect: fade-color.
// Adapted from gl-transitions `fadecolor.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/fadecolor.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

const vec3 color = vec3(0.0);   // fade-through colour (default black)
uniform float color_phase;      // knob; default in scr_transition_defaults

vec4 transition (vec2 uv) {
  float cphase = color_phase;
  return mix(
    mix(vec4(color, 1.0), getFromColor(uv), smoothstep(1.0-cphase, 0.0, progress)),
    mix(vec4(color, 1.0), getToColor(uv),   smoothstep(    cphase, 1.0, progress)),
    progress);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
