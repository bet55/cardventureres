extends Node
class_name EquipmentData

const TYPE = "equipment"
const ALLOWED_CONNECTORS = [
]


func main_effect(apllying_card, target_card):
	pass #это должно быть переопределенно в каждом наследнике


var on_apply_effect = func on_apply_effect(apllying_card, target_card):
	main_effect(apllying_card, target_card)
