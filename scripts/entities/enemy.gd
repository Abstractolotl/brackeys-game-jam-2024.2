extends RigidBody2D
class_name Enemy


var player: Node2D
@export var speed: float = 100
@export var explosion: PackedScene

@onready var animation_tree: AnimationTree = $AnimationTree
@export var audio_dead: AudioStream
@export var audio_hit: AudioStream


var animation: AnimationPlayer
var health: HealthComponent
var sprite: Sprite2D

var dead = false

func _ready():
	player = get_tree().get_current_scene().player

	animation = $animation_player
	health = $health
	sprite = $sprite
	animation_tree["parameters/Walk/blend_amount"] = 1.0

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
	AudioManager.play_sound(audio_hit, "Effects")
	if dead:
		if new_health < -5:
			queue_free()
		return

	if new_health <= 0:
		animation_tree.set("parameters/Death/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		animation_tree["parameters/Death 2/blend_amount"] = 1.0
		dead = true
		get_tree().get_current_scene().shake.emit(1, 0)
		on_death.call_deferred()
	else:
		animation_tree.set("parameters/Hurt/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		get_tree().get_current_scene().shake.emit(0.2, 0.5)

func on_death():
	lock_rotation = false
	AudioManager.play_sound(audio_dead, "Effects")


func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.damage(0.25)
