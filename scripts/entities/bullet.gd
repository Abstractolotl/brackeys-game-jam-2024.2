extends Area2D
class_name Bullet

var flightTime: float = 0.0
var speed: float      = 0.0

@export var explosion_scene: PackedScene

var origin: Vector2   = Vector2()
var midPoint: Vector2 = Vector2()
var target: Vector2   = Vector2()
var damage = 1.0
var pierce = 0
var explosion_chance = 0.0

func shoot(_origin: Vector2, _target: Vector2, direction: Vector2, _speed: float) -> void:
	self.origin = _origin
	self.target = _target

	var dist = target - origin

	self.midPoint = origin + direction * dist.length() * 0.5 
	self.speed = dist.length() / _speed

	position = origin
	rotation = direction.angle()
	flightTime = 0.0
	
var pierced_bodies = []
func on_collision_body(body: Node2D):
	if body in pierced_bodies:
		return

	pierced_bodies.append(body)

	if randf() < explosion_chance:
		spawn_explosion()
		queue_free()
	
	if pierced_bodies.size() > pierce:
		queue_free()
	_play_hit_sound()
	
	var health_component = Util.find_health_component(body)

	if health_component:
		health_component.hit(damage)
		if body is RigidBody2D:
			body.apply_impulse(Vector2.from_angle(rotation) * 1000, Vector2(0, 0))
			
func _play_hit_sound():
	pass
		
func _physics_process(delta: float) -> void:
	flightTime += delta
	var t: float               = flightTime / speed
	var next_position: Vector2 = _quadratic_bezier(origin, midPoint, target, t)
	rotation = (next_position - position).angle()
	position = next_position

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
	var q0: Vector2 = p0.lerp(p1, t)
	var q1: Vector2 = p1.lerp(p2, t)
	var r: Vector2  = q0.lerp(q1, t)
	return r

func spawn_explosion():
	var instance = explosion_scene.instantiate()
	instance.global_position = global_position
	get_tree().get_current_scene().add_child.call_deferred(instance)
