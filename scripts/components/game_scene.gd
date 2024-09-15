extends Node2D

signal shake(amount: float, min: float)
signal night_start()

@export var background: AudioStream
@export var rain_sound: AudioStream

func spawn_bullet(bullet: Node):
	add.call_deferred(bullet)

func add(node: Node): 
	get_parent().add_child(node)

var env: WorldEnvironment

var night: Texture
var night_brightness: float = 1.0
var night_contrast: float = 1.0
var night_saturation: float = 1.0

@export var base: Texture
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
var day_time = 30.0;

func _ready() -> void:
	AudioManager.play_sound(background, "Music", -3.0, true)
	
	if shake:
		pass
	env = $enviroment/world
	night = env.environment.adjustment_color_correction
	night_brightness = env.environment.adjustment_brightness
	night_contrast = env.environment.adjustment_contrast
	night_saturation = env.environment.adjustment_saturation
	env.environment.adjustment_color_correction = blend_textures(base, night, 0)
	hud.vignette.update_vignette(0)
	player.global_position = Vector2(1, 1) * (randf() * 3900 + 50)
	get_viewport().get_camera_2d().global_position = player.global_position

var timer: float = 0.0;
func _process(delta: float) -> void:
	timer += delta

	var progress = min(floor((timer / day_time) * blend_stepts) / blend_stepts, 1.0)
	if progress != last_blend:
		if progress == 1.0:
			AudioManager.play_sound(rain_sound, "Weather", 0, true)
			hud.do_thunder()
			night_start.emit()
		last_blend = progress
		env.environment.adjustment_color_correction = blend_textures(base, night, progress)
		env.environment.adjustment_brightness = lerp(1.0, night_brightness, progress)
		env.environment.adjustment_contrast = lerp(1.0, night_contrast, progress)
		env.environment.adjustment_saturation = lerp(1.0, night_saturation, progress)
		hud.vignette.update_vignette(progress)

	hud._on_time_progress(progress)

func update_light(amount: float):
	hud.vignette.update_light(amount)
