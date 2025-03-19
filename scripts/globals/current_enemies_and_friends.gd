extends Node

var current_heroes = []
var current_mobs = []
var current_bosses = []
var current_summons = []
var current_friendly = []
var current_hostile = []


func get_current_heroes():
	return current_heroes


func get_current_mobs():
	return current_mobs


func get_current_bosses():
	return current_bosses


func get_current_summons():
	return current_summons


func get_current_friendly():
	return current_friendly


func get_current_hostile():
	return current_hostile


func add_hero(hero):
	current_heroes.append(hero)
	current_friendly.append(hero)


func remove_hero(hero):
	current_heroes.remove_at(current_heroes.find(hero))
	current_friendly.remove_at(current_friendly.find(hero))


func add_mob(mob):
	current_mobs.append(mob)
	current_hostile.append(mob)


func remove_mob(mob):
	current_mobs.remove_at(current_mobs.find(mob))
	current_hostile.remove_at(current_hostile.find(mob))


func add_boss(boss):
	current_bosses.append(boss)
	current_hostile.append(boss)


func remove_boss(boss):
	current_bosses.remove_at(current_bosses.find(boss))
	current_hostile.remove_at(current_hostile.find(boss))


func add_summon(summon):
	current_summons.append(summon)
	current_friendly.append(summon)


func remove_summon(summon):
	current_summons.remove_at(current_summons.find(summon))
	current_friendly.remove_at(current_friendly.find(summon))
