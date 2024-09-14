extends Area2D

var animation: AnimationPlayer

func _ready():
	animation = $animation
	animation.play("explosion")
	get_tree().get_current_scene().shake.emit(0, 0.5)

func _on_animation_finished(_name: StringName):
	queue_free()

func on_collision(body: Node2D):
	var health = Util.find_health_component(body)

	if health:
		health.hit(1)
		

	if body is RigidBody2D:
		#var direction = (body.global_position - global_position).normalized()
		#body.apply_impulse(direction * 2000, Vector2(0, 0))
		pass
