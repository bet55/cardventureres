shader_type canvas_item;

uniform sampler2D sprite_texture; // The sprite's texture
uniform vec2 sprite_offset; // Offset of the sprite relative to the Polygon2D (normalized)
uniform vec2 sprite_scale; // Scale of the sprite (normalized)

void fragment() {
    // Calculate the sprite's UV coordinates relative to the Polygon2D
    vec2 sprite_uv = (UV - sprite_offset) / sprite_scale;

    // Sample the sprite's texture
    vec4 sprite_color = texture(sprite_texture, sprite_uv);

    // Sample the Polygon2D's texture
    vec4 texture_color = texture(TEXTURE, UV);

    // Use the sprite's alpha value directly to create a soft cutout
    COLOR = texture_color * (1.0 - sprite_color.a);
}