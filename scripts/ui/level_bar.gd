extends HBoxContainer
class_name LevelBar

@export var bullet_levels: Array[Texture2D]
@export var bullet_fire_rate: Array[Texture2D]

var bullet_level: TextureRect
var fire_rate: TextureRect

func _ready() -> void:
	bullet_level = TextureRect.new()
	bullet_level.texture = bullet_levels[0]
	add_child(bullet_level)

func update_bullet_level(level: int):
	if bullet_levels.size() < level:
		return
			
	if bullet_level != null:
		bullet_level.texture = bullet_levels[level - 1]
