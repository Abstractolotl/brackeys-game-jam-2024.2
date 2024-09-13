extends Area2D

func on_collision_fire_rate(body: Node2D) -> void:
	if !(body is Player):
		return
	AudioManager.play_sound(load("res://assets/audio/powerUp.wav"), "Effects")
	queue_free()
	var player = body as Player
	player.emitter.set_fire_rate(player.emitter._fire_rate + 2)
	player.bullet_update.emit(player.emitter.num_projectiles, (player.emitter._fire_rate - player.emitter.start_fire_rate) / 2)
	
func on_collision_projectiles(body: Node2D) -> void:
	if !(body is Player):
		return
	AudioManager.play_sound(load("res://assets/audio/powerUp.wav"), "Effects")
	queue_free()
	var player = body as Player
	player.emitter.add_projectile()
	player.bullet_update.emit(player.emitter.num_projectiles, (player.emitter._fire_rate - player.emitter.start_fire_rate) / 2)
