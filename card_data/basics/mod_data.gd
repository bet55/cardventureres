extends CardData
class_name ModData

const TYPE = "mod"
const ALLOWED_CONNECTORS = [
]


func on_apply_effect(apllying_card, target_card):
	target_card.mod_cards.append(apllying_card)
