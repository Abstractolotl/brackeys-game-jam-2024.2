extends Node2D
class_name Util

signal shake(amount: float, min: float)

func spawn_bullet(bullet: Node):
	call_deferred("add", bullet)

func add(node: Node): 
	get_parent().add_child(node)

var spawn_rate: float            = 3.0
var spawn_time: float            = 1.0 / spawn_rate
var time_since_last_spawn: float = 0.0

@export var enemy_scene: PackedScene = preload("res://entities/enemy.tscn")
@export var player: Node2D

var timer: float = 0.0;
func _process(delta: float) -> void:
	time_since_last_spawn += delta
	timer += delta
	if fmod(timer, 5) < delta:
		spawn_rate += 1
		spawn_time = 1.0 / spawn_rate
	
	if time_since_last_spawn >= spawn_time:
		time_since_last_spawn = 0

		var enemy: Enemy = enemy_scene.instantiate()
		enemy.player = player
		enemy.global_position = Vector2(randi() % 800, randi() % 600)
		$enemies.add_child(enemy)

static func find_health_component(node: Node) -> HealthComponent:
	for n in node.get_children():
		if n is HealthComponent:
			return n
	return null
