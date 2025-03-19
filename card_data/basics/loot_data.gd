extends Node
class_name LootData

const TYPE = "loot"
const ALLOWED_CONNECTORS = [
	"loot",
]


func main_effect(apllying_card, target_card):
	pass #это должно быть переопределенно в каждом наследнике


var on_apply_effect = func on_apply_effect(apllying_card, target_card):
	pass
