extends Node2D

var animation: AnimationPlayer
@export var drops: Array[Drop]

var dead = false

func _ready():
    animation = $animation
    animation.play("idle")


func on_death():
    if drops.size() == 0:
        return

    var total_weight = 0.0

    for drop in drops:
        total_weight += drop.weight

    var random = randf() * total_weight

    var current_weight = 0.0
    for drop: Drop in drops:
        current_weight += drop.weight
        if random <= current_weight:
            print("Spawning drop:", drop)
            if drop.scene == null:
                print("Error: drop is null", drops)
                return
            var drop_instance = drop.scene.instantiate()
            get_parent().add_child(drop_instance)
            drop_instance.global_position = global_position
            break

func hit(amount: float, new_health: float):
    if dead:
        return

    if new_health <= 0:
        animation.play("death")
        dead = true
        call_deferred("on_death")
    else:
        animation.stop()
        animation.play("hit")