extends Node2D
class_name BulletEmitter

@export var bullet_scene: PackedScene
@export var start_fire_rate: float = 30.0

var _fire_rate: float = start_fire_rate
var _fire_time: float = 1.0 / _fire_rate
var _fire_speed: float = 500.0

var fire_target: Vector2 = Vector2()

var spread_angle: float = 0.01
var spread_offset: float = 50

var num_projectiles: int = 1

var time_since_last_fire: float = _fire_time

func set_fire_rate(rate: float) -> void:
	_fire_rate = rate
	_fire_time = 1.0 / _fire_rate

func add_projectile() -> void:
	num_projectiles = num_projectiles + 1

var firing: bool = false
func shoot(target: Vector2) -> void:
	fire_target = target
	firing = true

func random_angle() -> float:
	return (randf() - 0.5) * spread_angle

func random_offset() -> Vector2:
	return Vector2(randf() - 0.5, randf() - 0.5) * spread_offset

func instantiate_bullet() -> void:
	get_tree().get_current_scene().shake.emit(0, 0.2)
	var direction_angle: float = (fire_target - global_position).normalized().angle()

	var spread: float = 20.0
	var radius: int = 320
	var teta: float = spread / radius;
	var max_spread: float = 50.0

	if teta * radius * num_projectiles > max_spread:
		teta = max_spread / radius / num_projectiles

	var offset_y = cos(teta * num_projectiles * 0.5) * radius

	for i in range(num_projectiles):
		var child_x = sin(teta * i - teta * num_projectiles * 0.5) * radius
		var child_y = cos(teta * i - teta * num_projectiles * 0.5) * radius
		var new_dir = Vector2(offset_y + child_y, child_x)
		
		var bullet  = bullet_scene.instantiate()
		get_tree().get_root().add_child(bullet)
		bullet.shoot(global_position, fire_target + random_offset(), Vector2.from_angle(direction_angle + new_dir.angle() + random_angle()), _fire_speed)


func _process(delta: float) -> void:
	time_since_last_fire += delta
	if firing:
		if time_since_last_fire >= _fire_time:
			time_since_last_fire = 0
			instantiate_bullet()
		firing = false
		fire_target = Vector2()
