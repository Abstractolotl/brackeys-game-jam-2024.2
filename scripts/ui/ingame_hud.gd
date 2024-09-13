extends Control

@export var level_bar: LevelBar
@export var health_bar: HealthBar
@export var time_bar: AnimatedTextureRect

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			resume()
		else:
			pause()

func pause():
	$Pause.visible = true
	get_tree().paused = true
	$AnimationPlayer.play("pause_start")


func resume():
	$AnimationPlayer.play("pause_stop")
	await $AnimationPlayer.animation_finished
	$Pause.visible = false
	get_tree().paused = false


func exit_to_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _on_player_player_damaged(health: float) -> void:
	health_bar.update(health)


func _on_player_bullet_update(projectiles: int, fire_rate: float) -> void:
	level_bar.update_bullet_level(projectiles)


func _on_time_progress(percentage: float) -> void:
	var frame_amount = 23
	var frame = int(round(frame_amount * percentage))
	time_bar.go_to_frame(frame)
