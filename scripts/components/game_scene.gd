extends Node2D

signal shake(amount: float, min: float)
signal night_start()

func spawn_bullet(bullet: Node):
	call_deferred("add", bullet)

func add(node: Node): 
	get_parent().add_child(node)

var spawn_rate: float            = 3.0
var spawn_time: float            = 1.0 / spawn_rate
var time_since_last_spawn: float = 0.0

var env: WorldEnvironment

@export var base: Texture
var night: Texture
@export var enemy_scene: PackedScene = preload("res://entities/enemy.tscn")
@export var player: Node2D
@export var hud: IngameHud

func blend_textures(texture1: Texture2D, texture2: Texture2D, alpha: float) -> Texture2D:
	var image1: Image = texture1.get_image()
	var image2: Image = texture2.get_image()

	# Ensure both images are the same size
	if image1.get_size() != image2.get_size():
		print("Textures must be the same size")
		return null

	# Iterate through all the pixels and blend them
	for y in range(image1.get_height()):
		for x in range(image1.get_width()):
			var color1: Color = image1.get_pixel(x, y)
			var color2: Color = image2.get_pixel(x, y)

			# Blend the colors based on the alpha value
			var blended_color: Color = color1.lerp(color2, alpha)

			# Set the blended color to image1
			image1.set_pixel(x, y, blended_color)

	# Create a new texture from the blended image
	var new_texture: ImageTexture = ImageTexture.create_from_image(image1)

	return new_texture


var last_blend = 0.0;
var blend_stepts = 150.0;
var day_time = 6.0;

func _ready() -> void:
	env = $enviroment/world
	night = env.environment.adjustment_color_correction
	env.environment.adjustment_color_correction = blend_textures(base, night, 0)
	hud.vignette.update_vignette(0)

var timer: float = 0.0;
func _process(delta: float) -> void:
	time_since_last_spawn += delta
	timer += delta

	var progress = min(floor((timer / day_time) * blend_stepts) / blend_stepts, 1.0)
	if progress != last_blend:
		if progress == 1.0:
			night_start.emit()
		last_blend = progress
		env.environment.adjustment_color_correction = blend_textures(base, night, progress)
		hud.vignette.update_vignette(progress)

	hud._on_time_progress(progress)

	if last_blend < 1.0:
		return

	if fmod(timer, 5) < delta:
		spawn_rate += 1
		spawn_time = 1.0 / spawn_rate
	
	if time_since_last_spawn >= spawn_time:
		time_since_last_spawn = 0

		var enemy: Enemy = enemy_scene.instantiate()
		enemy.player = player
		enemy.global_position = Vector2(randi() % 800, randi() % 600)
		$enemies.add_child(enemy)
