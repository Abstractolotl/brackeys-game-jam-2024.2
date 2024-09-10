extends Node
class_name HealthComponent

@export var health = 10.0

signal health_changed(amount: float, new_health: float)

func hit(amount: float):
    health -= amount
    health_changed.emit(amount, health)