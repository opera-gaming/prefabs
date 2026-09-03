#version 300 es
// Cold water dripping down off every edge, with glints and a wet caustic sheen inside.
precision highp float;

in vec2 v_vTexcoord;
in vec4 v_vColour;
out vec4 frag_colour;

// Host roles (shader.toml): time, distance field, nearest-seed texcoord, margin.
uniform float uTime;
uniform sampler2D uDist;
uniform sampler2D uSeed;
uniform float uMargin;

uniform float uWatReach;
uniform float uWatSpeed;
uniform float uWatScale;
uniform float uWatSheen;

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

vec3 waterPalette(float h) {
    h = clamp(h, 0.0, 1.0);
    vec3 c = mix(vec3(0.02, 0.09, 0.22), vec3(0.1, 0.55, 0.85), h);
    return c + vec3(0.9) * pow(h, 6.0);
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

    // slow falling turbulence; probe ABOVE this pixel so heavy tendrils drip
    // down off every edge (texture y points down)
    vec2 np = uv * uWatScale;
    float n = fbm(np - vec2(0.0, t * uWatSpeed));
    n = n * n * 1.5;
    float lift = uWatReach * (0.15 + 0.85 * n);
    vec2 probe = uv - vec2((n - 0.5) * uWatReach * 0.35, lift);
    float pin = smoothstep(0.45, 0.55, texture(gm_BaseTexture, probe).a);
    float sdp = edgeDist(probe) * (1.0 - pin);
    float drip = 1.0 - smoothstep(0.0, uWatReach * 0.35, sdp);
    float veil = 1.0 - smoothstep(0.0, uWatReach * (0.3 + 0.5 * n), dHere);
    float wet = pow(clamp(drip * veil, 0.0, 1.0), 1.3);

    light += waterPalette(wet) * (wet * 0.9 + veil * 0.1) * outside;
    // glints on the moving surface
    float spark = pow(vnoise(uv * 90.0 - vec2(0.0, t * 3.0)), 9.0);
    light += vec3(0.8, 0.95, 1.0) * spark * wet * outside * uWatSheen;
    body = over(body, sp.rgb, sp.a);
    // wet sheen and slow caustic shimmer just inside the edge
    float sheen = exp(-dHere / (uWatReach * 0.35)) * inside;
    float caust = pow(fbm(uv * 10.0 + vec2(t * 0.2, t * 0.35)), 3.0);
    light += vec3(0.15, 0.5, 0.8) * sheen * (0.4 + 2.0 * caust) * uWatSheen;

    frag_colour = finish(body, light) * v_vColour;
    frag_colour.a *= edgeFade(uv);
}
