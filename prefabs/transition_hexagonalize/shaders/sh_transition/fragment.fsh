#version 300 es
precision highp float;

// sh_transition — effect: hexagonalize.
// Adapted from gl-transitions `hexagonalize.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/hexagonalize.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;
uniform float ratio;   // set by transition-base to the display aspect ratio

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float steps;               // knob; default in scr_transition_defaults
uniform float horizontal_hexagons; // knob; default in scr_transition_defaults

struct Hexagon {
    float q;
    float r;
    float s;
};

Hexagon createHexagon(float q, float r) {
    Hexagon hex;
    hex.q = q;
    hex.r = r;
    hex.s = -q - r;
    return hex;
}

Hexagon roundHexagon(Hexagon hex) {
    float q = floor(hex.q + 0.5);
    float r = floor(hex.r + 0.5);
    float s = floor(hex.s + 0.5);

    float deltaQ = abs(q - hex.q);
    float deltaR = abs(r - hex.r);
    float deltaS = abs(s - hex.s);

    if (deltaQ > deltaR && deltaQ > deltaS)
        q = -r - s;
    else if (deltaR > deltaS)
        r = -q - s;
    else
        s = -q - r;

    return createHexagon(q, r);
}

Hexagon hexagonFromPoint(vec2 point, float size) {
    point.y /= ratio;
    point = (point - 0.5) / size;

    float q = (sqrt(3.0) / 3.0) * point.x + (-1.0 / 3.0) * point.y;
    float r = 0.0 * point.x + 2.0 / 3.0 * point.y;

    Hexagon hex = createHexagon(q, r);
    return roundHexagon(hex);
}

vec2 pointFromHexagon(Hexagon hex, float size) {
    float x = (sqrt(3.0) * hex.q + (sqrt(3.0) / 2.0) * hex.r) * size + 0.5;
    float y = (0.0 * hex.q + (3.0 / 2.0) * hex.r) * size + 0.5;

    return vec2(x, y * ratio);
}

vec4 transition(vec2 uv) {
    float esteps = steps;
    float ehex = horizontal_hexagons;

    float dist = 2.0 * min(progress, 1.0 - progress);
    dist = esteps > 0.0 ? ceil(dist * esteps) / esteps : dist;

    float size = (sqrt(3.0) / 3.0) * dist / ehex;

    vec2 point = dist > 0.0 ? pointFromHexagon(hexagonFromPoint(uv, size), size) : uv;

    return mix(getFromColor(point), getToColor(point), progress);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
