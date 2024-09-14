extends Camera2D

@export var target_node: Node2D
@export var follow_speed = 50.0

@export var decay : float = 0.8 #How quickly shaking will stop [0,1].
@export var max_offset : Vector2 = Vector2(50,40) #Maximum displacement in pixels.
@export var max_roll : float = 0.0 #Maximum rotation in radians (use sparingly).
@export var noise : FastNoiseLite #The source of random values.

var noise_y = 0 #Value used to move through the noise

var trauma : float = 0.0 #Current shake strength
var trauma_pwr := 3 #Trauma exponent. Use [2,3]

var trauma_raised : bool = false

func _ready():
	randomize()
	noise.seed = randi()
	get_tree().get_current_scene().shake.connect(add_trauma)
	global_position = target_node.global_position

func add_trauma(amount : float, minimum_trauma: float):
	trauma = min(max(amount + trauma, minimum_trauma), 1.0)
	trauma_raised = true

func _process(delta):
	pos_update(delta)
	trauma_update(delta)

func pos_update(delta: float):
	var direction = (get_global_mouse_position() - target_node.global_position)
	var direction_length = min(35, direction.length())

	var target_position = target_node.global_position + direction.normalized() * direction_length
	var dist = target_position - global_position
	var move = dist.normalized() * follow_speed * delta * sqrt(dist.length())

	if move.length() > dist.length():
		global_position = target_position
	else:
		global_position += move
	

func trauma_update(delta: float):
	if trauma:
		shake()
		if !trauma_raised:
			trauma = max(trauma - decay * delta, 0)
		else:
			trauma_raised = false

func shake(): 
	var amt = pow(trauma, trauma_pwr)
	noise_y += 1
	rotation = max_roll * amt * noise.get_noise_2d(0.5, noise_y)
	offset.x = max_offset.x * amt * noise.get_noise_2d(0, noise_y)
	offset.y = max_offset.y * amt * noise.get_noise_2d(1,noise_y)
