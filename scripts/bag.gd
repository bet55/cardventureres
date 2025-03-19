extends Node2D

const OPEN_OFFSET = Vector2(750, 0)
const OPEN_TIME = 0.7
const ALLOWED_CARDS = [
	"loot",
]

var close_spot = Vector2()

var is_open = false


func _ready() -> void:
	close_spot = global_position


func _on_bag_button_pressed() -> void:
	var tween = create_tween()
	var destination = Vector2()
	if is_open:
		is_open = false
		destination = close_spot
	else:
		is_open = true
		destination = close_spot - OPEN_OFFSET
	tween.tween_property(self, "global_position", destination, OPEN_TIME).set_ease(Tween.EASE_OUT)


func _on_bag_area_2d_area_entered(area: Area2D) -> void:
	if is_open and area.is_in_group("connector") and area.get_parent().card_type in ALLOWED_CARDS:
		print("works")
