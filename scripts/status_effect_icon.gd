extends TextureRect

@onready var icon_sprite: TextureRect = $"."
@onready var duration_label: Label = $DurationLabel
@onready var description_label: Label = $DescriptionLabel


func set_icon_data(icon, duration, description):
	icon_sprite.texture = icon
	duration_label.text = str(duration)
	description_label.text = description


func update_duration(new_duration):
	duration_label.text = str(new_duration)


func _on_mouse_hover_area_mouse_entered() -> void:
	description_label.visible = true


func _on_mouse_hover_area_mouse_exited() -> void:
	description_label.visible = false
