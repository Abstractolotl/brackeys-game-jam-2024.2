extends Node
class_name HealthComponent

@export var health: float = 10
@export var max_health: float = 10.0

@export var invincibility_time = 0.0

signal health_changed(amount: float, new_health: float)

var invincible_timer = 0.0

func _ready() -> void:
	health = max_health

func _process(delta: float) -> void:
	invincible_timer -= delta

func hit(amount: float):
	if invincible_timer > 0:
		return
	invincible_timer = invincibility_time
	if not get_parent() is Player:
		get_tree().get_current_scene().hud.show_damage_number(get_parent().global_position, amount)
		
	health -= amount
	health_changed.emit(amount, health)
