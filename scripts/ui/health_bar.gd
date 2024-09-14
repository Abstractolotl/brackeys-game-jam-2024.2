extends HBoxContainer
class_name HealthBar

@export var full: Texture2D
@export var half: Texture2D
@export var empty: Texture2D

@export var max_health: float = 10.0

@export var heart_scene: PackedScene

func _ready() -> void:
	for i in range(max_health):
		var heart = TextureRect.new()
		heart.texture = full
		add_child(heart)

func update(max_h: float, health: float):
	if max_health != max_h:
		max_health = max_h
		for i in range(max_health):
			if i < get_child_count():
				get_child(i).queue_free()
		for i in range(max_health):
			var heart = TextureRect.new()
			heart.texture = full
			add_child(heart)
		
	for i in range(max_health):
		if health >= (i + 1):
			get_children()[i].texture = full
		elif (i + 1) - 0.5 == health:
			get_children()[i].texture = half
		else:
			get_children()[i].texture = empty
