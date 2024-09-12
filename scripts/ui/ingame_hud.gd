extends Control

func pause_menu():
	$Pause.visible = !$Pause.visible


func _on_player_player_damaged(health: float) -> void:
	$Control/Bottom/MarginContainer/VBoxContainer/Healthbar.update(health)
