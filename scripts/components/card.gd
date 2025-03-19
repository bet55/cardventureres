extends Node2D

@onready var shadow: Sprite2D = $CardWithShadow/Shadow
@onready var sprite: Sprite2D = $CardWithShadow/Sprite
@onready var enlarged_sprite: Sprite2D = $EnlargedSprite # Увеличенная копия спрайта
@onready var card_with_shadow: Node2D = $CardWithShadow #чтобы крутить и карту и тень при движении и не было ебли с з индексом
@onready var card_highlight: Sprite2D = $CardHighlight
@onready var connected_cards: Node2D = $ConnectedCards
@onready var current_stats: Label = $CurrentStats
@onready var description: Label = $CardWithShadow/Sprite/Description
@onready var step_on_fog_area: Area2D = $StepOnFogArea
@onready var applied_effects: Node2D = $AppliedEffects
@onready var effect_icon_container: HBoxContainer = $Control/EffectIconContainer
@onready var input_blocker: ColorRect = $InputBlocker

const ENLARGED_SCALE = Vector2(2, 2) # Масштаб увеличенной копии
const FOLLOW_SPEED = 15 # скорость следования карты за мышкой (мышка скрыта, так что не сильно важно)
const MOUSE_POS_TO_ANGLE_SCALE = 0.003 #определяет как быстро крутится карта при пкме
const PICK_UP_SCALE = Vector2(1.2, 1.2) #увеличиваем карту при подъеме
const PICK_UP_TIME = 0.5 #время анимации при подъеме
const DAMP = 10.0 #дэмпфирование осцилятора
const SPRING = 150.0 #упругость осцилятора
const VELOCITY_MULTIPLIER = 2.0 #тоже для осцилятора
const MAX_VIEW_ANGLE = 70 #максимальный угол наклона карты при осмотре на пкм
const REMOVE_SCALE = Vector2(1.2, 1.2) #увеличение при удалении
const REMOVE_TIME = 0.3 #длительность анимации удаления
const BURN_MATERIAL = preload("uid://dndbqron256f7") #шейдер сжигания (material)
const BURN_TIME = 0.5 #время анимации сжигания


var mouse_pos_enlarged #запоминает, где была мышка при осмотре карты, чтобы не телепортировать ее в центр экрана
#для осцилятора
var last_pos = Vector2()
var velocity
var oscillator_velocity = 0.0
var displacement = 0.0
#для осцилятора конец
#компоненты
var connector = null #ссылка на коннектор, если есть, нужна для доступа модов к эффекту скила
var health_bar = null #раз есть ссылка на коннектор, то и на остальное пусть будет
var speed_counter = null
var card_producer = null
var auto_main_effet = null
var crafter = null
var equipment = null
#компоненты конец
var pick_up_position = null #чтобы класть карту обратно, если ходим куда нельзя
var allowed_area = null #зона на карте по которой можно ходить
var connected_to = null #к чему пристегнута карта
var card_holder = null
var mod_cards = [] #карты моды, тк они будут прикреплены к основной карте, надо бы их удалять как то при использовании + теперь их абилки колятся через них
var card_texture #какую картинку поставить в рэди
var card_description #описание в рэди
var card_type = null #для дебага
var card_id = null #для рецептов
var main_effect: Callable #для доступа к основной абилке карты

var is_dragging = false
var is_enlarged = false
var is_mouse_on_top = false
var is_connected = false
var is_uninteractable = false

signal card_picked_up #отправляет себя аргументом
signal card_layed_down #отправляет себя аргументом
signal took_damage #отправляет урон аргументом
signal took_heal #отправляет хил аргументом


func show_enlarged_sprite():
	if enlarged_sprite:
		is_enlarged = true
		enlarged_sprite.visible = true
		enlarged_sprite.texture = sprite.texture  # Используем ту же текстуру, что и у основного спрайта
		enlarged_sprite.scale = ENLARGED_SCALE
		# Позиционируем увеличенную копию по центру экрана
		var viewport_size = get_viewport_rect().size
		enlarged_sprite.global_position = viewport_size / 2


func hide_enlarged_sprite():
	if enlarged_sprite:
		is_enlarged = false
		enlarged_sprite.visible = false


func pick_up_animation():
	shadow.visible = true
	var tween = create_tween()
	tween.tween_property(self, "scale", PICK_UP_SCALE, PICK_UP_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)


func lay_down_animation():
	shadow.visible = false
	var tween = create_tween()
	var tween2 = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), PICK_UP_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween2.tween_property(self, "rotation", 0, PICK_UP_TIME/4).set_ease(Tween.EASE_OUT)


func rotate_velocity(delta: float) -> void:
	if not is_dragging: return
	# Compute the velocity
	velocity = (position - last_pos) / delta
	last_pos = position
	
	oscillator_velocity += velocity.x * 0.0005 * VELOCITY_MULTIPLIER
	
	# Oscillator stuff
	var force = -SPRING * displacement - DAMP * oscillator_velocity
	oscillator_velocity += force * delta
	displacement += oscillator_velocity * delta
	
	rotation = displacement


