extends HeroData
class_name TestHeroData

const CARDS_TO_PRODUCE = [070100] #test skill
const TEXTURE = preload("uid://cgiggmn8l1csn") #test card sprite
const MAX_HEALTH = 15
const MAX_SPEED = 4
var DESCRIPTION = "every " + str(MAX_SPEED) + " turns creates skill"


var main_effect = func main_effect():
	pass
