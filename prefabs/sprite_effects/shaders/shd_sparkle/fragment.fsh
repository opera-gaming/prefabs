#version 300 es
// Twinkling stars orbiting the silhouette in counter-rotating rings.
precision highp float;

in vec2 v_vTexcoord;
in vec4 v_vColour;
out vec4 frag_colour;

// Host roles (shader.toml): time, distance field, nearest-seed texcoord, margin.
uniform float uTime;
uniform sampler2D uDist;
uniform sampler2D uSeed;
uniform float uMargin;

uniform float uSpkReach;
uniform int uSpkDensity;
uniform float uSpkTwinkle;
uniform float uSpkSize;
uniform float uSpkSpeed;

float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}
float vnoise(vec2 p) {
    vec2 i = floor(p), f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float a = hash(i), b = hash(i + vec2(1, 0));
    float c = hash(i + vec2(0, 1)), d = hash(i + vec2(1, 1));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}
float fbm(vec2 p) {
    float v = 0.0, amp = 0.5;
    for (int i = 0; i < 4; i++) { v += amp * vnoise(p); p *= 2.03; amp *= 0.5; }
    return v;
}
// distance from p to the silhouette, inside or out
float edgeDist(vec2 p) {
    return texture(uDist, p).r;
}
// angle from the nearest silhouette texel to p: a coordinate "around" the shape
float aroundAngle(vec2 p) {
    vec2 s = texture(uSeed, p).xy;
    vec2 dir = s.x < 0.0 ? vec2(1.0, 0.0) : p - s;
    return atan(dir.y, dir.x);
}
// fades to nothing over the outer half of the margin, so nothing clips at
// the texture's edge and the subject's own box is untouched
float edgeFade(vec2 p) {
    float d = min(min(p.x, 1.0 - p.x), min(p.y, 1.0 - p.y));
    return smoothstep(0.0, 0.5 * uMargin, d);
}
vec3 firePalette(float h) {
    h = clamp(h, 0.0, 1.0);
    return vec3(pow(h, 0.9) * 1.9, pow(h, 1.8) * 1.45, pow(h, 4.5) * 1.1);
}
// composites colour c with coverage m over premultiplied body
vec4 over(vec4 body, vec3 c, float m) {
    return body * (1.0 - m) + vec4(c * m, m);
}
// tonemaps the emissive light and lays it over the body; straight alpha out
vec4 finish(vec4 body, vec3 light) {
    vec3 lit = 1.0 - exp(-light * 1.8);
    float la = max(lit.r, max(lit.g, lit.b));
    float a = body.a + la * (1.0 - body.a);
    vec3 rgb = a > 0.0 ? min((body.rgb + lit) / a, 1.0) : vec3(0.0);
    return vec4(rgb, a);
}

void main() {
    vec2 uv = v_vTexcoord;
    float t = uTime;
    vec4 sp = texture(gm_BaseTexture, uv);
    float inside = smoothstep(0.45, 0.55, sp.a);
    float outside = 1.0 - inside;
    float dHere = edgeDist(uv);
    vec4 body = vec4(0.0);
    vec3 light = vec3(0.0);

    // rings of hashed cells in (angle, distance) space, each spinning at its
    // own speed and direction
    float a = aroundAngle(uv) / 6.28318 + 0.5;
    float d = dHere;
    float ringW = uSpkReach / 4.0;

    vec3 acc = vec3(0.0);
    for (int r = 0; r < 4; r++) {
        float fr = float(r);
        float spin = hash(vec2(fr, 5.3)) > 0.5 ? 1.0 : -1.0;
        float aa = fract(a + t * uSpkSpeed * spin * (0.04 + 0.025 * fr));
        float cells = float(uSpkDensity) + fr * 6.0;
        float ci = floor(aa * cells);
        float hh = hash(vec2(ci, fr * 13.7));
        if (hh < 0.3) continue;
        // star centre drifts radially within its ring
        float rc = ringW * (fr + 0.5 + 0.3 * sin(t * 0.9 + hh * 6.28));
        // cell-local coords in texture units: tangential (arc length) and radial
        float perim = 0.9 + 6.28318 * rc;
        vec2 q = vec2((fract(aa * cells) - 0.5) * perim / cells, d - rc);
        float tw = pow(0.5 + 0.5 * sin(t * uSpkTwinkle + hh * 40.0), 6.0);
        float s = uSpkSize * (0.6 + 0.4 * hash(vec2(ci, fr)));
        float m = exp(-dot(q, q) * 20000.0 / s);
        // 4-point flare with arms along the tangent and the normal
        m += (exp(-abs(q.x) * 500.0 / s) * exp(-abs(q.y) * 2000.0)
            + exp(-abs(q.y) * 500.0 / s) * exp(-abs(q.x) * 2000.0)) * 0.7;
        vec3 tint = 0.8 + 0.2 * cos(6.28318 * (hh + vec3(0.0, 0.33, 0.67)));
        acc += tint * m * tw;
    }
    acc *= outside * (1.0 - smoothstep(uSpkReach, uSpkReach * 1.3, d));

    // faint glitter dust in the orbit zone
    light += vec3(0.5, 0.55, 0.7) * pow(vnoise(uv * 90.0 + t * 0.5), 8.0) * exp(-d / uSpkReach) * outside * 0.6;
    body = over(body, sp.rgb, sp.a);
    light += acc * 1.6;
    // soft shimmer rim
    light += vec3(0.8, 0.85, 1.0) * exp(-dHere / 0.02) * inside * 0.25;

    frag_colour = finish(body, light) * v_vColour;
    frag_colour.a *= edgeFade(uv);
}
