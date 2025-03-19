extends EffectData

const DAMAGE = 1
const DURATION = 2
const ICON = preload("uid://c18wg8lkw5smk")
var DESCRIPTION = "deals " + str(DAMAGE) + " damage every turn"


func _ready() -> void:
	duration = DURATION
	icon = ICON
	description = DESCRIPTION


func on_tick_effect():
	holder.took_damage.emit(DAMAGE)
