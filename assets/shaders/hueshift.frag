#pragma header
uniform float hue;

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0., -1./3., 2./3., -1.);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6. * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec3 rgb = clamp(abs(mod(c.x * 6. + vec3(0., 4., 2.), 6.) - 3.) - 1., 0., 1.);
    return c.z * mix(vec3(1.), rgb, c.y);
}

void main() {
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
    vec3 hsv = rgb2hsv(color.rgb);
    hsv.x = mod(hsv.x + hue, 1.0);
    color.rgb = hsv2rgb(hsv);
    gl_FragColor = color;
}