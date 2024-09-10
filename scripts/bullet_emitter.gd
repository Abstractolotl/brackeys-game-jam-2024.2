extends Node2D
class_name BulletEmitter

@export var bullet_scene: PackedScene

var fire_rate = 15.0
var fire_speed = 500.0

var fire_time = 1.0 / fire_rate
var fire_target = Vector2()

var spread_angle = 1.5
var spread_offset = 50

var time_since_last_fire = fire_time

var firing = false
func shoot(target: Vector2) -> void:
    fire_target = target
    firing = true

func random_angle() -> float:
    return (randf() - 0.5) * spread_angle

func random_offset() -> Vector2:
    return Vector2(randf() - 0.5, randf() - 0.5) * spread_offset

func instantiate_bullet() -> void:
    GameScene.shake.emit(0.5 / fire_rate, 0.4)
    var direction_angle = (fire_target - global_position).normalized().angle()

    bullet_scene.instantiate().shoot(global_position, fire_target + random_offset(), Vector2.from_angle(direction_angle + 45 + random_angle()), fire_speed)
    bullet_scene.instantiate().shoot(global_position, fire_target + random_offset(), Vector2.from_angle(direction_angle + 00 + random_angle()), fire_speed)
    bullet_scene.instantiate().shoot(global_position, fire_target + random_offset(), Vector2.from_angle(direction_angle - 45 + random_angle()), fire_speed)
    
func _process(delta: float) -> void:
    time_since_last_fire += delta
    if firing:
        if time_since_last_fire >= fire_time:
            time_since_last_fire = 0
            instantiate_bullet()
        firing = false
        fire_target = Vector2()

