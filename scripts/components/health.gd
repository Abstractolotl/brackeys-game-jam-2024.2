extends Node
class_name HealthComponent

@export var health: float = 10.0
signal health_changed(amount: float, new_health: float)

func hit(amount: float):
	if not get_parent() is Player:
		get_tree().get_current_scene().hud.show_damage_number(get_parent().global_position, amount)
		
	health -= amount
	health_changed.emit(amount, health)
