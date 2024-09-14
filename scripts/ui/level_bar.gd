extends HBoxContainer
class_name PowerUpBar

@export var textures: Array[Texture2D]

enum PowerUp {
	DAMAGE,
	EXPLOSION,
	HEALTH,
	HEALTH_GEN,
	SPEED,
	PIERCE,
	FIRE_RATE,
	PROJECTILES,
	LIGHT
}

var collected_powerups = {}

func add_power_up(power_up: PowerUp):
	var texture = textures[power_up]
	var rect = TextureRect.new()
	rect.texture = texture
	add_child(rect)
