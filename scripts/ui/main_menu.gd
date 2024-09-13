extends Control

@export var game_scene: PackedScene

func _on_new_game_button_down() -> void:
	get_tree().change_scene_to_file(game_scene.resource_path)


func _on_options_button_down() -> void:
	$Menu/TextureRect/HBoxContainer/Default.visible = false
	$Menu/TextureRect/HBoxContainer/Options.visible = true

func _on_back_button_down() -> void:
	$Menu/TextureRect/HBoxContainer/Options.visible = false
	$Menu/TextureRect/HBoxContainer/Default.visible = true


func _on_credits_button_down() -> void:
	$Menu.visible = false
	$Credits.visible = true
	
	$AnimationPlayer.play("credits")
	await $AnimationPlayer.animation_finished
	
	$Credits.visible = false
	$Menu.visible = true
