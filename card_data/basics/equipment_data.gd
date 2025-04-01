extends CardData
class_name EquipmentData

const TYPE = "equipment"
const ALLOWED_CONNECTORS = [
]


func on_apply_effect(apllying_card, target_card):
	GlobalStuff.equiped_items[target_card.slot_index] = apllying_card.card_id
	main_effect(apllying_card, target_card)


func on_remove_effect(apllying_card, target_card):
	GlobalStuff.equiped_items[target_card.slot_index] = null
