extends Node2D
class_name BulletEmitter

@export var bullet_scene: PackedScene
@export var start_fire_rate: float = 3.0
@export var sound_shoot: AudioStream

var _fire_rate: float
var _fire_time: float
var _fire_speed: float = 1500.0
var damage = 1.0
var pierce = 0
var explosion_chance = 0.0

var max_spread_angle = 300.0

var fire_target: Vector2 = Vector2()

var spread_angle: float = 0.01
var spread_offset: float = 25

var num_projectiles: int = 1

var time_since_last_fire: float = _fire_time

func _ready() -> void:
	_fire_rate = start_fire_rate
	_fire_time = 1.0 / _fire_rate

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
	AudioManager.play_sound(sound_shoot, "Effects")
	get_tree().get_current_scene().shake.emit(0, 0.2)

	var split_angle = max_spread_angle / (num_projectiles + 1)
	for i in range(num_projectiles):
		var bullet  = bullet_scene.instantiate()
		get_tree().get_root().add_child(bullet)

		var AAAAAAA = (-max_spread_angle * 0.5) + split_angle * (i + 1)
		var angle = Vector2.from_angle(random_angle() - deg_to_rad(AAAAAAA) + ((fire_target - global_position).normalized().angle()))
		set_bullet_properties(bullet)
		bullet.shoot(global_position, fire_target + random_offset(), angle, _fire_speed * (randf() * 0.5 + 0.75) )

func set_bullet_properties(bullet: Bullet) -> void:
	bullet.damage = damage * (randf() * 0.5 + 0.75)
	bullet.pierce = pierce
	bullet.explosion_chance = explosion_chance

func _process(delta: float) -> void:
	time_since_last_fire += delta
	if firing:
		if time_since_last_fire >= _fire_time:
			time_since_last_fire = 0
			instantiate_bullet()
		firing = false
		fire_target = Vector2()
