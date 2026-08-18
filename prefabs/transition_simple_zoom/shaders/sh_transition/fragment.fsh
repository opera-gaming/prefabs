#version 300 es
precision highp float;

// sh_transition — effect: simple-zoom.
// Adapted from gl-transitions `SimpleZoom.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SimpleZoom.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float zoom_quickness;   // knob; default in scr_transition_defaults

vec2 zoom(vec2 uv, float amount) {
    return 0.5 + ((uv - 0.5) * (1.0 - amount));
}

vec4 transition(vec2 uv) {
    float zq = zoom_quickness;
    float nQuick = clamp(zq, 0.2, 1.0);
    return mix(
        getFromColor(zoom(uv, smoothstep(0.0, nQuick, progress))),
        getToColor(uv),
        smoothstep(nQuick - 0.2, 1.0, progress)
    );
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
