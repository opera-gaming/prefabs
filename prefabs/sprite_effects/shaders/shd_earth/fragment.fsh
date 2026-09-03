#version 300 es
// Rings of rock chunks orbiting the silhouette through a haze of dust.
precision highp float;

in vec2 v_vTexcoord;
in vec4 v_vColour;
out vec4 frag_colour;

// Host roles (shader.toml): time, distance field, nearest-seed texcoord, margin.
uniform float uTime;
uniform sampler2D uDist;
uniform sampler2D uSeed;
uniform float uMargin;

uniform float uEarthReach;
uniform float uEarthSpeed;
uniform float uEarthDensity;
uniform float uEarthSize;

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

    float a = aroundAngle(uv) / 6.28318 + 0.5;
    float d = dHere;
    float ringW = uEarthReach / 3.0;

    // three rings of hashed debris cells, orbiting at different speeds
    float rock = 0.0, shade = 0.0;
    for (int r = 0; r < 3; r++) {
        float fr = float(r);
        float spin = hash(vec2(fr, 3.7)) > 0.5 ? 1.0 : -1.0;
        float aa = fract(a + t * uEarthSpeed * spin * (0.03 + 0.02 * fr));
        float cells = 14.0 + fr * 4.0;
        float ci = floor(aa * cells);
        float hh = hash(vec2(ci, fr * 17.1));
        if (hh < 1.0 - uEarthDensity * 0.75) continue;
        // chunk-local coords: angular within the cell, radial within the ring
        float bob = 0.25 * sin(t * 0.7 + hh * 6.28);
        vec2 q = vec2(fract(aa * cells) - 0.5,
                      (d - ringW * (fr + 0.5 + bob)) / ringW * 1.2);
        q += (vec2(fbm(uv * 22.0 + hh * 9.0), fbm(uv * 22.0 + hh * 5.0)) - 0.5) * 0.35;
        float rs = uEarthSize * (0.5 + 0.5 * hash(vec2(ci, fr)));
        float m = smoothstep(rs, rs * 0.55, length(q));
        rock = max(rock, m);
        shade = max(shade, m * (0.45 + 0.55 * hh));
    }
    rock *= outside * (1.0 - step(uEarthReach * 1.4, d));

    float dust = fbm(uv * 6.0 + vec2(t * 0.1, 0.0)) * exp(-d / uEarthReach) * 0.15;
    light += vec3(0.35, 0.28, 0.2) * dust * outside;
    vec3 rockCol = mix(vec3(0.16, 0.12, 0.09), vec3(0.5, 0.4, 0.3), shade);
    body = over(body, rockCol, rock);
    body = over(body, sp.rgb, sp.a);
    // crusted stone rim just inside the silhouette
    float crust = exp(-dHere / 0.02) * inside;
    body = over(body, vec3(0.35, 0.26, 0.16), crust * 0.5);

    frag_colour = finish(body, light) * v_vColour;
    frag_colour.a *= edgeFade(uv);
}
