#version 300 es
precision highp float;

// sh_transition — effect: doom.
// Adapted from gl-transitions `DoomScreenTransition.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DoomScreenTransition.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

// Number of total bars/columns.
const int bars = 30;
// Further speed variation. 0 = no noise (valid); default 0.1.
const float noise = 0.1;
// How much the bars "run" from the middle first. 0 = no drip (valid); default 0.5.
const float drip_scale = 0.5;

uniform float amplitude;   // knob; default in scr_transition_defaults
uniform float frequency;   // knob; default in scr_transition_defaults

float rand(int num) {
    return fract(mod(float(num) * 67123.313, 12.0) * sin(float(num) * 10.3) * cos(float(num)));
}

float wave(int num) {
    float freq = frequency;
    float fn = float(num) * freq * 0.1 * float(bars);
    return cos(fn * 0.5) * cos(fn * 0.13) * sin((fn + 10.0) * 0.3) / 2.0 + 0.5;
}

float drip(int num) {
    return sin(float(num) / float(bars - 1) * 3.141592) * drip_scale;
}

float pos(int num) {
    return (noise == 0.0 ? wave(num) : mix(wave(num), rand(num), noise)) + (drip_scale == 0.0 ? 0.0 : drip(num));
}

vec4 transition(vec2 uv) {
    float amp = amplitude;
    int bar = int(uv.x * (float(bars)));
    float scale = 1.0 + pos(bar) * amp;
    float phase = progress * scale;
    float posY = uv.y / vec2(1.0).y;
    vec2 p;
    vec4 c;
    if (phase + posY < 1.0) {
        p = vec2(uv.x, uv.y + mix(0.0, vec2(1.0).y, phase)) / vec2(1.0).xy;
        c = getFromColor(p);
    } else {
        p = uv.xy / vec2(1.0).xy;
        c = getToColor(p);
    }
    return c;
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
