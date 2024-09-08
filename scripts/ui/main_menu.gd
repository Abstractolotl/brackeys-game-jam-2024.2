extends Control


func _on_new_game_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/game/test.tscn")
	pass
