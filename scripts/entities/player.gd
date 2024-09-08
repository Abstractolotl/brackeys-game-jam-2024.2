extends CharacterBody2D

@export var speed = 400
@export var dash_multiplier = 2
@export var dash_time = 0.1

var dash_charge = 1
var dashing = false

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if dashing:
		return
	
	if Input.is_action_pressed("move_dash") && dash_charge > 0:
		dash(direction)
	else:
		velocity = direction * speed
	
	if is_moving():
		if dash_charge < 1:
			dash_charge += 0.01
		$AnimatedSprite2D.play("walking")
	else:
		$AnimatedSprite2D.play("idle")
	
	move_and_slide()

func dash(direction):
	if dash_charge <= 0:
		return
	
	dash_charge -= 1
	velocity = direction * (speed * dash_multiplier) * 5
	move_and_slide()
	
	await get_tree().create_timer(dash_time).timeout
	dashing = false

func is_moving():
	if Input.is_action_pressed("move_right"):
		return true
	if Input.is_action_pressed("move_left"):
		return true
	if Input.is_action_pressed("move_up"):
		return true
	if Input.is_action_pressed("move_down"):
		return true
