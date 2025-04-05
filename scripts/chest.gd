extends Node2D

@onready var connected_cards: Node2D = $ConnectedCards
@onready var connector: Area2D = $Connector
@onready var chest_highlight: Sprite2D = $ChestHighlight
@onready var card_producer: Node2D = $CardProducer

const REMOVE_SCALE = Vector2(1.2, 1.2) #увеличение при удалении
const REMOVE_TIME = 0.3 #длительность анимации удаления
const ALLOWED_CONNECTORS = [
	"loot",
]
const CARDS_TO_PRODUCE = [
	060100,
	060100,
]

#для работы коннектора
var mod_cards = []
var is_dragging = false
var is_connected = false
var card_holder = null
var is_in_bag = false
var card_type = "chest"
#для работы коннектора


func switch_highlight():
	if chest_highlight.visible:
		chest_highlight.visible = false
	else:
		chest_highlight.visible = true


func remove():
	var tween = create_tween()
	tween.tween_property(self, "scale", REMOVE_SCALE, REMOVE_TIME/2).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(0, 0), REMOVE_TIME/2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 0.0, REMOVE_TIME/2)
	tween.tween_callback(queue_free)


func _ready() -> void:
	connector.allowed_connectors = ALLOWED_CONNECTORS
	card_producer.cards_to_produce = CARDS_TO_PRODUCE


func _on_connected_cards_child_entered_tree(node: Node) -> void:
	if node.card_id == 090200:
		card_producer.produce_card(self)
		self.remove()
