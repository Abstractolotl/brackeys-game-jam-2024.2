extends Area2D
class_name Bullet

var flightTime = 0.0
var speed = 0.0

var origin = Vector2()
var midPoint = Vector2()
var target = Vector2()

func shoot(_origin: Vector2, _target: Vector2, direction: Vector2, _speed: float) -> void:
    self.origin = _origin
    self.target = _target

    var dist = target - origin

    self.midPoint = origin + direction * dist.length() * 0.5 
    self.speed = dist.length() / _speed

    position = origin
    rotation = direction.angle()
    flightTime = 0.0
    GameScene.spawn_bullet(self)

func on_collision_body(body: Node2D):
    queue_free()

    var health_component = GameScene.find_health_component(body)

    if health_component:
        health_component.hit(1)
        if body is RigidBody2D:
            body.apply_impulse(Vector2.from_angle(rotation) * 1000, Vector2(0, 0))
        
func _physics_process(delta: float) -> void:
    flightTime += delta
    var t = flightTime / speed
    var next_position = _quadratic_bezier(origin, midPoint, target, t)
    rotation = (next_position - position).angle()
    position = next_position

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
    var q0 = p0.lerp(p1, t)
    var q1 = p1.lerp(p2, t)
    var r = q0.lerp(q1, t)
    return r