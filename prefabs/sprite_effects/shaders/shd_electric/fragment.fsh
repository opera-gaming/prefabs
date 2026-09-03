#version 300 es
// Crackling discharge along the silhouette: jagged arcs, hot filaments and a charged rim.
precision highp float;

in vec2 v_vTexcoord;
in vec4 v_vColour;
out vec4 frag_colour;

// Host roles (shader.toml): time, distance field, nearest-seed texcoord, margin.
uniform float uTime;
uniform sampler2D uDist;
uniform sampler2D uSeed;
uniform float uMargin;

uniform float uAuraLen;
uniform float uDensity;
uniform float uFlicker;
uniform float uJag;
uniform float uBoltScale;
uniform float uThick;

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

    // discrete re-hash: the whole discharge pattern jumps uFlicker times a second
    float tq = floor(t * uFlicker);
    vec2 jolt = vec2(hash(vec2(tq, 1.7)), hash(vec2(tq, 9.1))) * 8.0;

    // jagged displacement of the field lookup makes everything crackle
    vec2 wig = (vec2(fbm(uv * uBoltScale + jolt),
                     fbm(uv * uBoltScale + jolt + vec2(37.2, 17.9))) - 0.5) * uJag;
    vec2 p = uv + wig;
    float d = edgeDist(p);

    // the nearest-edge seed is a stable coordinate along the silhouette:
    // noise of it is constant along each normal, so lit sections discharge outward
    vec2 s = texture(uSeed, p).xy;
    float along = s.x < 0.0 ? 0.0 : fbm(s * uBoltScale * 1.5 + jolt);
    float a0 = 0.78 - uDensity * 0.5;
    float gate = smoothstep(a0, a0 + 0.15, along);
    float reach = uAuraLen * (0.15 + 0.85 * along);
    float rad = 1.0 - smoothstep(0.0, reach, d);
    float bolt = gate * rad * rad * rad;

    // bright filaments where a noise field crosses zero inside the aura band
    float n1 = fbm(p * uBoltScale * 2.5 + jolt + vec2(51.3, 7.9)) - 0.5;
    float core = (1.0 - smoothstep(uThick * 0.35, uThick, abs(n1)))
               * (1.0 - smoothstep(0.0, uAuraLen, d))
               * (0.35 + 0.65 * gate);

    float corona = pow(clamp(1.0 - d / uAuraLen, 0.0, 1.0), 3.0) * 0.25;
    float e = (bolt * 0.9 + core * 1.5 + corona) * (0.8 + 0.4 * hash(vec2(tq, 4.2)));

    vec3 ec = vec3(0.45, 0.6, 1.6);
    light += ec * e * outside + vec3(0.9, 0.95, 1.3) * core * outside * 1.1;
    body = over(body, sp.rgb, sp.a);
    // charged rim just inside the silhouette
    float rim = exp(-dHere / (uAuraLen * 0.12)) * inside;
    light += ec * rim * (0.5 + 0.5 * hash(vec2(tq, 8.8)));
    // arcs crossing in front of the sprite
    light += ec * e * inside * 0.3;

    frag_colour = finish(body, light) * v_vColour;
    frag_colour.a *= edgeFade(uv);
}
