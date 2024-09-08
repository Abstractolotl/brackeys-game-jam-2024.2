extends CharacterBody2D

@export var speed = 400

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	
	if is_moving():
		$AnimatedSprite2D.play("walking")
	else:
		$AnimatedSprite2D.play("idle")
	
	move_and_slide()

func is_moving():
	if Input.is_action_pressed("move_right"):
		return true
	if Input.is_action_pressed("move_left"):
		return true
	if Input.is_action_pressed("move_up"):
		return true
	if Input.is_action_pressed("move_down"):
		return true
