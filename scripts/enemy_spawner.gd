extends Node


@export var player: Player
@export var spawn_waves: Array[SpawnWave]
@export var spawn_radius: float = 450

var is_night: bool = false
var wave_length_seconds: int = 5

var since_last_tick: float = 0.0

var since_last_wave: float = 0
var wave_counter: int = 0

var random: RandomNumberGenerator = RandomNumberGenerator.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_night:
		return
	
	since_last_wave += delta
	while since_last_wave > wave_length_seconds:
		since_last_wave -= wave_length_seconds
		wave_counter += 1
		var wave = _choose_wave(wave_counter)
		spawn_wave(wave)


func _ready() -> void:
	pass#spawn_enemy(player.global_position + Vector2(10, 0), load("res://entities/tnt_sheep.tscn"))

func spawn_wave(wave: SpawnWave):
	get_tree().current_scene.hud.do_thunder()
	if wave.enemy == null:
		print("wave " + str(wave_counter) + ": skipped")
		return
	
	var amount = random.randi_range(wave.amount_min, wave.amount_max)
	
	if amount == 0:
		print("wave " + str(wave_counter) + ": skipped")
		return
		
	if wave.spacing == Util.Spacing.EVEN:
		print("wave " + str(wave_counter) + ": even")
		_spawn_wave_even(wave, amount)
		
	if wave.spacing == Util.Spacing.RANDOM:
		print("wave " + str(wave_counter) + ": random")
		_spawn_wave_random(wave, amount)
		
	if wave.spacing == Util.Spacing.GROUPED:
		print("wave " + str(wave_counter) + ": grouped")
		_spawn_wave_grouped(wave, amount)


func _choose_wave(wave_number: int):		
	var available_waves = []
	var total_weight = 0
	
	for wave in spawn_waves:
		if wave.min_wave >= wave_number:
			continue
		if wave.max_wave != -1 and wave.max_wave <= wave_number:
			continue
		if wave.weight == 0:
			continue
		
		total_weight += wave.weight
		available_waves.append(wave)

	var chosen_weight = random.randi_range(0, total_weight - 1)

	var current_weight = 0
	for wave in available_waves:
		current_weight += wave.weight
		if chosen_weight < current_weight:
			return wave

	return null


func _spawn_wave_even(wave: SpawnWave, amount: int):
	var angle_offset = random.randf_range(0, 2 * PI)
	var angle_between = (2*PI) / (amount)
	
	for i in range(amount):
		var angle = angle_offset + (angle_between * i)
		var relative_pos = Vector2.from_angle(angle).normalized() * spawn_radius
		var spawn_position = player.global_position + relative_pos
		spawn_enemy(spawn_position, wave.enemy)


func _spawn_wave_random(wave: SpawnWave, amount: int):
	for i in range(amount):
		var angle = random.randf_range(0, 2 * PI)
		var relative_pos = Vector2.from_angle(angle).normalized() * spawn_radius
		var spawn_position = player.global_position + relative_pos
		spawn_enemy(spawn_position, wave.enemy)


func _spawn_wave_grouped(wave: SpawnWave, amount: int):
	var angle = random.randf_range(0, 2 * PI)
	var relative_pos = Vector2.from_angle(angle).normalized() * spawn_radius
	var spawn_position = player.global_position + relative_pos
	for i in range(amount):
		spawn_enemy(spawn_position, wave.enemy)


func spawn_enemy(spawn_position_global: Vector2, enemy_scene: PackedScene):
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.player = player
	enemy.global_position = spawn_position_global
	self.add_child(enemy)
	return enemy


func _on_game_night_start() -> void:
	is_night = true
