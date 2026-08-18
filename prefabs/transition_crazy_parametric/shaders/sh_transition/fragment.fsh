#version 300 es
precision highp float;

// sh_transition — effect: crazy-parametric.
// Adapted from gl-transitions `CrazyParametricFun.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CrazyParametricFun.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float a;           // knob; default in scr_transition_defaults
uniform float b;           // knob; default in scr_transition_defaults
uniform float amplitude;   // knob; default in scr_transition_defaults
uniform float smoothness;  // knob; default in scr_transition_defaults

vec4 transition(vec2 uv) {
    float aa  = a;
    float bb  = b;
    float amp = amplitude;
    float sm  = smoothness;
    vec2 p = uv.xy / vec2(1.0).xy;
    vec2 dir = p - vec2(0.5);
    float dist = length(dir);
    float x = (aa - bb) * cos(progress) + bb * cos(progress * ((aa / bb) - 1.0));
    float y = (aa - bb) * sin(progress) - bb * sin(progress * ((aa / bb) - 1.0));
    vec2 offset = dir * vec2(sin(progress * dist * amp * x), sin(progress * dist * amp * y)) / sm;
    return mix(getFromColor(p + offset), getToColor(p), smoothstep(0.2, 1.0, progress));
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
