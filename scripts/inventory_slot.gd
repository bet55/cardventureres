extends Node2D

@export var slot_index: int

@onready var connector: Area2D = $Connector
@onready var connected_cards: Node2D = $ConnectedCards
@onready var slot_name: Label = $SlotName
@onready var slot_highlight: Sprite2D = $SlotHighlight

#const TYPE = "inventory_slot"
const ALLOWED_CONNECTORS = [
	"equipment",
]

#для работы коннектора
var mod_cards = []
var is_dragging = false
var is_connected = false
var card_holder = null
var is_in_bag = false
var card_type = "inventory_slot"
#для работы коннектора


func switch_highlight():
	if slot_highlight.visible:
		slot_highlight.visible = false
	else:
		slot_highlight.visible = true


func _ready() -> void:
	connector.allowed_connectors = ALLOWED_CONNECTORS
	connector.monitoring = false
	connector.monitorable = false
	var gear_id = GlobalStuff.equiped_items[slot_index]
	if gear_id != null:
		var gear = CardFabric.create_card(gear_id)
		connected_cards.add_child(gear)
		gear.position = Vector2.ZERO
		gear.is_connected = true
		gear.connected_to = self
		gear.is_uninteractable = true
		gear.input_blocker.mouse_filter = Control.MOUSE_FILTER_IGNORE
