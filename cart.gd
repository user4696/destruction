extends CharacterBody3D

# Variables for movement
var speed : float = 10.0
var boost_speed : float = 20.0
var acceleration : float = 3.0
var rotation_speed : float = 3.0

# Store movement vector
var movement_velocity : Vector3 = Vector3.ZERO

func _process(delta):
	handle_input(delta)

func handle_input(delta):
	# Detect forward/backward movement (W/S)
	var input_vector = Vector3.ZERO
	if Input.is_action_pressed("north"):
		input_vector.z -= 1
	if Input.is_action_pressed("south"):
		input_vector.z += 1

	# Detect left/right movement (A/D)
	if Input.is_action_pressed("east"):
		rotate_y(-rotation_speed * delta)
	if Input.is_action_pressed("west"):
		rotate_y(rotation_speed * delta)

	# Apply movement direction
	input_vector = input_vector.normalized()

	# Determine if the player is boosting
	var current_speed = speed
	if Input.is_action_pressed("boost"):
		current_speed = boost_speed

	# Move the cart
	movement_velocity = movement_velocity.lerp(input_vector * current_speed, acceleration * delta)
	move_and_slide()

# Configure inputs in the Input Map:
# - "ui_up" -> W key
# - "ui_down" -> S key
# - "ui_left" -> A key
# - "ui_right" -> D key
# - "ui_boost" -> Shift key
