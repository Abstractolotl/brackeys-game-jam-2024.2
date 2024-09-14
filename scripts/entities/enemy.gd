extends RigidBody2D
class_name Enemy

enum EnemyType {
	NORMAL,
	RANGED,
	TNT
}

var player: Node2D
@export var speed: float = 100
@export var size: float = 1
@export var explosion: PackedScene

@export var enemy_type: EnemyType

@export var side_texture: Texture
@export var up_texture: Texture
@export var down_texture: Texture

@onready var animation_tree: AnimationTree = $AnimationTree
@export var audio_dead: AudioStream
@export var audio_hit: AudioStream
@export var damage_modifier: float = 1.0

# only for normal or ranged type
@export var cooldown: float = 1.0


var animation: AnimationPlayer
var health: HealthComponent
var sprite: Sprite2D
var bullet_emitter: BulletEmitter

var dead = false

# only for tnt type
var fuse: float = 0.0

# only for ranged type
var cross_wanted_distance: int = 0

# only for normal and ranged type
var last_attack: float = 10.0


var last_position: Vector2


func _ready():
	player = get_tree().get_current_scene().player

	animation = $animation_player
	health = $health
	sprite = $sprite
	if enemy_type == EnemyType.RANGED:
		bullet_emitter = $BulletEmitter
	
	last_position = global_position


func _process(_delta):
	if dead:
		return
	
	var direction = (player.global_position - global_position).normalized()
	var force = direction * (speed * mass)
	
	if enemy_type == EnemyType.RANGED:
		var min_shooting_distance = 100
		var max_shooting_distance = 200
		var wanted_distance = 150
		var distance = (player.global_position - global_position).length()
		if cross_wanted_distance > 0:
			if distance > wanted_distance:
				cross_wanted_distance = 0
			else:
				if distance > min_shooting_distance:
					force /= 2
					
				self.apply_force(-force)
		elif cross_wanted_distance < 0:
			if distance < wanted_distance:
				cross_wanted_distance = 0
			else:
				if distance < max_shooting_distance:
					force /= 2
				
				self.apply_force(force)
		elif distance < min_shooting_distance:
			cross_wanted_distance = 1
		elif distance > max_shooting_distance:
			cross_wanted_distance = -1
		else:
			bullet_emitter.shoot(player.global_position)
			
	else:
		self.apply_force(force)
	
	
	var move_direction = linear_velocity.normalized()
	var velocity = linear_velocity.length()
	velocity = (global_position-last_position).length() / _delta
	last_position = global_position
	animation_tree.set("parameters/BlendSpace2D/blend_position", move_direction)
	animation_tree.set("parameters/TimeScale/scale", Util.clamped_range_mapping(velocity, 10, 200) * 4)
	
	animation_tree["parameters/Walk/blend_amount"] = 1.0 if velocity > 10 else 0.0
	
	_handle_attack(_delta)
	
	

func _handle_attack(_delta: float):
	var distance = (player.global_position - global_position).length()
	
	match enemy_type:
		EnemyType.NORMAL:
			last_attack += _delta
			if distance < 40:
				if last_attack > cooldown:
					player.health.hit(1 * damage_modifier)
					last_attack = 0
		EnemyType.TNT:
			if (fuse == 0 and distance > 100) or fuse == -1:
				return
			fuse += _delta
			animation_tree["parameters/Explode/blend_amount"] = fuse
			if fuse > 1:
				var ex = explosion.instantiate()
				ex.damage = 1 * damage_modifier
				ex.global_position = global_position
				get_tree().current_scene.add_child.call_deferred(ex)
				queue_free()
				fuse = -1


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if dead:
		return

	var direction = (player.global_position - global_position).normalized()
	#state.linear_velocity = direction * speed


func _on_hit(_amount: float, new_health: float):
	AudioManager.play_sound(audio_hit, "Effects")
	if dead:
		if new_health < -5:
			queue_free()
		# TODO: clean up body after x seconds
		return

	if new_health <= 0:
		animation_tree.set("parameters/Death/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		animation_tree["parameters/Death 2/blend_amount"] = 1.0
		dead = true
		get_tree().get_current_scene().shake.emit(1, 0)
		on_death.call_deferred()
	else:
		animation_tree.set("parameters/Hurt/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		get_tree().get_current_scene().shake.emit(0.2, 0.5)


func on_death():
	lock_rotation = false
	AudioManager.play_sound(audio_dead, "Effects")


func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.damage(0.25)


func face_left() -> void:
	sprite.flip_h = false
	sprite.texture = side_texture


func face_right() -> void:
	sprite.flip_h = true
	sprite.texture = side_texture


func face_up() -> void:
	sprite.flip_h = false
	sprite.texture = up_texture


func face_down() -> void:
	sprite.flip_h = false
	sprite.texture = down_texture
