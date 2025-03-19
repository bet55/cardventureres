extends Node2D

var max_speed
var speed

signal speed_counter_refreshed #отправляет карту аргументом


func _on_card_played(apllying_card):
	speed -= 1
	print(speed)
	if speed <= 0:
		speed = max_speed
		if get_parent().card_type != "deck" and get_parent().health_bar != null:
			if get_parent().health_bar.health > 0:
				speed_counter_refreshed.emit(get_parent())
				print("speed counter refreshed for " + get_parent().card_type)
		else:
			speed_counter_refreshed.emit()
			print("speed counter refreshed for " + get_parent().card_type)
