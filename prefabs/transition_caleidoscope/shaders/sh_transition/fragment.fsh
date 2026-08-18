#version 300 es
precision highp float;

// sh_transition — effect: caleidoscope.
// Adapted from gl-transitions `kaleidoscope.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/kaleidoscope.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float speed;   // knob; default in scr_transition_defaults
uniform float angle;   // knob; default in scr_transition_defaults
uniform float power;   // knob; default in scr_transition_defaults

vec4 transition(vec2 uv) {
    float sp = speed;
    float an = angle;
    float pw = power;
    vec2 p = uv.xy / vec2(1.0).xy;
    vec2 q = p;
    float t = pow(progress, pw) * sp;
    p = p - 0.5;
    for (int i = 0; i < 7; i++) {
        p = vec2(sin(t) * p.x + cos(t) * p.y, sin(t) * p.y - cos(t) * p.x);
        t += an;
        p = abs(mod(p, 2.0) - 1.0);
    }
    abs(mod(p, 1.0));
    return mix(
        mix(getFromColor(q), getToColor(q), progress),
        mix(getFromColor(p), getToColor(p), progress),
        1.0 - 2.0 * abs(progress - 0.5));
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
