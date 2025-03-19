extends Camera2D

@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.0


func connect_camera(card):
	card.card_layed_down.connect(Callable(self, "_on_card_layed_down"))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			# Zoom in
			zoom_camera(-zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			# Zoom out
			zoom_camera(zoom_speed)

func zoom_camera(amount: float) -> void:
	# Calculate new zoom level
	var new_zoom = zoom + Vector2(amount, amount)
	
	# Clamp the zoom level between min and max values
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	
	# Apply the new zoom level
	zoom = new_zoom

func _on_card_layed_down(target):
	var tween = create_tween()
	tween.tween_property(self, "global_position", target.global_position, 0.3).set_ease(Tween.EASE_OUT)
