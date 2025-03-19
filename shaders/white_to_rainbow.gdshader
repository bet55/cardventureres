shader_type canvas_item;

// Цвет, который нужно заменить
uniform vec4 target_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Красный по умолчанию
// Порог для сравнения цветов
uniform float color_threshold : hint_range(0.0, 1.0) = 0.1;

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

void fragment() {
    // Получаем цвет текущего пикселя
    vec4 sprite_color = texture(TEXTURE, UV);

    // Сравниваем цвет пикселя с целевым цветом
    if (distance(sprite_color.rgb, target_color.rgb) < color_threshold) {
        // Если цвет совпадает, заменяем его на радужный градиент
        float time = TIME * 0.1; // Скорость изменения градиента
        vec3 rainbow_color = rainbow(time + UV.x + UV.y); // Градиент зависит от времени и UV-координат
        COLOR = vec4(rainbow_color, sprite_color.a); // Сохраняем альфа-канал
    } else {
        // Иначе оставляем оригинальный цвет
        COLOR = sprite_color;
    }
}