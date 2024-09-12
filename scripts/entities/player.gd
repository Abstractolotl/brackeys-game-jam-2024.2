extends CharacterBody2D 
class_name Player

@export var speed: int = 400
@export var dash_multiplier: float = 2.0
@export var dash_time: float = 0.1

@export var bullet: PackedScene
@export var health: float = 10.0

var emitter: BulletEmitter

var dash_charge: float = 1
var dashing: bool    = false

signal player_damaged(health: float)

func _ready() -> void:
	emitter = $emitter

func _physics_process(_delta) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if dashing:
		return
	
	if direction.y < 0:
		$sprite.play("walking_back")
	elif direction.y > 0 or direction.x != 0:
		$sprite.play("walking_front")
	else:
		$sprite.play("idle")
		
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
	
func _process(_delta: float) -> void:
	if Input.is_action_pressed("fire")	:
		shoot()

func damage(damage: float) -> void:
	if health - damage > 0:
		health = health - damage
	else:
		health = 0
	player_damaged.emit(health)
	
func shoot():
	$emitter.shoot(get_global_mouse_position())    
