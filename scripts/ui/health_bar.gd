extends HBoxContainer
class_name HealthBar

@export var full: Texture2D
@export var half: Texture2D
@export var empty: Texture2D

@export var max: float = 10.0

func _ready() -> void:
	for i in range(max):
		var heart = TextureRect.new()
		heart.texture = full
		add_child(heart)

func update(health: float):
	for i in range(max):
		if health >= (i + 1):
			get_children()[i].texture = full
		elif (i + 1) - 0.5 == health:
			get_children()[i].texture = half
		else:
			get_children()[i].texture = empty
