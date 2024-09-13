extends Control

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
	$Control/Bottom/MarginContainer/VBoxContainer/Healthbar.update(health)


func _on_player_bullet_update(projectiles: int, fire_rate: float) -> void:
	$Control/Bottom/MarginContainer/VBoxContainer/Levelbar.update_bullet_level(projectiles)


# Percentage of time already over before night (in format 0.x)
func _on_time_progress(percentage: float) -> void:
	var frame_amount = 23
	var frame = int(round(frame_amount * percentage))
	$Control/Top/VBoxContainer/TimeBar.go_to_frame(frame)


func _on_resume_button_down() -> void:
	AudioManager.play_sound(load("res://assets/audio/menu/menu_click_start.mp3"), "Effects")


func _on_resume_button_up() -> void:
	AudioManager.play_sound(load("res://assets/audio/menu/menu_click_end.mp3"), "Effects")
	resume()


func _on_back_to_menu_button_down() -> void:
	AudioManager.play_sound(load("res://assets/audio/menu/menu_click_start.mp3"), "Effects")


func _on_back_to_menu_button_up() -> void:
	AudioManager.play_sound(load("res://assets/audio/menu/menu_click_end.mp3"), "Effects")
	exit_to_menu()
