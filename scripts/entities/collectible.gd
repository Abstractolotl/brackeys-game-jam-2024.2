extends Area2D

func on_collision_fire_rate(body: Node2D) -> void:
	if !(body is Player):
		return

	queue_free()
	var player = body as Player
	player.emitter.set_fire_rate(player.emitter._fire_rate + 2)
	
func on_collision_projectiles(body: Node2D) -> void:
	if !(body is Player):
		return
	queue_free()
	var player = body as Player
	player.emitter.num_projectiles += 1
