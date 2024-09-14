extends ReferenceRect

@export var to_spawn: PackedScene
@export var min_amount: int = 1
@export var max_amount: int = 1
@export var min_distance: float = 0

func _ready():
	spawn()
	queue_free()

func spawn():
	var amount = randi() % (max_amount - min_amount + 1) + min_amount
	var spawned_positions = []

	var i = 0
	var max_tries = amount * 10
	var should_break = false
	while i < amount:
		if max_tries <= 0:
			print("Could not spawn all instances")
			break

		var random_pos = get_random_point()
		for pos in spawned_positions:
			if random_pos.distance_to(pos) < min_distance:
				random_pos = get_random_point()
				should_break = true
				break
		if should_break:
			should_break = false
			max_tries -= 1
			continue

		i += 1
		spawned_positions.append(random_pos)
		var instance = to_spawn.instantiate()
		instance.position = random_pos
		get_tree().current_scene.add_child.call_deferred(instance)

func get_random_point() -> Vector2:
	return get_rect().position + Vector2(randf() * get_rect().size.x, randf() * get_rect().size.y)
