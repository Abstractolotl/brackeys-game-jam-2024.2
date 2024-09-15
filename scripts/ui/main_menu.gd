extends Control

@export var background_music: AudioStream
@export var credits_music: AudioStream
@export var game_scene: PackedScene

var watching_credits = false

func _ready() -> void:
	AudioManager.play_sound(background_music, "Music", -2.5, true, 0.25)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and watching_credits:
		$AnimationPlayer.play("RESET")
		stop_credits()


func _on_new_game_button_down() -> void:
	AudioManager.play_sound(load("res://assets/audio/menu/menu_click_start.mp3"), "Effects")


func _on_new_game_button_up() -> void:
	AudioManager.play_sound(load("res://assets/audio/menu/menu_click_end.mp3"), "Effects")
	get_tree().change_scene_to_file(game_scene.resource_path)
	AudioManager.stop_all()


func _on_options_button_down() -> void:
	AudioManager.play_sound(load("res://assets/audio/menu/menu_click_start.mp3"), "Effects")


func _on_options_button_up() -> void:
	AudioManager.play_sound(load("res://assets/audio/menu/menu_click_end.mp3"), "Effects")
	$AnimationPlayer.play("show_options")


func _on_credits_button_down() -> void:
	if watching_credits:
		return		
	watching_credits = true
	
	AudioManager.play_sound(load("res://assets/audio/menu/menu_click_start.mp3"), "Effects")
	$Menu.visible = false
	$Credits.visible = true
	
	AudioManager.stop_all()
	AudioManager.play_sound(credits_music, "Music", -2.5, false)
	
	$AnimationPlayer.play("credits")
	await $AnimationPlayer.animation_finished
	
	stop_credits()

func stop_credits():
	AudioManager.stop_all()
	AudioManager.play_sound(background_music, "Music", -2.5, true, 0.25)
	
	$Credits.visible = false
	$Menu.visible = true
	watching_credits = false


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
	if value <= -23:
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
