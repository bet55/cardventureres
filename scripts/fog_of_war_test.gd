extends Node2D

@onready var camera_follower: Camera2D = $CameraFollower
@onready var card_holder: Node2D = $CardHolder
@onready var fog_of_war: Node2D = $FogOfWar
@onready var allowed_area: Polygon2D = $AllowedArea


func _ready() -> void:
	var card = CardFabric.create_card(010100)
	card_holder.add_child(card)
	card.global_position = camera_follower.global_position
	card.last_pos = card.global_position
	card.z_index += 1
	card.allowed_area = allowed_area

	camera_follower.connect_camera(card)
	
	fog_of_war.setup_card(card)
