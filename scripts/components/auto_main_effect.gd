extends Node2D


func use_main_effect(card):
	card.main_effect.call(card)
