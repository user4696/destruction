extends RigidBody3D

# Variables for movement
var speed : float = 100.0
var boost_speed : float = 60.0
var acceleration : float = 3.0
var rotation_speed : float = 20.0

# Function to process input
func _integrate_forces(state):
	handle_input(state)

func handle_input(state):
	var input_vector = Vector3.ZERO
	
	# Forward and backward movement
	if Input.is_action_pressed("up2"):
		input_vector.z -= 1
	if Input.is_action_pressed("down2"):
		input_vector.z += 1
	rotation.x = 0
	rotation.z = 0
	# Determine speed (boost or normal)
	var current_speed = speed
	if Input.is_action_pressed("boost2"):
		current_speed = boost_speed

	# Calculate movement direction relative to the cart's orientation
	input_vector = input_vector.normalized()
	var target_velocity = -transform.basis.z * input_vector.z * current_speed
	var current_velocity = state.get_linear_velocity()
	
	# Apply acceleration and deceleration
	if input_vector.z != 0:
		var force = (target_velocity - current_velocity) * acceleration
		apply_central_force(force)
	else:
		# Apply friction if there is no forward/backward input
		var friction_force = -current_velocity * acceleration
		apply_central_force(friction_force)

	# Left and right rotation
	if Input.is_action_pressed("right2"):
		apply_torque_impulse(Vector3.UP * -rotation_speed)
	if Input.is_action_pressed("left2"):
		apply_torque_impulse(Vector3.UP * rotation_speed)
