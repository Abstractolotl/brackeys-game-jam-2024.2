extends Node2D
class_name BulletEmitter

@export var bullet_scene: PackedScene

var fire_rate = 3.0
var fire_speed = 500.0

var fire_time = 1.0 / fire_rate
var fire_target = Vector2()

var time_since_last_fire = fire_time

var firing = false
func shoot(target: Vector2) -> void:
    fire_target = target
    firing = true

func instantiate_bullet() -> void:
    var bullet_instance: Bullet = bullet_scene.instantiate()
    bullet_instance.shoot(global_position, fire_target, fire_speed)
    
func _process(delta: float) -> void:
    time_since_last_fire += delta
    if firing:
        if time_since_last_fire >= fire_time:
            time_since_last_fire = 0
            instantiate_bullet()
        firing = false
        fire_target = Vector2()

