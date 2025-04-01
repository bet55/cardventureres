extends Area2D

var type
var allowed_connectors
var on_apply_effect: Callable
var on_remove_effect: Callable

var highlighted_card = null
var highlighted_connector = null

signal card_played


func connect_cards():
	highlighted_card.switch_highlight()
	var target_card = highlighted_card
	var apllying_card = get_parent()
	highlighted_card = null
	apllying_card.is_connected = true
	apllying_card.connected_to = target_card
	on_apply_effect.call(apllying_card, target_card) #вызываем перед добавлением к карте, чтобы два гэт парент давали кард холдер
	GlobalStuff.current_card_holder.remove_child(apllying_card) #удаляем из кардхолдера
	apllying_card.position = Vector2.ZERO
	target_card.connected_cards.add_child(apllying_card) #добавляем к таргет карте
	for card in apllying_card.connected_cards.get_children():
		apllying_card.connected_cards.remove_child(card)
		card.connected_to = target_card #если добавить, то связанные карты вместек непонятно как убирать
		target_card.connected_cards.add_child(card)
	card_played.emit(target_card) #пришлось перенести на место тк это сломало крафт, доты теперь скипают первый тик


func disconnect_cards(card, disconnect_from):
	on_remove_effect.call(card, disconnect_from)
	card.is_connected = false
	var after_disconnect_pos = card.global_position
	disconnect_from.connected_cards.remove_child(card) #остоединяем о ткарты
	GlobalStuff.current_card_holder.add_child(card) #кладем вкардхолдер
	if disconnect_from.mod_cards.has(card):
		disconnect_from.mod_cards.remove_at(disconnect_from.mod_cards.find(card)) #надеемся на уникальность объектов
	card.global_position = after_disconnect_pos
	card.last_pos = card.position


func _on_area_entered(area: Area2D) -> void:
	if highlighted_card == null and get_parent().is_dragging:
		for ov_area in get_overlapping_areas():
			if (
				ov_area.is_in_group("connector") and 
				!ov_area.get_parent().is_dragging and 
				!ov_area.get_parent().is_connected and 
				type in ov_area.allowed_connectors and 
				!ov_area.get_parent().is_in_bag
				):
				highlighted_card = ov_area.get_parent()
				highlighted_connector = ov_area
				highlighted_card.switch_highlight()
				break


func _on_area_exited(area: Area2D) -> void:
	if highlighted_card != null and get_parent().is_dragging:
		highlighted_card.switch_highlight()
		highlighted_card = null
		highlighted_connector = null


func _on_card_layed_down(card):
	if highlighted_card != null:
		connect_cards()
