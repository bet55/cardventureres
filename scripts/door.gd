extends Node2D

@export var scene_path: String

@onready var connected_cards: Node2D = $ConnectedCards
@onready var connector: Area2D = $Connector
@onready var door_highlight: Sprite2D = $DoorHighlight

const ALLOWED_CONNECTORS = [
	"hero",
]

#для работы коннектора
var mod_cards = []
var is_dragging = false
var is_connected = false
var card_holder = null
var is_in_bag = false
var card_type = "door"
#для работы коннектора


func switch_highlight():
	if door_highlight.visible:
		door_highlight.visible = false
	else:
		door_highlight.visible = true


func _ready() -> void:
	connector.allowed_connectors = ALLOWED_CONNECTORS


func _on_connected_cards_child_entered_tree(node: Node) -> void:
	if node.card_type == "hero":
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file(scene_path)
