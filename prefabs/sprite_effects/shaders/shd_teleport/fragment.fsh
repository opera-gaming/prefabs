#version 300 es
// Teleport dissolve: the sprite breaks up along a glowing noise front into motes that drift off, then reassembles.
precision highp float;

in vec2 v_vTexcoord;
in vec4 v_vColour;
out vec4 frag_colour;

// Host roles (shader.toml): time, distance field, nearest-seed texcoord, margin.
uniform float uTime;
uniform sampler2D uDist;
uniform sampler2D uSeed;
uniform float uMargin;

uniform float uTlpRate;
uniform float uTlpGrain;
uniform float uTlpEdge;
uniform float uTlpSweep;
uniform float uTlpMotes;
uniform vec3 uColour;

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

    // one cycle: the sprite dissolves, then what is left of it fades to
    // nothing; the second half plays that backwards
    float cycle = t * uTlpRate;
    float tc = fract(cycle);
    float ci = floor(cycle);
    float u = 1.0 - abs(2.0 * tc - 1.0);
    float prog = smoothstep(0.05, 0.7, u);
    float vis = 1.0 - smoothstep(0.7, 0.97, u);

    // the front: noise, pulled towards a bottom-up wipe by uTlpSweep; a fresh
    // noise pattern each cycle
    float n = clamp((fbm(uv * uTlpGrain + ci * 7.1) - 0.2) / 0.6, 0.0, 1.0);
    float field = mix(n, 1.0 - uv.y + (n - 0.5) * 0.25, uTlpSweep);
    // cut climbs from below the field's range to above it, so the glowing
    // band leads the way in and trails out
    float cut = prog * (1.0 + uTlpEdge) - uTlpEdge;
    float keep = smoothstep(cut, cut + 0.015, field);
    float band = keep * (1.0 - smoothstep(0.0, uTlpEdge, field - cut));

    // motes: the silhouette's edge is cut into cells, and each cell sheds a
    // mote that floats out along the edge's normal, drifting up, as the
    // sprite comes apart, and is drawn back as it reforms. A pixel only sees
    // the mote of the cell its nearest edge point lies in, so the mote has
    // to stay on that cell's normal to stay visible.
    vec2 seed = texture(uSeed, uv).xy;
    float cells = 48.0;
    vec2 cid = floor(seed * cells);
    vec2 home = (cid + 0.5) / cells;
    vec2 e = vec2(0.5 / cells, 0.0);
    vec2 grad = vec2(edgeDist(home + e.xy) - edgeDist(home - e.xy),
                     edgeDist(home + e.yx) - edgeDist(home - e.yx));
    vec2 normal = texture(gm_BaseTexture, home).a > 0.5 ? -grad : grad;
    vec2 away = length(normal) > 1e-4 ? normalize(normal) : normalize(uv - seed);
    away = normalize(away + vec2(0.0, -0.4));
    float h = hash(cid + ci * 0.53);
    float h2 = hash(cid * 1.7 + ci);
    float show = step(1.0 - uTlpMotes, h2);
    float reach = prog * 0.22 * (0.4 + 0.6 * h);
    vec2 wobble = vec2(sin(t * 3.0 + h * 9.0), cos(t * 2.3 + h * 5.0)) * 0.006;
    vec2 jitter = (vec2(h2, h) - 0.5) * 0.7 / cells;
    vec2 centre = home + jitter + away * reach + wobble;
    vec2 q = uv - centre;
    float size = 0.006 * (0.6 + 0.8 * h);
    float twinkle = 0.6 + 0.4 * sin(t * 12.0 + h * 40.0);
    float mote = show * exp(-dot(q, q) / (size * size))
               * twinkle * prog * outside;

    // the space a dissolved piece left: a ghost of the silhouette, lit by
    // streaks of vertical static rising through it, as a beam
    float beam = pow(vnoise(vec2(uv.x * 120.0, uv.y * 6.0 + t * 25.0)), 5.0);

    body = over(body, sp.rgb, sp.a * keep);
    light += uColour * band * inside * 2.0;
    light += uColour * (0.2 + 0.7 * beam) * (1.0 - keep) * inside;
    light += uColour * inside * keep * prog * 0.15;
    light += uColour * mote * 2.5;
    // soft halo outside while in transit
    light += uColour * exp(-dHere / 0.05) * outside * prog * 0.35;

    frag_colour = finish(body, light) * v_vColour;
    frag_colour.a *= edgeFade(uv) * vis;
}
