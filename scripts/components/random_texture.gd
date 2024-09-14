extends Sprite2D

@export var textures: Array[Texture2D]

func _ready() -> void:
	texture = textures[randi_range(0, textures.size() - 1)]
