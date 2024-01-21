shader_type spatial;

uniform vec4 color: source_color;

void vertex() {
    vec3 world_position = NODE_POSITION_WORLD + VERTEX;
    float x = sin((world_position.x + world_position.z) * 20.0) * 0.5 + sin((world_position.x + world_position.z) * 15.0) * 0.5 + sin((world_position.x + world_position.z) * 7.0 + 1.0) * 0.2;
    VERTEX.x += x * 0.07;
}

void fragment() {
    ALBEDO = color.rgb;
}
