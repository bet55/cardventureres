extends SkillData
class_name TestSkillData

const DAMAGE = 1
const TEXTURE = preload("uid://hgpoc60wx6y8") #test skill sprite
const BURN = preload("uid://v3t5tfoyaadu") #burn script
var DESCRIPTION = "deals " + str(DAMAGE) + " damage and applies burn"


func main_effect(apllying_card, target_card):
	target_card.took_damage.emit(DAMAGE)
	var burn = BURN.new()
	burn.apply(apllying_card, target_card)
