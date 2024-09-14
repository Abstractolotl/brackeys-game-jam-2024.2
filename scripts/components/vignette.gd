extends ColorRect
class_name Vignette

var player: Player
var camera: Node2D


func _ready() -> void:
	player = get_tree().get_current_scene().player
	print(get_viewport_rect().size)

func update_vignette(progress:float):
	material.set_shader_parameter("vignette_strength", progress)

var inner_radius = 0.1
var outer_radius = 0.5
func update_light(amount: float):
	inner_radius += amount
	outer_radius += amount
	material.set_shader_parameter("inner_radius", inner_radius)
	material.set_shader_parameter("outer_radius", outer_radius)

func _process(_delta: float) -> void:
	camera = get_viewport().get_camera_2d()

	var offset = camera.get_global_transform().basis_xform(player.global_position) - camera.global_position
	offset = Vector2(offset.x / get_viewport_rect().size.x * camera.zoom.x, offset.y / get_viewport_rect().size.y * camera.zoom.y)
	material.set_shader_parameter("player_coords", offset)
