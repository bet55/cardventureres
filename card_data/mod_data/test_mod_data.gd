extends ModData
class_name TestModData

const TEXTURE = preload("uid://bo36nea32xhn8") #test mod sprite
var DESCRIPTION = "repeats skill"


func main_effect(apllying_card, target_card):
	apllying_card.main_effect.call(apllying_card, target_card)
