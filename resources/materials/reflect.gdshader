shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_tex : hint_screen_texture, repeat_disable, filter_linear;
uniform float waterline_screen_y : hint_range(0.0, 1.0) = 0.5;
uniform float reflection_alpha : hint_range(0.0, 1.0) = 0.4;
uniform float ripple_strength : hint_range(0.0, 0.05) = 0.01;
uniform float ripple_speed : hint_range(0.0, 10.0) = 2.0;
uniform float ripple_frequency : hint_range(1.0, 100.0) = 30.0;
uniform float fade_power : hint_range(0.1, 5.0) = 1.8;
uniform vec4 water_tint : source_color = vec4(0.8, 0.9, 1.0, 1.0);

void fragment() {
    vec2 sample_uv = vec2(SCREEN_UV.x, 2.0 * waterline_screen_y - SCREEN_UV.y);

    sample_uv.x += sin(UV.y * ripple_frequency + TIME * ripple_speed) * ripple_strength;
    sample_uv.x += sin(UV.y * ripple_frequency * 0.5 + TIME * ripple_speed * 1.4) * ripple_strength * 0.5;

    vec4 col = texture(screen_tex, sample_uv);

    float fade = pow(1.0 - UV.y, fade_power);
    col.rgb *= water_tint.rgb;
    col.a *= reflection_alpha * fade;

    COLOR = col;
}
