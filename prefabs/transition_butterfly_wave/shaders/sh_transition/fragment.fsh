#version 300 es
precision highp float;

// sh_transition — effect: butterfly-wave.
// Adapted from gl-transitions `ButterflyWaveScrawler.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ButterflyWaveScrawler.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float amplitude;          // knob; default in scr_transition_defaults
uniform float waves;              // knob; default in scr_transition_defaults
uniform float color_separation;   // knob; default in scr_transition_defaults

const float PI = 3.14159265358979323846264;

float compute(vec2 p, float progress, vec2 center, float amp, float w) {
    vec2 o = p * sin(progress * amp) - center;
    // horizontal vector
    vec2 h = vec2(1.0, 0.0);
    // butterfly polar function (don't ask me why this one :))
    float theta = acos(dot(o, h)) * w;
    return (exp(cos(theta)) - 2.0 * cos(4.0 * theta) + pow(sin((2.0 * theta - PI) / 24.0), 5.0)) / 10.0;
}

vec4 transition(vec2 uv) {
    float amp = amplitude;
    float w = waves;
    float cs = color_separation;
    vec2 p = uv.xy / vec2(1.0).xy;
    float inv = 1.0 - progress;
    vec2 dir = p - vec2(0.5);
    float dist = length(dir);
    float disp = compute(p, progress, vec2(0.5, 0.5), amp, w);
    vec4 texTo = getToColor(p + inv * disp);
    vec4 texFrom = vec4(
        getFromColor(p + progress * disp * (1.0 - cs)).r,
        getFromColor(p + progress * disp).g,
        getFromColor(p + progress * disp * (1.0 + cs)).b,
        1.0);
    return texTo * progress + texFrom * inv;
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
