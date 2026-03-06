shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform vec2 center = vec2(0.5, 0.5);
uniform float force : hint_range(0.0, 1.0) = 0.05;
uniform float size : hint_range(0.0, 1.0) = 0.0;
uniform float thickness : hint_range(0.0, 0.5) = 0.1;

void fragment() {

    float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
    vec2 scaled_uv = (SCREEN_UV - center) / vec2(ratio, 1.0) + center;

    float dist = distance(scaled_uv, center);


    float mask = smoothstep(size, size - thickness, dist) -
                 smoothstep(size - thickness, size - thickness * 2.0, dist);


    vec2 disp = normalize(SCREEN_UV - center) * force * mask;
    COLOR = texture(screen_texture, SCREEN_UV - disp);
}