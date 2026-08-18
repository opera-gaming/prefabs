uniform sampler2D tex;
uniform float progress;
uniform vec3 mag;

varying vec2 v_vTexcoord;

vec4 getColor(vec2 uv) {
    return texture2D(tex, vec2(uv.x, 1.0-uv.y));
}

void main() {
  vec2 p = v_vTexcoord;
  vec2 block = floor(p.xy / vec2(16));
  vec2 uv_noise = block / vec2(64);
  uv_noise += floor(vec2(progress) * vec2(1200.0, 3500.0)) / vec2(64);
  vec2 dist = progress > 0.0 ? (fract(uv_noise) - 0.5) * 0.3 *(1.0 -progress) : vec2(0.0);
  vec2 red = p + dist * mag.r;
  vec2 green = p + dist * mag.g;
  vec2 blue = p + dist * mag.b;

  gl_FragColor = vec4(getColor(red).r,getColor(green).g,getColor(blue).b,1.0);
}
