extends Node2D

@export var camera: Camera2D
@export var fog: Polygon2D
@export var min_distance: float
@export var randomness: float
@export var reveal_time: float
@export var reveal_radius_multi: float

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

const CLOUD = preload("uid://b51jokru3502d") #cloud scene

var card = null


func setup_card(card_to_follow):
	card = card_to_follow
	card.card_picked_up.connect(Callable(self, "_on_card_picked_up"))
	card.card_layed_down.connect(Callable(self, "_on_card_layed_down"))


func fill_polygon_with_sprites():
	var vertices = fog.polygon
	if vertices.size() < 3:
		return  # Not a valid polygon

	# Calculate the bounding box of the polygon
	var min_x = vertices[0].x
	var max_x = vertices[0].x
	var min_y = vertices[0].y
	var max_y = vertices[0].y

	for vertex in vertices:
		if vertex.x < min_x:
			min_x = vertex.x
		if vertex.x > max_x:
			max_x = vertex.x
		if vertex.y < min_y:
			min_y = vertex.y
		if vertex.y > max_y:
			max_y = vertex.y

	var bounds = Rect2(min_x, min_y, max_x - min_x, max_y - min_y)
	var grid_spacing = min_distance
	var points = []

	# Generate grid points
	for x in range(bounds.position.x, bounds.end.x, grid_spacing):
		for y in range(bounds.position.y, bounds.end.y, grid_spacing):
			var point = Vector2(x, y)
			if Geometry2D.is_point_in_polygon(point, vertices):
				# Add randomness to the position
				var random_offset = Vector2(
					randf_range(-randomness, randomness),
					randf_range(-randomness, randomness)
				)
				points.append(point + random_offset)

	# Place sprites
	for point in points:
		var cloud = CLOUD.instantiate()
		add_child(cloud)
		cloud.position = point
		cloud.camera = camera


func _ready() -> void:
	area_2d.scale = Vector2(1, 1)
	fill_polygon_with_sprites()


func _process(delta: float) -> void:
	if card != null:
		area_2d.global_position = card.global_position


func _on_card_picked_up(card):
	collision_shape_2d.disabled = true
	area_2d.scale = Vector2(0.0001, 0.0001)


func _on_card_layed_down(card):
	collision_shape_2d.disabled = false
	var tween = create_tween()
	tween.tween_property(area_2d, "scale", Vector2(1, 1) * reveal_radius_multi, reveal_time)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("cloud"):
		area.get_parent().remove()
