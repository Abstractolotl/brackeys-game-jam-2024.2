extends Control

@export var game_scene: PackedScene

func _on_new_game_button_down() -> void:
	get_tree().change_scene_to_file(game_scene.resource_path)


func _on_options_button_down() -> void:
	$AnimationPlayer.play("show_options")

func _on_back_button_down() -> void:
	$AnimationPlayer.play("back_to_start")

func _on_credits_button_down() -> void:
	$Menu.visible = false
	$Credits.visible = true
	
	$AnimationPlayer.play("credits")
	await $AnimationPlayer.animation_finished
	
	$Credits.visible = false
	$Menu.visible = true
