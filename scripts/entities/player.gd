extends CharacterBody2D 
class_name Player

@export var speed: int = 400
@export var dash_multiplier: float = 2.0
@export var dash_time: float = 0.1

@export var bullet: PackedScene

var sprite: AnimatedSprite2D
var emitter: BulletEmitter
var dash_charge: float = 1
var dashing: bool    = false
var camera: Camera2D
var health: HealthComponent

signal player_health_changed(max_health: float, health: float)
signal bullet_update(projectiles: int, fire_rate: float)

func _ready() -> void:
	sprite = $body_mask/sprite
	emitter = $emitter
	camera = $camera
	health = $health
	if bullet_update:
		pass # so the compiler stops complaining

func _physics_process(_delta) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if dashing:
		return
	
	if direction.y < 0:
		sprite.play("walking_back")
		if sprite.flip_h:
			sprite.flip_h = false
	elif direction.y > 0:
		sprite.play("walking_front")
		if sprite.flip_h:
			sprite.flip_h = false
	elif direction.x > 0:
		sprite.play("walking_side")
		if sprite.flip_h:
			sprite.flip_h = false
	elif direction.x < 0:
		sprite.play("walking_side")
		if not sprite.flip_h:
			sprite.flip_h = true
	else:
		sprite.play("idle")
		if sprite.flip_h:
			sprite.flip_h = false
			
	if Input.is_action_pressed("move_dash") && dash_charge > 0:
		dash(direction)
	else:
		velocity = direction * speed
	
	if is_moving():
		if dash_charge < 1.0:
			dash_charge += 0.01
	
	move_and_slide()

func dash(direction) -> void:
	if dash_charge <= 0:
		return
	
	dash_charge -= 1
	velocity = direction * (speed * dash_multiplier) * 5
	move_and_slide()
	
	await get_tree().create_timer(dash_time).timeout
	dashing = false

func is_moving() -> bool:
	if Input.is_action_pressed("move_right"):
		return true
	if Input.is_action_pressed("move_left"):
		return true
	if Input.is_action_pressed("move_up"):
		return true
	if Input.is_action_pressed("move_down"):
		return true
	return false


func start_rain():
	$rain.visible = true
	
func _process(_delta: float) -> void:
	if Input.is_action_pressed("fire")	:
		shoot()
	
func shoot():
	$emitter.shoot(get_global_mouse_position())    


func _on_health_component_health_changed(_amount: float, new_health: float) -> void:
	player_health_changed.emit(health.max_health, new_health)
	if _amount > 0:
		$animation.play("hit")
		get_tree().get_current_scene().shake.emit(0, 1)
