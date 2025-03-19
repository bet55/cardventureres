extends Node2D

signal valid_craft_combined


func _on_card_played(target_card):
	var connected_cards = []
	for card in get_parent().connected_cards.get_children():
		connected_cards.append(card.card_id)
	connected_cards.append(get_parent().card_id)
	connected_cards.sort()
	var key = ",".join(connected_cards)
	if Recipies.RECIPIES.has(key):
		valid_craft_combined.emit(Recipies.RECIPIES.get(key))
		var card = CardFabric.create_card(Recipies.RECIPIES.get(key))
		get_parent().get_parent().add_child(card)
		card.global_position = get_viewport_rect().get_center()
		card.last_pos = card.global_position
		for card_to_remove in get_parent().connected_cards.get_children():
			card_to_remove.remove(card_to_remove.connected_to)
		get_parent().remove(get_parent().connected_to)
		print("valid craft")
