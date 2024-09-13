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
