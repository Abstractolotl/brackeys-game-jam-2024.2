extends Node2D

var animation: AnimationPlayer
@export var pool: DropPool

@export var leftover: PackedScene
@export var remain: bool = true

@export var hit_sound: AudioStream
@export var death_sound: AudioStream

var dead = false

func _ready():
	animation = $animation
	animation.play("RESET")

func on_death():
	if death_sound:
		AudioManager.play_sound(death_sound, "Effects", -5, false, 0.25)
	if animation.current_animation == "hit":
		await animation.animation_finished
	
	animation.play("death")
	if pool:
		var drop = pool.drop_from_pool()
		if drop.scene:
			var drop_instance = drop.scene.instantiate()
			get_parent().add_child.call_deferred(drop_instance)
			drop_instance.global_position = global_position + Vector2.from_angle(randf() * 2 * PI) * 75

	if leftover:
		await animation.animation_finished
		var leftover_instance = leftover.instantiate()
		get_parent().add_child.call_deferred(leftover_instance)
		leftover_instance.global_position = global_position
		queue_free()

	await animation.animation_finished
	if not remain:
		queue_free()

func hit(_amount: float, new_health: float):
	if dead:
		return


	if new_health <= 0:
		dead = true
		on_death()
	else:
		on_hit.call_deferred()

func on_hit():
	if hit_sound:
		AudioManager.play_sound(hit_sound, "Effects", -5)
	animation.stop()
	animation.play("hit")
