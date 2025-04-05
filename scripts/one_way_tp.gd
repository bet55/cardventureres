extends Node2D

@export var destination_point: Sprite2D

@onready var connected_cards: Node2D = $ConnectedCards
@onready var connector: Area2D = $Connector
@onready var tp_highlight: Sprite2D = $TpHighlight

const TP_TIME = 0.2
const ALLOWED_CONNECTORS = [
	"hero",
]

#для работы коннектора
var mod_cards = []
var is_dragging = false
var is_connected = false
var card_holder = null
var is_in_bag = false
var card_type = "one_way_tp"
#для работы коннектора


func switch_highlight():
	if tp_highlight.visible:
		tp_highlight.visible = false
	else:
		tp_highlight.visible = true


func _ready() -> void:
	connector.allowed_connectors = ALLOWED_CONNECTORS
	destination_point.visible = false


func _on_connected_cards_child_entered_tree(node: Node) -> void:
	if node.card_type == "hero":
		await get_tree().create_timer(1).timeout
		node.connector.disconnect_cards(node, node.connected_to)
		node.global_position = destination_point.global_position
		node.last_pos = node.global_position
		node.card_layed_down.emit(node)
