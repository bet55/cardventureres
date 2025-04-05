extends Node2D

@onready var bag_area_2d: Area2D = $BagArea2D
@onready var background: ColorRect = $Background
@onready var cards: Node2D = $Cards


const OPEN_OFFSET = Vector2(750, 0)
const OPEN_TIME = 0.7
const MOVE_IN_BAG_TIME = 0.1
const CARD_OFFSET = 64 #отступ по х между картами
const ALLOWED_CARDS = [
	"loot",
	"consumable",
]

var close_spot = Vector2()
var cards_in_bag = []

var is_open = false


func reposition_cards():
	var center = background.get_rect().get_center()
	var start = Vector2(center.x - CARD_OFFSET * 5, center.y)
	var cards_in_bag = cards.get_children()
	for i in range(cards.get_child_count()):
		var tween = create_tween()
		tween.tween_property(cards_in_bag[i], "position", Vector2(start.x + CARD_OFFSET * i, start.y), MOVE_IN_BAG_TIME)
		cards_in_bag[i].last_pos = cards_in_bag[i].position
	

func add_card(card):
	card.is_in_bag = true
	cards_in_bag.append(card.card_id)
	GlobalStuff.cards_in_bag = cards_in_bag
	reposition_cards()


func _ready() -> void:
	close_spot = get_parent().global_position + position
	for card_id in GlobalStuff.cards_in_bag:
		var new_card = CardFabric.create_card(card_id)
		cards.add_child(new_card)
		add_card(new_card)


func _on_bag_button_pressed() -> void:
	var tween = create_tween()
	var destination = Vector2()
	if is_open:
		close_spot = get_parent().global_position + position + OPEN_OFFSET
		is_open = false
		destination = close_spot
	else:
		close_spot = get_parent().global_position + position
		is_open = true
		destination = close_spot - OPEN_OFFSET
	tween.tween_property(self, "global_position", destination, OPEN_TIME).set_ease(Tween.EASE_OUT)


func _on_bag_area_2d_area_entered(area: Area2D) -> void:
	var card = area.get_parent()
	if card.card_type in ALLOWED_CARDS:
		card.card_layed_down.connect(Callable(self, "_on_card_layed_down"))
		card.card_picked_up.connect(Callable(self, "_on_card_picked_up"))


func _on_bag_area_2d_area_exited(area: Area2D) -> void:
	var card = area.get_parent()
	if card.card_type in ALLOWED_CARDS:
		card.card_layed_down.disconnect(Callable(self, "_on_card_layed_down"))
		card.card_picked_up.disconnect(Callable(self, "_on_card_picked_up"))
		if card in cards.get_children() and card.is_dragging:
			card.reparent(GlobalStuff.current_card_holder)
			card.last_pos = card.global_position
			cards_in_bag.remove_at(cards_in_bag.find(card.card_id))
			card.is_in_bag = false


func _on_card_layed_down(card):
	for i in range(cards.get_child_count()):
		if card.global_position.x > cards.get_children()[i].global_position.x:
			cards.move_child(card, i)
			
	if card in cards.get_children():
		reposition_cards()
		return
	card.reparent(cards)
	add_card(card)
	print(cards_in_bag)


func _on_card_picked_up(card):
	if card in cards.get_children():
		cards.move_child(card, cards.get_child_count())
