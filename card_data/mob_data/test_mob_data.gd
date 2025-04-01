extends MobData
class_name TestMobData

const DAMAGE = 4
const TEXTURE = preload("uid://dnpf4xtf8ehr3") #test mob sprite
const MAX_HEALTH = 10
const MAX_SPEED = 3
var DESCRIPTION = "every " + str(MAX_SPEED) + " turns deals " + str(DAMAGE) + " damage"


#тут был баг когда ближайшая цель не нул, а цель нул
func main_effect(apllying_card, target_card):
	var closest_target = CurrentEnemiesAndFriends.get_current_friendly().pick_random()
	for target in CurrentEnemiesAndFriends.get_current_friendly():
		if target != null and closest_target != null:
			if target.global_position.distance_to(apllying_card.global_position) < closest_target.global_position.distance_to(apllying_card.global_position):
				closest_target = target
	if closest_target != null:
		closest_target.took_damage.emit(DAMAGE)
