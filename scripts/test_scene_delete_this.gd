extends Node2D

@onready var card_holder: Node2D = $CardHolder


func _on_button_pressed() -> void:
	for card in card_holder.get_children():
		card.make_foil()


func _on_button_2_pressed() -> void:
	for card in card_holder.get_children():
		card.make_normal()


func _on_button_3_pressed() -> void:
	var card = CardFabric.create_card(010100)
	card_holder.add_child(card)
	card.global_position = get_viewport_rect().get_center()
	card.last_pos = card.global_position


func _on_button_4_pressed() -> void:
	for card in card_holder.get_children():
		card.remove(card.connected_to)


func _on_button_5_pressed() -> void:
	var card = CardFabric.create_card(070100)
	card_holder.add_child(card)
	card.global_position = get_viewport_rect().get_center()
	card.last_pos = card.global_position


func _on_button_6_pressed() -> void:
	var card = CardFabric.create_card(080100)
	card_holder.add_child(card)
	card.global_position = get_viewport_rect().get_center()
	card.last_pos = card.global_position


func _on_button_7_pressed() -> void:
	var card = CardFabric.create_card(110100)
	card_holder.add_child(card)
	card.global_position = get_viewport_rect().get_center()
	card.last_pos = card.global_position


func _on_button_8_pressed() -> void:
	var card = CardFabric.create_card(060100)
	card_holder.add_child(card)
	card.global_position = get_viewport_rect().get_center()
	card.last_pos = card.global_position


func _on_button_9_pressed() -> void:
	var card = CardFabric.create_card(030100)
	card_holder.add_child(card)
	card.global_position = get_viewport_rect().get_center()
	card.last_pos = card.global_position


func _on_button_10_pressed() -> void:
	get_tree().reload_current_scene()


func _on_button_11_pressed() -> void:
	var card = CardFabric.create_card(050100)
	card_holder.add_child(card)
	card.global_position = get_viewport_rect().get_center()
	card.last_pos = card.global_position
