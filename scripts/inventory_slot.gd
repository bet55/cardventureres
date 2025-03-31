extends Node2D

@onready var connector: Area2D = $Connector
@onready var connected_cards: Node2D = $ConnectedCards
@onready var slot_name: Label = $SlotName
@onready var slot_highlight: Sprite2D = $SlotHighlight

const TYPE = "inventory_slot"
const ALLOWED_CONNECTORS = [
	"equipment",
]

#для работы коннектора
var mod_cards = []
var is_dragging = false
var is_connected = false
var card_holder = null
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
