extends Node2D

@onready var inventory_slot_1: Node2D = $InventorySlot1
@onready var inventory_slot_2: Node2D = $InventorySlot2
@onready var inventory_slot_3: Node2D = $InventorySlot3

const SLOT1_OPEN_POSITION = Vector2(-80, -20)
const SLOT2_OPEN_POSITION = Vector2(0, -130)
const SLOT3_OPEN_POSITION = Vector2(80, -20)
const OPEN_DURATION = 0.5

var is_open = false


func _ready() -> void:
	inventory_slot_1.position = Vector2(0, 0)
	inventory_slot_2.position = Vector2(0, 0)
	inventory_slot_3.position = Vector2(0, 0)
	inventory_slot_1.modulate.a = 0
	inventory_slot_2.modulate.a = 0
	inventory_slot_3.modulate.a = 0
	inventory_slot_1.slot_name.text = "weapon"
	inventory_slot_2.slot_name.text = "armor"
	inventory_slot_3.slot_name.text = "another"


func _on_show_equip_button_pressed() -> void:
	var tween = create_tween()
	tween.set_parallel()
	if is_open:
		is_open = false
		inventory_slot_1.connector.monitoring = false
		inventory_slot_1.connector.monitorable = false
		inventory_slot_2.connector.monitoring = false
		inventory_slot_2.connector.monitorable = false
		inventory_slot_3.connector.monitoring = false
		inventory_slot_3.connector.monitorable = false
		if inventory_slot_1.connected_cards.get_children() != []:
			inventory_slot_1.connected_cards.get_children()[0].is_uninteractable = true
			inventory_slot_1.connected_cards.get_children()[0].input_blocker.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if inventory_slot_2.connected_cards.get_children() != []:
			inventory_slot_2.connected_cards.get_children()[0].is_uninteractable = true
			inventory_slot_2.connected_cards.get_children()[0].input_blocker.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if inventory_slot_3.connected_cards.get_children() != []:
			inventory_slot_3.connected_cards.get_children()[0].is_uninteractable = true
			inventory_slot_3.connected_cards.get_children()[0].input_blocker.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tween.tween_property(inventory_slot_1, "position", Vector2(0, 0), OPEN_DURATION).set_ease(Tween.EASE_OUT)
		tween.tween_property(inventory_slot_2, "position", Vector2(0, 0), OPEN_DURATION).set_ease(Tween.EASE_OUT)
		tween.tween_property(inventory_slot_3, "position", Vector2(0, 0), OPEN_DURATION).set_ease(Tween.EASE_OUT)
		tween.tween_property(inventory_slot_1, "modulate:a", 0, OPEN_DURATION/3).set_ease(Tween.EASE_OUT)
		tween.tween_property(inventory_slot_2, "modulate:a", 0, OPEN_DURATION/3).set_ease(Tween.EASE_OUT)
		tween.tween_property(inventory_slot_3, "modulate:a", 0, OPEN_DURATION/3).set_ease(Tween.EASE_OUT)
	else:
		is_open = true
		inventory_slot_1.connector.monitoring = true
		inventory_slot_1.connector.monitorable = true
		inventory_slot_2.connector.monitoring = true
		inventory_slot_2.connector.monitorable = true
		inventory_slot_3.connector.monitoring = true
		inventory_slot_3.connector.monitorable = true
		if inventory_slot_1.connected_cards.get_children() != []:
			inventory_slot_1.connected_cards.get_children()[0].is_uninteractable = false
			inventory_slot_1.connected_cards.get_children()[0].input_blocker.mouse_filter = Control.MOUSE_FILTER_STOP
		if inventory_slot_2.connected_cards.get_children() != []:
			inventory_slot_2.connected_cards.get_children()[0].is_uninteractable = false
			inventory_slot_2.connected_cards.get_children()[0].input_blocker.mouse_filter = Control.MOUSE_FILTER_STOP
		if inventory_slot_3.connected_cards.get_children() != []:
			inventory_slot_3.connected_cards.get_children()[0].is_uninteractable = false
			inventory_slot_3.connected_cards.get_children()[0].input_blocker.mouse_filter = Control.MOUSE_FILTER_STOP
		tween.tween_property(inventory_slot_1, "position", SLOT1_OPEN_POSITION, OPEN_DURATION).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(inventory_slot_2, "position", SLOT2_OPEN_POSITION, OPEN_DURATION).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(inventory_slot_3, "position", SLOT3_OPEN_POSITION, OPEN_DURATION).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(inventory_slot_1, "modulate:a", 1, OPEN_DURATION/3).set_ease(Tween.EASE_OUT)
		tween.tween_property(inventory_slot_2, "modulate:a", 1, OPEN_DURATION/3).set_ease(Tween.EASE_OUT)
		tween.tween_property(inventory_slot_3, "modulate:a", 1, OPEN_DURATION/3).set_ease(Tween.EASE_OUT)
