#version 300 es
precision highp float;

// sh_transition — effect: angular.
// Adapted from gl-transitions `angular.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/angular.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

#define PI 3.141592653589

uniform float starting_angle;   // knob; default in scr_transition_defaults

vec4 transition(vec2 uv) {
    float sa = starting_angle;
    float offset = sa * PI / 180.0;
    float angle = atan(uv.y - 0.5, uv.x - 0.5) + offset;
    float normalizedAngle = (angle + PI) / (2.0 * PI);
    normalizedAngle = normalizedAngle - floor(normalizedAngle);
    return mix(
        getFromColor(uv),
        getToColor(uv),
        step(normalizedAngle, progress)
    );
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
