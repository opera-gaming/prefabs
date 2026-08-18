#version 300 es
precision highp float;

// sh_transition — effect: squeeze.
// Adapted from gl-transitions `squeeze.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/squeeze.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float color_separation;   // knob; default in scr_transition_defaults

vec4 transition(vec2 uv) {
    float cs = color_separation;
    float y = 0.5 + (uv.y - 0.5) / (1.0 - progress);
    if (y < 0.0 || y > 1.0) {
        return getToColor(uv);
    } else {
        vec2 fp = vec2(uv.x, y);
        vec2 off = progress * vec2(0.0, cs);
        vec4 c = getFromColor(fp);
        vec4 cn = getFromColor(fp - off);
        vec4 cp = getFromColor(fp + off);
        return vec4(cn.r, c.g, cp.b, c.a);
    }
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
