extends Node
class_name ModData

const TYPE = "mod"
const ALLOWED_CONNECTORS = [
]


func main_effect(apllying_card, target_card):
	pass #это должно быть переопределенно в каждой карте


var on_apply_effect = func on_apply_effect(apllying_card, target_card):
	target_card.mod_cards.append(apllying_card)