func make_foil():
	sprite.material.set_shader_parameter("color_threshold", 0.1)
	enlarged_sprite.material.set_shader_parameter("color_threshold", 0.1)


func make_normal():
	sprite.material.set_shader_parameter("color_threshold", 0.0)
	enlarged_sprite.material.set_shader_parameter("color_threshold", 0.0)


func remove(target_card):
	var tween = create_tween()
	tween.tween_property(self, "scale", REMOVE_SCALE, REMOVE_TIME/2).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(0, 0), REMOVE_TIME/2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 0.0, REMOVE_TIME/2)
	if target_card == null:
		tween.tween_callback(queue_free)
	else:
		tween.tween_callback(remove_connected_card.bind(target_card))


func burn(target_card):
	z_index += 1
	var tween = create_tween()
	sprite.material = BURN_MATERIAL
	sprite.material.set_shader_parameter("dissolve_value", 1.0)
	tween.tween_property(sprite, "material:shader_parameter/dissolve_value", 0.0, BURN_TIME)
	if target_card == null:
		tween.tween_callback(queue_free)
	else:
		tween.tween_callback(remove_connected_card.bind(target_card))


func remove_connected_card(target_card):
	target_card.connected_cards.remove_child(self)
	queue_free()


func switch_highlight():
	if card_highlight.visible:
		card_highlight.visible = false
	else:
		card_highlight.visible = true


func _ready() -> void:
	last_pos = position
	sprite.texture = card_texture
	description.text = card_description


func _process(delta):
	if is_dragging:
		# Перемещаем спрайт к позиции курсора мыши
		global_position = lerp(global_position, get_global_mouse_position(), delta * FOLLOW_SPEED)
		
		#поворачиваем карту осцилятором
		rotate_velocity(delta)
		
		#двигаем тень
		var center: Vector2 = get_viewport_rect().size / 2.0
		var distance: float = global_position.x - center.x
		shadow.position.x = lerp(0.0, -sign(distance) * 10, abs(distance/(center.x)))
	
	if is_enlarged:
		#крутим карту при осмотре
		var mouse_pos = get_global_mouse_position() - mouse_pos_enlarged
		enlarged_sprite.material.set_shader_parameter("x_rot", clamp(rad_to_deg(mouse_pos.y * MOUSE_POS_TO_ANGLE_SCALE), -MAX_VIEW_ANGLE, MAX_VIEW_ANGLE))
		enlarged_sprite.material.set_shader_parameter("y_rot", clamp(rad_to_deg(mouse_pos.x * MOUSE_POS_TO_ANGLE_SCALE), -MAX_VIEW_ANGLE, MAX_VIEW_ANGLE))
	
	if is_connected:
		global_position = connected_to.global_position + Vector2(0, 36) * (get_index(true) + 1)


func _input(event):
	#drag n drop
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Проверяем, находится ли курсор над спрайтом
				if is_mouse_on_top and !is_uninteractable:
					if is_connected:
						connector.disconnect_cards(self, connected_to)
					#проигрываем анимацию поднятия
					Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
					pick_up_animation()
					pick_up_position = global_position
					card_picked_up.emit(self)
					is_dragging = true
			else:
				var return_needed = false
				for area in step_on_fog_area.get_overlapping_areas(): #проверяем не наступаем ли мы на облочка
					if area.get_parent().is_in_group("cloud"):
						return_needed = true
				if allowed_area != null: #если у нас есть зона, где можно ходить, проверяем ходим ли мы по ней
					if !Geometry2D.is_point_in_polygon(global_position, allowed_area.polygon):
						return_needed = true
				if return_needed:
					var tween = create_tween() #возвращаемся назад если наступаем
					tween.tween_property(self, "global_position", pick_up_position, 0.1)
					await tween.finished
				#возвращаем назад размеры при отпускании
				if self.scale != Vector2(1, 1):
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
					lay_down_animation()
				card_layed_down.emit(self)
				# Отпускаем спрайт, когда кнопка мыши отпущена
				is_dragging = false
	
	#осматриваем карту на пкм
	if event is InputEventMouseButton and !is_uninteractable:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				if is_mouse_on_top:
					mouse_pos_enlarged = get_global_mouse_position() #запоминаем где была мышка, когда нажали
					# Показываем увеличенную копию при нажатии правой кнопки мыши
					show_enlarged_sprite()
			else:
				# Скрываем увеличенную копию при отпускании правой кнопки мыши
				hide_enlarged_sprite()


func _on_input_blocker_mouse_entered() -> void:
	is_mouse_on_top = true
	var stats = ""
	if health_bar != null:
		stats += "hp: " + str(health_bar.health) + "\n"
	if speed_counter != null:
		stats += "speed: " + str(speed_counter.speed) + "\n"
	current_stats.text =  stats
	current_stats.visible = true


func _on_input_blocker_mouse_exited() -> void:
	is_mouse_on_top = false
	current_stats.visible = false
