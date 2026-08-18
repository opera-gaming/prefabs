#version 300 es
precision highp float;

// sh_transition — effect: glitch-memories.
// Adapted from gl-transitions `GlitchMemories.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GlitchMemories.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

vec4 transition(vec2 p) {
    vec2 block = floor(p.xy / vec2(16.0));
    vec2 uv_noise = block / vec2(64.0);
    uv_noise += floor(vec2(progress) * vec2(1200.0, 3500.0)) / vec2(64.0);
    vec2 dist = progress > 0.0 ? (fract(uv_noise) - 0.5) * 0.3 * (1.0 - progress) : vec2(0.0);
    vec2 red = p + dist * 0.2;
    vec2 green = p + dist * 0.3;
    vec2 blue = p + dist * 0.5;

    return vec4(
        mix(getFromColor(red), getToColor(red), progress).r,
        mix(getFromColor(green), getToColor(green), progress).g,
        mix(getFromColor(blue), getToColor(blue), progress).b,
        1.0);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
