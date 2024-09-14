extends ColorRect
class_name Vignette

var player: Player
var camera: Node2D


func _ready() -> void:
	player = get_tree().get_current_scene().player
	

func update_vignette(progress:float):
	material.set_shader_parameter("vignette_strength", progress)

func _process(_delta: float) -> void:
	camera = get_viewport().get_camera_2d()
	if Input.is_action_just_pressed("fire"):
		print(camera.global_position)
	

	var offset = camera.get_global_transform().basis_xform(player.global_position) - camera.global_position
	offset = Vector2(offset.x / get_viewport_rect().size.x, offset.y / get_viewport_rect().size.y)
	material.set_shader_parameter("player_coords", offset)
