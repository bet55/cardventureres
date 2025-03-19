extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var darker: Sprite2D = $Darker
@onready var shadow: Sprite2D = $Shadow
@onready var cloud_sprite: Sprite2D = $CloudSprite

const CLOUD1 = preload("uid://dvlvp8cwgku0w") #clouds assets
const CLOUD2 = preload("uid://cghmcqwsmmmcd")
const CLOUD3 = preload("uid://bmaybu5molm6b")
var sprites = [
	CLOUD1,
	CLOUD2,
	CLOUD3,
]

var disapear_time = 0.2

var camera = null


func remove():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.01, 0.01), disapear_time)
	await tween.finished
	queue_free()


func _ready() -> void:
	var random_texture = sprites.pick_random()
	darker.texture = random_texture
	shadow.texture = random_texture
	cloud_sprite.texture = random_texture
	var random_scale = randf_range(0.9, 1.1)
	scale = Vector2(random_scale, random_scale)
	animation_player.play("rotate")
	animation_player.seek(randf_range(0, 2))


func _process(delta: float) -> void:
	if camera != null:
		darker.modulate.a = global_position.distance_to(camera.global_position) * 0.0007
