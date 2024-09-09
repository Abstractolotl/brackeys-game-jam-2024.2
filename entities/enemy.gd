extends RigidBody2D

@export var player: Node2D
@export var speed: float = 100

var animation: AnimationPlayer;

func _ready():
    animation = $animation_player

func _physics_process(_delta: float) -> void:
    var direction = (player.global_position - global_position).normalized()
    linear_velocity = direction * speed

func _on_hit(_amount: float, new_health: float):
    animation.play("hit")
    if new_health <= 0:
        queue_free()