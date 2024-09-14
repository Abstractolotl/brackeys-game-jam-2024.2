extends Control

@export var game_scene: PackedScene

func _on_new_game_button_down() -> void:
	AudioManager.play_sound(load("res://assets/audio/menu/menu_click_start.mp3"), "Effects")


func _on_new_game_button_up() -> void:
	AudioManager.play_sound(load("res://assets/audio/menu/menu_click_end.mp3"), "Effects")
	get_tree().change_scene_to_file(game_scene.resource_path)


func _on_options_button_down() -> void:
	AudioManager.play_sound(load("res://assets/audio/menu/menu_click_start.mp3"), "Effects")


func _on_options_button_up() -> void:
	AudioManager.play_sound(load("res://assets/audio/menu/menu_click_end.mp3"), "Effects")
	$AnimationPlayer.play("show_options")


func _on_credits_button_down() -> void:
	AudioManager.play_sound(load("res://assets/audio/menu/menu_click_start.mp3"), "Effects")
	$Menu.visible = false
	$Credits.visible = true
	
	$AnimationPlayer.play("credits")
	await $AnimationPlayer.animation_finished
	
	$Credits.visible = false
	$Menu.visible = true


func _on_credits_button_up() -> void:
	AudioManager.play_sound(load("res://assets/audio/menu/menu_click_end.mp3"), "Effects")


func _on_back_button_down() -> void:
	AudioManager.play_sound(load("res://assets/audio/menu/menu_click_start.mp3"), "Effects")


func _on_back_button_up() -> void:
	AudioManager.play_sound(load("res://assets/audio/menu/menu_click_end.mp3"), "Effects")
	$AnimationPlayer.play("back_to_start")


func _on_master_slider_value_changed(value: float) -> void:
	if value <= -13:
		AudioManager.set_bus_mute("Master", true)
	else:
		AudioManager.set_bus_mute("Master", false)
		AudioManager.set_bus_volume("Master", value)


func _on_effects_slider_value_changed(value: float) -> void:
	if value <= -13:
		AudioManager.set_bus_mute("Effects", true)
	else:
		AudioManager.set_bus_mute("Effects", false)
		AudioManager.set_bus_volume("Effects", value)


func _on_music_slider_value_changed(value: float) -> void:
	if value <= -13:
		AudioManager.set_bus_mute("Music", true)
	else:
		AudioManager.set_bus_mute("Music", false)
		AudioManager.set_bus_volume("Music", value)


func _on_enemies_slider_value_changed(value: float) -> void:
	if value <= -13:
		AudioManager.set_bus_mute("Enemies", true)
	else:
		AudioManager.set_bus_mute("Enemies", false)
		AudioManager.set_bus_volume("Enemies", value)
