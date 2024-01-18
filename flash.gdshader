shader_type spatial;

uniform vec4 flash_color: source_color;
uniform float flash_lerp: hint_range(0, 1.0) = 0.5;

void fragment() {
    ALBEDO = flash_color.rbg;
    ALPHA = flash_lerp;
}
