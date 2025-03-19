extends Node2D

var max_health
var health


func _on_took_damage(damage):
	health -= damage
	print("we took " + str(damage) + " damage")
	print("current health: " + str(health))
	if health <= 0:
		get_parent().remove(get_parent().connected_to)


func _on_took_heal(heal):
	health += heal
	if health >= max_health:
		health = max_health
	print("we took " + str(heal) + " heal")
	print("current health: " + str(health))
