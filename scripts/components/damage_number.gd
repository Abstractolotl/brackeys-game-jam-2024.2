extends Control
class_name DamageNumber

@export var damage: float = 0.0
@export var damage_position: Vector2

@export var normal_damage_color: Color
@export var medium_damage_color: Color
@export var critical_damage_color: Color

var camera: Camera2D

func _ready() -> void:
	if damage >= 5.0:
		$label.add_theme_color_override("default_color", critical_damage_color)
	elif damage >= 2.5:
		$label.add_theme_color_override("default_color", medium_damage_color)
	else:
		$label.add_theme_color_override("default_color", normal_damage_color)
	
	$label.text = String.num(damage * 10, 0)
	camera = get_viewport().get_camera_2d()
	
	$AnimationPlayer.play("damage")
	await $AnimationPlayer.animation_finished
	queue_free()

func _process(delta: float) -> void:
	position = (damage_position - camera.global_position) * camera.zoom + (get_viewport_rect().size / 2.0)
