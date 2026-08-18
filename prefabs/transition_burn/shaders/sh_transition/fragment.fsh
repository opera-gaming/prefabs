#version 300 es
precision highp float;

// sh_transition — effect: burn.
// Adapted from gl-transitions `FilmBurn.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FilmBurn.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

const vec3 color = vec3(0.9, 0.4, 0.2);

vec4 transition(vec2 uv) {
    return mix(
        getFromColor(uv) + vec4(progress * color, 1.0),
        getToColor(uv) + vec4((1.0 - progress) * color, 1.0),
        progress
    );
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
