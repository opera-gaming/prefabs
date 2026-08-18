#version 300 es
precision highp float;

// sh_transition — effect: rotate-scale-face.
// Adapted from gl-transitions `rotate_scale_fade.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/rotate_scale_fade.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

#define PI 3.14159265359

const vec2 center = vec2(0.5, 0.5);
const vec4 back_color = vec4(0.15, 0.15, 0.15, 1.0);
uniform float rotations;   // knob; default in scr_transition_defaults
uniform float scale;       // knob; default in scr_transition_defaults

vec4 transition(vec2 uv) {
    float rot = rotations;
    float scl = scale;

    vec2 difference = uv - center;
    vec2 dir = normalize(difference);
    float dist = length(difference);

    float angle = 2.0 * PI * rot * progress;

    float c = cos(angle);
    float s = sin(angle);

    float currentScale = mix(scl, 1.0, 2.0 * abs(progress - 0.5));

    vec2 rotatedDir = vec2(dir.x * c - dir.y * s, dir.x * s + dir.y * c);
    vec2 rotatedUv = center + rotatedDir * dist / currentScale;

    if (rotatedUv.x < 0.0 || rotatedUv.x > 1.0 ||
        rotatedUv.y < 0.0 || rotatedUv.y > 1.0)
        return back_color;

    return mix(getFromColor(rotatedUv), getToColor(rotatedUv), progress);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
