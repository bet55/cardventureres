extends CardData
class_name LootPackData

const TYPE = "loot_pack"
const ALLOWED_CONNECTORS = [
]
const TEXTURE = preload("uid://de86b4nvfm5r") #loot bag texture
const LOOT_CONTENT = [
	090100, #coin
]
var CARDS_TO_PRODUCE = [
	LOOT_CONTENT.pick_random(),
	LOOT_CONTENT.pick_random(),
	LOOT_CONTENT.pick_random()
]
var DESCRIPTION = "contains loot"


func on_apply_effect(apllying_card, target_card):
	apllying_card.card_producer.produce_card(apllying_card)
	apllying_card.burn(apllying_card.connected_to)
