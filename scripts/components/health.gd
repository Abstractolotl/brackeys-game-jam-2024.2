extends Node

@export var health = 10.0

signal health_changed(amount: float, new_health: float)

func hit(amount: float):
    health -= amount
    emit_signal("health_changed", amount, health)