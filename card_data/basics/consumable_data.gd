extends CardData
class_name ConsumableData

const TYPE = "consumable"
const ALLOWED_CONNECTORS = [
]


func on_apply_effect(apllying_card, target_card):
	main_effect(apllying_card, target_card)
