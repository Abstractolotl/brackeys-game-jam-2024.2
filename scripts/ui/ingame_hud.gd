extends Control
class_name IngameHud

@export var level_bar: LevelBar
@export var health_bar: HealthBar
@export var time_bar: AnimatedTextureRect

@export var damage_number: PackedScene

var vignette: Vignette

func _ready() -> void:
	vignette = $vignette


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			resume()
		else:
			pause()

func show_damage_number(position: Vector2, damage: float):
	var damageNumber = damage_number.instantiate()
	damageNumber.damage = damage
	damageNumber.damage_position = Vector2(position.x + randf_range(-15.0, 15.0), position.y +  randf_range(-15.0, 15.0))
	$DamageNumbers.add_child(damageNumber)

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


func _on_player_bullet_update(projectiles: int, _fire_rate: float) -> void:
	level_bar.update_bullet_level(projectiles)


func _on_time_progress(percentage: float) -> void:
	var frame_amount = 23
	var frame = min(int(round(frame_amount * percentage)), frame_amount-1)
	time_bar.go_to_frame(frame)


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
