extends CardData
class_name SkillData

const TYPE = "skill"
const ALLOWED_CONNECTORS = [
	"mod",
]


func use_mods(apllying_card, target_card):
	for card in apllying_card.mod_cards:
		card.main_effect.call(apllying_card, target_card)


func on_apply_effect(apllying_card, target_card):
	main_effect(apllying_card, target_card)
	use_mods(apllying_card, target_card)
	for mod_card in apllying_card.mod_cards:
		mod_card.remove(mod_card.connected_to)
	apllying_card.remove(apllying_card.connected_to)
