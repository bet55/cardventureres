extends Node

const CARD_PATH = preload("uid://b2b15hre1vy6e") #card scene
const CONNECTOR_PATH = preload("uid://hgxycof3aq14") #connector scene
const HEALTH_BAR_PATH = preload("uid://bg8jx7iqhq6f6") #health bar scene
const SPEED_COUNTER_PATH = preload("uid://tfgdy6vimq0r") #speed counter scene
const CARD_PRODUCER_PATH = preload("uid://dop2e00vvy08q") #card producer scene
const AUTO_MAIN_EFFECT_PATH = preload("uid://bwry58tt7rhq7") #auto main effect scene
const CRAFTER_PATH = preload("uid://d087r03tpuwna") #crafter scene
const EQUIPMENT_PATH = preload("uid://cfj2gk3ybevb7") #equipment scene

func add_connector(card, card_data):
	var connector = CONNECTOR_PATH.instantiate()
	connector.type = card_data.TYPE
	connector.allowed_connectors = card_data.ALLOWED_CONNECTORS
	connector.on_apply_effect = card_data.on_apply_effect
	connector.on_remove_effect = card_data.on_remove_effect
	card.add_child(connector)
	card.connector = connector
	card.card_layed_down.connect(Callable(connector, "_on_card_layed_down"))
	connector.card_played.connect(Callable(GlobalSignals, "_on_card_played"))


func add_health_bar(card, card_data):
	var health_bar = HEALTH_BAR_PATH.instantiate()
	health_bar.max_health = card_data.MAX_HEALTH
	health_bar.health = card_data.MAX_HEALTH
	card.add_child(health_bar)
	card.health_bar = health_bar
	card.took_damage.connect(Callable(health_bar, "_on_took_damage"))
	card.took_heal.connect(Callable(health_bar, "_on_took_heal"))


func add_speed_counter(card, card_data):
	var speed_counter = SPEED_COUNTER_PATH.instantiate()
	speed_counter.max_speed = card_data.MAX_SPEED
	speed_counter.speed = card_data.MAX_SPEED
	card.add_child(speed_counter)
	card.speed_counter = speed_counter
	GlobalSignals.card_played.connect(Callable(speed_counter, "_on_card_played"))


#теперь можно производить карты по любому сигналу
func add_card_producer(card, card_data, signal_to_connect):
	var card_producer = CARD_PRODUCER_PATH.instantiate()
	card_producer.cards_to_produce = card_data.CARDS_TO_PRODUCE
	card.add_child(card_producer)
	card.card_producer = card_producer
	if signal_to_connect != null:
		signal_to_connect.connect(Callable(card_producer, "produce_card"))


func add_auto_main_effect(card, card_data, signal_to_connect):
	var auto_main_effect = AUTO_MAIN_EFFECT_PATH.instantiate()
	card.add_child(auto_main_effect)
	card.auto_main_effet = auto_main_effect
	if signal_to_connect != null:
		signal_to_connect.connect(Callable(auto_main_effect, "use_main_effect"))


func add_crafter(card, card_data, signal_to_connect):
	var crafter = CRAFTER_PATH.instantiate()
	card.add_child(crafter)
	card.crafter = crafter
	if signal_to_connect != null:
		signal_to_connect.connect(Callable(crafter, "_on_card_played"))


func add_equipment(card, card_data):
	var equipment = EQUIPMENT_PATH.instantiate()
	card.add_child(equipment)
	card.equipment = equipment


#создает карты и добавляет к ним детей-скрипты с логикой определенного функционала
func create_card(card_id):
	var card_data = CardLibrary.CARD_IDS.get(card_id).new()
	var new_card = CARD_PATH.instantiate()
	new_card.card_texture = card_data.TEXTURE
	new_card.card_type = card_data.TYPE
	new_card.card_id = card_id
	new_card.main_effect = card_data.main_effect
	new_card.card_description = card_data.DESCRIPTION
	match card_data.TYPE:
		"hero":
			add_connector(new_card, card_data)
			add_health_bar(new_card, card_data)
			add_speed_counter(new_card, card_data)
			add_card_producer(new_card, card_data, new_card.speed_counter.speed_counter_refreshed)
			add_equipment(new_card, card_data)
			CurrentEnemiesAndFriends.add_hero(new_card)
		"skill":
			add_connector(new_card, card_data)
		"mod":
			add_connector(new_card, card_data)
		"loot_pack":
			add_connector(new_card, card_data)
			add_card_producer(new_card, card_data, null)
		"loot":
			add_connector(new_card, card_data)
			add_crafter(new_card, card_data, GlobalSignals.card_played)
		"consumable":
			add_connector(new_card, card_data)
		"mob":
			add_connector(new_card, card_data)
			add_health_bar(new_card, card_data)
			add_speed_counter(new_card, card_data)
			add_auto_main_effect(new_card, card_data, new_card.speed_counter.speed_counter_refreshed)
			CurrentEnemiesAndFriends.add_mob(new_card)
		"equipment":
			add_connector(new_card, card_data)
	return new_card
