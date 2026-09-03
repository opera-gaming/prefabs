#version 300 es
// Flames licking up off every edge, with smoke above and a charred, ember-lit rim.
precision highp float;

in vec2 v_vTexcoord;
in vec4 v_vColour;
out vec4 frag_colour;

// Host roles (shader.toml): time, distance field, nearest-seed texcoord, margin.
uniform float uTime;
uniform sampler2D uDist;
uniform sampler2D uSeed;
uniform float uMargin;

uniform float uFlameLen;
uniform float uNoiseScale;
uniform float uSpeed;
uniform float uWobble;
uniform float uHeat;
uniform float uSmoke;
uniform float uEmber;

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

    // rising turbulence, domain-warped (texture y points down, so flames rise toward -y)
    vec2 np = vec2(uv.x, uv.y * 0.75) * uNoiseScale;
    vec2 drift = vec2(0.0, t * uSpeed);
    float warp = fbm(np * 1.9 + drift * 1.6);
    float n = fbm(np + drift + (warp - 0.5) * uWobble * 4.0);
    n = n * n * 1.6;

    // probe the distance field below this pixel: flames rise
    float lift = uFlameLen * (0.25 + 0.9 * n);
    vec2 probe = uv + vec2((warp - 0.5) * uFlameLen * 0.8, lift);
    float pInside = smoothstep(0.45, 0.55, texture(gm_BaseTexture, probe).a);
    float sd = edgeDist(probe) * (1.0 - pInside);
    float tongues = 1.0 - smoothstep(0.0, uFlameLen * 0.55, sd);

    // hug the whole silhouette, taper with true distance (noise varies the reach)
    float veil = 1.0 - smoothstep(0.0, uFlameLen * (0.35 + 0.85 * n), dHere);

    float heat = tongues * veil;
    heat *= 0.75 + 0.35 * vnoise(vec2(t * 8.0, uv.x * 40.0));
    heat = pow(clamp(heat, 0.0, 1.0), 1.5);

    // cool = deep red and dim, hot = yellow-white with a blue base
    vec3 fire = firePalette(heat * (0.45 + 1.1 * uHeat)) * (0.7 + 0.6 * uHeat);
    float baseZone = 1.0 - smoothstep(0.0, uFlameLen * 0.4, dHere);
    vec3 blue = vec3(0.25, 0.45, 1.4) * pow(heat, 1.2);
    fire = mix(fire, blue, smoothstep(0.65, 1.0, uHeat) * baseZone * 0.8);

    // smoke: a taller, softer probe above the flames
    vec2 probe2 = uv + vec2((warp - 0.5) * uFlameLen * 1.4, lift * 2.6);
    float p2in = smoothstep(0.45, 0.55, texture(gm_BaseTexture, probe2).a);
    float d2 = edgeDist(probe2) * (1.0 - p2in);
    float plume = 1.0 - smoothstep(0.0, uFlameLen * 0.8, d2);
    float sm = fbm(np * 0.6 + drift * 0.55);
    float smoke = uSmoke * plume * (0.35 + 0.65 * sm) * (1.0 - heat) * outside;

    light += vec3(0.30, 0.28, 0.30) * smoke * 0.5;
    light += fire * outside;

    // the sprite chars near the burning edge
    float charZone = 1.0 - smoothstep(0.0, uFlameLen * 0.45, dHere);
    vec3 spriteCol = mix(sp.rgb, sp.rgb * 0.25 + vec3(0.05, 0.02, 0.01), charZone * 0.8 * inside);
    body = over(body, spriteCol, sp.a);

    // glowing ember rim just inside the silhouette
    float ember = inside * (1.0 - smoothstep(0.0, uFlameLen * 0.12, dHere));
    ember *= 0.7 + 0.3 * vnoise(vec2(uv.x * 60.0, t * 6.0));
    light += firePalette(ember) * uEmber;

    // flame licks passing in front of the sprite
    light += fire * inside * 0.35;

    frag_colour = finish(body, light) * v_vColour;
    frag_colour.a *= edgeFade(uv);
}
