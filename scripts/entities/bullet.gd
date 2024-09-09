extends Area2D
class_name Bullet

var velocity = Vector2()

func shoot(origin: Vector2, target: Vector2, speed: float) -> void:
    var direction = (target - origin).normalized()
    position = origin
    rotation = direction.angle()
    velocity = direction * speed
    BulletSpawner.spawn_bullet(self)

func on_collision_body(body: Node2D):
    queue_free()
    if body.has_node("health"):
        body.get_node("health").hit(1)
        
func _physics_process(delta: float) -> void:
    position += velocity * delta
