extends Node2D

@export var cards = []
@export var is_friendly: bool
@export var max_speed: int

@onready var speed_counter: Node2D = $SpeedCounter
@onready var card_amount: Label = $CardAmount

var card_type = "deck"

var last_card = null

signal card_drawn


func draw_random_card():
	if cards != []:
		var random_card = cards.pick_random()
		last_card = random_card
		cards.remove_at(cards.find(random_card))
		var card = CardFabric.create_card(random_card)
		get_parent().card_holder.add_child(card)
		card.global_position = get_viewport_rect().get_center()
		card.last_pos = card.global_position


func _ready() -> void:
	card_drawn.connect(Callable(GlobalSignals, "_on_card_played"))
	speed_counter.speed_counter_refreshed.connect(Callable(self, "_on_speed_counter_refreshed"))
	GlobalSignals.card_played.connect(Callable(speed_counter, "_on_card_played"))
	speed_counter.max_speed = max_speed
	speed_counter.speed = max_speed


func _on_texture_button_pressed() -> void:
	if is_friendly:
		if cards != []:
			draw_random_card()
			card_drawn.emit()
			card_amount.text = str(len(cards))
			print("draw " + str(last_card) + " from " + str(self))
		else:
			print("no cards")


func _on_speed_counter_refreshed():
	if !is_friendly:
		draw_random_card()
		card_amount.text = str(len(cards))
		print("draw " + str(last_card) + " from " + str(self))


func _on_texture_button_mouse_entered() -> void:
	card_amount.text = str(len(cards))
	card_amount.visible = true


func _on_texture_button_mouse_exited() -> void:
	card_amount.visible = false
