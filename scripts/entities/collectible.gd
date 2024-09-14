extends Area2D

enum CollectibleType {
	FIRE_RATE,
	PROJECTILES,
	DAMAGE,
	MOVE_SPEED,
	LIGHT,
	HP,
	PIERCE,
	EXPLOSION
}


@export var type: CollectibleType = CollectibleType.FIRE_RATE
var animation: AnimationPlayer

func _ready() -> void:
	animation = $animation
	animation.play("spawn")
	
func on_collision(body: Node2D) -> void:
	if !(body is Player):
		return

	AudioManager.play_sound(load("res://assets/audio/powerUp.wav"), "Effects")
	queue_free()

	var player = body as Player

	match type:
		CollectibleType.FIRE_RATE:
			_increase_fire_rate(player)
		CollectibleType.PROJECTILES:
			_increase_projectiles(player)
		CollectibleType.DAMAGE:
			_increase_damage(player)
		CollectibleType.MOVE_SPEED:
			_increase_move_speed(player)
		CollectibleType.LIGHT:
			_increase_light()
		CollectibleType.HP:
			_increase_hp(player)
		CollectibleType.PIERCE:
			_increase_pierce(player)
		CollectibleType.EXPLOSION:
			_increase_explosion(player)
	
func _increase_fire_rate(player: Player) -> void:
	player.emitter.set_fire_rate(player.emitter._fire_rate + 2)
	player.bullet_update.emit(player.emitter.num_projectiles, (player.emitter._fire_rate - player.emitter.start_fire_rate) / 2)


func _increase_projectiles(player: Player) -> void:
	player.emitter.num_projectiles = player.emitter.num_projectiles + 1
	player.bullet_update.emit(player.emitter.num_projectiles, (player.emitter._fire_rate - player.emitter.start_fire_rate) / 2)

func _increase_damage(player: Player) -> void:
	player.emitter.damage += 1

func _increase_move_speed(player: Player) -> void:
	player.speed += 50

func _increase_light() -> void:
	get_tree().get_current_scene().update_light(0.1)

func _increase_hp(player: Player) -> void:
	player.health.max_health += 1
	player.health.health += 1
	player._on_health_component_health_changed(0, player.health.health)

func _increase_pierce(player: Player) -> void:
	player.emitter.pierce += 1
	player.bullet_update.emit(player.emitter.num_projectiles, (player.emitter._fire_rate - player.emitter.start_fire_rate) / 2)

func _increase_explosion(player: Player) -> void:
	player.emitter.explosion_chance += 0.025
	player.bullet_update.emit(player.emitter.num_projectiles, (player.emitter._fire_rate - player.emitter.start_fire_rate) / 2)
