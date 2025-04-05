extends Node2D

const SCALE = Vector2(1.2, 1.2)
const ANIMATION_TIME = 0.2
var OFFSET_SCALE = 40

var cards_to_produce# = []


func play_produce_animation(card):
	var tween1 = create_tween()
	var tween2 = create_tween()
	tween1.tween_property(card, "global_position", card.global_position + Vector2(1, 0).rotated(randf_range(0, PI * 2)) * OFFSET_SCALE, ANIMATION_TIME).set_ease(Tween.EASE_IN)
	tween2.tween_property(card, "scale", SCALE, ANIMATION_TIME/2).set_ease(Tween.EASE_OUT)
	tween2.tween_property(card, "scale", Vector2(1, 1), ANIMATION_TIME/2).set_ease(Tween.EASE_OUT)


func produce_card(producer):
	for card in cards_to_produce:
		var new_card = CardFabric.create_card(card)
		GlobalStuff.current_card_holder.add_child(new_card)
		new_card.global_position = get_parent().global_position
		play_produce_animation(new_card)
		new_card.last_pos = new_card.global_position
