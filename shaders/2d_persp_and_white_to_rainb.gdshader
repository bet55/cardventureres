shader_type canvas_item;

// Параметры для замены цвета
uniform vec4 target_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Красный по умолчанию
uniform float color_threshold : hint_range(0.0, 1.0) = 0.1;

// Параметры для вращения и перспективы
uniform float fov : hint_range(1, 179) = 90;
uniform bool cull_back = true;
uniform float y_rot : hint_range(-70, 70) = 0.0;
uniform float x_rot : hint_range(-70, 70) = 0.0;
uniform float inset : hint_range(0, 1) = 0.0;

varying flat vec2 o;
varying vec3 p;

// Функция для создания радужного градиента
vec3 rainbow(float t) {
    t = fract(t); // Ограничиваем t в диапазоне [0, 1]
    vec3 color = vec3(
        abs(t * 6.0 - 3.0) - 1.0,
        2.0 - abs(t * 6.0 - 2.0),
        2.0 - abs(t * 6.0 - 4.0)
    );
    return clamp(color, 0.0, 1.0);
}

// Вершинный шейдер для вращения и перспективы
void vertex() {
    float sin_b = sin(y_rot / 180.0 * PI);
    float cos_b = cos(y_rot / 180.0 * PI);
    float sin_c = sin(x_rot / 180.0 * PI);
    float cos_c = cos(x_rot / 180.0 * PI);

    mat3 inv_rot_mat;
    inv_rot_mat[0][0] = cos_b;
    inv_rot_mat[0][1] = 0.0;
    inv_rot_mat[0][2] = -sin_b;

    inv_rot_mat[1][0] = sin_b * sin_c;
    inv_rot_mat[1][1] = cos_c;
    inv_rot_mat[1][2] = cos_b * sin_c;

    inv_rot_mat[2][0] = sin_b * cos_c;
    inv_rot_mat[2][1] = -sin_c;
    inv_rot_mat[2][2] = cos_b * cos_c;

    float t = tan(fov / 360.0 * PI);
    p = inv_rot_mat * vec3((UV - 0.5), 0.5 / t);
    float v = (0.5 / t) + 0.5;
    p.xy *= v * inv_rot_mat[2].z;
    o = v * inv_rot_mat[2].xy;

    VERTEX += (UV - 0.5) / TEXTURE_PIXEL_SIZE * t * (1.0 - inset);
}

// Фрагментный шейдер
void fragment() {
    if (cull_back && p.z <= 0.0) discard;

    vec2 uv = (p.xy / p.z).xy - o;
    vec4 sprite_color = texture(TEXTURE, uv + 0.5);

    // Сравниваем цвет пикселя с целевым цветом
    if (distance(sprite_color.rgb, target_color.rgb) < color_threshold) {
        // Если цвет совпадает, заменяем его на радужный градиент
        float time = TIME * 0.1; // Скорость изменения градиента
        vec3 rainbow_color = rainbow(time + uv.x + uv.y); // Градиент зависит от времени и UV-координат
        COLOR = vec4(rainbow_color, sprite_color.a); // Сохраняем альфа-канал
    } else {
        // Иначе оставляем оригинальный цвет
        COLOR = sprite_color;
    }

    COLOR.a *= step(max(abs(uv.x), abs(uv.y)), 0.5);
}
//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
