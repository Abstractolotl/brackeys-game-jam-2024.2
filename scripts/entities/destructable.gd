extends Node2D

var animation: AnimationPlayer

func _ready():
    animation = $animation
    animation.play("idle")

func hit(amount: float, new_health: float):
    if new_health <= 0:
        animation.play("death")
    else:
        animation.play("hit")
