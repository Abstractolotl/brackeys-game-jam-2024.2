extends ColorRect

var player: Player
var camera: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_current_scene().player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera = player.camera

	if !camera:
		print("NO CAMERA")
		return
	
	var offset = (player.global_position - camera.global_position) * 1
	material.set_shader_parameter("player_coords", Vector2(offset.x / DisplayServer.screen_get_size().x, offset.y / DisplayServer.screen_get_size().y))
