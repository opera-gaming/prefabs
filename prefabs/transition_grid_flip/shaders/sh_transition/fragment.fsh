#version 300 es
precision highp float;

// sh_transition — effect: grid-flip.
// Adapted from gl-transitions `GridFlip.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GridFlip.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

// Baked defaults (no goto param): grid = 4x4, background = opaque black.
const vec2 size = vec2(4.0);
const vec4 bgcolor = vec4(0.0, 0.0, 0.0, 1.0);

uniform float pause;          // knob; default in scr_transition_defaults
uniform float divider_width;  // knob; default in scr_transition_defaults
uniform float randomness;     // knob; default in scr_transition_defaults

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float getDelta(vec2 p) {
    vec2 rectanglePos = floor(size * p);
    vec2 rectangleSize = vec2(1.0 / size.x, 1.0 / size.y);
    float top = rectangleSize.y * (rectanglePos.y + 1.0);
    float bottom = rectangleSize.y * rectanglePos.y;
    float left = rectangleSize.x * rectanglePos.x;
    float right = rectangleSize.x * (rectanglePos.x + 1.0);
    float minX = min(abs(p.x - left), abs(p.x - right));
    float minY = min(abs(p.y - top), abs(p.y - bottom));
    return min(minX, minY);
}

float getDividerSize() {
    float dw = divider_width;
    vec2 rectangleSize = vec2(1.0 / size.x, 1.0 / size.y);
    return min(rectangleSize.x, rectangleSize.y) * dw;
}

vec4 transition(vec2 p) {
    float epause = pause;
    float erand = randomness;
    if (progress < epause) {
        float currentProg = progress / epause;
        float a = 1.0;
        if (getDelta(p) < getDividerSize()) {
            a = 1.0 - currentProg;
        }
        return mix(bgcolor, getFromColor(p), a);
    } else if (progress < 1.0 - epause) {
        if (getDelta(p) < getDividerSize()) {
            return bgcolor;
        } else {
            float currentProg = (progress - epause) / (1.0 - epause * 2.0);
            vec2 q = p;
            vec2 rectanglePos = floor(size * q);

            float r = rand(rectanglePos) - erand;
            float cp = smoothstep(0.0, 1.0 - r, currentProg);

            float rectangleSize = 1.0 / size.x;
            float delta = rectanglePos.x * rectangleSize;
            float offset = rectangleSize / 2.0 + delta;

            p.x = (p.x - offset) / abs(cp - 0.5) * 0.5 + offset;
            vec4 a = getFromColor(p);
            vec4 b = getToColor(p);

            float s = step(abs(size.x * (q.x - delta) - 0.5), abs(cp - 0.5));
            return mix(bgcolor, mix(b, a, step(cp, 0.5)), s);
        }
    } else {
        float currentProg = (progress - 1.0 + epause) / epause;
        float a = 1.0;
        if (getDelta(p) < getDividerSize()) {
            a = currentProg;
        }
        return mix(bgcolor, getToColor(p), a);
    }
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
