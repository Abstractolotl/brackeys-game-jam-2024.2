extends Camera2D

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

func add_trauma(amount : float, minimum_trauma: float):
	trauma = min(max(amount + trauma, minimum_trauma), 1.0)
	trauma_raised = true

func _process(delta):
	var mouse_position: Vector2 = get_global_mouse_position()
	var direction: Vector2      = (mouse_position - global_position)
	if direction.length() > 35:
		position = direction.normalized() * 100
		pass

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
