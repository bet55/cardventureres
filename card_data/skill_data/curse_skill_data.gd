extends SkillData
class_name CurseSkillData

const DAMAGE = 4
const TEXTURE = preload("uid://bl314spem23vk") #curse skill sprite
const SKULL_ANIMATION = preload("uid://b4b65ubl6emo4") #skull animation scene
var DESCRIPTION = "deals " + str(DAMAGE) + " damage"


func main_effect(apllying_card, target_card):
	target_card.took_damage.emit(DAMAGE)
	var skull = SKULL_ANIMATION.instantiate()
	target_card.get_parent().get_parent().add_child(skull)
	skull.global_position = target_card.global_position + Vector2(0, -52)
	skull.get_node("AnimationPlayer").play("curse")
