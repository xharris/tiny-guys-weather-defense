shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_tex : hint_screen_texture, repeat_disable, filter_linear;

void fragment() {
    vec2 sample_uv = vec2(SCREEN_UV.x, SCREEN_UV.y);
    vec4 col = texture(screen_tex, sample_uv);
    COLOR = col;
}