extends ConsumableData

const HEAL_AMOUNT = 5
const TEXTURE = preload("uid://dllgckiwqsg4s") #heal potion sprite
var DESCRIPTION = "heals target for " + str(HEAL_AMOUNT)


func main_effect(apllying_card, target_card):
	target_card.took_heal.emit(HEAL_AMOUNT)
	apllying_card.remove(apllying_card.connected_to)
