extends Node2D

var sprite: AnimatedSprite2D

func _ready():
	sprite = $sprite
	sprite.play("idle")

func hit(amount: float, new_health: float) -> void:
	if new_health <= 0:
		sprite.play("death")
	else:
		sprite.play("hit")
