#version 300 es
precision highp float;

// sh_transition — effect: cross-hatch.
// Adapted from gl-transitions `crosshatch.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/crosshatch.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

const vec2 center = vec2(0.5, 0.5);
uniform float threshold;   // knob; default in scr_transition_defaults
uniform float fade_edge;   // knob; default in scr_transition_defaults

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

vec4 transition(vec2 p) {
    float th = threshold;
    float fe = fade_edge;
    float dist = distance(center, p) / th;
    float r = progress - min(rand(vec2(p.y, 0.0)), rand(vec2(0.0, p.x)));
    return mix(
        getFromColor(p),
        getToColor(p),
        mix(0.0,
            mix(step(dist, r), 1.0, smoothstep(1.0 - fe, 1.0, progress)),
            smoothstep(0.0, fe, progress)));
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
