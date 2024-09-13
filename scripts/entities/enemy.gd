extends RigidBody2D
class_name Enemy

@export var player: Node2D
@export var speed: float = 100
@export var explosion: PackedScene

var animation: AnimationPlayer
var health: HealthComponent
var sprite: Sprite2D

var dead = false

func _ready():
	animation = $animation_player
	health = $health
	sprite = $sprite

func _process(_delta):
	if health.health <= 0:
		return
		
	if linear_velocity.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if health.health <= 0:
		return

	var direction = (player.global_position - global_position).normalized()
	state.linear_velocity = direction * speed
	pass

func _on_hit(_amount: float, new_health: float):
	if dead:
		if new_health < -5:
			if randf() < 0.5:
				var instance = explosion.instantiate()
				instance.global_position = global_position
				get_tree().get_current_scene().call_deferred("add_child", instance)

			queue_free()
		return

	if new_health <= 0:
		animation.play("death", 0)
		dead = true
		get_tree().get_current_scene().shake.emit(0, 0.5)
		call_deferred("on_death")
	else:
		animation.play("hit")
		get_tree().get_current_scene().shake.emit(0.0, 0.2)

func on_death():
	lock_rotation = false


func _on_body_entered(body: Node) -> void:
	if body is Player:
		print("Player entered")
