#version 300 es
precision highp float;

// sh_transition — effect: directional.
// Adapted from gl-transitions `Directional.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Directional.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

const vec2 direction = vec2(1.0, 0.0);

vec4 transition(vec2 uv) {
    vec2 p = uv + progress * sign(direction);
    vec2 f = fract(p);
    return mix(
        getToColor(f),
        getFromColor(f),
        step(0.0, p.y) * step(p.y, 1.0) * step(0.0, p.x) * step(p.x, 1.0)
    );
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
