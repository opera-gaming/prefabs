#version 300 es
// Endgame: the sprite turns to stone, crumbles along a noise front and blows away as dust.
precision highp float;

in vec2 v_vTexcoord;
in vec4 v_vColour;
out vec4 frag_colour;

// Host roles (shader.toml): time, distance field, nearest-seed texcoord, margin.
uniform float uTime;
uniform sampler2D uDist;
uniform sampler2D uSeed;
uniform float uMargin;

uniform float uEndRate;
uniform float uEndGrain;
uniform float uEndSweep;
uniform float uEndReach;
uniform float uEndDust;
uniform vec3 uColour;

// dust drifts up and to the right
const vec2 WIND = vec2(0.85, -0.5);
const int DUST_SAMPLES = 6;

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
// fades to nothing over the outer half of the margin, so nothing clips at
// the texture's edge and the subject's own box is untouched
float edgeFade(vec2 p) {
    float d = min(min(p.x, 1.0 - p.x), min(p.y, 1.0 - p.y));
    return smoothstep(0.0, 0.5 * uMargin, d);
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
// the sprite's colour as stone: its shading in the chosen shade
vec3 stone(vec3 c) {
    float lum = dot(c, vec3(0.3, 0.59, 0.11));
    return (0.12 + 0.85 * lum) * uColour * 2.0;
}
// the crumbling front: noise, pulled towards a bottom-up wipe by uEndSweep;
// a fresh pattern each cycle
float front(vec2 p, float ci) {
    float n = clamp((fbm(p * uEndGrain + ci * 7.1) - 0.2) / 0.6, 0.0, 1.0);
    return mix(n, 1.0 - p.y + (n - 0.5) * 0.25, uEndSweep);
}

void main() {
    vec2 uv = v_vTexcoord;
    float t = uTime;
    vec4 sp = texture(gm_BaseTexture, uv);
    float inside = smoothstep(0.45, 0.55, sp.a);
    vec4 body = vec4(0.0);
    vec3 light = vec3(0.0);

    // one cycle: the sprite turns to stone, crumbles from one end to the
    // other, the dust thins out, and it comes back whole for the next
    float cycle = t * uEndRate;
    float tc = fract(cycle);
    float ci = floor(cycle);
    float petrify = smoothstep(0.0, 0.2, tc);
    float vis = 1.0 - smoothstep(0.85, 0.95, tc);

    // the cut climbs through the front's range at a steady rate and keeps
    // counting past it, so a crumbled piece's age is the cut minus its front
    float edge = 0.06;
    float cut = (tc - 0.2) / 0.45 * (1.0 + edge) - edge;
    float f = front(uv, ci);
    float keep = smoothstep(cut, cut + 0.015, f);
    float band = keep * (1.0 - smoothstep(0.0, edge, f - cut));
    vec3 col = mix(sp.rgb, stone(sp.rgb), petrify) * (1.0 - 0.45 * band);
    body = over(body, col, sp.a * keep);

    // dust: looking back along the wind, any crumbled piece upwind of this
    // pixel blew grains through it; the grains thin out with distance and
    // are broken up by fine noise so they read as grit, not a smear. Each
    // grain has its own lifetime, so the dust thins grain by grain and the
    // first pieces to crumble are gone before the last ones fall.
    float blow = uEndReach * max(cut, 0.0);
    vec2 grain = floor(uv * 900.0) + ci;
    float grit = hash(grain);
    float life = mix(0.15, 0.8, hash(grain * 1.3 + 7.0));
    float dust = 0.0;
    vec3 dustCol = vec3(0.0);
    for (int k = 0; k < DUST_SAMPLES; k++) {
        float s = (float(k) + hash(uv * 37.0 + float(k))) / float(DUST_SAMPLES);
        vec2 src = uv - WIND * blow * s * (0.6 + 0.8 * vnoise(uv * 30.0 + float(k)));
        vec4 sample_ = texture(gm_BaseTexture, src);
        float age = cut - front(src, ci);
        float gone = smoothstep(0.0, 0.015, age);
        float alive = 1.0 - smoothstep(0.5 * life, life, age);
        float a = sample_.a * gone * alive * (1.0 - s) * step(1.0 - uEndDust, grit);
        dustCol += stone(sample_.rgb) * a;
        dust += a;
    }
    if (dust > 0.0) dustCol /= dust;
    dust = min(dust * 0.9, 1.0);
    body = over(body, dustCol * (0.8 + 0.4 * grit), dust);

    frag_colour = finish(body, light) * v_vColour;
    frag_colour.a *= edgeFade(uv) * vis;
}
