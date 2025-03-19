extends Node
class_name EffectData

const STATUS_EFFECT_ICON_SCENE = preload("uid://hq22km7dmi6w")

#длительность и иконка переопределяются в наследниках
var duration
var icon
var description

var holder = null
var applier = null
var my_icon = null

#вот эта хуйня тут чтобы скипать первый тик, который применение дота и вызывает
#если посылать сигнал до коннекта кард, то это сломает крафт
var skip_first_tick = true

#след 3 эффекста определяются в наследниках
func on_apply_effect():
	pass


func on_remove_effect():
	pass


func on_tick_effect():
	pass


#непосредственно функционал всех эффектов
func tick(target_card):#не используй аргумент
	if skip_first_tick: #мне жаль
		skip_first_tick = false
	else:
		on_tick_effect()
		duration -= 1
		my_icon.update_duration(duration)
		if duration <= 0:
			remove()


func apply(who_applies, to_whom):
	applier = who_applies
	holder = to_whom
	var status_effect_icon = STATUS_EFFECT_ICON_SCENE.instantiate()
	holder.effect_icon_container.add_child(status_effect_icon)
	holder.applied_effects.add_child(self)
	status_effect_icon.set_icon_data(icon, duration, description)
	my_icon = status_effect_icon
	GlobalSignals.card_played.connect(Callable(self, "tick"))
	on_apply_effect()


func remove():
	on_remove_effect()
	my_icon.queue_free()
	queue_free()
