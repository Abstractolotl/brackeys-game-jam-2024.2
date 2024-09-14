extends Node2D

var animation: AnimationPlayer
@export var pool: DropPool

var dead = false

func _ready():
	animation = $animation
	animation.play("RESET")

func on_death():
	if pool:
		var drop = pool.drop_from_pool()
		if drop:
			var drop_instance = drop.scene.instantiate()
			get_parent().add_child.call_deferred(drop_instance)
			drop_instance.global_position = global_position

func hit(_amount: float, new_health: float):
	if dead:
		return


	if new_health <= 0:
		dead = true
		if animation.current_animation == "hit":
			await animation.animation_finished
		animation.play("death")
		on_death()
	else:
		animation.stop()
		animation.play("hit")
