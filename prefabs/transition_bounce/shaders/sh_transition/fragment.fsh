#version 300 es
precision highp float;

// sh_transition — effect: bounce.
// Adapted from gl-transitions `Bounce.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Bounce.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

const vec4 shadow_colour = vec4(0.0, 0.0, 0.0, 0.6);
uniform float shadow_height;   // knob; default in scr_transition_defaults
uniform float bounces;         // knob; default in scr_transition_defaults

const float PI = 3.14159265358;

vec4 transition(vec2 uv) {
    float sh = shadow_height;
    float b = bounces;
    float time = progress;
    float stime = sin(time * PI / 2.0);
    float phase = time * PI * b;
    float y = (abs(cos(phase))) * (1.0 - stime);
    float d = uv.y - y;
    return mix(
        mix(
            getToColor(uv),
            shadow_colour,
            step(d, sh) * (1.0 - mix(
                ((d / sh) * shadow_colour.a) + (1.0 - shadow_colour.a),
                1.0,
                smoothstep(0.95, 1.0, progress) // fade-out the shadow at the end
            ))
        ),
        getFromColor(vec2(uv.x, uv.y + (1.0 - y))),
        step(d, 0.0)
    );
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
