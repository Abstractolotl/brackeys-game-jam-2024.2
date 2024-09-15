extends Control
class_name IngameHud

@export var power_ups: PowerUpBar
@export var health_bar: HealthBar
@export var time_bar: AnimatedTextureRect

@export var timer: RichTextLabel
@export var death_time: RichTextLabel

@export var death_sound: AudioStream
@export var thunder_sound: AudioStream
@export var damage_number: PackedScene

var death_screen: bool = false
var vignette: Vignette

var night: bool
var night_time: float = 0.0

func _ready() -> void:
	vignette = $vignette
	$AnimationPlayer.play("tutorial")

func _process(delta: float) -> void:
	if not death_screen and not $AnimationPlayer.is_playing():
		if night and not get_tree().paused:
			night_time += delta
			update_timer()
		
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


func show_death_screen() -> void:
	AudioManager.stop_busses(["Effects", "Enemies", "Weather"])
	AudioManager.play_sound(death_sound, "Effects")
	
	$Death.visible = true
	death_screen = true
	get_tree().paused = true
	$AnimationPlayer.play("death")


func update_timer() -> void:
	var time = night_time
	if time >= 60:
		var minutes = roundi(time / 60)
		var seconds = roundi(time - (minutes * 60))
		timer.text = "[center]" +  ("%02d" % minutes) + ":" + ("%02d" % seconds) +  "[/center]"
		death_time.text = "[center]" +  ("%02d" % minutes) + ":" + ("%02d" % seconds) +  "[/center]"
	else:
		timer.text = "[center]00:" + ("%02d" % round(time)) +  "[/center]"
		death_time.text = "[center]00:" + ("%02d" % round(time)) +  "[/center]"


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
	AudioManager.stop_all()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func _on_player_power_up(type: int):
	power_ups.add_power_up(type)


func _on_player_player_damaged(max_health: float, health: float) -> void:
	health_bar.update(max_health, health)


func _on_player_death() -> void:
	show_death_screen()


func _on_player_bullet_update(projectiles: int, _fire_rate: float) -> void:
	power_ups.update_bullet_level(projectiles)

func _on_time_progress(percentage: float) -> void:
	var frame_amount = 11
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


func do_thunder():
	AudioManager.play_sound(thunder_sound, "Effects", 5, false, 0.1)
	$AnimationPlayer.play("thunder")


func show_start_night():
	$AnimationPlayer.play("night_begin")
	night = true
	timer.visible = true
