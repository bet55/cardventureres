extends Node

signal card_played


func _on_card_played(target_card):
	card_played.emit(target_card)
