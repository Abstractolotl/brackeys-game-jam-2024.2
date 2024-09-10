extends Node2D

signal shake(amount: float, min: float)

func spawn_bullet(bullet: Bullet):
    get_parent().add_child(bullet)


var spawn_rate = 5.0
var spawn_time = 1.0 / spawn_rate
var time_since_last_spawn = 0.0

var enemy_scene = preload("res://entities/enemy.tscn")
var player: Node2D

func _process(delta: float) -> void:
    time_since_last_spawn += delta
    
    if time_since_last_spawn >= spawn_time:
        time_since_last_spawn = 0

        var enemy: Enemy = enemy_scene.instantiate()
        enemy.player = player
        enemy.global_position = Vector2(randi() % 800, randi() % 600)
        add_child(enemy)
